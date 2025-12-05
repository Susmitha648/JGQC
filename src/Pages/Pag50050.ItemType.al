page 50050 "Item Type"
{
    ApplicationArea = All;
    Caption = 'Item Type';
    PageType = List;
    SourceTable = "Item Type";
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
                field(Descritpion; Rec.Descritpion)
                {
                    ToolTip = 'Specifies the value of the Descritpion field.', Comment = '%';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
            }
        }
    }
}
