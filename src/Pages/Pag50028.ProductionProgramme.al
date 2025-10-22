page 50028 "Production Programme"
{
    ApplicationArea = All;
    Caption = 'Production Programme';
    PageType = Document;
    SourceTable = "Production Programme Header";
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("No of Archived Versions"; Rec."No of Archived Versions")
                {
                    ToolTip = 'Specifies the value of the No of Archived Versions field.', Comment = '%';
                }
                field("Created Date"; Rec."Created Date")
                {
                    ToolTip = 'Specifies the value of the Created Date field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Demand Forecast Name"; Rec."Demand Forecast Name")
                {
                    ToolTip = 'Specifies the value of the Demand Forecast Name field.', Comment = '%';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
            }
            part(ProductionProgrammeLines; "Production Programme Subform")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
                UpdatePropagation = Both;
                Caption = 'Production Programme Lines';
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        ManufacturingSetup: Record "Manufacturing Setup";
        NoSeries: Codeunit "No. Series";
    begin

        If ManufacturingSetup.Get() then
            If not (ManufacturingSetup."Production Programme No." = '') then begin
                Rec."No." := NoSeries.PeekNextNo(ManufacturingSetup."Production Programme No.");
                Rec."Created Date" := System.Today();
            end else
                Error('Production Programme No series setup is not done in Manufacturing setup');
    end;
}
