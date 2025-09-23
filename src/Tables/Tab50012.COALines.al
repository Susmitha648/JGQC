table 50012 "COA Lines"
{
    Caption = 'COA Lines';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Released Prod Order No."; Code[20])
        {
            Caption = 'Released Prod Order No.';
            Editable = false;
        }
        field(2; "Production Order Date"; Date)
        {
            Caption = 'Production Order Date';
            Editable = false;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
        }
        field(4; "Section No."; Enum "Section No.")
        {
            Caption = 'Section No.';
            Editable = false;
        }
        field(5; "Front/Back"; Enum "Front Back")
        {
            Caption = 'Front/Back';
            Editable = false;
        }
        field(6; "Mould Numbers"; Integer)
        {
            Caption = 'Mould Numbers';
        }
        field(7; "QC Parameter Code"; Code[20])
        {
            Caption = 'QC Parameter Code';
            Editable = false;
            TableRelation = "QC Parameters"."Parameter Code";
        }
        field(8; "QC Parameter Name"; Text[100])
        {
            Caption = 'QC Parameter Name';
            Editable = false;
        }
        field(9; "Min"; Text[100])
        {
            Caption = 'Min';
            Editable = false;
        }
        field(10; "Max"; Text[100])
        {
            Caption = 'Max';
            Editable = false;
        }
        field(11; Result; Text[100])
        {
            Caption = 'Result';
        }
    }
    keys
    {
        key(PK; "Released Prod Order No.","Production Order Date","Line No.")
        {
            Clustered = true;
        }
    }
}
