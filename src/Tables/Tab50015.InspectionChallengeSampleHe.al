table 50015 "Inspection Challenge Sample He"
{
    Caption = 'Inspection Challenge Sample He';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Released Prod Order No."; Code[20])
        {
            Caption = 'Released Prod Order No.';
        }
        field(2; "Production Order Date"; Date)
        {
            Caption = 'Production Order Date';
        }
        field(3; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = "QC Plan Header"."Job No.";
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
            TableRelation = "Machine Center"."No.";
        }
        field(7; "Furnace No."; Text[20])
        {
            Caption = 'Furnace No.';
        }
        
    }
    keys
    {
        key(PK; "Released Prod Order No.","Production Order Date")
        {
            Clustered = true;
        }
    }
}
