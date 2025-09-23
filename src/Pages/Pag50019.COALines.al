page 50019 "COA Lines"
{
    ApplicationArea = All;
    Caption = 'COA Lines';
    PageType = ListPart;
    SourceTable = "COA Lines";
    DeleteAllowed = false;
    InsertAllowed = false;
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
                field("Mould Numbers"; Rec."Mould Numbers")
                {
                    ToolTip = 'Specifies the value of the Mould Numbers field.', Comment = '%';
                }
                field("QC Parameter Code"; Rec."QC Parameter Code")
                {
                    ToolTip = 'Specifies the value of the QC Parameter Code field.', Comment = '%';
                }
                field("QC Parameter Name"; Rec."QC Parameter Name")
                {
                    ToolTip = 'Specifies the value of the QC Parameter Name field.', Comment = '%';
                }
                field("Min"; Rec."Min")
                {
                    ToolTip = 'Specifies the value of the Min field.', Comment = '%';
                }
                field("Max"; Rec."Max")
                {
                    ToolTip = 'Specifies the value of the Max field.', Comment = '%';
                }
                field(Result; Rec.Result)
                {
                    ToolTip = 'Specifies the value of the Result field.', Comment = '%';
                }
            }
        }
    }
}
