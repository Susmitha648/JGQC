report 50004 "COA Report"
{
    ApplicationArea = All;
    Caption = 'COA Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/COAReport.rdl';
    dataset
    {
        dataitem(COAHeader; "COA Header")
        {
            column(Job_No_; "Job No.") { }
            column(Description; Description) { }
            column(Send_To; "Send To") { }
            column(Contact; '') { }
            column(Production_Order_Date; Format("Production Order Date")) { }
            column(Ring_Finish; "Ring Finish") { }
            column(Machine; "Machine") { }
            column(Fill_Point; "Fill Point") { }
            column(Water_Temp; "Water Temp") { }
            column(Lot_No; '') { }
            column(CompanyLogo; CompanyInfo.Picture) { }
            dataitem(COALines; "COA Lines")
            {
                DataItemLink = "Released Prod Order No." = field("Released Prod Order No.");
                column(Result; "Result") { }
                column(UserId; UserId) { }
                column(SystemCreatedAt; "SystemCreatedAt") { }
                column(QC_Parameter_Code; "QC Parameter Code") { }
                column(QC_Parameter_Name; "QC Parameter Name") { }
                column(Min; Min) { }
                column(Max; Max) { }
                column(Mould_Numbers; "Mould Numbers") { }
                column(Section_No_; "Section No.") { }
                column(Front_Back; "Front/Back") { }
                column(Line_No_; "Line No.") { }
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
