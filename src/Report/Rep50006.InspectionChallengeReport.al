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

            dataitem(TimeLoop; Integer)
            {
                DataItemTableView = sorting(Number);

                column(FrequencyText; FrequencyText) { }
                column(TimeAsInteger; TimeAsInteger) { }
                column(SectionGroup; SectionGroupNo) { }

                dataitem(Line; "Inspection Challenge Sample li")
                {

                    DataItemTableView = sorting("Released Prod Order No.", "Line No.");

                    column(LineNo; "Line No.") { }
                    column(Time; Frequency) { }
                    column(Inspection_Type; "Inspection Type") { }
                    column(QC_Defect_Code; "QC Defect Code") { }
                    column(QC_Defect_Name; DefectName) { }
                    column(Reject_Percent; "Reject %") { }

                    trigger OnPreDataItem()
                    begin
                        SetRange("Released Prod Order No.", Header."Released Prod Order No.");
                        SetRange(Frequency, CurrentFrequency);
                    end;

                    trigger OnAfterGetRecord()
                    var
                        DefectCodeRec: Record "Defect Code";
                    begin
                        DefectName := '';
                        if DefectCodeRec.Get("QC Defect Code") then
                            DefectName := DefectCodeRec."Defect Name";
                    end;
                }

                // 3. MNR DATA: Iterates through MASTER DEFECT CODES to ensure consistency
                dataitem(MNR_DefectLoop; "Defect Code")
                {
                    column(MNR_Label; 'MNR') { }
                    column(MNR_DefectCode; "Defect Code") { }
                    column(MNR_DefectName; "Defect Name") { }
                    column(MNR_CavityNo; CavityNoText) { }

                    trigger OnAfterGetRecord()
                    var
                        MNR_Check: Record MNR;
                        MNR_TransRec: Record MNR;
                    begin

                        MNR_Check.SetRange("Production Order No", Header."Released Prod Order No.");
                        MNR_Check.SetRange("Defect Code List", "Defect Code");

                        if MNR_Check.IsEmpty() then
                            CurrReport.Skip();


                        CavityNoText := '';

                        MNR_TransRec.SetRange("Production Order No", Header."Released Prod Order No.");
                        MNR_TransRec.SetRange(Frequency, CurrentFrequency);       // Filter by Current Time
                        MNR_TransRec.SetRange("Defect Code List", "Defect Code"); // Match Defect

                        if MNR_TransRec.FindFirst() then begin
                            CavityNoText := MNR_TransRec."Cavity No";
                        end;
                    end;
                }

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 0, 23);
                end;

                trigger OnAfterGetRecord()
                var
                    StartHour: Integer;
                begin
                    CurrentFrequency := Enum::"Time".FromInteger(Number);

                    FrequencyText := Format(CurrentFrequency);

                    StartHour := CurrentFrequency.AsInteger();

                    if StartHour < 6 then
                        TimeAsInteger := StartHour + 24
                    else
                        TimeAsInteger := StartHour;

                    SectionGroupNo := (TimeAsInteger - 6) div 8;
                end;
            }
        }
    }

    var
        DefectName: Text[80];
        MNRDefectName: Text[80];
        SectionGroupNo: Integer;
        TimeAsInteger: Integer;
        CurrentFrequency: Enum "Time";
        FrequencyText: Text;
        CavityNoText: Code[20];
}