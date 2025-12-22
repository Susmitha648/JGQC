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
                    SingleInstance: Codeunit "QC Subcriber";
                    ProductionProgram: Record "Production Programme Line";
                    ProductionProgramLine: Record "Production Programme Line";
                begin
                    MyReportID := Report::RecordingSlipReport;
                    CurrPage.SetSelectionFilter(DocumentNo);
                    ProductionProgram.Reset();
                    ProductionProgram.SetRange(Job, Rec."Shortcut Dimension 2 Code");
                    ProductionProgram.SetRange(Date, Rec."Due Date");
                    If not ProductionProgram.FindFirst() then begin
                        ProductionProgram.SetRange(Date, CalcDate('<-1D>', Rec."Due Date"));
                        If not ProductionProgram.FindFirst() then
                            Error('Date is not with in the production run for this job..You can print recording slip from Item Tracking Lines. Have to manually enter the serial no');
                    end;
                        Report.Run(MyReportID, true, false, DocumentNo);
                end;
            }
        }
    }
}
