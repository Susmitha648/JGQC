page 50363 "Weight Issued"
{
    ApplicationArea = All;
    Caption = 'Weight Issued';
    PageType = List;
    SourceTable = "Weight Issued";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Production Order No"; Rec."Production Order No")
                {
                    ToolTip = 'Specifies the value of the Production Order No field.', Comment = '%';
                }
                field("Time"; Rec."Frequency")
                {
                    ToolTip = 'Specifies the value of the Frequency field.', Comment = '%';
                }
                field(Front; Rec.Front)
                {
                    ToolTip = 'Specifies the value of the Front field.', Comment = '%';
                    BlankZero = True;
                }
                field(Back; Rec.Back)
                {
                    ToolTip = 'Specifies the value of the Back field.', Comment = '%';
                    BlankZero = True;
                }
                field(Gauged; Rec.Gauged)
                {
                    ToolTip = 'Specifies the value of the Gauged field.', Comment = '%';
                }
                field("Stones %"; Rec."Stones %")
                {
                    ToolTip = 'Specifies the value of the Stones % field.', Comment = '%';
                    BlankZero = True;
                }
                field("EFF %"; Rec."EFF %")
                {
                    ToolTip = 'Specifies the value of the EFF % field.', Comment = '%';
                    BlankZero = True;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                }
                field("Rub Test"; Rec."Rub Test")
                {
                    ToolTip = 'Specifies the value of the Rub Test field.', Comment = '%';
                }
            }
        }
    }
}
