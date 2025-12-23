report 50017 "Copy Inspection Challenge"
{
    Caption = 'Copy Inspection Challenge';
    ProcessingOnly = true;
    ApplicationArea = All;
    
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(WorkOrderNo; WorkOrderNo)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Work Order';
                        ShowMandatory = True;
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            InspectionChallenge1: Record "Inspection Challenge Sample He";
                        begin
                            InspectionChallenge1.Reset();
                            InspectionChallenge1.SetRange("Job No.", InspectionChallengeSample."Job No.");
                            if Page.RunModal(50025, InspectionChallenge1) = Action::LookupOK then
                                WorkOrderNo := InspectionChallenge1."Released Prod Order No.";
                        end;
                    }
                }
            }
        }
    }
    procedure Set(var InspectionChallengeNew: Record "Inspection Challenge Sample He")
    begin

        InspectionChallengeSample := InspectionChallengeNew;
    end;

    var
        WorkOrderNo: Code[20];
        InspectionChallengeSample: Record "Inspection Challenge Sample He";

    trigger OnPreReport()
    var
        InspectionChallengeLine2: Record "Inspection Challenge Sample li";
        InspectionChallengeLine: Record "Inspection Challenge Sample li";
        InspectionChallengeLine1: Record "Inspection Challenge Sample li";
    begin
        InspectionChallengeLine2.Reset();
        InspectionChallengeLine2.SetRange("Released Prod Order No.", InspectionChallengeSample."Released Prod Order No.");
        InspectionChallengeLine2.DeleteAll();
       
            InspectionChallengeLine.Reset();
            InspectionChallengeLine.SetRange("Released Prod Order No.", WorkOrderNo);
            If InspectionChallengeLine.FindSet() then
                repeat
                    InspectionChallengeLine1.Init();
                    InspectionChallengeLine1."Released Prod Order No." := InspectionChallengeSample."Released Prod Order No.";
                    InspectionChallengeLine1."Production Order Date" := InspectionChallengeSample."Production Order Date";
                    InspectionChallengeLine1.Frequency := InspectionChallengeLine.Frequency;
                    InspectionChallengeLine1."Line No." := InspectionChallengeLine."Line No.";
                    InspectionChallengeLine1."Inspection Type" := InspectionChallengeLine."Inspection Type";
                    InspectionChallengeLine1."QC Defect Code" := InspectionChallengeLine."QC Defect Code";
                    InspectionChallengeLine1."Reject %" := InspectionChallengeLine."Reject %";
                    InspectionChallengeLine1.Remarks := InspectionChallengeLine.Remarks;
                    InspectionChallengeLine1."Sample Quantity" := InspectionChallengeLine."Sample Quantity";
                    InspectionChallengeLine1."Sampling Time" := InspectionChallengeLine."Sampling Time";
                    InspectionChallengeLine1.Insert();
                until InspectionChallengeLine.Next() = 0;

        
    end;
}
