page 50000 "Defect Code List"
{
    ApplicationArea = All;
    Caption = 'Defect Code List';
    PageType = List;
    SourceTable = "Defect Code";
    UsageCategory = Lists;
    Editable = true;
    DeleteAllowed = true;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Defect Code"; Rec."Defect Code")
                {
                    ToolTip = 'Specifies the value of the Defect Code field.', Comment = '%';
                }
                field("Defect Name"; Rec."Defect Name")
                {
                    ToolTip = 'Specifies the value of the Defect Name field.', Comment = '%';
                }
                field("Defect Category"; Rec."Defect Category")
                {
                    ToolTip = 'Specifies the value of the Defect Category field.', Comment = '%';
                }
            }
        }
    }
}
