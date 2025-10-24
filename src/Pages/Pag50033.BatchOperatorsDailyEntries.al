page 50033 "Batch Operators Daily Entries"
{
    ApplicationArea = All;
    Caption = 'Batch Operators Daily Entries';
    PageType = List;
    SourceTable = "Batch Operators Daily Entry";
    UsageCategory = Lists;
    Editable = false;
    CardPageId = "Batch Operator Daily Entry";
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Production Order No."; Rec."Production Order No.")
                {
                    ToolTip = 'Specifies the value of the Production Order No. field.', Comment = '%';
                }
                field("Work Order No."; Rec."Work Order No.")
                {
                    ToolTip = 'Specifies the value of the Work Order No. field.', Comment = '%';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ToolTip = 'Specifies the value of the Due Date field.', Comment = '%';
                }
                field(Furnace; Rec.Furnace)
                {
                    ToolTip = 'Specifies the value of the Furnace field.', Comment = '%';
                }
            }
        }
    }
}
