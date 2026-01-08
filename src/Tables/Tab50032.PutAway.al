table 50032 "Put Away"
{
    Caption = 'Put Away';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Entry No"; Integer)
        {
            Caption = 'Entry No';
        }
        field(2; "Serial No"; Code[35])
        {
            Caption = 'Serial No';
        }
          field(3; Registered; Boolean)
        {
            Caption = 'Registered';
        }
    }
    keys
    {
        key(PK; "Entry No")
        {
            Clustered = true;
        }
    }
}
