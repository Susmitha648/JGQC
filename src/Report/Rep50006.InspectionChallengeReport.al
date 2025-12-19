report 50006 "Inspection Challenge Report"
{
    ApplicationArea = All;
    Caption = 'Inspection Challenge Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/InspectionChallengeReport.rdlc';

    dataset
    {
        dataitem(Header; "Inspection Challenge Sample He")
        {
            DataItemTableView = sorting("Released Prod Order No.", "Production Order Date");
            column(ReleasedProdOrderNo; "Released Prod Order No.") { }
            column(ProductionOrderDate; "Production Order Date") { }
            column(JobNo; "Job No.") { }
            column(Description; Description) { }
            column(Ring; Ring) { }
            column(MCNo; "MC No.") { }
            column(FurnaceNo; "Furnace No.") { }

            dataitem(CCP; CCP)
            {
                DataItemLink = "Production Order No" = field("Released Prod Order No.");
                DataItemTableView = sorting("Production Order No", "Type", "Work Shift");

                column(CCP_Type; "Type") { }
                column(CCP_ResultObtained; "Result Obtained") { }
                column(CCP_Inspection1; "Inspection 1") { }
                column(CCP_Inspection2; "Inspection 2") { }
                column(CCP_Inspection3; "Inspection 3") { }
                column(CCP_WorkShift; "Work Shift") { }
            }



            dataitem(Line; "Inspection Challenge Sample li")
            {
                DataItemLink = "Released Prod Order No." = field("Released Prod Order No.");
                DataItemTableView = sorting("Released Prod Order No.", "Line No.");

                column(LineNo; "Line No.") { }
                column(Time; Frequency) { }
                column(FrequencyText; Format(Frequency)) { }
                column(TimeAsInteger; TimeAsInteger) { }
                column(Inspection_Type; "Inspection Type") { }
                column(QC_Defect_Code; "QC Defect Code") { }
                column(QC_Defect_Name; DefectName) { }
                column(SectionGroup; SectionGroupNo) { }
                column(Reject_Percent; "Reject %") { }
                column(MNR_Label; 'MNR') { }

                dataitem(MNRData; MNR)
                {
                    DataItemLink = "Production Order No" = field("Released Prod Order No."),
                    Frequency = field(Frequency);
                    DataItemTableView = sorting("Production Order No", "Line No");

                    column(MNR_DefectCode; "Defect Code List") { }
                    column(MNR_CavityNo; "Cavity No") { }
                    column(MNR_DefectName; MNRDefectName) { }

                    trigger OnAfterGetRecord()
                    var
                        DefectCodeRec: Record "Defect Code";
                    begin
                        MNRDefectName := '';
                        if DefectCodeRec.Get("Defect Code List") then
                            MNRDefectName := DefectCodeRec."Defect Name";
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    DefectCodeRec: Record "Defect Code";
                    StartHour: Integer;
                begin
                    // 1. Line Defect Name
                    DefectName := '';
                    if DefectCodeRec.Get("QC Defect Code") then
                        DefectName := DefectCodeRec."Defect Name";

                    // 2. Chronological Sorting Logic
                    StartHour := Frequency.AsInteger();
                    if StartHour < 6 then
                        TimeAsInteger := StartHour + 24
                    else
                        TimeAsInteger := StartHour;

                    // 3. Section Grouping
                    SectionGroupNo := (TimeAsInteger - 6) div 8;

                    // Remove all MNR fetching logic from here!
                end;
            }
            trigger OnAfterGetRecord()
            begin
                Clear(CCP);
                CCP.SetRange("Production Order No", "Released Prod Order No.");
                if not CCP.FindFirst() then Clear(CCP);
            end;
        }
    }

    var

    var

    var
        DefectName: Text[80];
        MNRDefectName: Text[80];  // Used in MNRData dataitem
        SectionGroupNo: Integer;
        TimeAsInteger: Integer;
}