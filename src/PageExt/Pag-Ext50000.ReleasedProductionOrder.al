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
             action(BatchOperationEntry)
            {
                ApplicationArea = All;
                Caption = 'Batch Operation Entries';
                Image = List;
                ToolTip = 'Batch Operation Entries';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Batch Operators Daily Entries";
                RunPageLink = "Production Order No." = field("No.");
                trigger OnAction()
                var 
                BatchOperator : Record "Batch Operators Daily Entry";
                Singleinstance : Codeunit "QC Subcriber";
                begin
                   Singleinstance.SetProductionHdr(Rec);
                end;
            }
                                         
        }
        addafter("Shortage List")
        {
            action(RecordingSlipReport)
            {
                ApplicationArea = All;
                Caption = 'Print Recording Slip';
                Image = Report; // Optional icon
               // Promoted = true;
               // PromotedIsBig = true;
                //PromotedCategory = Report;
                trigger OnAction()
                var
                    MyReportID: Integer;
                    DocumentNo: Record "Production Order";
                    Count: Integer;
                    QtyToPrint: Integer;
                begin
                    MyReportID := Report::RecordingSlipReport;
                    // Run with request page
                    CurrPage.SetSelectionFilter(DocumentNo);
                   // If DocumentNo.FindFirst() then
                     //   QtyToPrint := DocumentNo.Quantity;
                    //for Count := 1 to QtyToPrint do begin
                        Report.Run(MyReportID, true, false, DocumentNo);
                
                end;
            }
        }
    }
}
