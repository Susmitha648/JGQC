table 50019 "Production Programme Archive"
{
    Caption = 'Production Programme Archive';
    DataClassification = CustomerContent;
    
     fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
        }

        field(3; "Created Date"; Date)
        {
            Caption = 'Created Date';
            Editable = false;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(5; "Demand Forecast Name"; Code[10])
        {
            Caption = 'Demand Forecast Name';
            TableRelation = "Production Forecast Name".Name;
             trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(2; "Version No."; Integer)
        {
            Caption = 'Version No.';
            Editable = false;
        }
        field(6; Remarks; Text[100])
        {
            Caption = 'Remarks';
             trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(7; Status; enum "QC Status")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(8; "Archived By"; Code[20])
        {
            Caption = 'Archived By';
            Editable = false;
        }
          field(9; "Date Archived"; Date)
        {
            Caption = 'Date Archived';
            Editable = false;
        }
          field(10; "Time Archived"; Time)
        {
            Caption = 'Time Archived';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "No.","Version No.")
        {
            Clustered = true;
        }
    }
}
