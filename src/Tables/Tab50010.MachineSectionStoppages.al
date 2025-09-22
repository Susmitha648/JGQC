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
            MachineStoppageCode : Record "Machine Stoppages Master";
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
            SectionStoppageMaster : Record "Section Stoppages Master";
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
    }
    keys
    {
        key(PK; "Production Order No.","Line No.")
        {
            Clustered = true;
        }
    }
     procedure GetLastLineNo(): Integer;
    var
        FindRecordManagement: Codeunit "Find Record Management";
    begin
        exit(FindRecordManagement.GetLastEntryIntFieldValue(Rec, FieldNo("Line No.")))
    end;
}
