table 50001 "AQL Standard"
{
    Caption = 'AQL Standard';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Defect Category"; enum "Defect Category")
        {
            Caption = 'Defect Category';
        }
        field(2; "AQL %"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0:2;
        }
        field(3; "Accept Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0:2;
        }
        field(4; "Reject Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0:2;
        }
    }
    keys
    {
        key(PK; "Defect Category")
        {
            Clustered = true;
        }
    }
}
