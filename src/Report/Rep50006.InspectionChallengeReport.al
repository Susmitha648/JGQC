report 50006 "Inspection Challenge Report"
{
    ApplicationArea = All;
    Caption = 'Inspection Challenge Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/InspectionChallengeReport.rdlc';

    dataset
    {
        // MAIN HEADER
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
                column(TimeAsInteger; Frequency.AsInteger()) { }
                column(FrequencyText; Format(Frequency)) { }
                column(Inspection_Type; "Inspection Type") { }
                column(QC_Defect_Code; "QC Defect Code") { }
                column(QC_Defect_Name; DefectName) { }
                column(SectionGroup; SectionGroupNo) { }
                column(Reject_Percent; "Reject %") { }

                column(MNR_Frequency; MNRRec.Frequency) { }
                column(MNR_DefectCodeList; MNRRec."Defect Code List") { }
                column(MNR_CavityNo; MNRRec."Cavity No") { }
                column(MNR_DefectName; MNRDefectName) { }

                trigger OnAfterGetRecord()
                var
                    DefectCodeRec: Record "Defect Code";
                begin
                    // 1. Line Defect Name
                    DefectName := '';
                    if DefectCodeRec.Get("QC Defect Code") then
                        DefectName := DefectCodeRec."Defect Name";
                    // 2. Section Group Logic
                    SectionGroupNo := Frequency.AsInteger() div 8;

                    // 3. Initialize MNR per Line
                    Clear(MNRRec);
                    MNRDefectName := '';
                    // Linking MNR to current line via Order No and Line No
                    if MNRRec.Get("Released Prod Order No.", "Line No.") then begin
                        if DefectCodeRec.Get(MNRRec."Defect Code List") then
                            MNRDefectName := DefectCodeRec."Defect Name";
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Clear(CCPRec);
                CCPRec.SetRange("Production Order No", "Released Prod Order No.");
                if not CCPRec.FindFirst() then
                    Clear(CCPRec);
            end;
        }
    }

    var
        CCPRec: Record CCP;
        MNRRec: Record MNR;
        DefectName: Text[80];
        MNRDefectName: Text[80];
        SectionGroupNo: Integer;
}