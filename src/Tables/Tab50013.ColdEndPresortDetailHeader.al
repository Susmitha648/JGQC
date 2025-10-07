table 50013 "Cold End Presort Detail Header"
{
    Caption = 'Cold End Presort Detail Header';
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
                "Customer Name" := QCPlanHeader."Customer Name";
                "Finish" := QCPlanHeader.Finish;
            end;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(5; Finish; Text[80])
        {
            Caption = 'Finish';
            Editable = false;
        }
        field(6; "MC No."; Code[20])
        {
            Caption = 'MC No.';
            TableRelation = "Machine Center"."No.";
        }
        field(7; "Machine Speed"; Text[20])
        {
            Caption = 'Machine Speed';
        }
        field(8; "LEHR Time"; Time)
        {
            Caption = 'LEHR Time';
        }
         field(9; "Customer Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            
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
