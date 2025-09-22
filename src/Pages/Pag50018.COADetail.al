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
