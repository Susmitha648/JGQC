page 50012 "Machine Stoppages Master"
{
    ApplicationArea = All;
    Caption = 'Machine Stoppages Master';
    PageType = List;
    SourceTable = "Machine Stoppages Master";
    UsageCategory = Lists;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
            }
        }
    }
}
