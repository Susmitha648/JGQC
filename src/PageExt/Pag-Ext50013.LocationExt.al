pageextension 50013 "Location Ext" extends "Location Card"
{
    layout
    {
        addafter("Default Bin Selection")
        {
            field("Skip Default Bin Update"; Rec."Skip Default Bin Update")
            {
                ApplicationArea = All;
            }
        }
    }
}
