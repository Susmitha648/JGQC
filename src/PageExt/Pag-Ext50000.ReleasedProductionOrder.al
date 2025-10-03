pageextension 50000 "Released Production Order" extends "Released Production Order"
{
     actions
    {
        addafter("Re&plan")
        {
            action(MachineSectionStoppages)
            {
                ApplicationArea = All;
                Caption = 'Machine/Section Stoppages Details';
                Image = List;
                ToolTip = 'Machine/Section Stoppages Details';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Machine/Section Stoppages List";
                RunPageLink = "Production Order No." = field("No.");
            }
            action(COADetails)
            {
                ApplicationArea = All;
                Caption = 'COA Details';
                Image = List;
                ToolTip = 'COA Details';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "COA Details";
                RunPageLink = "Released Prod Order No." = field("No.");
            }
        }
        addafter("Shortage List")
        {
            action(RecordingSlipReport)
            {
                ApplicationArea = All;
                Caption = 'Print Recording Slip';
                Image = Report; // Optional icon
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category4;
                trigger OnAction()
                var
                    MyReportID: Integer;
                    DocumentNo: Record "Production Order";
                begin
                    MyReportID := Report::RecordingSlipReport;
                    // Run with request page
                    CurrPage.SetSelectionFilter(DocumentNo);
                    Report.RunModal(MyReportID, true, false, DocumentNo);
                end;
            }
        }
    }
}
