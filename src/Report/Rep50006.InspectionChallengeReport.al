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
            column(MNR_Label; 'MNR') { }

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
                column(TimeAsInteger; TimeAsInteger) { } // The critical sorting field
                column(Inspection_Type; "Inspection Type") { }
                column(QC_Defect_Code; "QC Defect Code") { }
                column(QC_Defect_Name; DefectName) { }
                column(SectionGroup; SectionGroupNo) { }
                column(Reject_Percent; "Reject %") { }

                // MNR Columns (Fetched per Line based on Frequency)
                column(MNR_DefectCode; MNRRec."Defect Code List") { }
                column(MNR_CavityNo; MNRRec."Cavity No") { }
                column(MNR_DefectName; MNRDefectName) { }

                trigger OnAfterGetRecord()
                var
                    DefectCodeRec: Record "Defect Code";
                    StartHour: Integer;
                begin
                    // 1. Line Defect Name
                    DefectName := '';
                    if DefectCodeRec.Get("QC Defect Code") then
                        DefectName := DefectCodeRec."Defect Name";

                    // 2. Chronological Sorting Logic (Starting at 7 AM)
                    // Converts the Enum/Time to an index where 7 AM = 7, but 1 AM = 25
                    StartHour := Frequency.AsInteger();
                    if StartHour < 6 then
                        TimeAsInteger := StartHour + 24
                    else
                        TimeAsInteger := StartHour;

                    // 3. Section Grouping (Based on sorted index)
                    SectionGroupNo := (TimeAsInteger - 6) div 8;

                    // 4. Fetch MNR by Frequency (Syncs MNR to the Time slot)
                    Clear(MNRRec);
                    MNRDefectName := '';
                    MNRRec.SetRange("Production Order No", "Released Prod Order No.");
                    MNRRec.SetRange(Frequency, Frequency);
                    if MNRRec.FindFirst() then begin
                        if DefectCodeRec.Get(MNRRec."Defect Code List") then
                            MNRDefectName := DefectCodeRec."Defect Name";
                    end;
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
        MNRRec: Record MNR;
        DefectName: Text[80];
        MNRDefectName: Text[80];
        SectionGroupNo: Integer;
        TimeAsInteger: Integer;
}