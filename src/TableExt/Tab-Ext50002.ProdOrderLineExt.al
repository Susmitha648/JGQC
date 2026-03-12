tableextension 50002 "Prod Order Line Ext" extends "Prod. Order Line"
{
    fields
    {
        field(50000; "Work Shift"; Code[20])
        {
            Caption = 'Work Shift';
            DataClassification = CustomerContent;
            TableRelation = "Work Shift".Code;
            trigger OnValidate()
            var
                Workshift: Record "Work Shift";
            begin
                If Workshift.Get("Work Shift") then begin
                    "Starting Time WO" := Workshift."Starting Time";
                    "Ending Time WO" := Workshift."Ending Time"
                end;


            end;
        }
        field(50001; "Work Center"; Code[20])
        {
            Caption = 'Work Center';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code;
        }
        field(50002; "Starting Time WO"; Time)
        {
            Caption = 'Starting Time';
            DataClassification = CustomerContent;
        }
        field(50003; "Ending Time WO"; Time)
        {
            Caption = 'Ending Time';
            DataClassification = CustomerContent;
        }
        field(50004; "Section"; Integer)
        {
            Caption = 'Section';
            DataClassification = CustomerContent;
        }
        field(50005; "Speed Bpm"; Integer)
        {
            Caption = 'Speed Bpm';
            DataClassification = CustomerContent;
        }
        field(50007; "QCD Quantity"; Decimal)
        {
            Caption = 'QCD Quantity';
            DataClassification = CustomerContent;
        }
        modify("Item No.")
        {
            trigger OnBeforeValidate()
            var
                ProducOrder: Record "Production Order";
                Item: Record Item;
                DimensionSetEntry: Record "Default Dimension";
                JobExist: Boolean;
                ItemCategoryExists: Boolean;
            begin
                JobExist := false;
                ItemCategoryExists := false;
                If ProducOrder.Get(ProducOrder.Status::Released, Rec."Prod. Order No.") then
                    if ProducOrder."Gen. Prod. Posting Group" = 'FG' then begin
                        DimensionSetEntry.Reset();
                        DimensionSetEntry.SetRange("Table ID", 27);
                        DimensionSetEntry.SetRange("No.", Rec."Item No.");
                        If DimensionSetEntry.FindSet() then
                            repeat
                                If DimensionSetEntry."Dimension Code" = 'JOB' then
                                    JobExist := True;
                                If DimensionSetEntry."Dimension Code" = 'ITEM CATEGORY' then
                                    ItemCategoryExists := True;
                            until DimensionSetEntry.Next() = 0;
                        If not (JobExist) or not (ItemCategoryExists) then
                            Error('Please update dimensions Job/Item Categroy in the Item Card');
                    end;


            end;
        }
    }
}
