page 50021 "Cold End Presort Detail"
{
    ApplicationArea = All;
    Caption = 'Cold End Presort Detail';
    PageType = Document;
    SourceTable = "Cold End Presort Detail Header";
    PromotedActionCategoriesML = ENU = 'Create, Report';
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
                
                 field("Shift 1 Leading Hand"; Rec."Shift 1 Leading Hand")
                {
                    ToolTip = 'Specifies the value of the Shift 1 Leading Hand field.', Comment = '%';
                }
                field("Shift 1 Foreman"; Rec."Shift 1 Foreman")
                {
                    ToolTip = 'Specifies the value of the Shift 1 Foreman field.', Comment = '%';
                }
                field("Shift 2 Leading Hand"; Rec."Shift 2 Leading Hand")
                {
                    ToolTip = 'Specifies the value of the Shift 2 Leading Hand field.', Comment = '%';
                }
                field("Shift 2 Foreman"; Rec."Shift 2 Foreman")
                {
                    ToolTip = 'Specifies the value of the Shift 2 Foreman field.', Comment = '%';
                }
                field("Shift 3 Leading Hand"; Rec."Shift 3 Leading Hand")
                {
                    ToolTip = 'Specifies the value of the Shift 3 Leading Hand field.', Comment = '%';
                }
                field("Shift 3 Foreman"; Rec."Shift 3 Foreman")
                {
                    ToolTip = 'Specifies the value of the Shift 3 Foreman field.', Comment = '%';
                }
                field("Cold End Coating"; Rec."Cold End Coating")
                {
                    ToolTip = 'Specifies the value of the Cold End Coating field.', Comment = '%';
                }
                field("Weight Issue Min"; Rec."Weight Issue Min")
                {
                    ToolTip = 'Specifies the value of the Weight Issue Min field.', Comment = '%';
                }
                 field("Weight Issue Max"; Rec."Weight Issue Max")
                {
                    ToolTip = 'Specifies the value of the Weight Issue Max field.', Comment = '%';
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
    actions
    {
        area(Navigation)
        {
            group(Action12)
            {
                Caption = 'Create';
                Image = Create;
                action(GenerateLines)
                {
                    ApplicationArea = Suite;
                    Caption = 'Generate Lines';
                    Image = Create;
                    Promoted = True;
                    PromotedIsBig = True;
                    PromotedCategory = New;
                    ToolTip = 'Create lines';
                    trigger OnAction()
                    var
                        ColdEndLine: Record "Cold End Presort Detail Lines";
                        ColdEndLineBlankSection: Record "Cold End Presort Detail Lines";
                        ColdEndLineNo: Record "Cold End Presort Detail Lines";
                        QCParameter: Record "QC Parameters";
                        QCParameterType: Record "QC Parameter Type";
                        QCPlanLine: Record "QC Plan Lines";
                        UploadMouldNo: Record "Update Mould No";
                        Enumtext: Integer;
                        FrontBack: Integer;
                        Time: Integer;
                        Proceed: Boolean;
                        Count: Integer;
                    begin
                        Proceed := True;
                        ColdEndLine.Reset();
                        ColdEndLine.SetRange("Released Prod Order No.", Rec."Released Prod Order No.");
                        ColdEndLine.SetRange("Production Order Date", Rec."Production Order Date");
                        If ColdEndLine.FindFirst() then
                            If not Confirm('It will delete the existing lines and create New. Do you want to Continue?') then
                                Proceed := false;
                        If Proceed then begin
                            ColdEndLine.DeleteAll();
                            Clear(Count);
                            foreach Time in Enum::Time.Ordinals() do begin
                                for Enumtext := 1 to Enum::"Section No.".Ordinals().Count - 1  do begin
                                    foreach FrontBack in Enum::"Front Back".Ordinals() do begin
                                        ColdEndLine.Init();
                                        ColdEndLine."Released Prod Order No." := Rec."Released Prod Order No.";
                                        ColdEndLine."Production Order Date" := Rec."Production Order Date";
                                        ColdEndLineNo.Reset();
                                        ColdEndLineNo.SetAscending("Line No.", false);
                                        ColdEndLineNo.SetRange("Released Prod Order No.", Rec."Released Prod Order No.");
                                        ColdEndLineNo.SetRange("Production Order Date", Rec."Production Order Date");
                                        If ColdEndLineNo.FindFirst() then
                                            ColdEndLine."Line No." := ColdEndLineNo."Line No." + 10000
                                        else
                                            ColdEndLine."Line No." := 10000;
                                        ColdEndLine.Insert();
                                        Evaluate(ColdEndLine."Section No.", Format(Enumtext));
                                        Evaluate(ColdEndLine."Front/Back", Format(FrontBack));
                                        Evaluate(ColdEndLine.Frequency, Format(Time));

                                        UploadMouldNo.Reset();
                                        UploadMouldNo.SetRange("Work Order No.", Rec."Released Prod Order No.");
                                        UploadMouldNo.SetRange("Section No.", ColdEndLine."Section No.");
                                        If UploadMouldNo.FindFirst() then
                                            If ColdEndLine."Front/Back" = ColdEndLine."Front/Back"::F then
                                                ColdEndLine."Cavity No" := UploadMouldNo."Front Mould No"
                                            Else
                                                ColdEndLine."Cavity No" := UploadMouldNo."Back Mould No";
                                        ColdEndLine.Modify();

                                        Count += 1;
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
                
            }

            group(Action13)
            {
                Caption = 'Print';
                Image = Report;

                action(PrintInspectionChallenge)
                {
                    ApplicationArea = Suite;
                    Caption = 'Print Cold End Presort';
                    Image = Print;
                    Promoted = True;
                    PromotedIsBig = True;
                    PromotedCategory = Report;
                    ToolTip = 'Print the Print Cold End Presort report for the current Released Prod Order No.';

                    trigger OnAction()
                    var
                        ColdEndPresortHeader: Record "Cold End Presort Detail Header";
                        ColdEndPresortReport: Report "Cold End Presort Report";
                    begin
                        if Rec."Released Prod Order No." = '' then begin
                            Message('No Released Prod Order No. specified.');
                            exit;
                        end;

                        ColdEndPresortHeader.Reset();
                        ColdEndPresortHeader.SetRange("Released Prod Order No.", Rec."Released Prod Order No.");
                        ColdEndPresortHeader.SetRange("Production Order Date", Rec."Production Order Date");

                        if ColdEndPresortHeader.FindFirst() then begin
                            ColdEndPresortReport.SetTableView(ColdEndPresortHeader);
                            ColdEndPresortReport.RunModal();
                        end else begin
                            Message('No record found to print.');
                        end;
                    end;
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

            end;
    end;
}
