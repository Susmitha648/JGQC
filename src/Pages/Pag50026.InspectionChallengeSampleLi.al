page 50026 "Inspection Challenge Sample Li"
{
    ApplicationArea = All;
    Caption = 'Inspection Challenge Sample Lines';
    PageType = ListPart;
    SourceTable = "Inspection Challenge Sample li";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Released Prod Order No."; Rec."Released Prod Order No.")
                {
                    ToolTip = 'Specifies the value of the Released Prod Order No. field.', Comment = '%';
                }
                field("Production Order Date"; Rec."Production Order Date")
                {
                    ToolTip = 'Specifies the value of the Production Order Date field.', Comment = '%';
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                }
                field("Inspection Type"; Rec."Inspection Type")
                {
                    ToolTip = 'Specifies the value of the Inspection Type field.', Comment = '%';
                }
                field("QC Defect Code"; Rec."QC Defect Code")
                {
                    ToolTip = 'Specifies the value of the QC Defect Code field.', Comment = '%';
                }
                field("Reject %"; Rec."Reject %")
                {
                    ToolTip = 'Specifies the value of the Reject % field.', Comment = '%';
                }
                field("Time"; Rec."Time")
                {
                    ToolTip = 'Specifies the value of the Time field.', Comment = '%';
                }
            }
        }
    }
}
