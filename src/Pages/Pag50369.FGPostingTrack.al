page 50369 "FG Posting Track"
{
    ApplicationArea = All;
    Caption = 'FG Posting Track';
    PageType = List;
    SourceTable = "FG Posting Tracking";
    UsageCategory = Lists;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Source ID"; Rec."Source ID")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ToolTip = 'Specifies the value of the Creation Date field.', Comment = '%';
                }
                field("Transferred from Entry No."; Rec."Transferred from Entry No.")
                {
                    ToolTip = 'Specifies the value of the Transferred from Entry No. field.', Comment = '%';
                }
                field("Source Prod. Order Line"; Rec."Source Prod. Order Line")
                {
                    ToolTip = 'Specifies the value of the Source Prod. Order Line field.', Comment = '%';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ToolTip = 'Specifies the value of the Serial No. field.', Comment = '%';
                }
                field(Rejected; Rec.Rejected)
                {
                    ToolTip = 'Specifies the value of the Rejected field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Error Text"; Rec."Error Text")
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Output Posted"; Rec."Output Posted")
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Transfer Order Created"; Rec."Transfer Order Created")
                {
                    ToolTip = 'Specifies the value of the Transfer Order Created field.', Comment = '%';
                }
                field("Transfer Shipment Posted"; Rec."Transfer Shipment Posted")
                {
                    ToolTip = 'Specifies the value of the Transfer Order Posted field.', Comment = '%';
                }
                field("Transfer Receipt Posted"; Rec."Transfer Receipt Posted")
                {
                    ToolTip = 'Specifies the value of the Transfer Receipt Posted field.', Comment = '%';
                }
            }
        }
    }
}
