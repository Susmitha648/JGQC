table 50011 "COA Header"
{
    Caption = 'COA Header';
    DataClassification = ToBeClassified;

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
                "Send To" := QCPlanHeader."Customer Name";
                "Ring Finish" := QCPlanHeader.Finish;
            end;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(5; "Ring Finish"; Text[80])
        {
            Caption = 'Ring Finish';
            Editable = false;
        }
        field(6; Machine; Code[20])
        {
            Caption = 'Machine';
            TableRelation = "Machine Center"."No.";
        }
        field(7; "Fill Point"; Text[50])
        {
            Caption = 'Fill Point';
        }
        field(8; "Water Temp"; Text[50])
        {
            Caption = 'Water Temp';
        }
        field(9; "Send To"; Text[100])
        {
            Caption = 'Send To';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Released Prod Order No.", "Production Order Date")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        COALines: Record "COA Lines";
    begin
        COALines.Reset();
        COALines.SetRange("Released Prod Order No.", Rec."Released Prod Order No.");
        COALines.SetRange("Production Order Date", Rec."Production Order Date");
        COALines.DeleteAll();
    end;

    trigger OnInsert()
    var
        ReleaseProdOrder: Record "Production Order";
    begin

        If ReleaseProdOrder.Get(ReleaseProdOrder.Status::Released, Rec."Released Prod Order No.") then
            If ReleaseProdOrder."Source Type" = ReleaseProdOrder."Source Type"::Item then begin
                Rec."Production Order Date" := WorkDate();
                Rec.Validate("Job No.",ReleaseProdOrder."Source No.");
            end;
        

    end;
}
