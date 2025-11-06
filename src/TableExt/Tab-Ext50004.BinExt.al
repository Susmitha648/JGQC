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
            begin
                CalcFields("Used Capacity");
                "Remaining Pallet Capacity" := "Pallet Capacity" - "Used Capacity";
            end;
        }
        field(50001; "Used Capacity"; Decimal)
        {
            Caption = 'Used Capacity';
            FieldClass = FlowField;
            Editable = false;
            BlankZero = true;
            CalcFormula = Sum("Bin Content".Quantity where ("Location Code" = field("Location Code"),"Bin Code" = field(Code)));
        }
        field(50002; "Remaining Pallet Capacity"; Decimal)
        {
            Caption = 'Remaining Pallet Capacity';
            Editable = false;
            DataClassification = CustomerContent;
            BlankZero = true;
        }
    }
}
