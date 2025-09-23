table 50007 "QC Parameter Type"
{
    Caption = 'QC Parameter Type';
    DataClassification = CustomerContent;
    LookupPageId = "QC Parameter Type";
    fields
    {
        field(1; "Code"; Code[50])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
         field(3; "COA Needed"; Boolean)
        {
            Caption = 'COA Needed';
        }
        
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
    fieldgroups{
        fieldgroup(DropDown; "Code","Description")
        {
        }
    }
}
