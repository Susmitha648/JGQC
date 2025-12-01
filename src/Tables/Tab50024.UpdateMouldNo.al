table 50024 "Update Mould No"
{
    Caption = 'Update Mould No';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Work Order No."; Code[20])
        {
            Caption = 'Work Order No.';
            Editable = false;
        }
        field(2; "Section No."; enum "Section No.")
        {
            Caption = 'Section No.';
        }
        field(3; "Front Mould No"; Integer)
        {
            Caption = 'Front Mould No';
            trigger OnValidate()
            var
            COALine : Record "COA Lines";
            ColdEndPresortLine : Record "Cold End Presort Detail Lines";
            begin
                COALine.Reset();
                COALine.SetRange("Released Prod Order No.","Work Order No.");
                COALine.SetRange("Section No.","Section No.");
                COALine.SetRange("Front/Back",COALine."Front/Back"::F);
                If COALine.FindSet(True) then repeat
                  COALine."Mould Numbers" := "Front Mould No";
                  COALine.Modify();
                until COALine.Next() = 0;
                ColdEndPresortLine.Reset();
                ColdEndPresortLine.SetRange("Released Prod Order No.","Work Order No.");
                ColdEndPresortLine.SetRange("Section No.","Section No.");
                ColdEndPresortLine.SetRange("Front/Back",COALine."Front/Back"::F);
                If ColdEndPresortLine.FindSet(True) then repeat
                  ColdEndPresortLine."Cavity No" := "Front Mould No";
                  ColdEndPresortLine.Modify();
                until ColdEndPresortLine.Next() = 0;
            end;
        }
        field(4; "Back Mould No"; Integer)
        {
            Caption = 'Back Mould No';
            trigger OnValidate()
            var
            COALine : Record "COA Lines";
            ColdEndPresortLine : Record "Cold End Presort Detail Lines";
            begin
                COALine.Reset();
                COALine.SetRange("Released Prod Order No.","Work Order No.");
                COALine.SetRange("Section No.","Section No.");
                COALine.SetRange("Front/Back",COALine."Front/Back"::B);
                If COALine.FindSet(True) then repeat
                  COALine."Mould Numbers" := "Back Mould No";
                  COALine.Modify();
                until COALine.Next() = 0;
                ColdEndPresortLine.Reset();
                ColdEndPresortLine.SetRange("Released Prod Order No.","Work Order No.");
                ColdEndPresortLine.SetRange("Section No.","Section No.");
                ColdEndPresortLine.SetRange("Front/Back",COALine."Front/Back"::B);
                If ColdEndPresortLine.FindSet(True) then repeat
                  ColdEndPresortLine."Cavity No" := "Back Mould No";
                  ColdEndPresortLine.Modify();
                until ColdEndPresortLine.Next() = 0;
            end;
        }
    }
    keys
    {
        key(PK; "Work Order No.","Section No.")
        {
            Clustered = true;
        }
    }
}
