page 50004 "QC Plan Line"
{
    ApplicationArea = All;
    Caption = 'QC Plan Line';
    PageType = ListPart;
    SourceTable = "QC Plan Lines";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Job No."; Rec."Job No.")
                {
                    ToolTip = 'Specifies the value of the Job No. field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Parameter Code"; Rec."Parameter Code")
                {
                    ToolTip = 'Specifies the value of the Parameter Code field.', Comment = '%';
                }
                field("Parameter Name"; Rec."Parameter Name")
                {
                    ToolTip = 'Specifies the value of the Parameter Name field.', Comment = '%';
                }
                field("Parameter Type"; Rec."Parameter Type")
                {
                    ToolTip = 'Specifies the value of the Parameter Type field.', Comment = '%';
                }
                field("COA Needed"; Rec."COA Needed")
                {
                    ToolTip = 'Specifies the value of the COA Needed field.', Comment = '%';
                }
                field("Min"; Rec."Min")
                {
                    ToolTip = 'Specifies the value of the Min field.', Comment = '%';
                }
                field(Nom; Rec.Nom)
                {
                    ToolTip = 'Specifies the value of the Nom field.', Comment = '%';
                }
                field("Max"; Rec."Max")
                {
                    ToolTip = 'Specifies the value of the Max field.', Comment = '%';
                }
                field(Frequency; Rec.Frequency)
                {
                    ToolTip = 'Specifies the value of the Frequency field.', Comment = '%';
                }
                field("Required for CE"; Rec."Required for CE")
                {
                    ToolTip = 'Specifies the value of the Required for CE field.', Comment = '%';
                }
                field("Required for HE"; Rec."Required for HE")
                {
                    ToolTip = 'Specifies the value of the Required for HE field.', Comment = '%';
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        
    end;
}
