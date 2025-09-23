page 50018 "COA Detail"
{
    ApplicationArea = All;
    Caption = 'COA Detail';
    PageType = Document;
    SourceTable = "COA Header";

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
                field("Ring Finish"; Rec."Ring Finish")
                {
                    ToolTip = 'Specifies the value of the Ring Finish field.', Comment = '%';
                }
                field(Machine; Rec.Machine)
                {
                    ToolTip = 'Specifies the value of the Machine field.', Comment = '%';
                }
                field("Fill Point"; Rec."Fill Point")
                {
                    ToolTip = 'Specifies the value of the Fill Point field.', Comment = '%';
                }
                field("Water Temp"; Rec."Water Temp")
                {
                    ToolTip = 'Specifies the value of the Water Temp field.', Comment = '%';
                }
                field("Send To"; Rec."Send To")
                {
                    ToolTip = 'Specifies the value of the Send To field.', Comment = '%';
                }
            }
            part(COALines; "COA Lines")
            {
                ApplicationArea = All;
                SubPageLink = "Released Prod Order No." = field("Released Prod Order No."), "Production Order Date" = field("Production Order Date");
                UpdatePropagation = Both;
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
                    Caption = 'Generate COA Lines';
                    Image = Create;
                    Promoted = True;
                    PromotedIsBig = True;
                    PromotedCategory = Process;
                    ToolTip = 'Create COA lines based on the QC Plan Header';
                    trigger OnAction()
                    var
                        COALine: Record "COA Lines";
                        COALineNo: Record "COA Lines";
                        QCParameter: Record "QC Parameters";
                        QCParameterType: Record "QC Parameter Type";
                        QCPlanLine: Record "QC Plan Lines";
                        Enumtext: Integer;
                        FrontBack: Integer;
                        Count: Integer;
                    begin
                        COALine.Reset();
                        COALine.SetRange("Released Prod Order No.",Rec."Released Prod Order No.");
                        COALine.SetRange("Production Order Date",Rec."Production Order Date");
                        COALine.DeleteAll();
                        Clear(Count);
                        QCPlanLine.Reset();
                        QCPlanLine.SetRange("Job No.", Rec."Job No.");
                        If QCPlanLine.FindSet() then
                            repeat
                                If QCParameter.Get(QCPlanLine."Parameter Code") then;
                                If QCParameterType.Get(QCParameter."Parameter Type") then
                                    If QCParameterType."COA Needed" then begin
                                        foreach Enumtext in Enum::"Section No.".Ordinals() do begin
                                            foreach FrontBack in Enum::"Front Back".Ordinals() do begin
                                                COALine.Init();
                                                COALine."Released Prod Order No." := Rec."Released Prod Order No.";
                                                COALine."Production Order Date" := Rec."Production Order Date";
                                                COALineNo.Reset();
                                                COALineNo.SetAscending("Line No.", false);
                                                COALineNo.SetRange("Released Prod Order No.", Rec."Released Prod Order No.");
                                                COALineNo.SetRange("Production Order Date", Rec."Production Order Date");
                                                If COALineNo.FindFirst() then
                                                    COALine."Line No." := COALineNo."Line No." + 10000
                                                else
                                                    COALine."Line No." := 10000;
                                                COALine.Insert();
                                                Evaluate(COALine."Section No.", Format(Enumtext));
                                                Evaluate(COALine."Front/Back", Format(FrontBack));
                                                COALine.Min := QCPlanLine.Min;
                                                COALine.Max := QCPlanLine.Max;
                                                COALine."QC Parameter Code" := QCPlanLine."Parameter Code";
                                                COALine."QC Parameter Name" := QCPlanLine."Parameter Name";
                                                COALine.Modify();
                                                Count += 1;
                                            end;
                                        end;
                                    end;
                            until QCPlanLine.Next() = 0;
                        If Count > 1 then
                            Message('COA Lines created')
                        else
                            Message('No Lines created');
                    end;
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        ReleaseProdOrder: Record "Production Order";
    begin
        If ReleaseProdOrder.Get(ReleaseProdOrder.Status::Released, Rec."Released Prod Order No.") then
            If ReleaseProdOrder."Source Type" = ReleaseProdOrder."Source Type"::Item then begin
                Rec."Production Order Date" := WorkDate();
                Rec.Validate("Job No.", ReleaseProdOrder."Source No.");
            end;
    end;
}
