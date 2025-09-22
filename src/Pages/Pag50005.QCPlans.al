page 50005 "QC Plan List"
{
    ApplicationArea = All;
    Caption = 'QC Plans';
    PageType = List;
    CardPageId = "QC Plan Header";
    SourceTable = "QC Plan Header";
    UsageCategory = Lists;
    Editable = false;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Job No."; Rec."Job No.")
                {
                    ToolTip = 'Specifies the value of the Job No. field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field(Finish; Rec.Finish)
                {
                    ToolTip = 'Specifies the value of the Finish field.', Comment = '%';
                }
                field("Customer Code"; Rec."Customer Code")
                {
                    ToolTip = 'Specifies the value of the Customer Code field.', Comment = '%';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field.', Comment = '%';
                }
                field("Room Temperature"; Rec."Room Temperature")
                {
                    ToolTip = 'Specifies the value of the Room Temperature field.', Comment = '%';
                }
                field("IM Starwheel Code"; Rec."IM Starwheel Code")
                {
                    ToolTip = 'Specifies the value of the IM Starwheel Code field.', Comment = '%';
                }
                field(Colour; Rec.Colour)
                {
                    ToolTip = 'Specifies the value of the Colour field.', Comment = '%';
                }
            }
        }
    }
}
