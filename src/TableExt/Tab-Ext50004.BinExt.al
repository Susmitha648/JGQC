tableextension 50004 "Bin Ext" extends Bin
{
    fields
    {
        field(50000; "Pallet Capacity"; Decimal)
        {
            Caption = 'Pallet Capacity';
            DataClassification = CustomerContent;
            BlankZero = true;
            trigger OnValidate()
            var
                BinContent: Record "Bin Content";
                Quantity : Decimal;
            begin
                Clear(Quantity);
                BinContent.Reset();
                BinContent.SetRange("Bin Code", Rec.Code);
                BinContent.SetRange("Location Code", "Location Code");
                If BinContent.FindSet() then
                    repeat
                        BinContent.CalcFields(Quantity);
                        Quantity += BinContent.Quantity;
                    until BinContent.Next() = 0;
                
                Rec."Remaining Pallet Capacity" := Rec."Pallet Capacity" - Quantity;
                Rec.Modify(false);
            end;
        }
        field(50002; "Remaining Pallet Capacity"; Decimal)
        {
            Caption = 'Remaining Pallet Capacity';
            DataClassification = CustomerContent;
            BlankZero = true;
        }
    }
}
