report 50016 "QC Plan Report Revised"
{
    ApplicationArea = All;
    Caption = 'QC Plan Report Revised';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/QCPlanReportNew_Revised.rdl';
    dataset
    {
        dataitem(QCPlanHeader; "QC Plan Header")
        {
            column(Job_No_; "Job No.") { }
            column(Description; Description) { }
            column(Finish; Finish) { }
            column(Customer_Code; "Customer Code") { }
            column(Customer_Name; "Customer Name") { }
            column(Room_Temperature; "Room Temperature") { }
            column(IM_Starwheel_Code; "IM Starwheel Code") { }
            column(Water_Temperature; "Water Temperature") { }
            column(Drawing_Number; "Drawing Number") { }
            column(Degree; "Room Temperature") { }
            column(Colour; Colour) { }
            column(CompanyLogo; CompanyInfo.Picture) { }
            column(SystemModifiedAt; Format(SystemModifiedAt)) { }
            dataitem(QCPlanLine; "QC Plan Lines")
            {
                DataItemLink = "Job No." = field("Job No.");
                DataItemTableView = sorting("Parameter Code");
                column(ParameterTyp_Code; "Parameter Code") { }
                column(ParameterTyp_Name; "Parameter Name") { }
                column(ParameterTyp_Type; ParameterTyp_Type) { }
                column(Sequence; Sequence) { }
                column(Line_Job_No_; "Job No.") { }
                column(Line_Description; Description) { }
                column(Parameter_Code; "Parameter Code") { }
                column(Parameter_Name; "Parameter Name") { }
                column(Frequency; Frequency) { }
                column(Min; Min) { }
                column(Max; Max) { }
                column(Nom; Nom) { }
                column(Required_for_CE; "Required for CE") { }
                column(Required_for_HE; "Required for HE") { }
                trigger OnAfterGetRecord()
                var
                    QCParameter: Record "QC Parameters";
                begin
                    // Clear variables first to avoid stale data
                    Clear(ParameterTyp_Type);
                    Clear(Sequence);

                    // Look up the Parameter Type and Sequence from the master QC Parameters table
                    QCParameter.Reset();
                    QCParameter.SetRange("Parameter Code", QCPlanLine."Parameter Code");
                    if QCParameter.FindFirst() then begin
                        ParameterTyp_Type := QCParameter."Parameter Type";
                        Sequence := QCParameter.Sequence;
                    end;
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

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        ParameterTyp_Type: Text;
        Sequence: Integer;

}
