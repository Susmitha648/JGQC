page 50014 "Machine/Section Stoppages"
{
    ApplicationArea = All;
    Caption = 'Machine/Section Stoppages';
    PageType = Card;
    SourceTable = "Machine/Section Stoppages";
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
        }
}
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Line No." := Rec.GetLastLineNo() + 10;
    end;
    trigger OnOpenPage()
    var
    ProductionOrder : Record "Production Order";
    begin
      /* ProductionOrder.SetRange("No.",Rec."Production Order No.");
       If ProductionOrder.FindFirst() then
          If ProductionOrder.Status = ProductionOrder.Status::Finished then 
            IsEditable := false;*/
    end;
    
}
