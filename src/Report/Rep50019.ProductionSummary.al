report 50019 "Production Summary"
{
    ApplicationArea = All;
    Caption = 'Production Summary';
    UsageCategory = ReportsAndAnalysis;
    //DefaultLayout = RDLC;
    //RDLCLayout = './src/Report/Layouts/ProductionSummary.rdl';
    DefaultRenderingLayout = LayoutWithoutMachine;
    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = where("Gen. Prod. Posting Group" = Filter('PB'));
            RequestFilterFields = "Due Date";
            column(DueDate; Format("Due Date")) { }
            column(MachineNo; MachineNo) { }
            column(JobNo; "Source No.") { }
            dataitem("Prod. Order Line"; "Prod. Order Line")
            {
                DataItemLink = "Prod. Order No." = field("No.");
                column(QtyProdGobCut; "Finished Quantity") { }
                column(Consumption; Consumption) { }
                trigger OnPreDataItem()
                begin
                    SetRange("Inventory Posting Group", 'PB');
                end;
                trigger OnAfterGetRecord()
                begin
                    Clear(Consumption);
                    ItemLedgerConsumption.Reset();
                    ItemLedgerConsumption.SetRange("Document No.","Prod. Order Line"."Prod. Order No.");
                    ItemLedgerConsumption.SetRange("Order Line No.","Prod. Order Line"."Line No.");
                    ItemLedgerConsumption.SetRange("Entry Type",ItemLedgerConsumption."Entry Type"::Consumption);
                   // ItemLedgerConsumption.SetRange("Item No.",'MG');
                    If ItemLedgerConsumption.FindFirst() then
                       Consumption := ABS(ItemLedgerConsumption.Quantity);
                end;
            }
            dataitem(ProductionOrder1; "Production Order")
            {
                DataItemLink = "Shortcut Dimension 2 Code" = field("Source No."), "Due Date" = Field("Due Date");
                DataItemTableView = where("Gen. Prod. Posting Group" = Filter('FG'));
                DataItemLinkReference = "Production Order";
                dataitem(ItemLedgerEntry; "Item Ledger Entry")
                {
                    DataItemTableView = where("Entry Type" = CONST(Output), "Item Category Code" = filter('FG'), "Location Code" = filter('SF1' | 'SF2'));
                    DataItemLink = "Document No." = field("No.");
                    DataItemLinkReference = ProductionOrder1;
                    column(QtyPacked; ReceivedQty) { }
                    column(LogisticsQty; LogisticsQty) { }
                    column(LogisticsPallets; LogisticsPallets) { }
                    column(PackedPallets; PackedPallets) { }
                    column(PackTon; PackTon) { }
                    trigger OnAfterGetRecord()
                    begin
                        Clear(ReceivedQty);
                        Clear(LogisticsQty);
                        Clear(LogisticsPallets);
                        Clear(PackedPallets);
                        Clear(PackTon);
                        ItemledgerEntry1.Reset();
                        ItemledgerEntry1.SetRange("Entry Type", "Entry Type"::Transfer);
                        ItemledgerEntry1.SetRange("Document Type", ItemledgerEntry1."Document Type"::"Transfer Receipt");
                        ItemledgerEntry1.SetRange("Serial No.", "Serial No.");
                        ItemledgerEntry1.SetRange("Location Code", 'FGWH');
                        If ItemledgerEntry1.FindFirst() then begin
                            LogisticsPallets := 1;
                            If Item.Get("Item No.") then
                                if Packsize.Get(Item."Pack Size") then
                                    LogisticsQty := Packsize."Qty Per Pack";
                        end;

                        PackedPallets := 1;
                        If Item.Get("Item No.") then
                            if Packsize.Get(Item."Pack Size") then
                                ReceivedQty := Packsize."Qty Per Pack";

                        PackTon := ("Net Weight" * ReceivedQty)/1000000;
                    end;
                }

            }
            trigger OnPreDataItem()
            begin
                SetRange("Due Date", StartDate, EndDate);
                GeneralLedgerSetup.Get();
            end;

            trigger OnAfterGetRecord()
            begin
                Clear(MachineNo);
                Clear(QtyProdGobCut);
                ProductionProgLine.Reset();
                ProductionProgLine.SetRange("No.", "Production Programme");
                ProductionProgLine.SetRange(Date, "Due Date");
                ProductionProgLine.SetRange(Job, "Source No.");
                If ProductionProgLine.FindFirst() then
                    MachineNo := ProductionProgLine.Furnace;

                ProductionLine.Reset();
                ProductionLine.SetRange("Prod. Order No.", "No.");
                ProductionLine.Setfilter("Work Shift", '<>%1', '');
                If ProductionLine.FindSet() then
                    repeat
                        QtyProdGobCut += ProductionLine.Quantity;
                    until ProductionLine.Next() = 0;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field("Start Date"; StartDate)
                    {
                        ApplicationArea = All;
                    }
                    field("End Date"; EndDate)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
    rendering
    {
        layout(LayoutWithoutMachine)
        {
            Type = RDLC;
            
            LayoutFile = './src/Report/Layouts/ProductionSummaryWithoutMachineNO.rdl';
            Caption = 'Production Summary';
            Summary = 'Without Machine No.';
        }
        layout(LayoutWithMachine)
        {
            Type = RDLC;
            LayoutFile = './src/Report/Layouts/ProductionSummary.rdl';
            Caption = 'Production Summary';
            Summary = 'With Machine No.';
        }
    }
    var
        StartDate: Date;
        EndDate: Date;
        DimensionSetEntry: Record "Dimension Set Entry";
        GeneralLedgerSetup: Record "General Ledger Setup";
        MachineNo: Code[20];
        NoOfDaysRun: Integer;
        ProductionLine: Record "Prod. Order Line";
        QtyProdGobCut: Integer;
        FirstDayNextMonth: Date;
        CutoffDateTime: DateTime;
        startdatetime: DateTime;
        Item: Record Item;
        Packsize: Record "Pack Size";
        ItemRL: Record Item;
        PacksizeRL: Record "Pack Size";
        PackSizeProd: Decimal;
        PackSizeRLQty: Decimal;
        ItemledgerEntry1: Record "Item Ledger Entry";
        ReceivedQty: Decimal;
        LogisticsQty: Decimal;
        LogisticsPallets: Integer;
        PackedPallets: Integer;
        ProductionProgLine: Record "Production Programme Line";
        Consumption : Decimal;
        ItemLedgerConsumption : Record "Item Ledger Entry";
        PackTon : Decimal;
}
