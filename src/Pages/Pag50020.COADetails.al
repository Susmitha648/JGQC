page 50020 "COA Details"
{
    ApplicationArea = All;
    Caption = 'COA Details';
    PageType = List;
    SourceTable = "COA Header";
    UsageCategory = Lists;
    Editable = false;
    CardPageId = "COA Detail";
    layout
    {
        area(Content)
        {
            repeater(General)
            {
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
                field("Send To"; Rec."Send To")
                {
                    ToolTip = 'Specifies the value of the Send To field.', Comment = '%';
                }
            }
        }

    }
    actions
    {
        area(Processing)
        {
            group(Print)
            {
                action("COA Report")
                {
                    ApplicationArea = All;
                    Caption = 'COA Report';
                    Image = Report; // Optional icon
                    trigger OnAction()
                    var
                        MyReportID: Integer;
                        JobNo: Record "COA Header";
                    begin
                        MyReportID := Report::"COA Report";
                        JobNo.Reset();
                        JobNo.SetRange("Job No.", Rec."Job No.");
                        If JobNo.FindSet() then
                            Report.RunModal(MyReportID, true, false, JobNo);
                    end;
                }
            }
        }
    }
}
