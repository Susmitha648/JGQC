page 50034 "Batch Operator Daily Entry"
{
    ApplicationArea = All;
    Caption = 'Batch Operator Daily Entry';
    PageType = Document;
    SourceTable = "Batch Operators Daily Entry";
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                
                field("Production Order No."; Rec."Production Order No.")
                {
                    ToolTip = 'Specifies the value of the Production Order No. field.', Comment = '%';
                }
                field("Work Order No."; Rec."Work Order No.")
                {
                    ToolTip = 'Specifies the value of the Work Order No. field.', Comment = '%';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ToolTip = 'Specifies the value of the Due Date field.', Comment = '%';
                }
                field(Furnace; Rec.Furnace)
                {
                    ToolTip = 'Specifies the value of the Furnace field.', Comment = '%';
                }
            }
            part(BatchOperatorEntryLine; "Batch Operator Entry Line")
            {
                ApplicationArea = All;
                Caption = 'Batch Operator Entry Line';
                SubPageLink = "Production Order No." = field("Production Order No.");
                UpdatePropagation = Both;
            }
        }
        
    }
}
