pageextension 50011 "Item Tracking Lines Ext" extends "Item Tracking Lines"
{
    Actions
    {

        addlast(FunctionsSupply)
        {
            action(RecordingSlipReport)
            {
                ApplicationArea = ItemTracking;
                Caption = 'Print Recording Slip';
                Image = Report;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Visible = PrintingSlipVisible;
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
                    // CurrPage.SetSelectionFilter(DocumentNo);
                    DocumentNo.Reset();
                    DocumentNo.SetRange("Prod. Order No.", Rec."Source ID");
                    DocumentNo.SetRange("Line No.", Rec."Source Prod. Order Line");
                    If DocumentNo.FindFirst() then
                        Report.Run(MyReportID, true, false, DocumentNo);
                    If SingleInstance.GetRejected() then begin
                        Rec.Rejected := True;
                        Rec."Recording Slip Printed" := True;
                    end;
                    CurrPage.Update();
                end;
            }

        }
    }
    var
        PrintingSlipVisible: Boolean;

    trigger OnOpenPage()
    begin
         If (Rec."Source Type" = 5406) and (Rec."Source Subtype" = 3) then
           PrintingSlipVisible := True;
    end;
     trigger OnAfterGetRecord()
    begin
         If (Rec."Source Type" = 5406) and (Rec."Source Subtype" = 3) then
           PrintingSlipVisible := True;
    end;

}
