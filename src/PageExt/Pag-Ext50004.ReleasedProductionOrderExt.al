pageextension 50004 "Released Production Order Ext" extends "Released Production Orders"
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
        addafter("Production Order Statistics")
        {
            action("Daily Batch Consumption")
            {
                ApplicationArea = Manufacturing;
                Caption = 'Daily Batch Consumption';
                Image = Report;

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
                Image = Report;

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

        addlast(Category_Report)
        {
            actionref("Daily Batch Consumption_Promoted"; "Daily Batch Consumption")
            {
            }
            actionref("Batch Operator Daily_Promoted"; "Batch Operator Daily")
            {
            }
        }
    }
}