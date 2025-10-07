page 50022 "Cold End Presort Detail Lines"
{
    ApplicationArea = All;
    Caption = 'Cold End Presort Detail Lines';
    PageType = ListPart;
    SourceTable = "Cold End Presort Detail Lines";
    DeleteAllowed = false;
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
                field("Section No."; Rec."Section No.")
                {
                    ToolTip = 'Specifies the value of the Section No. field.', Comment = '%';
                }
                field("Front/Back"; Rec."Front/Back")
                {
                    ToolTip = 'Specifies the value of the Front/Back field.', Comment = '%';
                }
                field("Cavity No"; Rec."Cavity No")
                {
                    ToolTip = 'Specifies the value of the Cavity No field.', Comment = '%';
                }
                field("QC Defect Code"; Rec."QC Defect Code")
                {
                    ToolTip = 'Specifies the value of the QC Defect Code field.', Comment = '%';
                }
            }
        }
    }
}
