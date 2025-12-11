table 50010 "Machine/Section Stoppages"
{
    Caption = 'Machine/Section Stoppages';
    DataClassification = CustomerContent;
    LookupPageId = "Machine/Section Stoppages List";
    fields
    {
        field(1; "Production Order No."; Code[20])
        {
            Caption = 'Production Order No.';
            Editable = false;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
        }
        field(3; Shift; Code[20])
        {
            Caption = 'Shift';
            TableRelation = "Work Shift".Code;
        }
        field(4; "Machine Stoppages Code"; Code[20])
        {
            Caption = 'Machine Stoppages Code';
            TableRelation = "Machine Stoppages Master"."Code";
            trigger OnValidate()
            var
                MachineStoppageCode: Record "Machine Stoppages Master";
            begin
                If MachineStoppageCode.Get("Machine Stoppages Code") then
                    "Machine Stoppage Description" := MachineStoppageCode.Description;
            end;
        }
        field(5; "Machine Stoppage Description"; Text[250])
        {
            Caption = 'Machine Stoppage Description';
        }
        field(6; "Section Stoppage Code"; Code[20])
        {
            Caption = 'Section Stoppage Code';
            TableRelation = "Section Stoppages Master".Code;
            trigger OnValidate()
            var
                SectionStoppageMaster: Record "Section Stoppages Master";
            begin
                If SectionStoppageMaster.Get("Section Stoppage Code") then
                    "Section Stoppage Description" := SectionStoppageMaster.Description;
            end;
        }
        field(7; "Section Stoppage Description"; Text[250])
        {
            Caption = 'Section Stoppage Description';
        }
        field(8; "Shift Fitter"; Text[100])
        {
            Caption = 'Shift Fitter';
        }
        field(9; "Machine Operator"; Text[100])
        {
            Caption = 'Machine Operator';
        }
        field(10; "Asst Machine Operator"; Text[100])
        {
            Caption = 'Asst Machine Operator';
        }
        field(11; "Foreman/Shift Supt"; Text[100])
        {
            Caption = 'Foreman/Shift Supt';
        }
        field(12; Status; Enum "Production Order Status")
        {
            Caption = 'Status';
        }
        field(14; Department; Code[20])
        {
            Caption = 'Department';
            TableRelation = "Dimension Value".Code;
            trigger OnLookup()
            begin
                GeneralLegderSetup.Get();
                DimensionValue.Reset();
                DimensionValue.SetRange("Dimension Code", GeneralLegderSetup."Shortcut Dimension 1 Code");
                If DimensionValue.FindSet() then;
                if Page.RunModal(537, DimensionValue) = Action::LookupOK then
                    Department := DimensionValue.Code;
            end;
        }
        field(15; Remarks; Text[100])
        {
            Caption = 'Remarks';
        }
        field(16; "Root Cause"; Text[100])
        {
            Caption = 'Root Cause';
        }
        field(17; "Corrective Action Taken"; Text[100])
        {
            Caption = 'Corrective Action Taken';
        }
        field(18; "Preventive Action Taken"; Text[100])
        {
            Caption = 'Preventive Action Taken';
        }
        field(19; "MS Status"; Enum Status)
        {
            Caption = 'Status';
        }
        field(20; "Downtime (Hrs)"; Decimal)
        {
            Caption = 'Downtime (Hrs)';
            BlankZero = true;
        }
        field(21; "Section No."; Enum "Section No.")
        {
            Caption = 'Section No.';
        }
        field(22; "Incident Date"; Date)
        {
            Caption = 'Incident Date';
        }
        field(23; "Start Time"; Time)
        {
            Caption = 'Start Time';
        }
        field(24; "End Time"; Time)
        {
            Caption = 'End Time';
        }
        field(25; "Machine Number"; Code[20])
        {
            Caption = 'Machine Number';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Production Order No.", "Line No.")
        {
            Clustered = true;
        }
    }
     fieldgroups
    {
        fieldgroup(DropDown; "Production Order No.", "Line No.","Section No.",Shift,"Section Stoppage Description")
        {
        }
    }
    procedure GetLastLineNo(): Integer;
    var
        FindRecordManagement: Codeunit "Find Record Management";
    begin
        exit(FindRecordManagement.GetLastEntryIntFieldValue(Rec, FieldNo("Line No.")))
    end;

    var
        GeneralLegderSetup: Record "General Ledger Setup";
        DimensionValue: Record "Dimension Value";
}
