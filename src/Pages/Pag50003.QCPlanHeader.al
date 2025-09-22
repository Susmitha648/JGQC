page 50003 "QC Plan Header"
{
    ApplicationArea = All;
    Caption = 'QC Plan Header';
    PageType = Document;
    SourceTable = "QC Plan Header";
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                
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
                field("Customer Code"; Rec."Customer Code")
                {
                    ToolTip = 'Specifies the value of the Customer Code field.', Comment = '%';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field.', Comment = '%';
                    Editable = false;
                }
                field("Room Temperature"; Rec."Room Temperature")
                {
                    ToolTip = 'Specifies the value of the Room Temperature field.', Comment = '%';
                }
                field("IM Starwheel Code"; Rec."IM Starwheel Code")
                {
                    ToolTip = 'Specifies the value of the IM Starwheel Code field.', Comment = '%';
                }
                field(Colour; Rec.Colour)
                {
                    ToolTip = 'Specifies the value of the Colour field.', Comment = '%';
                }
                 field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
            }
            part(QCPlanLine; "QC Plan Line")
            {
                ApplicationArea = All;
               // Editable = IsSalesLinesEditable;
                //Enabled = IsSalesLinesEditable;
                SubPageLink = "Job No." = field("Job No.");
                UpdatePropagation = Both;
            }
            
        }
        area(factboxes)
        {
            part("Attached Documents List"; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Documents';
                UpdatePropagation = Both;
                SubPageLink = "Table ID" = const(Database::"QC Plan Header"),
                              "No." = field("Job No.");
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
}
