page 50365 MNR
{
    ApplicationArea = All;
    Caption = 'MNR List';
    PageType = List;
    SourceTable = MNR;
    UsageCategory = Lists;
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Production Order No"; Rec."Production Order No")
                {
                    ToolTip = 'Specifies the Production Order number.';
                    ApplicationArea = All;
                }
                field(Frequency; Rec.Frequency)
                {
                    ToolTip = 'Specifies the frequency of the check.';
                    ApplicationArea = All;
                }
                field("Defect Code List"; Rec."Defect Code List")
                {
                    ToolTip = 'Specifies the defect code.';
                    ApplicationArea = All;
                }
                field("Cavity No"; Rec."Cavity No")
                {
                    ToolTip = 'Specifies the cavity number.';
                    ApplicationArea = All;
                }
            }
        }
    }
}