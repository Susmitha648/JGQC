table 50021 "Batch Operators Daily Entry"
{
    Caption = 'Batch Operators Daily Entry';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Production Order No."; Code[20])
        {
            Caption = 'Production Order No.';
        }
        field(2; "Work Order No."; Code[20])
        {
            Caption = 'Work Order No.';
        }
        field(3; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(4; Furnace; Code[20])
        {
            Caption = 'Furnace';
             trigger OnLookup()
            begin
                GeneralLegderSetup.Get();
                DimensionValue.Reset();
                DimensionValue.SetRange("Dimension Code", GeneralLegderSetup."Shortcut Dimension 8 Code");
                If DimensionValue.FindSet() then;
                if Page.RunModal(537, DimensionValue) = Action::LookupOK then 
                    Furnace := DimensionValue.Code;
            end;
        }
    }
    keys
    {
        key(PK; "Production Order No.")
        {
            Clustered = true;
        }
    }
     var
        GeneralLegderSetup: Record "General Ledger Setup";
        DimensionValue: Record "Dimension Value";
}
