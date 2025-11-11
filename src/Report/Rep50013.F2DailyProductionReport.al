report 50013 "F2 Daily Production Report"
{
    ApplicationArea = All;
    Caption = 'F2 - Daily Production Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/DailyProductionReportF2.rdl';
    dataset
    {
        dataitem(ProductionProgrammeLine; "Production Programme Line")
        {
            RequestFilterFields = Date;
            column(No; "No.")
            {
            }
            column(Date; "Date")
            {
            }
            column(Day; Day)
            {
            }
            column(Furnace; Furnace)
            {
            }
            column(Job; Job)
            {
            }
            column(WT; WT)
            {
            }
            column(Speed; Speed)
            {
            }
            column(TonPerLine; TonPerLine)
            {
            }
            column(Ton; Ton)
            {
            }
            column(Tray; Tray)
            {
            }
            column(Pallet; Pallet)
            {
            }
            column(BottlesPerMinute; "Bottles Per Minute")
            {
            }
            column(ProductionOrderNo; "Production Order No.")
            {
            }
            column(ProdOrderCreated; "Prod Order Created")
            {
            }
             column(TotalPackQty; TotalPackQty)
            {
            }
            dataitem("Production Order"; "Production Order")
            {
                DataItemLink = "No." = field("Production Order No.");
                DataItemLinkReference = ProductionProgrammeLine;
                column(Description; Description) { }
                dataitem(ProdOrderLine; "Prod. Order Line")
                {
                    DataItemLink = "Prod. Order No." = field("No.");
                    DataItemLinkReference = "Production Order";
                    column(Work_Shift; "Work Shift") { }
                    column(GobCutOutPutQuantity; Quantity) { }
                    dataitem(ItemLedgerEntry; "Item Ledger Entry")
                    {
                        DataItemLink = "Document No." = field("Prod. Order No."), "Order Line No." = Field("Line No.");
                        DataItemTableView = Where("Entry Type" = Filter(Output));
                        DataItemLinkReference = ProdOrderLine;
                        column(PackQty; ItemLedgerEntry.Quantity) { }
                        column(ActPackQty; ActPackQty) { }
                        column(NetPackPerc; NetPackPerc) { }
                        trigger OnAfterGetRecord()
                        begin
                            If ProdOrderLine.Quantity <> 0 then begin
                                ActPackQty := Round((ItemLedgerEntry.Quantity / ProdOrderLine.Quantity) * 100);
                                NetPackPerc := Round((ItemLedgerEntry.Quantity / ProdOrderLine.Quantity) * 100,0.1);
                            end;
                        end;
                    }
                }
                dataitem("QC Details";"QC Details")
                {
                    DataItemLink = "Work Order No" = field("No.");
                    DataItemLinkReference = "Production Order";
                    column(MachineNo;"Machine No."){}
                    column(Shift1;Shift){}
                    column(IRIZ;"IRIZ %"){}
                    column(SL;"SL %"){}
                    column(Defect_Code_1;"Defect Code 1"){}
                    column(Defect_Code_2;"Defect Code 2"){}
                    column(Defect_Code_3;"Defect Code 3"){}
                    dataitem("Machine/Section Stoppages";"Machine/Section Stoppages")
                    {
                        DataItemLink = "Production Order No." = field("Work Order No"), Shift = Field(Shift);
                        DataItemLinkReference = "QC Details";
                        column(Machine_Stoppage_Description;"Machine Stoppage Description"){}
                        column(Section_Stoppage_Description;"Section Stoppage Description"){}
                        column(Department;Department){}
                        column(Remarks;Remarks){}
                    }
                }
            }
            trigger OnPreDataItem()
            begin
                ProductionProgrammeLine.SetFilter(Furnace, '%1', 'F2*');
                ProductionProgrammeLine.SetFilter("Production Order No.",'<>%1','');
            end;

            trigger OnAfterGetRecord()
            begin
                Clear(TotalPackQty);
                Clear(TonPerLine);
                ProdOrdLine.Reset();
                ProdOrdLine.SetRange("Prod. Order No.", ProductionProgrammeLine."Production Order No.");
                If ProdOrdLine.Count > 1 then
                    TonPerLine := ProductionProgrammeLine.Ton / ProdOrdLine.Count
                Else
                    TonPerLine := ProductionProgrammeLine.Ton;
                ProdProgramLine.Reset();
                ProdProgramLine.SetRange(Furnace,ProductionProgrammeLine.Furnace);
                ProdProgramLine.SetRange("No.",ProductionProgrammeLine."No.");
                ProdProgramLine.SetFilter(Date,'<=%1',ProductionProgrammeLine.Date);
                If ProdProgramLine.FindSet() then repeat
                    ProdOrdLine1.Reset();
                    ProdOrdLine1.SetRange("Prod. Order No.",ProdProgramLine."Production Order No.");
                    If ProdOrdLine1.FindSet() then repeat
                        ItemLedgerEntry1.Reset();
                        ItemLedgerEntry1.SetRange("Entry Type",ItemLedgerEntry1."Entry Type"::Output);
                        ItemLedgerEntry1.SetRange("Document No.",ProdOrdLine1."Prod. Order No.");
                        ItemLedgerEntry1.SetRange("Order Line No.",ProdOrdLine1."Line No.");
                        if ItemLedgerEntry1.FindFirst() then
                            TotalPackQty += ItemLedgerEntry1.Quantity;
                    until ProdOrdLine1.Next() = 0;
                until ProdProgramLine.Next() = 0;
                
            end;
        }
    }

    var
        TonPerLine: Decimal;
        ProdOrdLine: Record "Prod. Order Line";
        ProdOrdLine1: Record "Prod. Order Line";
        ProdProgramLine : Record "Production Programme Line";
        ItemLedgerEntry1 : Record "Item Ledger Entry";
        ActPackQty: Decimal;
        NetPackPerc: Decimal;
        TotalPackQty : Integer;
}