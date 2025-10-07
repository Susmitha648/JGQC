table 50014 "Cold End Presort Detail Lines"
{
    Caption = 'Cold End Presort Detail Lines';
    DataClassification = ToBeClassified;
    
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
        field(6; "Cavity No"; Integer)
        {
            Caption = 'Cavity No';
        }
        field(7; "QC Defect Code"; Code[20])
        {
            Caption = 'QC Defect Code';
            TableRelation = "Defect Code"."Defect Code";
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
