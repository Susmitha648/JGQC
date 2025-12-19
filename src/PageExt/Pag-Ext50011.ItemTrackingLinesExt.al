pageextension 50011 "Item Tracking Lines Ext" extends "Item Tracking Lines"
{
    Actions
    {
        addafter("Assign &Package No.")
        {
            action(RecordingSlipReport)
            {
                ApplicationArea = Suite;
                Caption = 'Print Recording Slip';
                Image = Report;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category5;
                Visible = True;
                trigger OnAction()
                var
                    MyReportID: Integer;
                    DocumentNo: Record "Prod. Order Line";
                    Count: Integer;
                    QtyToPrint: Integer;
                    SingleInstance: Codeunit "QC Subcriber";
                begin
                    SingleInstance.Set(Rec."Serial No.");
                    MyReportID := Report::"Recording Slip Reprint";
                    CurrPage.SetSelectionFilter(DocumentNo);
                    DocumentNo.Reset();
                    DocumentNo.SetRange("Prod. Order No.", Rec."Source ID");
                    DocumentNo.SetRange("Line No.", Rec."Source Prod. Order Line");
                    If DocumentNo.FindFirst() then
                        Report.Run(MyReportID, true, false, DocumentNo);
                end;
            }

        }
    }


}
