page 50370 "Gas Consumption"
{
    ApplicationArea = All;
    Caption = 'Gas Consumption';
    PageType = List;
    SourceTable = "Gas Consumption";
    UsageCategory = Lists;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.', Comment = '%';
                }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 7 Code field.', Comment = '%';
                }
                field("Machine/Location"; Rec."Machine/Location")
                {
                    ToolTip = 'Specifies the value of the Machine/Location field.', Comment = '%';
                }
                field(Reading; Rec.Reading)
                {
                    ToolTip = 'Specifies the value of the Reading field.', Comment = '%';
                }
                field("Consumption (SM3)"; Rec."Consumption (SM3)")
                {
                    ToolTip = 'Specifies the value of the Consumption (SM3) field.', Comment = '%';
                }
            }
        }
    }
}
