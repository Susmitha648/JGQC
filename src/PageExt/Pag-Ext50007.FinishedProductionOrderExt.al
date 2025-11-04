pageextension 50007 "Finished Production Order Ext" extends "Finished Production Orders"
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
}
