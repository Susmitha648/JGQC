table 50016 "Inspection Challenge Sample li"
{
    Caption = 'Inspection Challenge Sample li';
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
        field(6; "Inspection Type"; Enum "Inspection Type")
        {
            Caption = 'Inspection Type';
            Editable = false;
        }
         field(7; "QC Defect Code"; Code[20])
        {
            Caption = 'QC Defect Code';
            TableRelation = "Defect Code"."Defect Code";
        }
         field(8; "Reject %"; Decimal)
        {
            Caption = 'Reject %';
            DecimalPlaces = 0:2;
        }
        field(9; Time; Enum Time)
        {
            Caption = 'Time';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Released Prod Order No.", "Production Order Date", "Line No.")
        {
            Clustered = true;
        }
    }
}
