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
                field("Time"; Rec."Time")
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
