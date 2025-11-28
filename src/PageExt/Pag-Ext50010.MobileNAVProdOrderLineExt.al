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
        addlast(Group) 
        {
             field("Recording_Slip"; '')
            {
                ApplicationArea = All;
                Caption = 'Recording Slip';
            }
        }
    }

}
