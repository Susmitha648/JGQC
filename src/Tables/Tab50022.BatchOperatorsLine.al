table 50022 "Batch Operators Line"
{
    Caption = 'Batch Operators Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Production Order No."; Code[20])
        {
            Caption = 'Work Order No.';
            Editable = false;
        }
        field(2; Shift; Code[10])
        {
            Caption = 'Shift';
            TableRelation = "Work Shift".Code;
        }
        field(3; Batching; Enum Batching)
        {
            Caption = 'Batching';
        }
        field(4; "Batch Unit"; Integer)
        {
            Caption = 'Batch Unit';
        }
        field(5; Tonnage; Decimal)
        {
            Caption = 'Tonnage';
             DecimalPlaces = 0 : 2;
            BlankZero = true;
        }
        field(6; "Time"; Time)
        {
            Caption = 'Time';
        }
        field(7; "Sand Moisture Test"; Decimal)
        {
            Caption = 'Sand Moisture Test';
            DecimalPlaces = 0 : 2;
            BlankZero = true;
        }
        field(8; "Moisture Compensated"; Decimal)
        {
            Caption = 'Moisture Compensated';
            DecimalPlaces = 0 : 2;
            BlankZero = true;
        }
    }
    keys
    {
        key(PK; "Production Order No.", Shift, Batching)
        {
            Clustered = true;
        }
    }
}
