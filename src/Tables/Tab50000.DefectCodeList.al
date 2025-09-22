table 50000 "Defect Code"
{
    Caption = 'Defect Code';
    DataClassification = CustomerContent;
    LookupPageId = "Defect Code List";
    fields
    {
        field(1; "Defect Code"; Code[20])
        {
            Caption = 'Defect Code';
            DataClassification = CustomerContent;
        }
        field(2; "Defect Name"; Text[80])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Defect Category"; Enum "Defect Category")
        {
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Defect Code")
        {
            Clustered = true;
        }
    }
    fieldgroups {
        fieldgroup(DropDown; "Defect Code","Defect Name")
        {
        }
    }
}
