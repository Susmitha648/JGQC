page 50035 "Batch Operator Entry Line"
{
    ApplicationArea = All;
    Caption = 'Batch Operator Entry Line';
    PageType = ListPart;
    SourceTable = "Batch Operators Line";
    
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
                field(Shift; Rec.Shift)
                {
                    ToolTip = 'Specifies the value of the Shift field.', Comment = '%';
                }
                field(Batching; Rec.Batching)
                {
                    ToolTip = 'Specifies the value of the Batching field.', Comment = '%';
                }
                field("Batch Unit"; Rec."Batch Unit")
                {
                    ToolTip = 'Specifies the value of the Batch Unit field.', Comment = '%';
                }
                field(Tonnage; Rec.Tonnage)
                {
                    ToolTip = 'Specifies the value of the Tonnage field.', Comment = '%';
                }
                field("Time"; Rec."Time")
                {
                    ToolTip = 'Specifies the value of the Time field.', Comment = '%';
                }
                field("Sand Moisture Test"; Rec."Sand Moisture Test")
                {
                    ToolTip = 'Specifies the value of the Sand Moisture Test field.', Comment = '%';
                }
                field("Moisture Compensated"; Rec."Moisture Compensated")
                {
                    ToolTip = 'Specifies the value of the Moisture Compensated field.', Comment = '%';
                }
            }
        }
    }
}
