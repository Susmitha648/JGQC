page 50024 "Inspection Challenge Sample"
{
    ApplicationArea = All;
    Caption = 'Inspection Challenge Sample';
    PageType = Document;
    SourceTable = "Inspection Challenge Sample He";
    
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
                field(Ring; Rec.Ring)
                {
                    ToolTip = 'Specifies the value of the Ring field.', Comment = '%';
                }
                field("MC No."; Rec."MC No.")
                {
                    ToolTip = 'Specifies the value of the MC No. field.', Comment = '%';
                }
                field("Furnace No."; Rec."Furnace No.")
                {
                    ToolTip = 'Specifies the value of the Furnace No. field.', Comment = '%';
                }
            }
            part(InspectionChallengeSampleList; "Inspection Challenge Sample Li")
            {
                ApplicationArea = All;
                SubPageLink = "Released Prod Order No." = field("Released Prod Order No."), "Production Order Date" = field("Production Order Date");
                UpdatePropagation = Both;
            }
        }
    }
     trigger OnNewRecord(BelowxRec: Boolean)
    var
        ReleaseProdOrder: Record "Production Order";
        DimensionSetEntry : Record "Dimension Set Entry";
        GeneralLedgerSetup : Record "General Ledger Setup";
    begin
        GeneralLedgerSetup.Get();
        If ReleaseProdOrder.Get(ReleaseProdOrder.Status::Released, Rec."Released Prod Order No.") then
            If ReleaseProdOrder."Source Type" = ReleaseProdOrder."Source Type"::Item then begin
                Rec."Production Order Date" := WorkDate();
                Rec.Validate("Job No.", ReleaseProdOrder."Source No.");
                If DimensionSetEntry.Get(ReleaseProdOrder."Dimension Set ID",GeneralLedgerSetup."Shortcut Dimension 8 Code") then
                  Rec."MC No." := DimensionSetEntry."Dimension Value Code";
                  Rec."Furnace No." := ReleaseProdOrder."Location Code";
            end;
    end;
}
