table 50002 "QC Parameters"
{
    Caption = 'QC Parameters';
    DataClassification = CustomerContent;
    LookupPageId = "QC Parameters";
    
    fields
    {
        field(1; "Parameter Code"; Code[20])
        {
            Caption = 'Parameter Code';
        }
        field(2; "Parameter Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Parameter Type"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "QC Parameter Type".Code;
        }
           field(4; "COA Needed"; Boolean)
        {
            Caption = 'COA Needed';
        }
    }
    keys
    {
        key(PK; "Parameter Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Parameter Code", "Parameter Name","Parameter Type")
        {
        }
    }
}
