table 50014 "Cold End Presort Detail Lines"
{
    Caption = 'Cold End Presort Detail Lines';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Released Prod Order No."; Code[20])
        {
            Caption = 'Released Prod Order No.';
            Editable = false;
        }
        field(2; "Production Order Date"; Date)
        {
            Caption = 'Production Order Date';
            Editable = false;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
        }
        field(4; "Section No."; Enum "Section No.")
        {
            Caption = 'Section No.';
            Editable = false;
        }
        field(5; "Front/Back"; Enum "Front Back")
        {
            Caption = 'Front/Back';
            Editable = false;
        }
        field(6; "Cavity No"; Integer)
        {
            Caption = 'Cavity No';
        }
        field(7; "QC Defect Code"; Code[20])
        {
            Caption = 'QC Defect Code';
            TableRelation = "Defect Code"."Defect Code";
        }
        field(9; Frequency; Enum Time)
        {
            Caption = 'Frequency';
            trigger OnValidate()
            begin
                If Frequency = Frequency::"7 to 8" then
                    "Frequency Sort Order" := 1;
                If Frequency = Frequency::"8 to 9" then
                    "Frequency Sort Order" := 2;
                If Frequency = Frequency::"9 to 10" then
                    "Frequency Sort Order" := 3;
                If Frequency = Frequency::"10 to 11" then
                    "Frequency Sort Order" := 4;
                If Frequency = Frequency::"11 to 12" then
                    "Frequency Sort Order" := 5;
                If Frequency = Frequency::"12 to 13" then
                    "Frequency Sort Order" := 6;
                If Frequency = Frequency::"13 to 14" then
                    "Frequency Sort Order" := 7;
                If Frequency = Frequency::"14 to 15" then
                    "Frequency Sort Order" := 8;

                If Frequency = Frequency::"15 to 16" then
                    "Frequency Sort Order" := 9;
                If Frequency = Frequency::"16 to 17" then
                    "Frequency Sort Order" := 10;
                If Frequency = Frequency::"17 to 18" then
                    "Frequency Sort Order" := 11;
                If Frequency = Frequency::"18 to 19" then
                    "Frequency Sort Order" := 12;
                If Frequency = Frequency::"19 to 20" then
                    "Frequency Sort Order" := 13;
                If Frequency = Frequency::"20 to 21" then
                    "Frequency Sort Order" := 14;
                If Frequency = Frequency::"21 to 22" then
                    "Frequency Sort Order" := 15;
                If Frequency = Frequency::"22 to 23" then
                    "Frequency Sort Order" := 16;

                If Frequency = Frequency::"23 to 24" then
                    "Frequency Sort Order" := 17;
                If Frequency = Frequency::"24 to 1" then
                    "Frequency Sort Order" := 18;
                If Frequency = Frequency::"1 to 2" then
                    "Frequency Sort Order" := 19;
                If Frequency = Frequency::"2 to 3" then
                    "Frequency Sort Order" := 20;
                If Frequency = Frequency::"3 to 4" then
                    "Frequency Sort Order" := 21;
                If Frequency = Frequency::"4 to 5" then
                    "Frequency Sort Order" := 22;
                If Frequency = Frequency::"5 to 6" then
                    "Frequency Sort Order" := 23;
                If Frequency = Frequency::"6 to 7" then
                    "Frequency Sort Order" := 24;
            end;
        }
        field(10; Category; Enum "Presort Category ")
        {
            Caption = 'Category';
        }
        field(11; "QC Defect Code 2"; Code[20])
        {
            Caption = 'QC Defect Code 2';
            TableRelation = "Defect Code"."Defect Code";
        }
        field(12; "Frequency Sort Order"; Integer)
        {
            Caption = 'Frequency Sort Order';
        }
    }
    keys
    {
        key(PK; "Released Prod Order No.", "Production Order Date", "Line No.")
        {
            Clustered = true;
        }
        key(PK2; "Frequency Sort Order")
        {
        }
    }
}
