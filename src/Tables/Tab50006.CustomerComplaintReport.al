table 50006 "Customer Complaint Report"
{
    Caption = 'Customer Complaint Report';
    DataClassification = CustomerContent;
    LookupPageId = "Customer Complaint Report";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'CCR No';
            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(2; "CCR Date"; Date)
        {
            Caption = 'CCR Date';
            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(3; "Customer No"; Code[20])
        {
            Caption = 'Customer No';
            TableRelation = Customer."No.";
            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                TestField(Status, Status::Open);
                If Customer.Get("Customer No") then
                    "Customer Name" := Customer.Name;
            end;
        }
        field(4; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            Editable = false;
        }
        field(5; "Job No"; Code[20])
        {
            Caption = 'Job No';
            TableRelation = Item."No.";
            trigger OnValidate()
            var
                Item: Record Item;
            begin
                TestField(Status, Status::Open);
                If Item.Get("Job No") then
                    Description := Item.Description;
            end;
        }
        field(6; Description; Text[100])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(7; "Ring Finish"; Text[100])
        {
            Caption = 'Ring Finish';
            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(8; "Complaint Received Date"; Date)
        {
            Caption = 'Complaint Received Date';
            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(15; "Complaint Raised by"; Text[100])
        {
            Caption = 'Complaint Raised by';
            TableRelation = "Salesperson/Purchaser".Name;
            ValidateTableRelation = false;
            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(9; "Customer Contact"; Code[100])
        {
            Caption = 'Customer Contact';
            TableRelation = Contact;//where ("Company No." = field("Customer No"));
            ValidateTableRelation = false;
            trigger OnLookup()
            begin
                TestField(Status, Status::Open);
                LookupContactList();
            end;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(10; "Complaint Details"; Text[250])
        {
            Caption = 'Complaint Details';
            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(11; "Complaint Type"; enum "Complaint Type")
        {
            Caption = 'Complaint Type';
            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(12; "Defect Name"; Text[80])
        {
            Caption = 'Defect Name';
            TableRelation = "Defect Code"."Defect Name";
            ValidateTableRelation = false;
            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(13; "Complaint Category "; enum "Complaint Category")
        {
            Caption = 'Complaint Category';
            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(14; "Complaint Category Remarks"; text[100])
        {
            Caption = 'Complaint Category Remarks';
            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(16; Status; Enum "QC Status")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(17; "Sales Return Order"; Code[20])
        {
            Caption = 'Sales Return Order';
            TableRelation = "Sales Header"."No." where("Document Type" = filter("Return Order"));
        }
        field(18; Remarks; Text[200])
        {
            Caption = 'Remarks';
        }
        field(19; "Manufacture Date"; Date)
        {
            Caption = 'Manufacture Date';
        }
        field(20; "Slip No"; Text[100])
        {
            Caption = 'Slip No';
        }
        field(21; "Specific Mould Numbers"; Text[100])
        {
            Caption = 'Specific Mould Numbers';
        }
        field(22; "Samples Available"; Boolean)
        {
            Caption = 'Samples Available';
        }
        field(23; "Give to Who"; Text[100])
        {
            Caption = 'Give to Who';
        }
        field(24; "Visit Required"; Boolean)
        {
            Caption = 'Visit Required';
        }
        field(25; "Customer Requirement"; enum "Customer Requirements")
        {
            Caption = 'Customer Requirement';
        }
         field(26; "Where Found"; Text[100])
        {
            Caption = 'Where Found';
        }
         field(27; "Quality Involved"; Text[100])
        {
            Caption = 'Quality Involved';
        }

    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    var
        SalesReceSetup: Record "Sales & Receivables Setup";

    procedure LookupContactList()
    var
        ContactBusinessRelation: Record "Contact Business Relation";
        ContactForLookup: Record Contact;
        TempCustomer: Record Customer temporary;
        IsHandled: Boolean;
    begin
        IsHandled := false;


        ContactForLookup.FilterGroup(2);
        if ContactBusinessRelation.FindByRelation(ContactBusinessRelation."Link to Table"::Customer, "Customer No") then
            ContactForLookup.SetRange("Company No.", ContactBusinessRelation."Contact No.")
        else
            ContactForLookup.SetRange("Company No.", '');

        if "Customer Contact" <> '' then
            if ContactForLookup.Get("Customer Contact") then;
        if Page.RunModal(0, ContactForLookup) = Action::LookupOK then begin
            Validate("Customer Contact", ContactForLookup.Name);
        end;
    end;

    trigger OnInsert()
    var
        NoSeries: Codeunit "No. Series";
    begin
        If SalesReceSetup.Get() then;
        If SalesReceSetup."Customer Complaint Report No." <> '' then
            Rec."No." := NoSeries.GetNextNo(SalesReceSetup."Customer Complaint Report No.", Today(), true)
        Else
            Error('Please setup Customer Complaint Report No. in sales & receivables setup');
    end;
}
