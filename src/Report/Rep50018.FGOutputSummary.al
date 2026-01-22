report 50018 "FG Output Summary"
{
    ApplicationArea = All;
    Caption = 'FG Output Summary';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/FGOutputSummary.rdl';
    dataset
    {
        dataitem("Production Order"; "Production Order")
        {

            RequestFilterFields = "Due Date";
            column(DueDate;Format("Due Date")){}
            dataitem(ItemLedgerEntry; "Item Ledger Entry")
            {
                DataItemTableView = where("Entry Type" = CONST(Output), "Item Category Code" = filter('FG'), "Location Code" = filter('SF1'|'SF2'));
                DataItemLink = "Document No." = field("No.");
                column(Posting_Date; "Posting Date") { }
                column(Item_No_; "Item No.") { }
                column(Order_Line_No_; "Order Line No.") { }
                Column(Document_No_; "Document No.") { }
                column(Quantity; Quantity) { }
                column(Quantity_Pieces; "Quantity Pieces") { }
                column(WorkShift; WorkShift) { }
                column(GobCut; GobCut) { }
                column(Net_Weight; "Net Weight") { }
                trigger OnAfterGetRecord()
                begin
                    Clear(GobCut);
                    Clear(WorkShift);
                    ProdOrderLine.Reset();
                    ProdOrderLine.SetRange("Prod. Order No.", "Document No.");
                    ProdOrderLine.SetRange("Line No.", "Order Line No.");
                    If ProdOrderLine.FindFirst() then begin
                        WorkShift := ProdOrderLine."Work Shift";

                        ProdOrderLinePB.Reset();
                        ProdOrderLinePB.SetRange("Due Date", "Posting Date");
                        ProdOrderLinePB.SetRange("Item No.", "Global Dimension 2 Code");
                        ProdOrderLinePB.SetRange("Work Shift", ProdOrderLine."Work Shift");
                        If ProdOrderLinePB.FindFirst() then begin
                            GobCut := ProdOrderLinePB.Quantity;
                        end;
                    end;

                end;
            }
        }
    }
    var
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderLinePB: Record "Prod. Order Line";
        WorkShift: code[20];
        GobCut: Decimal;

}
