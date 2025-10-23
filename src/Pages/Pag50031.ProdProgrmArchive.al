page 50031 "Prod Progrm Archive"
{
    ApplicationArea = All;
    Caption = 'Production Programme Archive';
    PageType = Document;
    SourceTable = "Production Programme Archive";
    Editable = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Version No."; Rec."Version No.")
                {
                    ToolTip = 'Specifies the value of the No of Archived Versions field.', Comment = '%';
                }
                field("Created Date"; Rec."Created Date")
                {
                    ToolTip = 'Specifies the value of the Created Date field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Demand Forecast Name"; Rec."Demand Forecast Name")
                {
                    ToolTip = 'Specifies the value of the Demand Forecast Name field.', Comment = '%';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
            }
            part(ProductionProgramArchive; "Product Prog Arch Subform")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No."),"Version No." = field("Version No.");
                UpdatePropagation = Both;
                Caption = 'Production Programme Lines';
            }
        }
          
    }
   
   
}
