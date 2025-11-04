pageextension 50006 "Finished Prod Line Ext" extends "Finished Prod. Order Lines"
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
}
