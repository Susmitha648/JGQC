page 50033 "Batch Operators Daily Entry"
{
    ApplicationArea = All;
    Caption = 'Batch Operators Daily Entry';
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
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        ReleaseProdOrder: Record "Production Order";
        Singleinstance : Codeunit "QC Subcriber";
    begin

        Rec."Production Order No." := Singleinstance.GetProductionHdr();
        If ReleaseProdOrder.Get(ReleaseProdOrder.Status::Released, Rec."Production Order No.") then
            If ReleaseProdOrder."Source Type" = ReleaseProdOrder."Source Type"::Item then begin
                Rec."Due Date" := ReleaseProdOrder."Due Date";
            end;
            Clear(Singleinstance);
    end;
    
}
