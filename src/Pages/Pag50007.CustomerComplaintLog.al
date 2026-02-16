page 50007 "Customer Complaint Log"
{
    ApplicationArea = All;
    Caption = 'Customer Complaint Log';
    PageType = Card;
    SourceTable = "Customer Complaint Log";
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("CCR No"; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the CCR No field.', Comment = '%';
                }
                field("CCR Date"; Rec."CCR Date")
                {
                    ToolTip = 'Specifies the value of the CCR Date field.', Comment = '%';
                }
                field("Customer No"; Rec."Customer No")
                {
                    ToolTip = 'Specifies the value of the Customer No field.', Comment = '%';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field.', Comment = '%';
                }
                 field("Customer Contact"; Rec."Customer Contact")
                {
                    ToolTip = 'Specifies the value of the Customer Contact field.', Comment = '%';
                }
                field("Job No"; Rec."Job No")
                {
                    ToolTip = 'Specifies the value of the Job No field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Complaint Details"; Rec."Complaint Details")
                {
                    ToolTip = 'Specifies the value of the Complaint Details field.', Comment = '%';
                    MultiLine = true;
                }
                field("Complaint Type"; Rec."Complaint Type")
                {
                    ToolTip = 'Specifies the value of the Complaint Type field.', Comment = '%';
                }
                field("Shift/Machine"; Rec."Shift/Machine")
                {
                    ToolTip = 'Specifies the value of the Shift/Machine field.', Comment = '%';
                }
                field("CCI Report Date"; Rec."CCI Report Date")
                {
                    ToolTip = 'Specifies the value of the CCI Report Date field.', Comment = '%';
                }
                field("Complaint Classification"; Rec."Complaint Classification")
                {
                    ToolTip = 'Specifies the value of the Complaint Classification field.', Comment = '%';
                }
                field("Complaint Category"; Rec."Complaint Category")
                {
                    ToolTip = 'Specifies the value of the Complaint Category field.', Comment = '%';
                }
                field("Complaint Category Remarks "; Rec."Complaint Category Remarks ")
                {
                    ToolTip = 'Specifies the value of the Complaint Category Remarks field.', Comment = '%';
                    MultiLine = true;
                }
                field("CCR Link"; Rec."CCR Link")
                {
                    ToolTip = 'Specifies the value of the CCR Link field.', Comment = '%';
                    //ExtendedDatatype = URL;
                    trigger OnDrillDown()
                    begin
                        System.Hyperlink(Rec."CCR Link");
                    end;
                }
                field("CCI Link"; Rec."CCI Link")
                {
                    ToolTip = 'Specifies the value of the CCI Link field.', Comment = '%';
                    //ExtendedDatatype = URL;
                   trigger OnDrillDown()
                    begin
                        System.Hyperlink(Rec."CCI Link");
                    end;
                }
                field("CC ShopFloor Update"; Rec."CC ShopFloor Update")
                {
                    ToolTip = 'Specifies the value of the CC ShopFloor Update field.', Comment = '%';
                }
                 field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status by field.', Comment = '%';
                }
            }
            group(Investigation)
            {
                field(Invest; Invest)
                {
                    ToolTip = 'Specifies the value of the Investigation field.', Comment = '%';
                    MultiLine = true;
                    ExtendedDatatype = RichContent;
                    ShowCaption = false;
                    trigger OnValidate()
                    begin
                        Rec.Investigation := Invest;
                    end;
                }
            }
            group("Root Cause")
            {
                field(RootCause; RootCause)
                {
                    ToolTip = 'Specifies the value of the Root Cause field.', Comment = '%';
                    MultiLine = true;
                    ExtendedDatatype = RichContent;
                    ShowCaption = false;
                    trigger OnValidate()
                    begin
                        Rec."Root Cause" := RootCause;
                    end;
                }
            }
            group("Corrective Action")
            {
                field(CorrectiveAction;CorrectiveAction)
                {
                    ToolTip = 'Specifies the value of the Corrective Action field.', Comment = '%';
                    MultiLine = true;
                    ExtendedDatatype = RichContent;
                    ShowCaption = false;
                    trigger OnValidate()
                    begin
                        Rec."Corrective Action" := CorrectiveAction;
                    end;
                }
            }
            group("Preventive Action")
            {
                field(PreventiveAction; PreventiveAction)
                {
                    ToolTip = 'Specifies the value of the Preventive Action field.', Comment = '%';
                    MultiLine = true;
                    ExtendedDatatype = RichContent;
                    ShowCaption = false;
                    trigger OnValidate()
                    begin
                        Rec."Preventive Action" := PreventiveAction;
                    end;
                }
            }

        }
        area(factboxes)
        {
            part("Attached Documents List"; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Documents';
                UpdatePropagation = Both;
                SubPageLink = "Table ID" = const(Database::"Customer Complaint Log"),
                              "No." = field("No.");
            }
        }
    }
     actions
    {
        area(Processing)
        {
            group(Action12)
            {
                 action(Release)
                {
                    ApplicationArea = Suite;
                    Caption = 'Re&lease';
                    Enabled = Rec.Status <> Rec.Status::Released;
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';
                    Promoted = True;
                    PromotedIsBig = True;
                    PromotedCategory = Process;
                    ToolTip = 'Release the document to the next stage of processing. You must reopen the document before you can make changes to it.';

                    trigger OnAction()
                    var
                        
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
                    PromotedCategory = Process;
                    ToolTip = 'ReOpen the document.';

                    trigger OnAction() 
                    begin
                        PerformManualReopen();
                    end;
                }
                action(PrintCCL)
                {
                    ApplicationArea = All;
                    Caption = 'Print CCL';
                    Image = Print;
                    ShortCutKey = 'Ctrl+F7';
                    Promoted = True;
                    PromotedIsBig = True;
                    PromotedCategory = Process;
                    ToolTip = 'Print the CCL Report.';

                    trigger OnAction()
                    var
                        Report50001: Report "CCI Report (DEV)";
                        CCLRec: Record "Customer Complaint Log";
                    begin
                        CCLRec.Copy(Rec);
                        CCLRec.SetRange("No.", Rec."No.");
                        Report50001.SetTableView(CCLRec);
                        Report50001.RunModal();
                    end;
                }

            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        Clear(Invest);
        Clear(RootCause);
        Clear(PreventiveAction);
        Clear(CorrectiveAction);
        if Rec."No." <> '' then
            Rec.Get(Rec."No.");
        Invest := Rec.Investigation;
        RootCause := Rec."Root Cause";
        PreventiveAction := Rec."Preventive Action";
        CorrectiveAction := Rec."Corrective Action";
    end;
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
    var
    Invest : Text;
    RootCause : Text;
    CorrectiveAction : Text;
    PreventiveAction : Text;
}
