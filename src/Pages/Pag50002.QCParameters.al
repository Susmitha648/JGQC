page 50002 "QC Parameters"
{
    ApplicationArea = All;
    Caption = 'QC Parameters';
    PageType = List;
    SourceTable = "QC Parameters";
    UsageCategory = Lists;
    Editable = true;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
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
            }
        }
    }
}
