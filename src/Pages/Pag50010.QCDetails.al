page 50010 "QC Details"
{
    ApplicationArea = All;
    Caption = 'CE Update Details';
    PageType = List;
    SourceTable = "QC Details";
    CardPageId = "QC Detail";
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Work Order No"; Rec."Work Order No")
                {
                    ToolTip = 'Specifies the value of the Work Order No field.', Comment = '%';
                }
                field(Shift; Rec.Shift)
                {
                    ToolTip = 'Specifies the value of the Shift field.', Comment = '%';
                }
                field("Machine No."; Rec."Machine No.")
                {
                    ToolTip = 'Specifies the value of the Machine No. field.', Comment = '%';
                }
                field("IRIZ %"; Rec."IRIZ %")
                {
                    ToolTip = 'Specifies the value of the IRIZ % field.', Comment = '%';
                }
                field("SL %"; Rec."SL %")
                {
                    ToolTip = 'Specifies the value of the SL % field.', Comment = '%';
                }
                field("Defect Code 1"; Rec."Defect Code 1")
                {
                    ToolTip = 'Specifies the value of the Defect Code 1 field.', Comment = '%';
                }
                field("Defect Code 2"; Rec."Defect Code 2")
                {
                    ToolTip = 'Specifies the value of the Defect Code 2 field.', Comment = '%';
                }
                field("Defect Code 3"; Rec."Defect Code 3")
                {
                    ToolTip = 'Specifies the value of the Defect Code 3 field.', Comment = '%';
                }
                field("Action Plan"; Rec."Action Plan")
                {
                    ToolTip = 'Specifies the value of the Action Plan field.', Comment = '%';
                }
            }
        }
    }
}
