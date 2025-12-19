page 50026 "Inspection Challenge Sample Li"
{
    ApplicationArea = All;
    Caption = 'Inspection Challenge Sample Lines';
    PageType = ListPart;
    SourceTable = "Inspection Challenge Sample li";
    //AutoSplitKey = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Released Prod Order No."; Rec."Released Prod Order No.")
                {
                    ToolTip = 'Specifies the value of the Released Prod Order No. field.', Comment = '%';
                    Editable = false;
                }
                field("Production Order Date"; Rec."Production Order Date")
                {
                    ToolTip = 'Specifies the value of the Production Order Date field.', Comment = '%';
                    Editable = false;
                }
                field("Inspection Type"; Rec."Inspection Type")
                {
                    ToolTip = 'Specifies the value of the Inspection Type field.', Comment = '%';
                }
                field("Time"; Rec."Frequency")
                {
                    ToolTip = 'Specifies the value of the Frequency field.', Comment = '%';
                }
                field("QC Defect Code"; Rec."QC Defect Code")
                {
                    ToolTip = 'Specifies the value of the QC Defect Code field.', Comment = '%';
                }
                field("Reject %"; Rec."Reject %")
                {
                    ToolTip = 'Specifies the value of the Reject % field.', Comment = '%';
                }
                field("Defect Reject %"; Rec."Defect Reject %")
                {
                    ToolTip = 'Specifies the value of the Defect Reject % field.', Comment = '%';
                }
                 field("Sampling Time"; Rec."Sampling Time")
                {
                    ToolTip = 'Specifies the value of the Sampling Time field.', Comment = '%';
                }
                 field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                }

            }
        }
    }
     actions
    {
        area(Processing)
        {
            group(CreatePO)
            {
                Caption = 'MNR';
                action(Create)
                {
                    ApplicationArea = Suite;
                    Caption = 'MNR';
                    Image = List;
                    ToolTip = 'MNR';
                    RunObject = Page MNR;
                    RunPageLink = "Production Order No" = field("Released Prod Order No."),Frequency = field(Frequency);
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
    InspectionLine2 : Record "Inspection Challenge Sample li";
    begin
        InspectionLine2.Reset();
        InspectionLine2.SetAscending("Line No.", false);
        InspectionLine2.SetRange("Released Prod Order No.", Rec."Released Prod Order No.");
        InspectionLine2.SetRange("Production Order Date", Rec."Production Order Date");
        If InspectionLine2.FindFirst() then
            Rec."Line No." := InspectionLine2."Line No." + 10000
        else
            Rec."Line No." := 10000;
    end;
}
