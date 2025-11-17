table 50024 "Update Mould No"
{
    Caption = 'Update Mould No';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Work Order No."; Code[20])
        {
            Caption = 'Work Order No.';
            Editable = false;
        }
        field(2; "Section No."; enum "Section No.")
        {
            Caption = 'Section No.';
        }
        field(3; "Front Mould No"; Integer)
        {
            Caption = 'Front Mould No';
        }
        field(4; "Back Mould No"; Integer)
        {
            Caption = 'Back Mould No';
        }
    }
    keys
    {
        key(PK; "Work Order No.","Section No.")
        {
            Clustered = true;
        }
    }
}
