table 50026 "Item Reclass Posting"
{
    Caption = 'Item Reclass Posting';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(2; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
        }
        field(3; "Item Type"; Code[20])
        {
            Caption = 'Item Type';
            TableRelation = "Item Type".Code;
        }
        field(4; "Item Weight"; Decimal)
        {
            Caption = 'Item Weight';
            DecimalPlaces = 0:2;
            BlankZero = true;
        }
    }
    keys
    {
        key(PK; "Item No.")
        {
            Clustered = true;
        }
    }
}
