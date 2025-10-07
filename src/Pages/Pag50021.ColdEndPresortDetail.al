page 50021 "Cold End Presort Detail"
{
    ApplicationArea = All;
    Caption = 'Cold End Presort Detail';
    PageType = Document;
    SourceTable = "Cold End Presort Detail Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Released Prod Order No."; Rec."Released Prod Order No.")
                {
                    ToolTip = 'Specifies the value of the Released Prod Order No. field.', Comment = '%';
                }
                field("Production Order Date"; Rec."Production Order Date")
                {
                    ToolTip = 'Specifies the value of the Production Order Date field.', Comment = '%';
                }
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
                field("MC No."; Rec."MC No.")
                {
                    ToolTip = 'Specifies the value of the MC No. field.', Comment = '%';
                }
                field("Machine Speed"; Rec."Machine Speed")
                {
                    ToolTip = 'Specifies the value of the Machine Speed field.', Comment = '%';
                }
                field("LEHR Time"; Rec."LEHR Time")
                {
                    ToolTip = 'Specifies the value of the LEHR Time field.', Comment = '%';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field.', Comment = '%';
                }
            }
             part(ColdEndPresortDetailLines; "Cold End Presort Detail Lines")
            {
                ApplicationArea = All;
                SubPageLink = "Released Prod Order No." = field("Released Prod Order No."), "Production Order Date" = field("Production Order Date");
                UpdatePropagation = Both;
            }
        }
        
    }
}
