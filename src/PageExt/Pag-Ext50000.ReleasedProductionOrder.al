pageextension 50000 "Released Production Order" extends "Released Production Order"
{
    layout{
        modify("Starting Date-Time")
        {
            Visible = false;
        }
        modify("Ending Date-Time")
        {
            Visible = false;
        }
    }
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
                RunObject = Page "Machine/Section Stoppages List";
                RunPageLink = "Production Order No." = field("No.");
            }
            action(COADetails)
            {
                ApplicationArea = All;
                Caption = 'COA Details';
                Image = List;
                ToolTip = 'COA Details';
                RunObject = Page "COA Details";
                RunPageLink = "Released Prod Order No." = field("No.");
            }
            
            action(BatchOperationEntry)
            {
                ApplicationArea = All;
                Caption = 'Batch Operators Daily Entries';
                Image = List;
                ToolTip = 'Batch Operators Daily Entries';
                RunObject = Page "Batch Operators Daily Entries";
                RunPageLink = "Production Order No." = field("No.");
                trigger OnAction()
                var
                    BatchOperator: Record "Batch Operators Daily Entry";
                    Singleinstance: Codeunit "QC Subcriber";
                begin
                    Singleinstance.SetProductionHdr(Rec);
                end;
            }
             action(QCUpdate)
            {
                ApplicationArea = All;
                Caption = 'QC Update Details';
                Image = List;
                ToolTip = 'QC Update Details';
                RunObject = Page "QC Details";
                RunPageLink = "Work Order No" = field("No.");
            }
        }
        addafter("Shortage List")
        {
            
            action("Daily Batch Consumption")
            {
                ApplicationArea = Manufacturing;
                Caption = 'Daily Batch Consumption';
                Image = "Report";
                trigger OnAction()
                var
                    DailyBatchConsumption: Report 50010;
                    BatchOperatorsDailyEntry: Record "Batch Operators Daily Entry";
                begin
                    BatchOperatorsDailyEntry.SetRange("Production Order No.", Rec."No.");
                    DailyBatchConsumption.SetTableView(BatchOperatorsDailyEntry);
                    DailyBatchConsumption.Run();
                end;
            }
            action("Batch Operator Daily")
            {
                ApplicationArea = Manufacturing;
                Caption = 'Daily Batch Operator';
                Image = "Report";
                trigger OnAction()
                var
                    BatchOperatorDaily: Report 50011;
                    BatchOperatorsDailyEntry: Record "Batch Operators Daily Entry";
                begin
                    BatchOperatorsDailyEntry.SetRange("Production Order No.", Rec."No.");
                    BatchOperatorDaily.SetTableView(BatchOperatorsDailyEntry);
                    BatchOperatorDaily.Run();
                end;
            }
        }

        addafter("Re&plan_Promoted")
        {
            actionref("MachineSectionStoppages_Promoted"; MachineSectionStoppages)
            {
            }
            actionref(COADetails_Promoted; COADetails)
            {
            }
            actionref(BatchOperationEntry_Promoted; BatchOperationEntry)
            {
            }
        }

        addafter("Shortage List_Promoted")
        {
            actionref("Daily Batch Consumption_Promoted"; "Daily Batch Consumption")
            {
            }
            actionref("Batch Operator Daily_Promoted"; "Batch Operator Daily")
            {
            }
        }
         addafter("Re&plan_Promoted")
        {
            actionref("QCUpdate_Promoted"; QCUpdate)
            {
            }
        }
    }
}