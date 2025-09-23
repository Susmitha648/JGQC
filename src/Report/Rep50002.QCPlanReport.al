report 50002 "QC Plan Report"
{
    ApplicationArea = All;
    Caption = 'QC Plan Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/QCPlanReport.rdlc';
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
            column(Colour; Colour) { }
            column(CompanyLogo; CompanyInfo.Picture) { }

            dataitem(QCPlanLine; "QC Plan Lines")
            {
                DataItemLink = "Job No." = field("Job No.");

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

                dataitem(ParameterType; "QC Parameters")
                {
                    DataItemLink = "Parameter Code" = field("Parameter Code");
                    DataItemLinkReference = QCPlanLine;

                    column(ParameterTyp_Code; "Parameter Code") { }
                    column(ParameterTyp_Name; "Parameter Name") { }
                    column(ParameterTyp_Type; "Parameter Type") { }
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

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
}
