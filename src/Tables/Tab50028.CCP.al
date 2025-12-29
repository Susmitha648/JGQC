table 50028 CCP
{
    Caption = 'CCP';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Production Order No"; Code[20])
        {
            Caption = 'Production Order No';
        }
        field(2; "Type"; enum "Inspection Type")
        {
            Caption = 'Type';
        }
        field(3; "Result Obtained"; Text[2048])
        {
            Caption = 'Result Obtained';
        }
        field(4; "Inspection 1"; Boolean)
        {
            Caption = 'Inspection 1';
        }
        field(5; "Inspection 2"; Boolean)
        {
            Caption = 'Inspection 2';
        }
        field(6; "Inspection 3"; Boolean)
        {
            Caption = 'Inspection 3';
        }
          field(7; "Work Shift"; Code[20])
        {
            Caption = 'Work Shift';
            TableRelation = "Work Shift".Code;
            trigger OnValidate()
            var
            WorkShift : Record "Work Shift";
            begin
                WorkShift.Reset();
                WorkShift.SetRange(Code,"Work Shift");
                If WorkShift.FindFirst() then 
                    "Work Shift Description" := WorkShift.Description;
            end;
        }
          field(8; "Work Shift Description"; Text[20])
        {
            Caption = 'Work Shift Description';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Production Order No","Type","Work Shift")
        {
            Clustered = true;
        }
    }
}
