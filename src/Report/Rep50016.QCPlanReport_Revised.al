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
            column(Water_Temperature; '') { }
            column(Drawing_Number; '') { }
            column(Degree; '') { }
            column(Colour; Colour) { }
            column(CompanyLogo; CompanyInfo.Picture) { }
            dataitem(ParameterType; "QC Parameters")
            {
                column(ParameterTyp_Code; "Parameter Code") { }
                column(ParameterTyp_Name; "Parameter Name") { }
                column(ParameterTyp_Type; "Parameter Type") { }
                column(Sequence; Sequence) { }
                column(Line_Job_No_; Line_Job_No_) { }
                column(Line_Description; Line_Description) { }
                column(Parameter_Code; "Parameter Code") { }
                column(Parameter_Name; "Parameter Name") { }
                column(Frequency; Frequency) { }
                column(Min; Min) { }
                column(Max; Max) { }
                column(Nom; Nom) { }
                column(Required_for_CE; Required_for_CE) { }
                column(Required_for_HE; Required_for_HE) { }
                trigger OnAfterGetRecord()
                var
                    QCPlanLine: Record "QC Plan Lines";
                begin
                    QCPlanLine.Reset();
                    QCPlanLine.SetRange("Job No.", QCPlanHeader."Job No.");
                    QCPlanLine.SetRange("Parameter Code", ParameterType."Parameter Code");
                    //QCPlanLine.SetRange("Parameter Name", "Parameter Name");
                    //QCPlanLine.SetRange("Parameter Type", "Parameter Type");
                    IF QCPlanLine.FindFirst() then BEGIN
                        Line_Job_No_ := QCPlanLine."Job No.";
                        Line_Description := QCPlanLine."Description";
                        Parameter_Code := QCPlanLine."Parameter Code";
                        Parameter_Name := QCPlanLine."Parameter Name";
                        Frequency := QCPlanLine."Frequency";
                        Min := QCPlanLine."Min";
                        Max := QCPlanLine."Max";
                        Nom := QCPlanLine."Nom";
                        Required_for_CE := QCPlanLine."Required for CE";
                        Required_for_HE := QCPlanLine."Required for HE";
                    END;
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
        JobNo: Text;
        Line_Job_No_: Text;
        Line_Description: Text;
        Parameter_Code: Text;
        Parameter_Name: Text;
        Frequency: Text;
        Min: Text;
        Max: Text;
        Nom: Text;
        Required_for_CE: Boolean;
        Required_for_HE: Boolean;

}
