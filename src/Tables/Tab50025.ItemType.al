table 50025 "Item Type"
{
    Caption = 'Item Type';
    DataClassification = CustomerContent;
    LookupPageId = "Item Type";
    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Descritpion; Text[100])
        {
            Caption = 'Descritpion';
        }
        field(3; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Code", Descritpion, Quantity)
        {
        }
    }
}
