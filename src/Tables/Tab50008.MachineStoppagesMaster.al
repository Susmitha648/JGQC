table 50008 "Machine Stoppages Master"
{
    Caption = 'Machine Stoppages Master';
    DataClassification = CustomerContent;
    LookupPageId = "Machine Stoppages Master";
    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[250])
        {
            Caption = 'Description';
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
        fieldgroup(DropDown;"Code",Description){}
    }
}
