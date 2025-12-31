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
                    ProdOrder : Record "Production Order";
                    ReservationEntry : Record "Reservation Entry";
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
                    ProdOrder.Reset();
                    ProdOrder.SetRange("No.",Rec."Prod. Order No.");
                    If ProdOrder.FindFirst() then
                      If ProdOrder."Location Code" = '' then
                        Error('Location Code should not be blank in Production Order');
                    
                    ReservationEntry.Reset();
                    ReservationEntry.SetRange("Source Type",5406);
                    ReservationEntry.SetRange("Source Subtype",3);
                    ReservationEntry.SetRange("Source ID",Rec."Prod. Order No.");
                    ReservationEntry.SetRange("Source Prod. Order Line",Rec."Line No.");
                    If ReservationEntry.Count < Rec.Quantity then
                        Report.Run(MyReportID, true, false, DocumentNo)
                    else
                       Error('Recording slips exceeded the quantity...can reprint from Item Tracking Lines');
                end;
            }
        }
    }
}
