page 50009 "Customer Complaint Report"
{
    ApplicationArea = All;
    Caption = 'Customer Complaint Report';
    PageType = Card;
    SourceTable = "Customer Complaint Report";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
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
                field("Job No"; Rec."Job No")
                {
                    ToolTip = 'Specifies the value of the Job No field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Ring Finish"; Rec."Ring Finish")
                {
                    ToolTip = 'Specifies the value of the Ring Finish field.', Comment = '%';
                }
                field("Complaint Received Date"; Rec."Complaint Received Date")
                {
                    ToolTip = 'Specifies the value of the Complaint Received Date field.', Comment = '%';
                }
                field("Customer Contact"; Rec."Customer Contact")
                {
                    ToolTip = 'Specifies the value of the Customer Contact field.', Comment = '%';
                }
                field("Complaint Details"; Rec."Complaint Details")
                {
                    ToolTip = 'Specifies the value of the Complaint Details field.', Comment = '%';
                    MultiLine = True;
                }
                field("Complaint Type"; Rec."Complaint Type")
                {
                    ToolTip = 'Specifies the value of the Complaint Type field.', Comment = '%';
                }
                field("Defect Name"; Rec."Defect Name")
                {
                    ToolTip = 'Specifies the value of the Defect Name field.', Comment = '%';
                }
                field("Complaint Category "; Rec."Complaint Category ")
                {
                    ToolTip = 'Specifies the value of the Complaint Category field.', Comment = '%';
                }
                field("Complaint Category Remarks"; Rec."Complaint Category Remarks")
                {
                    ToolTip = 'Specifies the value of the Complaint Category Remarks field.', Comment = '%';
                    MultiLine = True;
                }
                field("Complaint Raised by"; Rec."Complaint Raised by")
                {
                    ToolTip = 'Specifies the value of the Complaint Raised by field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status by field.', Comment = '%';
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
                SubPageLink = "Table ID" = const(Database::"Customer Complaint Report"),
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
                 action(PrintCCR)
                {
                    ApplicationArea = All;
                    Caption = 'Print CCR';
                    Image = Print;
                    ShortCutKey = 'Ctrl+F7';
                    Promoted = True;
                    PromotedIsBig = True;
                    PromotedCategory = Process;
                    ToolTip = 'Print the CCR Report.';

                    trigger OnAction()
                    var
                        Report50000: Report "CCR Report (DEV)";
                        CCRRec: Record "Customer Complaint Report";
                    begin
                        CCRRec.Copy(Rec);
                        CCRRec.SetRange("No.", Rec."No.");
                        Report50000.SetTableView(CCRRec);
                        Report50000.RunModal();
                    end;
                }

            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        if Rec."No." <> '' then
            Rec.Get(Rec."No.");
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

}
