table 50035 "Gas Consumption"
{
    Caption = 'Gas Consumption';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Date"; Date)
        {
            Caption = 'Date';
        }
         field(2; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7),
                                                          Blocked = const(false));
        }
        field(3; "Machine/Location"; enum "MachineLocation Gas Reading")
        {
            Caption = 'Machine/Location';
        }
        field(4; Reading; Decimal)
        {
            Caption = 'Reading';
            decimalPlaces = 2;
        }
        field(5; "Consumption (SM3)"; Decimal)
        {
            Caption = 'Consumption (SM3)';
            DecimalPlaces = 2;
        }
    }
    keys
    {
        key(PK; "Date","Shortcut Dimension 7 Code","Machine/Location")
        {
            Clustered = true;
        }
    }
}
