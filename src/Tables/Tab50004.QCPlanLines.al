table 50004 "QC Plan Lines"
{
    Caption = 'QC Plan Lines';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Job No.";Code[20] )
        {
            Caption = 'Job No.';
            TableRelation = Item where(Blocked = const(false),Type = const(Inventory));
            Editable = false;
        }
        field(2; "Parameter Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "QC Parameters";
            trigger OnValidate()
            var 
            Parameter : Record "QC Parameters";
            begin
            CheckStatusOpen();
              If Parameter.Get("Parameter Code") then
                 "Parameter Name" := Parameter."Parameter Name";
            end;
        }
        field(3; "Parameter Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            trigger OnValidate()
            begin
                CheckStatusOpen();
            end;
        }
        field(4; Description; Text[80])
        {
            DataClassification = CustomerContent;
            Editable = false;
            trigger OnValidate()
            begin
                CheckStatusOpen();
            end;
        }
        field(5; Min; Text[100])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CheckStatusOpen();
            end;
        }
        field(6; Max; Text[100])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CheckStatusOpen();
            end;
        }
        field(7; Nom; Text[100])
        {
            DataClassification = CustomerContent;
            
            trigger OnValidate()
            begin
                CheckStatusOpen();
            end;
        }
        field(8; Frequency; Text[50])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CheckStatusOpen();
            end;
        }
        field(9; "Required for HE"; Boolean)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CheckStatusOpen();
            end;
        }
        field(10; "Required for CE"; Boolean)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CheckStatusOpen();
            end;
        }
    }
    keys
    {
        key(PK; "Job No.","Parameter Code")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
    Item : Record Item;
    begin
      If Item.Get("Job No.") then
         Description := Item.Description;
    end;
    var
        QCPlanHeader: Record "QC Plan Header";

    procedure CheckStatusOpen()
    begin
        If QCPlanHeader.Get("Job No.") then
            QCPlanHeader.TestField(QCPlanHeader.Status, QCPlanHeader.Status::Open);
    end;
}
