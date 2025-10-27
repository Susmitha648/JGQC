table 50020 "Production Prgrme Archive Line"
{
    Caption = 'Production Prgrme Archive Line';
    DataClassification = CustomerContent;
    
     fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(3; Day; Code[10])
        {
            Caption = 'Day';
        }
        field(4; Furnace; Code[20])
        {
            Caption = 'Furnace';
            TableRelation = "Work Center"."No.";
        }
        field(5; Job; Code[20])
        {
            Caption = 'Job';
            TableRelation = Item."No.";
        }
        field(6; WT; Decimal)
        {
            Caption = 'WT';
        }
        field(7; Speed; Enum Speed)
        {
            Caption = 'Speed';
        }
        field(8; Ton; Decimal)
        {
            Caption = 'Ton';
        }
        field(9; Tray; Text[50])
        {
            Caption = 'Tray';
        }
        field(10; Pallet; Text[50])
        {
            Caption = 'Pallet';
        }
         field(11; "Version No."; Integer)
        {
            Caption = 'Version No.';
            Editable = false;
        }
          field(12; "Bottles Per Minute"; Integer)
        {
            Caption = 'Bottles Per Minute';
            Editable = false;
        }

    }
    keys
    {
        key(PK; "No.",Date,Job,"Version No.")
        {
            Clustered = true;
        }
    }
}
