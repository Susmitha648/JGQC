pageextension 50008 "Work Shifts Ext" extends "Work Shifts"
{
    layout{
        addafter(Description)
        {
            field("Starting Time"; Rec."Starting Time")
            {
                ApplicationArea = All;
            }
            field("Ending Time"; Rec."Ending Time")
            {
                ApplicationArea = All;
            }
        }
    }
}
