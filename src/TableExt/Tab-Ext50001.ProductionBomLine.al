tableextension 50001 "Production Bom Line" extends "Production BOM Line"
{
    fields
    {
        field(50000; "Yield %"; Decimal)
        {
            Caption = 'Yield %';
            DataClassification = CustomerContent;
            DecimalPlaces = 0:3;
            BlankZero = true;
        }
        field(50001; "Glass Yield"; Decimal)
        {
            Caption = 'Glass Yield';
            DataClassification = CustomerContent;
             DecimalPlaces = 0:3;
            BlankZero = true;
        }
    }
}
