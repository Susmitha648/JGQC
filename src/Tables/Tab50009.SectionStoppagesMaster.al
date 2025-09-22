table 50009 "Section Stoppages Master"
{
    Caption = 'Section Stoppages Master';
    DataClassification = CustomerContent;
    LookupPageId = "Section Stoppages Master";
    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Section Stoppage Code';
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
        fieldgroup(DropDown; "Code", Description) { }
    }
}
