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
        }
        field(2; "No of Archived Versions"; Integer)
        {
            Caption = 'No of Archived Versions';
        }
        field(3; "Created Date"; Date)
        {
            Caption = 'Created Date';
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(5; "Demand Forecast Name"; Code[10])
        {
            Caption = 'Demand Forecast Name';
            TableRelation = "Production Forecast Name".Name;
        }
        field(6; Remarks; Text[100])
        {
            Caption = 'Remarks';
        }
        field(7; Status; enum "QC Status")
        {
            Caption = 'Status';
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        ManufacturingSetup: Record "Manufacturing Setup";
        NoSeries: Codeunit "No. Series";
    begin

        If ManufacturingSetup.Get() then
            Rec."No." := NoSeries.GetNextNo(ManufacturingSetup."Production Programme No.", Today(), true);

    end;
}
