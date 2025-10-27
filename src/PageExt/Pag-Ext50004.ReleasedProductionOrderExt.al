pageextension 50004 "Released Production Order Ext" extends "Released Production Orders"
{
    actions
    {
        addafter("Production Order Statistics")
        {
            action("Daily Batch Consumption")
            {
                ApplicationArea = Manufacturing;
                Caption = 'Daily Batch Consumption';
                Image = "Report";
                RunObject = Report 50010; // Replace with your actual report ID
            }

            action("Batch Operator Daily")
            {
                ApplicationArea = Manufacturing;
                Caption = 'Daily Batch Operator';
                Image = "Report";
                RunObject = Report 50011; // Replace with your actual report ID
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