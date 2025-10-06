report 50005 RecordingSlipReport
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/RecordingSlipReport.rdl';
    Caption = 'Recording Slip';
    ApplicationArea = Suite;
    UsageCategory = Documents;
    WordMergeDataItem = "Production Order";

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            column(PrintName; CompanyInfo."Print Name")
            {
            }
            column(CompanyAddress; CompanyInfo."Address")
            {
            }
            column(CompanyPostcode; CompanyInfo."Post Code")
            {
            }
            column(CompanyCity; CompanyInfo."City")
            {
            }
            column(CompanyState; CompanyCounty)
            {
            }
            column(CompanyCountry; CompanyCountry)
            {
            }
            column(CompanyInfoName; CompanyInfo.Name)
            {
            }
            column(CompanyInfoFax; CompanyInfo."Fax No.")
            {
            }
            column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfoEmail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyInfoHomePage; CompanyInfo."Home Page")
            {
            }
            column(CompanyInfoVATRegNo; CompanyInfo."ADY E-INV SST Reg No.")
            {
            }
            column(CompanyInfoBusinessRegistrationNo; CompanyInfo."Registration No.")
            {
            }
            column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
            {
            }
            column(CompanyInfoBankName; CompanyInfo."Bank Name")
            {
            }
            column(CompanyInfoBankAccountNo; CompanyInfo."Bank Account No.")
            {
            }
            column(CompanyLogo; CompanyInfo."Picture")
            {
            }
            column(CompanyPicture1; CompanyInfo."Company Logo 1")
            {
            }
            column(CompanyPicture2; CompanyInfo."Company Logo 2")
            {
            }
            column(CompanyPicture3; CompanyInfo."Company Logo 3")
            {
            }
            column(Last_Date_Modified; Format("Last Date Modified")) { }
            column(Job_Code; "Source No.") { }
            column(Description; Description) { }
            column(Finish; QCPlanHeader.Finish) { }
            column(CustomerName; QCPlanHeader."Customer Name") { }
            column(WorkShiftCode; ShopCalenderWorkingDays."Work Shift Code") { }
            column(Color; QCPlanHeader.Colour) { }
            column(PackSize; Item."Pack Size") { }
            column(QtyofPiecePerPack; PackSizeRec."Qty of Pieces Per Pack") { }
            column(QtyofCarton_TraysPerPallet; PackSizeRec."Qty of Cartons") { }
            column(QtyPerPack; PackSizeRec."Qty Per Pack") {}
            column(SlipNo; '') { }
            trigger OnPreDataItem()
            var
                CountryRegion: Record "Country/Region";
                County: Record County;
            begin
                CompanyInfo.Get();
                FormatAddr.Company(CompanyAddr, CompanyInfo);
                begin

                    if CountryRegion.Get(CompanyInfo."Country/Region Code") then
                        CompanyCountry := CountryRegion.Name;
                    if County.Get(CompanyInfo."County") then
                        CompanyCounty := County."Description";
                end;
                GLSetup.Get();
            end;

            trigger OnAfterGetRecord()
            begin
                If Item.Get("Source No.") then
                If PackSizeRec.Get(Item."Pack Size") then;
                If QCPlanHeader.Get("Source No.") then;
                ShopCalenderWorkingDays.Reset();
                ShopCalenderWorkingDays.SetFilter("Starting Time",'>%1',"Ending Time");
                ShopCalenderWorkingDays.SetFilter("Ending Time",'<%1',"Ending Time");
                If ShopCalenderWorkingDays.FindFirst() then;
            end;
        }
    }
    trigger OnInitReport()
    begin
        CompanyInfo.SetAutoCalcFields(Picture);
        CompanyInfo.SetAutoCalcFields("Company Logo 1");
        CompanyInfo.SetAutoCalcFields("Company Logo 2");
        CompanyInfo.SetAutoCalcFields("Company Logo 3");
    end;

    var
        QCPlanHeader: Record "QC Plan Header";
        PackSizeRec : Record "Pack Size";
        Item : Record Item;
        ShopCalenderWorkingDays : Record "Shop Calendar Working Days";
        QtyPerPack: Text;
        QtyofCarton_TraysPerPallet: Text;
        QtyofPiecePerPack: Text;
        PackSize: Text;
        Color: Text;
        WorkShiftCode: Text;
        CustomerName: Text;
        Finish: Text;
        CompanyCounty: Text;
        CompanyCountry: Text;
        CompanyInfo: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        FormatAddr: Codeunit "Format Address";
        ReportTitle: Text[30];
        CompanyAddr: array[8] of Text[100];
}