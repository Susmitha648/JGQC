page 50013 "Section Stoppages Master"
{
    ApplicationArea = All;
    Caption = 'Section Stoppages Master';
    PageType = List;
    SourceTable = "Section Stoppages Master";
    UsageCategory = Lists;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Section Stoppage Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
            }
        }
    }
}
