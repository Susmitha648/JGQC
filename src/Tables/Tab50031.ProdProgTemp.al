table 50031 "Prod Prog Temp"
{
    Caption = 'Production Programme Line';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = "Production Programme Header"."No.";
        }
        field(2; "Date"; Date)
        {
            Caption = 'Date';
           
        }
        field(3; Day; Code[10])
        {
            Caption = 'Day';
           
        }
        field(5; Job; Code[20])
        {
            Caption = 'Job';
            TableRelation = Item."No.";
        }
        field(4; Furnace; Code[20])
        {
            Caption = 'Work Center';
            TableRelation = "Dimension Value".Code;
            

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
            
        }
        field(7; Speed; Enum Speed)
        {
            Caption = 'Section';
           
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
        field(12; "Bottles Per Minute"; Integer)
        {
            Caption = 'Bottles Per Minute';
        
        }
        field(13; "Production Order No."; Code[20])
        {
            Caption = 'Production Order No.';
            Editable = false;
            TableRelation = "Production Order"."No.";
        }
        field(14; "Prod Order Created"; Boolean)
        {
            Caption = 'Production Order Created';
            Editable = false;
        }
        field(15; "First Line"; Boolean)
        {
            Caption = 'First Line';
        }
        field(16; "Last Line"; Boolean)
        {
            Caption = 'Last Line';
        }
        field(17; "Record Slip No"; Integer)
        {
            Caption = 'Record Slip No';
        }
        field(18; "Sequence No"; Integer)
        {
            Caption = 'Sequence No';
        }
        field(19; "Line No"; Integer)
        {
            Caption = 'Line No';
        }
        field(20; "Work Shift"; Code[10])
        {
            Caption = 'Work Shift';
        }
        field(21; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
        }
        field(22; "Ton Per Line"; Decimal)
        {
            Caption = 'Ton Per Line';
        }


    }
    keys
    {
        key(PK; "No.", Date, Furnace,"Line No")
        {
            Clustered = true;
        }
        key(PK2; Furnace, Job)
        {
        }
    }
   
    var
        GeneralLegderSetup: Record "General Ledger Setup";
        DimensionValue: Record "Dimension Value";

}

