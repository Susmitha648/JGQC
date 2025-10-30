table 50018 "Production Programme Line"
{
    Caption = 'Production Programme Line';
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
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(3; Day; Code[10])
        {
            Caption = 'Day';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(5; Job; Code[20])
        {
            Caption = 'Job';
            TableRelation = Item."No.";
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(4; Furnace; Code[20])
        {
            Caption = 'Furnace';
            TableRelation = "Dimension Value".Code;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
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
        field(6; WT; Decimal)
        {
            Caption = 'WT';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(7; Speed; Enum Speed)
        {
            Caption = 'Speed';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(8; Ton; Decimal)
        {
            Caption = 'Ton';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(9; Tray; Text[50])
        {
            Caption = 'Tray';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(10; Pallet; Text[50])
        {
            Caption = 'Pallet';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(12; "Bottles Per Minute"; Integer)
        {
            Caption = 'Bottles Per Minute';
             trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
         field(13; "Production Order No."; Code[20])
        {
            Caption = 'Bottles Per Minute';
            Editable = false;
            TableRelation = "Production Order"."No.";
        }
          field(14; "Prod Order Created"; Boolean)
        {
            Caption = 'Prod Order Created';
            Editable = false;
        }

    }
    keys
    {
        key(PK; "No.", Date, Job)
        {
            Clustered = true;
        }
    }
    trigger OnDelete()

    begin
        TestStatusOpen();
    end;

    procedure TestStatusOpen()
    var
        ProgramingHeader: Record "Production Programme Header";
    begin
        If ProgramingHeader.Get("No.") then
            If ProgramingHeader.Status = ProgramingHeader.Status::Released then
                Error('Status must be equal to released');

    end;

    var
        GeneralLegderSetup: Record "General Ledger Setup";
        DimensionValue: Record "Dimension Value";
}
