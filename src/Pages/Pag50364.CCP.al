page 50364 CCP
{
    ApplicationArea = All;
    Caption = 'CCP';
    PageType = List;
    SourceTable = CCP;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Production Order No"; Rec."Production Order No")
                {
                    ToolTip = 'Specifies the value of the Production Order No field.', Comment = '%';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                }
                field("Work Shift"; Rec."Work Shift")
                {
                    ToolTip = 'Specifies the value of the Work Shift field.', Comment = '%';
                }
                 field("Work Shift Description"; Rec."Work Shift Description")
                {
                    ToolTip = 'Specifies the value of the Work Shift Description field.', Comment = '%';
                }
                field("Result Obtained"; Rec."Result Obtained")
                {
                    ToolTip = 'Specifies the value of the Result Obtained field.', Comment = '%';
                }
                field("Inspection 1"; Rec."Inspection 1")
                {
                    ToolTip = 'Specifies the value of the Inspection 1 field.', Comment = '%';
                }
                field("Inspection 2"; Rec."Inspection 2")
                {
                    ToolTip = 'Specifies the value of the Inspection 2 field.', Comment = '%';
                }
                field("Inspection 3"; Rec."Inspection 3")
                {
                    ToolTip = 'Specifies the value of the Inspection 3 field.', Comment = '%';
                }
                
            }
        }
    }
}
