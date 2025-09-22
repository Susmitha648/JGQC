table 50005 "Customer Complaint Log"
{
    Caption = 'Customer Complaint Log';
    DataClassification = CustomerContent;
    LookupPageId = "Customer Complaint Log";
    
    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'CCR No';
            TableRelation = "Customer Complaint Report"."No.";
            trigger OnValidate()
            var
            CustCompRep : Record "Customer Complaint Report";
            begin
                TestField(Status, Status::Open);
                If CustCompRep.Get("No.") then begin
                    "CCR Date" := CustCompRep."CCR Date";
                    "Customer No" := CustCompRep."Customer No";
                    "Customer Name" := CustCompRep."Customer Name";
                    "Job No" := CustCompRep."Job No";
                    Description := CustCompRep.Description;
                end;
            end;
        }
        field(2; "CCR Date"; Date)
        {
            Caption = 'CCR Date';
            Editable = false;
        }
        field(3; "Customer No"; Code[20])
        {
            Caption = 'Customer No';
            TableRelation = Customer."No.";
            Editable = false;
            
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
            Editable = false;
        }
        field(6; Description; Text[100])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(7; "Complaint Details"; Text[250])
        {
            Caption = 'Complaint Details';
             trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(8; "Complaint Type"; Enum "Complaint Type")
        {
            Caption = 'Complaint Type';
             trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(9; "Shift/Machine"; Code[20])
        {
            Caption = 'Shift/Machine';
            TableRelation = "Machine Center"."No.";
             trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(10; "CCI Report Date"; Date)
        {
            Caption = 'CCI Report Date';
             trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(11; "Complaint Classification"; enum "Defect Category")
        {
            Caption = 'Complaint Classification';
             trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(12; "Complaint Category";enum "Complaint Category" )
        {
            Caption = 'Complaint Category';
             trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(13; "Complaint Category Remarks "; Text[100])
        {
            Caption = 'Complaint Category Remarks ';
             trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(14; "CCR Link";text[250] )
        {
            Caption = 'CCR Link';
            ExtendedDatatype = URL;
             trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
            
        }
        field(15; "CCI Link"; Text[250])
        {
            Caption = 'CCI Link';
            ExtendedDatatype = URL;
             trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(16; "CC ShopFloor Update"; enum "Floor Update")
        {
            Caption = 'CC ShopFloor Update';
             trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
         field(17; Status; Enum "QC Status")
        {
           Caption = 'Status';
           Editable = false;
           
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    procedure PerformManualRelease()
    begin
    
        if Rec.Status <> Rec.Status::Released then begin
            Rec.Status := Rec.Status::Released;
            Commit();
        end;
    end;
}
