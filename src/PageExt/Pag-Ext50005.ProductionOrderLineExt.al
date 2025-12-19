pageextension 50005 "Production Order Line Ext" extends "Released Prod. Order Lines"
{
    layout
    {
        addafter(Quantity)
        {
            field("Work Shift"; Rec."Work Shift")
            {
                ApplicationArea = All;
                ToolTip = 'Work Shift';
            }
            field("Starting Time WO"; Rec."Starting Time WO")
            {
                ApplicationArea = All;
                ToolTip = 'Starting Time';
            }
            field("Ending Time WO"; Rec."Ending Time WO")
            {
                ApplicationArea = All;
                ToolTip = 'Ending Time';
            }

        }
        modify("Starting Date-Time")
        {
            Visible = false;
        }
        modify("Ending Date-Time")
        {
            Visible = false;
        }

    }
    Actions
    {
        addafter(ProductionJournal)
        {
            action(RecordingSlipReport)
            {
                ApplicationArea = All;
                Caption = 'Print Recording Slip';
                Image = Report;
                trigger OnAction()
                var
                    MyReportID: Integer;
                    DocumentNo: Record "Prod. Order Line";
                    Count: Integer;
                    QtyToPrint: Integer;
                    SingleInstance : Codeunit "QC Subcriber";
                begin
                    MyReportID := Report::RecordingSlipReport;
                    CurrPage.SetSelectionFilter(DocumentNo);
                    SingleInstance.Set(DocumentNo);
                    Report.Run(MyReportID, true, false, DocumentNo);
                end;
            }
        }
    }
}
