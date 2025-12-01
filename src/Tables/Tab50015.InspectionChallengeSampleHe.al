table 50015 "Inspection Challenge Sample He"
{
    Caption = 'Inspection Challenge Sample He';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Released Prod Order No."; Code[20])
        {
            Caption = 'Released Prod Order No.';
            Editable = false;
        }
        field(2; "Production Order Date"; Date)
        {
            Caption = 'Production Order Date';
            Editable = false;
        }
        field(3; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            Editable = false;

            trigger OnValidate()
            var
                QCPlanHeader: Record "QC Plan Header";
            begin
                If QCPlanHeader.Get("Job No.") then;
                Description := QCPlanHeader.Description;
                Ring := QCPlanHeader.Finish;
            end;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(5; Ring; Text[80])
        {
            Caption = 'Ring';
            Editable = false;
        }
        field(6; "MC No."; Code[20])
        {
            Caption = 'MC No.';
             trigger OnLookup()
            begin
                GeneralLegderSetup.Get();
                DimensionValue.Reset();
                DimensionValue.SetRange("Dimension Code", GeneralLegderSetup."Shortcut Dimension 8 Code");
                If DimensionValue.FindSet() then;
                if Page.RunModal(537, DimensionValue) = Action::LookupOK then 
                    "MC No." := DimensionValue.Code;
            end;
        }
        field(7; "Furnace No."; Text[20])
        {
            Caption = 'Furnace No.';
        }

    }
    keys
    {
        key(PK; "Released Prod Order No.", "Production Order Date")
        {
            Clustered = true;
        }
    }
    var
        GeneralLegderSetup: Record "General Ledger Setup";
        DimensionValue: Record "Dimension Value";
    trigger OnDelete()
    var
    InspectionChallengeLine : Record "Inspection Challenge Sample li";
    begin
       InspectionChallengeLine.Reset();
       InspectionChallengeLine.SetRange("Released Prod Order No.","Released Prod Order No.");
       InspectionChallengeLine.SetRange("Production Order Date","Production Order Date");
       InspectionChallengeLine.DeleteAll();
    end;
    trigger OnInsert()
    var
        ReleaseProdOrder: Record "Production Order";
        DimensionSetEntry: Record "Dimension Set Entry";
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        GeneralLedgerSetup.Get();
        If ReleaseProdOrder.Get(ReleaseProdOrder.Status::Released, Rec."Released Prod Order No.") then
            If ReleaseProdOrder."Source Type" = ReleaseProdOrder."Source Type"::Item then begin
                Rec."Production Order Date" := ReleaseProdOrder."Due Date";
                Rec.Validate("Job No.", ReleaseProdOrder."Source No.");
                If DimensionSetEntry.Get(ReleaseProdOrder."Dimension Set ID", GeneralLedgerSetup."Shortcut Dimension 8 Code") then
                    Rec."MC No." := DimensionSetEntry."Dimension Value Code";
                    Rec."Furnace No." := ReleaseProdOrder."Location Code";
            end;


    end;
}
