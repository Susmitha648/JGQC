report 50012 "F1 - Daily Production Report"
{
    ApplicationArea = All;
    Caption = 'F1 - Daily Production Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/DailyProductionReport.rdl';
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
            column(Ton; Ton)
            {
            }
            column(TonPerLine; TonPerLine)
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
            dataitem("Production Order"; "Production Order")
            {
                DataItemLink = "No." = field("Production Order No.");
                column(Description; Description) { }
                dataitem(ProdOrderLine; "Prod. Order Line")
                {
                    DataItemLink = "Prod. Order No." = field("No.");
                    column(Work_Shift; "Work Shift") { }
                    column(GobCutOutPutQuantity; Quantity) { }
                    dataitem(ItemLedgerEntry; "Item Ledger Entry")
                    {
                        DataItemLink = "Document No." = field("Prod. Order No."), "Order Line No." = Field("Line No.");
                        DataItemTableView = Where("Entry Type" = Filter(Output));
                        column(PackQty; ItemLedgerEntry.Quantity) { }
                        column(ActPackQty; ActPackQty) { }
                        trigger OnAfterGetRecord()
                        begin
                            If ProdOrderLine.Quantity <> 0 then
                                ActPackQty := Round((ItemLedgerEntry.Quantity / ProdOrderLine.Quantity) * 100);
                        end;
                    }
                }
            }
            trigger OnPreDataItem()
            begin
                ProductionProgrammeLine.SetFilter(Furnace, '%1', 'F1*');
            end;

            trigger OnAfterGetRecord()
            begin
                ProdOrdLine.Reset();
                ProdOrdLine.SetRange("Prod. Order No.", ProductionProgrammeLine."Production Order No.");
                If ProdOrdLine.Count > 1 then
                    TonPerLine := ProductionProgrammeLine.Ton / ProdOrdLine.Count
                Else
                    TonPerLine := ProductionProgrammeLine.Ton;
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
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    var
        TonPerLine: Decimal;
        ProdOrdLine: Record "Prod. Order Line";
        ActPackQty: Decimal;
}
