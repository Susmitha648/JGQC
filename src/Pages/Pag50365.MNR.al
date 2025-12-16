page 50365 MNR
{
    ApplicationArea = All;
    Caption = 'MNR';
    PageType = List;
    SourceTable = MNR;
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
                field(Frequency; Rec.Frequency)
                {
                    ToolTip = 'Specifies the value of the Frequency field.', Comment = '%';
                }
                field("Defect Code List"; Rec."Defect Code List")
                {
                    ToolTip = 'Specifies the value of the Defect Code List field.', Comment = '%';
                }
                field("Cavity No"; Rec."Cavity No")
                {
                    ToolTip = 'Specifies the value of the Cavity No field.', Comment = '%';
                }
                field("Line No"; Rec."Line No")
                {
                    ToolTip = 'Specifies the value of the Line No field.', Comment = '%';
                }
            }
        }
    }
}
