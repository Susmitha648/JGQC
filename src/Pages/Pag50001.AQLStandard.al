page 50001 "AQL Standard"
{
    ApplicationArea = All;
    Caption = 'AQL Standard';
    PageType = List;
    SourceTable = "AQL Standard";
    UsageCategory = Lists;
    Editable = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Defect Category"; Rec."Defect Category")
                {
                    ToolTip = 'Specifies the value of the Defect Category field.', Comment = '%';
                }
                field("AQL %"; Rec."AQL %")
                {
                    ToolTip = 'Specifies the value of the AQL % field.', Comment = '%';
                }
                field("Accept Quantity"; Rec."Accept Quantity")
                {
                    ToolTip = 'Specifies the value of the Accept Quantity field.', Comment = '%';
                }
                field("Reject Quantity"; Rec."Reject Quantity")
                {
                    ToolTip = 'Specifies the value of the Reject Quantity field.', Comment = '%';
                }
            }
        }
    }
}
