table 50023 "QC Details"
{
    Caption = 'QC Details';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Work Order No"; Code[20])
        {
            Caption = 'Work Order No';
            TableRelation = "Production Order"."No.";
        }
        field(2; Shift; Code[20])
        {
            Caption = 'Shift';
            TableRelation = "Work Shift".Code;
        }
        field(3; "Machine No."; Code[20])
        {
            Caption = 'Machine No.';
            TableRelation = "Dimension Value".Code;
            trigger OnLookup()
            begin
                GeneralLegderSetup.Get();
                DimensionValue.Reset();
                DimensionValue.SetRange("Dimension Code", GeneralLegderSetup."Shortcut Dimension 8 Code");
                If DimensionValue.FindSet() then;
                if Page.RunModal(537, DimensionValue) = Action::LookupOK then 
                    "Machine No." := DimensionValue.Code;
            end;
        }
        field(4; "IRIZ %"; Integer)
        {
            Caption = 'IRIZ %';
        }
        field(5; "SL %"; Integer)
        {
            Caption = 'SL %';
        }
        field(6; "Defect Code 1"; Code[20])
        {
            Caption = 'Defect Code 1';
            TableRelation = "Defect Code"."Defect Code";
        }
        field(7; "Defect Code 2"; Code[20])
        {
            Caption = 'Defect Code 2';
            TableRelation = "Defect Code"."Defect Code";
        }
        field(8; "Defect Code 3"; Code[20])
        {
            Caption = 'Defect Code 3';
            TableRelation = "Defect Code"."Defect Code";
        }
        field(9; "Action Plan"; Text[50])
        {
            Caption = 'Action Plan';
        }
    }
    keys
    {
        key(PK; "Work Order No",Shift)
        {
            Clustered = true;
        }
    }
     var
        GeneralLegderSetup: Record "General Ledger Setup";
        DimensionValue: Record "Dimension Value";
}
