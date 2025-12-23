page 50024 "Inspection Challenge Sample"
{
    ApplicationArea = All;
    Caption = 'Inspection Challenge Sample';
    PageType = Document;
    SourceTable = "Inspection Challenge Sample He";
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
                        DefectCodeList: Record "Defect Code";
                        DefectCodeList1: Record "Defect Code";
                        DefectCodePage: Page "Defect Code List";
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
                            Clear(Count);


                            DefectCodePage.Editable(True);
                            If DefectCodePage.RunModal() = Action::OK then begin

                                InspectionLine.DeleteAll();
                                DefectCodeList.SetRange("Create Inspection Lines", True);
                                If DefectCodeList.FindSet() then
                                    repeat
                                        foreach Enumtext in Enum::Time.Ordinals() do begin
                                           
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
                                                If DefectCodeList."Inspection Type" = DefectCodeList."Inspection Type"::"Mechanical Inspection Machine" then
                                                    InspectionLine."Inspection Type" := InspectionLine."Inspection Type"::"Mechanical Inspection Machine";
                                                If DefectCodeList."Inspection Type" = DefectCodeList."Inspection Type"::"Visual Inspection Machine" then
                                                    InspectionLine."Inspection Type" := InspectionLine."Inspection Type"::"Visual Inspection Machine";  
                                                Evaluate(InspectionLine.Frequency, Format(Enumtext));
                                                InspectionLine."QC Defect Code" := DefectCodeList."Defect Code";
                                                InspectionLine.Insert();
                                                Count += 1;
                                           
                                        end;
                                    until DefectCodeList.Next() = 0;


                            end;
                            DefectCodeList1.SetRange("Create Inspection Lines", True);
                            DefectCodeList.ModifyAll("Create Inspection Lines", false);
                        end;
                        If Count > 1 then
                            Message('Lines created')
                        else
                            Message('No Lines created');
                    end;
                }
                action(CopyDoc)
                {
                    ApplicationArea = Suite;
                    Caption = 'Copy Document';
                    Image = Copy;
                    Promoted = True;
                    PromotedIsBig = True;
                    PromotedCategory = New;
                    ToolTip = 'Copy Inspection Challenge Lines';
                    trigger OnAction()
                    var
                    CopyReport : Report "Copy Inspection Challenge";
                    begin
                        CopyReport.Set(Rec);
                        CopyReport.RunModal();
                       
                        //if Rec.Get(Rec."Production Order No.",Rec."Line No.") then;
                        
                        CurrPage.Update();
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

                group(Action13)
                {
                    Caption = 'Print';
                    Image = Report;

                    action(PrintInspectionChallenge)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Print Inspection Challenge';
                        Image = Print;
                        Promoted = True;
                        PromotedIsBig = True;
                        PromotedCategory = Report;
                        ToolTip = 'Print the Inspection Challenge report for the current Released Prod Order No.';

                        trigger OnAction()
                        var
                            InspectionHeader: Record "Inspection Challenge Sample He";
                            InspectionReport: Report "Inspection Challenge Report";
                        begin
                            if Rec."Released Prod Order No." = '' then begin
                                Message('No Released Prod Order No. specified.');
                                exit;
                            end;

                            InspectionHeader.Reset();
                            InspectionHeader.SetRange("Released Prod Order No.", Rec."Released Prod Order No.");
                            InspectionHeader.SetRange("Production Order Date", Rec."Production Order Date");

                            if InspectionHeader.FindFirst() then begin
                                InspectionReport.SetTableView(InspectionHeader);
                                InspectionReport.RunModal();
                            end else begin
                                Message('No record found to print.');
                            end;
                        end;
                    }
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