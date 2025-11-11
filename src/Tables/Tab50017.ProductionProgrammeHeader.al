table 50017 "Production Programme Header"
{
    Caption = 'Production Programme Header';
    DataClassification = CustomerContent;
    LookupPageId = "Production Programme List";
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
        field(2; "No of Archived Versions"; Integer)
        {
            Caption = 'No of Archived Versions';
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
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
     fieldgroups
    {
        fieldgroup(DropDown; "No.", "Created Date",Description)
        {
        }
    }
    trigger OnInsert()
    var
        ManufacturingSetup: Record "Manufacturing Setup";
        NoSeries: Codeunit "No. Series";
    begin

        If ManufacturingSetup.Get() then
            If not (ManufacturingSetup."Production Programme No." = '') then begin
                Rec."No." := NoSeries.GetNextNo(ManufacturingSetup."Production Programme No.", Today(), true);
                Rec."Created Date" := System.Today();
            end else
                Error('Production Programme No series setup is not done in Manufacturing setup');

    end;
    trigger OnDelete()
    var
    ProgramingLines : Record "Production Programme Line";
    begin
        TestField(Status, Status::Open);
        ProgramingLines.Reset();
        ProgramingLines.SetRange("No.",Rec."No.");
        ProgramingLines.DeleteAll();
    end;
    
}
