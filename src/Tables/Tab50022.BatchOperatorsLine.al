table 50022 "Batch Operators Line"
{
    Caption = 'Batch Operators Line';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Production Order No."; Code[20])
        {
            Caption = 'Production Order No.';
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
        field(4; "Batch Unit";Integer)
        {
            Caption = 'Batch Unit';
        }
        field(5; Tonnage; Decimal)
        {
            Caption = 'Tonnage';
        }
        field(6; "Time"; Time)
        {
            Caption = 'Time';
        }
        field(7; "Sand Moisture Test"; Decimal)
        {
            Caption = 'Sand Moisture Test';
        }
        field(8; "Moisture Compensated"; Decimal)
        {
            Caption = 'Moisture Compensated';
        }
    }
    keys
    {
        key(PK; "Production Order No.",Shift,Batching)
        {
            Clustered = true;
        }
    }
}
