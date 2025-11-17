page 50045 "Update Mould No"
{
    ApplicationArea = All;
    Caption = 'Update Mould No';
    PageType = List;
    SourceTable = "Update Mould No";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Section No."; Rec."Section No.")
                {
                    ToolTip = 'Specifies the value of the Section No. field.', Comment = '%';
                }
                field("Front Mould No"; Rec."Front Mould No")
                {
                    ToolTip = 'Specifies the value of the Front Mould No field.', Comment = '%';
                }
                field("Back Mould No"; Rec."Back Mould No")
                {
                    ToolTip = 'Specifies the value of the Back Mould No field.', Comment = '%';
                }
            }
        }
    }
}
