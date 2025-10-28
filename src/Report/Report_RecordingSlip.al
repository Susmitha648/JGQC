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
            column(Job_Code; "Shortcut Dimension 2 Code") { }
            column(Description; Description) { }
            column(Finish; QCPlanHeader.Finish) { }
            column(CustomerName; QCPlanHeader."Customer Name") { }
            column(WorkShiftCode; ShopCalenderWorkingDays."Work Shift Code") { }
            column(Color; QCPlanHeader.Colour) { }
            column(PackSize; Item."Pack Size") { }
            column(QtyofPiecePerPack; PackSizeRec."Qty of Pieces Per Pack") { }
            column(QtyofCarton_TraysPerPallet; PackSizeRec."Qty of Cartons") { }
            column(QtyPerPack; PackSizeRec."Qty Per Pack") { }
            column(SlipNo; '') { }
            column(Quantity; Quantity) { }
            column(GTINQRCode; GTINQRCode) { }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = sorting(Number);

                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));
                    column(OutputNo; OutputNo) { }
                }
                trigger OnAfterGetRecord()
                begin
                    OutputNo := OutputNo + 1;
                    //ItemLabelBufferTemp := ItemLabelBufferTemp;
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Round(Abs("Production Order".Quantity), 1);
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    OutputNo := 0;

                end;
            }
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
            var
                BarcodeFontProvider: Interface "Barcode Font Provider";
                BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
            begin
                // Declare the barcode provider using the barcode provider interface and enum
                BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
                If Item.Get("Source No.") then
                    If PackSizeRec.Get(Item."Pack Size") then;
                If QCPlanHeader.Get("Source No.") then;
                ShopCalenderWorkingDays.Reset();
                ShopCalenderWorkingDays.SetFilter("Starting Time", '<=%1', "Production Order"."Ending Time");
                ShopCalenderWorkingDays.SetFilter("Ending Time", '>=%1', "Production Order"."Ending Time");
                //ShopCalenderWorkingDays.SetFilter("Work Shift Code",'<>%1','');
                If ShopCalenderWorkingDays.FindFirst() then;

                if "Shortcut Dimension 2 Code" <> '' then begin
                    BarcodeString := Format("Shortcut Dimension 2 Code") + Format(Item."Pack Size") + Format(Description) + Format("Last Date Modified", 0, '<Day,2>/<Month,2>/<Year4>');
                    // Validate the input
                    BarcodeString := DelChr(BarcodeString, '=', ' ');
                    BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
                    // Encode the data string to the barcode font
                    GTINBarCode := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
                    GTINQRCode := BarcodeFontProvider2D.EncodeFont(BarcodeString, BarcodeSymbology2D);
                end
            end;
        }
    }
    trigger OnInitReport()
    begin
        CompanyInfo.SetAutoCalcFields(Picture);
        CompanyInfo.SetAutoCalcFields("Company Logo 1");
        CompanyInfo.SetAutoCalcFields("Company Logo 2");
        CompanyInfo.SetAutoCalcFields("Company Logo 3");
        BarcodeSymbology := Enum::"Barcode Symbology"::Code128;
        BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
    end;

    var
        QCPlanHeader: Record "QC Plan Header";
        PackSizeRec: Record "Pack Size";
        Item: Record Item;
        ShopCalenderWorkingDays: Record "Shop Calendar Working Days";
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
        NoOfCopies: Integer;
        ItemQuantity: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        OutputNo: Integer;
        BarcodeSymbology: Enum "Barcode Symbology";
        BarcodeSymbology2D: Enum "Barcode Symbology 2D";
        GTINBarCode: Text[500];
        GTINQRCode: Text[500];
        BarcodeString: Text[500];
}