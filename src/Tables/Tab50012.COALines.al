table 50012 "COA Lines"
{
    Caption = 'COA Lines';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Released Prod Order No."; Code[20])
        {
            Caption = 'Released Prod Order No.';
        }
        field(2; "Production Order Date"; Date)
        {
            Caption = 'Production Order Date';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Section No."; Enum "Section No.")
        {
            Caption = 'Section No.';
        }
        field(5; "Front/Back"; Enum "Front Back")
        {
            Caption = 'Front/Back';
        }
        field(6; "Mould Numbers"; Integer)
        {
            Caption = 'Mould Numbers';
        }
        field(7; "QC Parameter Code"; Code[20])
        {
            Caption = 'QC Parameter Code';
        }
        field(8; "QC Parameter Name"; Text[100])
        {
            Caption = 'QC Parameter Name';
        }
        field(9; "Min"; Text[100])
        {
            Caption = 'Min';
        }
        field(10; "Max"; Text[100])
        {
            Caption = 'Max';
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
