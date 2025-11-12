page 50028 "Production Programme"
{
    ApplicationArea = All;
    Caption = 'Production Programme';
    PageType = Document;
    SourceTable = "Production Programme Header";
    PromotedActionCategoriesML = ENU = 'Home,Process,Report,Release,Create, Print';
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
                field("No of Archived Versions"; Rec."No of Archived Versions")
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
                    MultiLine = True;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
            }
            part(ProductionProgrammeLines; "Production Programme Subform")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
                UpdatePropagation = Both;
                Caption = 'Production Programme Lines';
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            group(Action12)
            {
                action(Create)
                {
                    ApplicationArea = Suite;
                    Caption = 'Create Production Programme Lines';
                    Image = Create;
                    Promoted = True;
                    PromotedIsBig = True;
                    PromotedCategory = Category5;
                    ToolTip = 'Create Production Programme Lines based on the Request form data';
                    trigger OnAction()
                    var
                        ProdProg: Record "Production Programme Header";
                    begin
                        CurrPage.SetSelectionFilter(ProdProg);
                        Report.RunModal(50008, True, false, ProdProg);
                    end;
                }


                action("Archive Document")
                {
                    ApplicationArea = Suite;
                    Caption = 'Archi&ve Document';
                    Image = Archive;
                    Promoted = True;
                    PromotedIsBig = True;
                    PromotedCategory = Category5;
                    ToolTip = 'Send the document to the archive, for example because it is too soon to delete it. Later, you delete or reprocess the archived document.';

                    trigger OnAction()
                    begin
                        ArchiveProdProgDocument();

                    end;
                }
            }
        }

        area(Processing)
        {
            group(ReleaseDoc)
            {
                Caption = 'Process';
                action(Release)
                {
                    ApplicationArea = Suite;
                    Caption = 'Re&lease';
                    Enabled = Rec.Status <> Rec.Status::Released;
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';
                    Promoted = True;
                    PromotedIsBig = True;
                    PromotedCategory = Category4;
                    ToolTip = 'Release the document to the next stage of processing. You must reopen the document before you can make changes to it.';

                    trigger OnAction()
                    begin

                        PerformManualRelease();
                    end;
                }
                action(ReOpen)
                {
                    ApplicationArea = Suite;
                    Caption = 'Re&Open';
                    Enabled = Rec.Status <> Rec.Status::Open;
                    Image = ReOpen;
                    ShortCutKey = 'Ctrl+F9';
                    Promoted = True;
                    PromotedIsBig = True;
                    PromotedCategory = Category4;
                    ToolTip = 'ReOpen the document.';

                    trigger OnAction()
                    begin
                        PerformManualReopen();
                    end;
                }
            }

            group(_Print)
            {
                action(Print)
                {
                    ApplicationArea = Suite;
                    Caption = 'Production Programme';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Category6;
                    ToolTip = 'Print the Production Programme report.';

                    trigger OnAction()
                    var
                        ProdProgHeader: Record "Production Programme Header";
                    begin
                        CurrPage.SetSelectionFilter(ProdProgHeader);
                        Report.RunModal(Report::"Production Programme", true, false, ProdProgHeader);
                    end;
                }
                action(F2DailyProduction)
                {
                    ApplicationArea = Suite;
                    Caption = 'F2 - Daily Production Report';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Category6;
                    ToolTip = 'Print the F2 - Daily Production Report.';

                    trigger OnAction()
                    var
                        ProdProgHeader: Record "Production Programme Line";
                    begin
                        
                        Report.RunModal(Report::"F2 Daily Production Report", true, false);
                    end;
                }

            }
        }
    }
    procedure PerformManualReopen()
    begin

        if Rec.Status = Rec.Status::Open then
            exit;
        Rec.Status := Rec.Status::Open;
        Rec.Modify();
    end;

    procedure PerformManualRelease()
    begin

        if Rec.Status <> Rec.Status::Released then begin
            Rec.Status := Rec.Status::Released;
            Rec.Modify();
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        ManufacturingSetup: Record "Manufacturing Setup";
        NoSeries: Codeunit "No. Series";
    begin

        If ManufacturingSetup.Get() then
            If not (ManufacturingSetup."Production Programme No." = '') then begin
                Rec."No." := NoSeries.PeekNextNo(ManufacturingSetup."Production Programme No.");
                Rec."Created Date" := System.Today();
            end else
                Error('Production Programme No series setup is not done in Manufacturing setup');
    end;

    procedure ArchiveProdProgDocument()
    var
        ProdLine: Record "Production Programme Line";
        HeaderArchive: Record "Production Programme Archive";
        PurchLineArchive: Record "Production Prgrme Archive Line";
        IsHandled: Boolean;
    begin


        HeaderArchive.Init();
        HeaderArchive.TransferFields(Rec);
        HeaderArchive."Archived By" := CopyStr(UserId(), 1, MaxStrLen(HeaderArchive."Archived By"));
        HeaderArchive."Date Archived" := Today();
        HeaderArchive."Time Archived" := Time();
        HeaderArchive."Version No." := Rec."No of Archived Versions" + 1;
        HeaderArchive.Insert();


        ProdLine.SetRange("No.", Rec."No.");
        if ProdLine.FindSet() then
            repeat
                PurchLineArchive.Init();
                PurchLineArchive.TransferFields(ProdLine);
                PurchLineArchive."Version No." := HeaderArchive."Version No.";
                PurchLineArchive.Insert();

            until ProdLine.Next() = 0;
        Rec."No of Archived Versions" := Rec."No of Archived Versions" + 1;
        Rec.Modify();
    end;


}
