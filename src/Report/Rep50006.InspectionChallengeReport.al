report 50006 "Inspection Challenge Report"
{
    ApplicationArea = All;
    Caption = 'Inspection Challenge Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/InspectionChallengeReport.rdlc';
    dataset
    {
        dataitem(InspectionChallengeSampleHe; "Inspection Challenge Sample He")
        {
            DataItemTableView = sorting("Released Prod Order No.", "Production Order Date");
            column(ReleasedProdOrderNo; "Released Prod Order No.")
            {
            }
            column(ProductionOrderDate; "Production Order Date")
            {
            }
            column(JobNo; "Job No.")
            {
            }
            column(Description; Description)
            {
            }
            column(Ring; Ring)
            {
            }
            column(MCNo; "MC No.")
            {
            }
            column(FurnaceNo; "Furnace No.")
            {
            }

            dataitem("Inspection Challenge Sample li"; "Inspection Challenge Sample li")
            {
                DataItemLink = "Released Prod Order No." = field("Released Prod Order No.");
                DataItemTableView = sorting("Released Prod Order No.", "Line No.");
                column(ReleasedProdOrderNo_li; "Released Prod Order No.")
                {
                }
                column(ProductionOrderDate_li; "Production Order Date")
                {
                }
                column(LineNo; "Line No.")
                {
                }
                column(Time; Time)
                {
                }
                column(TimeAsInteger; Time.AsInteger())
                {
                }
                column(FrequencyText; Format(Time))
                {
                }
                column(SectionGroup; SectionGroupNo)
                {
                }
                column(Inspection_Type; "Inspection Type")
                {
                }
                column(QC_Defect_Code; "QC Defect Code")
                {
                }
                column(QC_Defect_Name; DefectName)
                {
                }
                column(Reject__; "Reject %")
                {
                }

                trigger OnAfterGetRecord()
                var
                    DefectCode: Record "Defect Code";
                begin
                    // Get the Defect Name from Defect Code table
                    DefectName := '';
                    if "QC Defect Code" <> '' then begin
                        if DefectCode.Get("QC Defect Code") then
                            DefectName := DefectCode."Defect Name";
                    end;

                    // Calculate section group (every 8 frequencies)
                    SectionGroupNo := Time.AsInteger() div 8;
                end;
            }

            // Add a dataitem for signature sections
            dataitem(SignatureSection; Integer)
            {
                DataItemTableView = sorting(Number) where(Number = filter(0 .. 2));
                column(SignatureSectionNo; Number)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    // This will create 3 sections (0, 1, 2)
                end;
            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    var
        DefectName: Text[80];
        SectionGroupNo: Integer;
}