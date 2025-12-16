table 50027 MNR
{
    Caption = 'MNR';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Production Order No"; Code[20])
        {
            Caption = 'Production Order No';
        }
        field(2; Frequency; enum Time)
        {
            Caption = 'Frequency';
        }
        field(3; "Defect Code List"; Code[20])
        {
            Caption = 'Defect Code List';
            TableRelation = "Defect Code"."Defect Code";
        }
        field(4; "Cavity No"; Code[20])
        {
            Caption = 'Cavity No';
        }
        field(5; "Line No"; Integer)
        {
            Caption = 'Line No';
        }
    }
    keys
    {
        key(PK; "Production Order No","Line No")
        {
            Clustered = true;
        }
    }
}
