page 50027 "Production Programme List"
{
    ApplicationArea = All;
    Caption = 'Production Programme List';
    PageType = List;
    SourceTable = "Production Programme Header";
    UsageCategory = Lists;
    CardPageId = "Production Programme";
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
                field("Created Date"; Rec."Created Date")
                {
                    ToolTip = 'Specifies the value of the Created Date field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("No of Archived Versions"; Rec."No of Archived Versions")
                {
                    ToolTip = 'Specifies the value of the No of Archived Versions field.', Comment = '%';
                }
            }
        }
    }
}
