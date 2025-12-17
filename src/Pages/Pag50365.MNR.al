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
            }
        }
    }
     trigger OnNewRecord(BelowxRec: Boolean)
    var
    MNR1 : Record MNR;
    begin
        MNR1.Reset();
        MNR1.SetAscending("Line No", false);
        MNR1.SetRange("Production Order No", Rec."Production Order No");
        MNR1.SetRange(Frequency,Rec.Frequency);
        If MNR1.FindFirst() then
            Rec."Line No" := MNR1."Line No" + 10000
        else
            Rec."Line No" := 10000;
    end;
}
