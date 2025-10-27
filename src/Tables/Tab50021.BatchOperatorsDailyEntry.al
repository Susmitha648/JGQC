table 50021 "Batch Operators Daily Entry"
{
    Caption = 'Batch Operators Daily Entry';
    DataClassification = CustomerContent;
    LookupPageId = "Batch Operators Daily Entries";
    fields
    {
        field(1; "Production Order No."; Code[20])
        {
            Caption = 'Work Order No.';
            Editable = false;
        }
        field(3; "Due Date"; Date)
        {
            Caption = 'Due Date';
            Editable = false;
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
    trigger OnDelete()
    var
        BatchOperatorsLines: Record "Batch Operators Line";
    begin
        BatchOperatorsLines.Reset();
        BatchOperatorsLines.SetRange("Production Order No.","Production Order No.");
        BatchOperatorsLines.DeleteAll();
    end;
}
