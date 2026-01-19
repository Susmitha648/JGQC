report 50007 "Cold End Presort Report"
{
    ApplicationArea = All;
    Caption = 'Cold End Presort Report';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/Report/Layouts/ColdEndPresortReport.rdlc';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem(ColdEndPresortDetailHeader; "Cold End Presort Detail Header")
        {
            column(released_Prod_Order_No; "Released Prod Order No.") { }
            column(Production_Order_Date; "Production Order Date") { }
            column(MC_No_; "MC No.") { }
            column(Finish; Finish) { }
            column(Machine_Speed; "Machine Speed") { }
            column(Job_No_; "Job No.") { }
            column(Description; Description) { }
            column(LEHR_Time; "LEHR Time") { }
            column(Customer_Name; "Customer Name") { }
            column(Weight_Issue_Max; "Weight Issue Max") { }
            column(Weight_Issue_Min; "Weight Issue Min") { }
            column(Shift_1_Foreman; "Shift 1 Foreman") { }
            column(Shift_2_Foreman; "Shift 2 Foreman") { }
            column(Shift_3_Foreman; "Shift 3 Foreman") { }
            column(Shift_1_Leading_Hand; "Shift 1 Leading Hand") { }
            column(Shift_2_Leading_Hand; "Shift 2 Leading Hand") { }
            column(Shift_3_Leading_Hand; "Shift 3 Leading Hand") { }
            column(ColdEndCoating; "Cold End Coating") { }

            dataitem(ColdEndPresortDetailLine; "Cold End Presort Detail Lines")
            {
                DataItemLink = "Released Prod Order No." = field("Released Prod Order No.");

                column(released_Prod_Order_No_li; "Released Prod Order No.") { }
                column(Line_No; "Line No.") { }
                column(Production_Order_Date_li; "Production Order Date") { }
                column(Time; Frequency) { }
                column(Section_No_; "Section No.") { }

                // NEW: Integer value for sorting sections numerically (1, 2, 3... 10)
                column(SectionSortIndex; "Section No.".AsInteger()) { }

                // Sorting & Grouping Columns
                column(SectionGroup; SectionGroupNo) { }
                column(TimeSortIndex; TimeSortIndex) { }
                column(TimeLabel; TimeLabel) { }

                column(Front_Back; "Front/Back") { }
                column(Cavity_No; "Cavity No") { }
                column(QC_Defect_Code; "QC Defect Code") { }
                column(Category; Category) { }

                // Weight Issued Columns
                column(WI_Front; WeightIssuedRec.Front) { }
                column(WI_Back; WeightIssuedRec.Back) { }
                column(WI_Gauged; WeightIssuedRec.Gauged) { }
                column(WI_Stones; WeightIssuedRec."Stones %") { }
                column(WI_EFF; WeightIssuedRec."EFF %") { }
                column(WI_Remarks; WeightIssuedRec.Remarks) { }
                column(WI_RubTest; Format(WeightIssuedRec."Rub Test")) { }

                trigger OnAfterGetRecord()
                var
                    FreqText: Text;
                    SpacePos: Integer;
                    StartHour: Integer;
                    EndHour: Integer;
                    StartTime: Time;
                    EndTime: Time;
                begin
                    // 1. Time Sorting Logic
                    FreqText := Format(Frequency);
                    SpacePos := StrPos(FreqText, ' ');
                    if SpacePos > 0 then begin
                        if not Evaluate(StartHour, CopyStr(FreqText, 1, SpacePos - 1)) then
                            StartHour := 0;
                    end else begin
                        if not Evaluate(StartHour, FreqText) then
                            StartHour := 0;
                    end;

                    if StartHour < 7 then
                        TimeSortIndex := StartHour + 24
                    else
                        TimeSortIndex := StartHour;

                    SectionGroupNo := (TimeSortIndex - 7) div 8;

                    // 2. Time Label Logic
                    StartTime := 000000T + (StartHour * 3600000);
                    EndHour := StartHour + 1;
                    if EndHour = 24 then EndHour := 0;
                    EndTime := 000000T + (EndHour * 3600000);
                    TimeLabel := Format(StartTime, 0, '<Hours24,2>.<Minutes,2>') + ' - ' + Format(EndTime, 0, '<Hours24,2>.<Minutes,2>');

                    // 3. Weight Issued Logic
                    if not WeightIssuedRec.Get("Released Prod Order No.", Frequency) then
                        Clear(WeightIssuedRec);
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
                group(GroupName) { }
            }
        }
        actions
        {
            area(Processing) { }
        }
    }

    var
        SectionGroupNo: Integer;
        TimeSortIndex: Integer;
        TimeLabel: Text;
        WeightIssuedRec: Record "Weight Issued";
}