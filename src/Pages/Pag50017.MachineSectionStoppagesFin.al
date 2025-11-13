page 50017 "Machine/SectionStoppagesFinLis"
{
    ApplicationArea = All;
    Caption = 'Machine/Section Stoppages Details';
    PageType = List;
    SourceTable = "Machine/Section Stoppages";
    CardPageId = "Machine/SectionStoppage Fin";
    Editable = false;
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
                field("Machine Stoppages Code"; Rec."Machine Stoppages Code")
                {
                    ToolTip = 'Specifies the value of the Machine Stoppages Code field.', Comment = '%';
                }
                field("Section Stoppage Code"; Rec."Section Stoppage Code")
                {
                    ToolTip = 'Specifies the value of the Section Stoppage Code field.', Comment = '%';
                }
                  field(Department; Rec.Department)
                {
                    ToolTip = 'Specifies the value of the Department field.', Comment = '%';
                }
                  field("MS Status"; Rec."MS Status")
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                  field("Downtime (Hrs)"; Rec."Downtime (Hrs)")
                {
                    ToolTip = 'Specifies the value of the Downtime (Hrs) field.', Comment = '%';
                }
            }
        }
    }
}
