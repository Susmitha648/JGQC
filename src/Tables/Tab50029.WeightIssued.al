table 50029 "Weight Issued"
{
    Caption = 'Weight Issued';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Production Order No"; Code[20])
        {
            Caption = 'Production Order No';
        }
        field(2; "Time"; Enum Time)
        {
            Caption = 'Time';
        }
        field(3; Front; Integer)
        {
            Caption = 'Front';
        }
        field(4; Back; Integer)
        {
            Caption = 'Back';
        }
        field(5; Gauged; Boolean)
        {
            Caption = 'Gauged';
        }
        field(6; "Stones %"; Decimal)
        {
            Caption = 'Stones %';
        }
        field(7; "EFF %"; Decimal)
        {
            Caption = 'EFF %';
        }
        field(8; Remarks; Text[100])
        {
            Caption = 'Remarks';
        }
         field(9; "Rub Test"; enum "Rub Test")
        {
            Caption = 'Rub Test';
        }
        
    }
    keys
    {
        key(PK; "Production Order No","Time")
        {
            Clustered = true;
        }
    }
}
