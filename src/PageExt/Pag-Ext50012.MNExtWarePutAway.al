pageextension 50012 "MNExt Ware Put Away" extends "MobileNAV WarehousePutaway"
{
    layout{
        addafter("Assigned User ID")
        {
               field("External Document No.2"; Rec."External Document No.2")
            {
                ApplicationArea = All;
            }
        }
    }
}
