page 50029 "Production Programme Subform"
{
    ApplicationArea = All;
    Caption = 'Production Programme Subform';
    PageType = ListPart;
    SourceTable = "Production Programme Line";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.', Comment = '%';
                }
                field(Day; Rec.Day)
                {
                    ToolTip = 'Specifies the value of the Day field.', Comment = '%';
                }
                field(Furnace; Rec.Furnace)
                {
                    ToolTip = 'Specifies the value of the Furnace field.', Comment = '%';
                }
                field(Job; Rec.Job)
                {
                    ToolTip = 'Specifies the value of the Job field.', Comment = '%';
                }
                field(WT; Rec.WT)
                {
                    ToolTip = 'Specifies the value of the WT field.', Comment = '%';
                }
                field(Speed; Rec.Speed)
                {
                    ToolTip = 'Specifies the value of the Speed field.', Comment = '%';
                }
                field(Ton; Rec.Ton)
                {
                    ToolTip = 'Specifies the value of the Ton field.', Comment = '%';
                }
                field(Tray; Rec.Tray)
                {
                    ToolTip = 'Specifies the value of the Tray field.', Comment = '%';
                }
                field(Pallet; Rec.Pallet)
                {
                    ToolTip = 'Specifies the value of the Pallet field.', Comment = '%';
                }
            }
        }
    }
}
