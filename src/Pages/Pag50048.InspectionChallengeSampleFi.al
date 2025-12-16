page 50048 "Inspection Challenge Sample Fi"
{
     ApplicationArea = All;
    Caption = 'Inspection Challenge Sample';
    PageType = Document;
    SourceTable = "Inspection Challenge Sample He";
    PromotedActionCategoriesML = ENU = 'Create';
    Editable = false;
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
    actions
    {
        area(Navigation)
        {
            group(Action12)
            {
                Caption = 'Create';
                Image = Create;
                action(Release)
                {
                    ApplicationArea = Suite;
                    Caption = 'Generate Lines';
                    Image = Create;
                    Promoted = True;
                    PromotedIsBig = True;
                    PromotedCategory = New;
                    ToolTip = 'Create Inspection Challenge Sample lines';
                    trigger OnAction()
                    var
                        InspectionLine: Record "Inspection Challenge Sample li";
                        InspectionLine2: Record "Inspection Challenge Sample li";
                        QCPlanLine: Record "QC Plan Lines";
                        UploadMouldNo: Record "Update Mould No";
                        Enumtext: Integer;
                        FrontBack: Integer;
                        Proceed: Boolean;
                        Count: Integer;
                        i: Integer;
                    begin

                        Proceed := True;
                        InspectionLine.Reset();
                        InspectionLine.SetRange("Released Prod Order No.", Rec."Released Prod Order No.");
                        InspectionLine.SetRange("Production Order Date", Rec."Production Order Date");
                        If InspectionLine.FindFirst() then
                            If not Confirm('It will delete the existing lines and create New. Do you want to Continue?') then
                                Proceed := false;
                        If Proceed then begin
                            InspectionLine.DeleteAll();
                            Clear(Count);
                            InspectionLine.Reset();
                            InspectionLine.SetRange("Released Prod Order No.", Rec."Released Prod Order No.");
                            InspectionLine.SetRange("Production Order Date", Rec."Production Order Date");
                            If InspectionLine.FindFirst() then
                                If not Confirm('It will delete the existing lines and create New. Do you want to Continue?') then
                                    Proceed := false;
                            If Proceed then begin
                                InspectionLine.DeleteAll();
                                Clear(Count);
                                foreach Enumtext in Enum::Time.Ordinals() do begin
                                    foreach FrontBack in Enum::"Inspection Type".Ordinals() do begin
                                        for i := 1 to 10 do begin
                                            InspectionLine.Init();
                                            InspectionLine."Released Prod Order No." := Rec."Released Prod Order No.";
                                            InspectionLine."Production Order Date" := Rec."Production Order Date";
                                            InspectionLine2.Reset();
                                            InspectionLine2.SetAscending("Line No.", false);
                                            InspectionLine2.SetRange("Released Prod Order No.", Rec."Released Prod Order No.");
                                            InspectionLine2.SetRange("Production Order Date", Rec."Production Order Date");
                                            If InspectionLine2.FindFirst() then
                                                InspectionLine."Line No." := InspectionLine2."Line No." + 10000
                                            else
                                                InspectionLine."Line No." := 10000;
                                            Evaluate(InspectionLine."Inspection Type", Format(FrontBack));
                                            Evaluate(InspectionLine.Frequency, Format(Enumtext));
                                            InspectionLine.Insert();
                                            Count += 1;
                                        end
                                    end;
                                end;
                            end;
                            If Count > 1 then
                                Message('Lines created')
                            else
                                Message('No Lines created');
                        end;
                    end;
                }
                action(CCP)
                {
                    ApplicationArea = Suite;
                    Caption = 'CCP';
                    Image = List;
                    Promoted = True;
                    PromotedIsBig = True;
                    PromotedCategory = New;
                    ToolTip = 'Create CCP lines';
                    RunObject = Page CCP;
                    RunPageLink = "Production Order No" = field("Released Prod Order No.");
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        ReleaseProdOrder: Record "Production Order";
        DimensionSetEntry: Record "Dimension Set Entry";
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        GeneralLedgerSetup.Get();
        If ReleaseProdOrder.Get(ReleaseProdOrder.Status::Released, Rec."Released Prod Order No.") then
            If ReleaseProdOrder."Source Type" = ReleaseProdOrder."Source Type"::Item then begin
                Rec."Production Order Date" := ReleaseProdOrder."Due Date";
                Rec.Validate("Job No.", ReleaseProdOrder."Source No.");
                If DimensionSetEntry.Get(ReleaseProdOrder."Dimension Set ID", GeneralLedgerSetup."Shortcut Dimension 8 Code") then
                    Rec."MC No." := DimensionSetEntry."Dimension Value Code";
                Rec."Furnace No." := ReleaseProdOrder."Location Code";
            end;

    end;
}
