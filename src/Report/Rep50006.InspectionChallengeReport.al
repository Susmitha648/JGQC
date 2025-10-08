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
                column(Inspection_Type; "Inspection Type")
                {
                }
                column(QC_Defect_Code; "QC Defect Code")
                {
                }
                column(Reject__; "Reject %")
                {
                }
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
}
