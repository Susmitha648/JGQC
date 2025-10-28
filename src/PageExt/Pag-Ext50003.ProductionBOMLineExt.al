pageextension 50003 "Production BOM Line Ext" extends "Production BOM Lines"
{
    layout{
        addafter("Unit of Measure Code")
        {
            field("Yield %"; Rec."Yield %")
            {
                ApplicationArea = All;
            }
        }
    }
}
