page 50030 "ProductionPrgrameArchive List"
{
    ApplicationArea = All;
    Caption = 'Production Programme Archive List';
    PageType = List;
    SourceTable = "Production Programme Archive";
    UsageCategory = Lists;
    Editable = false;
    CardPageId = "Prod Progrm Archive";
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Version No."; Rec."Version No.")
                {
                    ToolTip = 'Specifies the value of the No of Archived Versions field.', Comment = '%';
                }
                field("Archived By"; Rec."Archived By")
                {
                    ToolTip = 'Specifies the value of the Archived By field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Date Archived"; Rec."Date Archived")
                {
                    ToolTip = 'Specifies the value of the Date Archived field.', Comment = '%';
                }
            }
        }
    }
}
