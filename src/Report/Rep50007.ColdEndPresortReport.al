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

                // Sorting & Grouping Columns
                column(SectionGroup; SectionGroupNo) { }
                column(TimeSortIndex; TimeSortIndex) { }

                column(Front_Back; "Front/Back") { }
                column(Cavity_No; "Cavity No") { }
                column(QC_Defect_Code; "QC Defect Code") { }

                column(WI_Front; WeightIssuedRec.Front) { }
                column(WI_Back; WeightIssuedRec.Back) { }
                column(WI_Gauged; WeightIssuedRec.Gauged) { }
                column(WI_Stones; WeightIssuedRec."Stones %") { }
                column(WI_EFF; WeightIssuedRec."EFF %") { }
                column(WI_Remarks; WeightIssuedRec.Remarks) { }
                column(WI_RubTest; Format(WeightIssuedRec."Rub Test")) { } // Format Enum to Text


                trigger OnAfterGetRecord()
                var
                    FreqText: Text;
                    SpacePos: Integer;
                    StartHour: Integer;
                begin
                    // 1. Convert the Enum to Text (e.g., "7 to 8")
                    FreqText := Format(Frequency);

                    // 2. Extract the first number (the start hour) for sorting logic
                    SpacePos := StrPos(FreqText, ' ');
                    if SpacePos > 0 then begin
                        if not Evaluate(StartHour, CopyStr(FreqText, 1, SpacePos - 1)) then
                            StartHour := 0;
                    end else begin
                        if not Evaluate(StartHour, FreqText) then
                            StartHour := 0;
                    end;

                    // 3. Calculate Sorting (Start day at 7 AM)
                    if StartHour < 7 then
                        TimeSortIndex := StartHour + 24
                    else
                        TimeSortIndex := StartHour;

                    // 4. Calculate Section Grouping
                    SectionGroupNo := (TimeSortIndex - 7) div 8;

                    // 5. FETCH WEIGHT ISSUED DATA
                    // We fetch the record matching the current Line's Prod Order and Frequency (Time)
                    // If found, the variables are populated. If not, we initialize them.
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
    }

    var
        SectionGroupNo: Integer;
        TimeSortIndex: Integer;
        WeightIssuedRec: Record "Weight Issued";
}