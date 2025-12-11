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
        addafter("Due Date")
        {
            field("Production Programme"; Rec."Production Programme")
            {
                ApplicationArea = All;
            }
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
                RunPageLink = "Released Prod Order No." = field("No."),"Production Order Date" = field("Due Date");
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
            action(InspectionChallengeSample)
            {
                ApplicationArea = All;
                Caption = 'Inspection Challenge Sample';
                Image = List;
                ToolTip = 'Inspection Challenge Sample';
                RunObject = Page "Inspection Challenge Samples";
                RunPageLink = "Released Prod Order No." = field("No.");
            }
             action(ColdEndPresort)
            {
                ApplicationArea = All;
                Caption = 'Cold End Presort Detail';
                Image = List;
                ToolTip = 'Cold End Presort Detail';
                RunObject = Page "Cold End Presort Details";
                RunPageLink = "Released Prod Order No." = field("No.");
            }
             action(UpdateMouldNo)
                {
                    ApplicationArea = Suite;
                    Caption = 'Update Mould No';
                    ToolTip = 'Update Mould No';
                    Image = Create;
                    RunObject = Page "Update Mould No";
                    RunPageLink = "Work Order No." = field("No.");
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
             actionref(InspectionChallengeSample_Promoted; InspectionChallengeSample)
            {
            }
              actionref(ColdEndPresort_Promoted; ColdEndPresort)
            {
            }
             actionref(UpdateMouldNo_Promoted; UpdateMouldNo)
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