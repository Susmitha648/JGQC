page 50014 "Machine/Section Stoppages"
{
    ApplicationArea = All;
    Caption = 'Machine/Section Stoppages';
    PageType = Card;
    SourceTable = "Machine/Section Stoppages";
    PromotedActionCategoriesML = ENU = 'Copy';
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
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                }
                field(Shift; Rec.Shift)
                {
                    ToolTip = 'Specifies the value of the Shift field.', Comment = '%';
                }
                field("Machine Stoppages Code"; Rec."Machine Stoppages Code")
                {
                    ToolTip = 'Specifies the value of the Machine Stoppages Code field.', Comment = '%';
                }
                field("Machine Stoppage Description"; Rec."Machine Stoppage Description")
                {
                    ToolTip = 'Specifies the value of the Machine Stoppage Description field.', Comment = '%';
                    MultiLine = true;
                }
                field("Section Stoppage Code"; Rec."Section Stoppage Code")
                {
                    ToolTip = 'Specifies the value of the Section Stoppage Code field.', Comment = '%';
                }
                field("Section Stoppage Description"; Rec."Section Stoppage Description")
                {
                    ToolTip = 'Specifies the value of the Section Stoppage Description field.', Comment = '%';
                    MultiLine = true;
                }
                
                 field("Machine Number"; Rec."Machine Number")
                {
                    ToolTip = 'Specifies the value of the Machine Number field.', Comment = '%';
                }
                field("Section No."; Rec."Section No.")
                {
                    ToolTip = 'Specifies the value of the Section No. field.', Comment = '%';
                }
                field("Incident Date"; Rec."Incident Date")
                {
                    ToolTip = 'Specifies the value of the Incident Date field.', Comment = '%';
                }
                field("Start Time"; Rec."Start Time")
                {
                    ToolTip = 'Specifies the value of the Start Time field.', Comment = '%';
                }
                field("End Time"; Rec."End Time")
                {
                    ToolTip = 'Specifies the value of the End Time field.', Comment = '%';
                }
                field("Downtime (Hrs)"; Rec."Downtime (Hrs)")
                {
                    ToolTip = 'Specifies the value of the Downtime (Hrs) field.', Comment = '%';
                }
                field("Shift Fitter"; Rec."Shift Fitter")
                {
                    ToolTip = 'Specifies the value of the Shift Fitter field.', Comment = '%';
                    MultiLine = true;
                }
                field("Machine Operator"; Rec."Machine Operator")
                {
                    ToolTip = 'Specifies the value of the Machine Operator field.', Comment = '%';
                    MultiLine = true;
                }
                field("Asst Machine Operator"; Rec."Asst Machine Operator")
                {
                    ToolTip = 'Specifies the value of the Asst Machine Operator field.', Comment = '%';
                    MultiLine = true;
                }
                field("Foreman/Shift Supt"; Rec."Foreman/Shift Supt")
                {
                    ToolTip = 'Specifies the value of the Foreman/Shift Supt field.', Comment = '%';
                    MultiLine = true;
                }
            }
            group(Action)
            {
                Caption = 'Action';
                field(Department; Rec.Department)
                {
                    ToolTip = 'Specifies the value of the Department field.', Comment = '%';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                    MultiLine = true;
                }
                field("Root Cause"; Rec."Root Cause")
                {
                    ToolTip = 'Specifies the value of the Root Cause field.', Comment = '%';
                    MultiLine = true;
                }
                field("Corrective Action Taken"; Rec."Corrective Action Taken")
                {
                    ToolTip = 'Specifies the value of the Corrective Action Taken field.', Comment = '%';
                    MultiLine = true;
                }
                field("Preventive Action Taken"; Rec."Preventive Action Taken")
                {
                    ToolTip = 'Specifies the value of the Preventive Action Taken field.', Comment = '%';
                    MultiLine = true;
                }
                field("MS Status"; Rec."MS Status")
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
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
                SubPageLink = "Table ID" = const(Database::"Machine/Section Stoppages"),
                              "No." = field("Production Order No."),"Line No." = field("Line No.");
            }
        }
            

    }
    actions
    {
        area(Navigation)
        {
            group(Action12)
            {
                Caption = 'Copy';
                Image = Copy;
               
                action(CopyDoc)
                {
                    ApplicationArea = Suite;
                    Caption = 'Copy Document';
                    Image = Copy;
                    Promoted = True;
                    PromotedIsBig = True;
                    PromotedCategory = New;
                    ToolTip = 'Copy Machine Section Stoppages';
                    trigger OnAction()
                    var
                    CopyReport : Report "Copy Machine Stoppages";
                    begin
                       CopyReport.Set(Rec);
                       CopyReport.RunModal();
                       If Rec.Get(Rec."Production Order No.") then;
                       CurrPage.Update();
                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        MachinSectinStoppages: Record "Machine/Section Stoppages";
         ReleaseProdOrder: Record "Production Order";
    begin
        MachinSectinStoppages.Reset();
        MachinSectinStoppages.SetAscending("Line No.", false);
        MachinSectinStoppages.SetRange("Production Order No.", Rec."Production Order No.");
        If MachinSectinStoppages.FindFirst() then
            Rec."Line No." := MachinSectinStoppages."Line No." + 10
        else
            Rec."Line No." := MachinSectinStoppages."Line No.";
        If ReleaseProdOrder.Get(ReleaseProdOrder.Status::Released, Rec."Production Order No.") then
            If ReleaseProdOrder."Source Type" = ReleaseProdOrder."Source Type"::Item then begin
                Rec."Machine Number" := ReleaseProdOrder."Location Code";
            end;
    end;
}
