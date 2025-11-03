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
                        column(ActPackQty;ActPackQty){}
                        trigger OnAfterGetRecord()
                        begin
                            If ProdOrderLine.Quantity <> 0 then 
                            ActPackQty := Round((ItemLedgerEntry.Quantity/ProdOrderLine.Quantity) * 100);
                        end;
                    }
                    trigger OnPostDataItem()
                    begin
                        TonPerLine := ProductionProgrammeLine.Ton / ProdOrderLine.Count;
                    end;
                }
            }
            trigger OnPreDataItem()
            begin
                ProductionProgrammeLine.SetFilter(Furnace, '%1', 'F2*');
            end;

            trigger OnAfterGetRecord()
            begin
                ProdOrdLine.Reset();
                ProdOrdLine.SetRange("Prod. Order No.", ProductionProgrammeLine."Production Order No.");
                TonPerLine := ProductionProgrammeLine.Ton / ProdOrdLine.Count;
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
        ActPackQty : Decimal;
}