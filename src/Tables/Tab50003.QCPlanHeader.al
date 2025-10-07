table 50003 "QC Plan Header"
{
    Caption = 'QC Plan Header';
    DataClassification = CustomerContent;
    LookupPageId = "QC Plan List";
    fields
    {
        field(1; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Item where(Blocked = Const(False), Type = const(Inventory));
            trigger OnValidate()
            var
            QCPlanLine : Record "QC Plan Lines";
            begin
              If Item.Get("Job No.") then
                 Description := Item.Description;
              
            end;
        }
        field(2; Description; Text[80])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(3; Finish; Text[80])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(4; "Customer Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer;
            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                If Customer.get("Customer Code") then
                    "Customer Name" := Customer.Name;
            end;
        }
        field(5; "Customer Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            
        }
        field(6; "Room Temperature"; Text[80])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(7; "IM Starwheel Code"; Code[20])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(8; Colour; Text[80])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
          field(9; Status; Enum "QC Status")
        {
           Caption = 'Status';
           Editable = false;
           
        }
    }
    keys
    {
        key(PK; "Job No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Job No.", Description,"Customer Code","Customer Name")
        {
        }
    }
    var
        Customer: Record Customer;
        Item : Record Item;
}
