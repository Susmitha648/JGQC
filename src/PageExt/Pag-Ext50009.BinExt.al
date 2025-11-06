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
            /* field("Used Capacity"; Rec."Used Capacity")
             {
                 ApplicationArea = All;
             }*/
            field("Remaining Pallet Capacity"; Rec."Remaining Pallet Capacity")
            {
                ApplicationArea = All;
            }

        }
    }
    /*trigger OnAfterGetCurrRecord()
    begin
        Rec.CalcFields("Used Capacity");
        Rec."Remaining Pallet Capacity" := Rec."Pallet Capacity" - Rec."Used Capacity";
    end;*/
    trigger OnAfterGetRecord()
    var
        BinContent: Record "Bin Content";
        Quantity: Decimal;
    begin
        Clear(Quantity);
        BinContent.Reset();
        BinContent.SetRange("Bin Code", Rec.Code);
        BinContent.SetRange("Location Code", Rec."Location Code");
        If BinContent.FindSet() then
            repeat
                BinContent.CalcFields(Quantity);
                Quantity += BinContent.Quantity;
            until BinContent.Next() = 0;
        If Rec."Remaining Pallet Capacity" > 0 then begin
            Rec."Remaining Pallet Capacity" := Rec."Pallet Capacity" - Quantity;
            Rec.Modify(false);
        end;
    end;
}
