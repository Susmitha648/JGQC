pageextension 50010 "MobileNAV Prod Order Line Ext" extends "MobileNAV ReleasedProdOrd.Line"
{
    layout{
        addafter(Quantity)
        {
            field("Work Shift"; Rec."Work Shift")
            {
                ApplicationArea = All;
            }
        }
    }
}
