pageextension 50009 "Bin Ext" extends Bins
{
    layout
    {
        addafter(Empty)
        {
            field("Pallet Capacity"; Rec."Pallet Capacity")
            {
                ApplicationArea = All;
            }
            field("Used Capacity"; Rec."Used Capacity")
            {
                ApplicationArea = All;
            }
            field("Remaining Pallet Capacity"; Rec."Remaining Pallet Capacity")
            {
                ApplicationArea = All;
            }

        }
    }
    trigger OnOpenPage()
    begin
        Rec.CalcFields("Used Capacity");
        Rec."Remaining Pallet Capacity" := Rec."Pallet Capacity" - Rec."Used Capacity";
    end;
}
