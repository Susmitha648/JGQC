report 50014 "Recording Slip Reprint"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/RecordingSlipReprint.rdl';
    Caption = 'Recording Slip';
    ApplicationArea = Suite;
    UsageCategory = Documents;
    // WordMergeDataItem = "Production Order";

    dataset
    {
        dataitem("Prod. Order Line"; "Prod. Order Line")
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
            column(Last_Date_Modified; Format("Due Date")) { }
            column(Job_Code; "Shortcut Dimension 2 Code") { }
            column(Description; Description) { }
            column(Finish; QCPlanHeader.Finish) { }
            column(CustomerName; QCPlanHeader."Customer Name") { }
            column(WorkShiftCode; WorkShiftCode) { }
            column(Color; QCPlanHeader.Colour) { }
            column(PackSize; Item."Pack Size") { }
            column(QtyofPiecePerPack; PackSizeRec."Qty of Pieces Per Pack") { }
            column(QtyofCarton_TraysPerPallet; PackSizeRec."Qty of Cartons") { }
            column(QtyPerPack; PackSizeRec."Qty Per Pack") { }
            column(SlipNo; '') { }
            column(Quantity; Quantity) { }
            column(GTINQRCode; GTINQRCode) { }
            column(JobQRCode; JobQRCode) { }
            column(RecordingSlipNo; RecordingSlipNo) { }
            column(MachineNo; MachineNo) { }
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

            // trigger OnAfterGetRecord()
            // var
            //     BarcodeFontProvider: Interface "Barcode Font Provider";
            //     BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
            //     MinDateDiff: Integer;
            //     MaxDateDiff: Integer;
            //     SingleInstance: Codeunit "QC Subcriber";
            // begin


            //     // Declare the barcode provider using the barcode provider interface and enum
            //     BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
            //     BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
            //     If Item.Get("Item No.") then
            //         If PackSizeRec.Get(Item."Pack Size") then;
            //     If QCPlanHeader.Get("Item No.") then;



            //     SingleInstance.Get();
            //     BarcodeString := Format(SingleInstance.Get());
            //     RecordingSlipNo := GetTextAfterLastChar(BarcodeString, '-');
            //     // Validate the input
            //     BarcodeString := DelChr(BarcodeString, '=', ' ');
            //     BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
            //     JobCodeString := Format("Prod. Order Line"."Item No.");
            //     JobCodeString := DelChr(JobCodeString, '=', ' ');
            //     BarcodeFontProvider.ValidateInput(JobCodeString, BarcodeSymbology);
            //     // Encode the data string to the barcode font
            //     GTINBarCode := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
            //     GTINQRCode := BarcodeFontProvider2D.EncodeFont(BarcodeString, BarcodeSymbology2D);
            //     JobQRCode := BarcodeFontProvider2D.EncodeFont(JobCodeString, BarcodeSymbology2D);
            // end;
            // trigger OnAfterGetRecord()
            // var
            //     BarcodeFontProvider: Interface "Barcode Font Provider";
            //     BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
            //     RawInput: Text; // Variable to hold the raw value from SingleInstance
            // begin
            //     // 1. Initialize Providers
            //     BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
            //     BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;

            //     // 2. Get Related Records
            //     If Item.Get("Item No.") then;
            //     // Note: PackSizeRec and QCPlanHeader get logic was empty in your snippet, ensure they are fetched if needed for columns

            //     // 3. Retrieve the Sequence Number from the SingleInstance
            //     SingleInstance.Get();
            //     RawInput := Format(SingleInstance.Get());

            //     // Extract only the slip number from the passed string
            //     RecordingSlipNo := GetTextAfterLastChar(RawInput, '-');

            //     // 4. RECONSTRUCT the Barcode String safely
            //     // This ensures the string has no hidden characters and uses the correct date format
            //     if ("Shortcut Dimension 2 Code" <> '') and (RecordingSlipNo <> '') then begin

            //         // Rebuild string using the same logic as Report 50005
            //         BarcodeString := Format("Shortcut Dimension 2 Code") + '-' +
            //                          Format(Item."Pack Size") + '-' +
            //                          Format("Due Date", 0, '<Day,2>/<Month,2>/<Year4>') + '-' +
            //                          Format(RecordingSlipNo);

            //         // 5. Clean and Validate
            //         BarcodeString := DelChr(BarcodeString, '=', ' '); // Remove spaces

            //         // Validate and Encode
            //         BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);

            //         // Generate Barcodes
            //         GTINBarCode := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
            //         GTINQRCode := BarcodeFontProvider2D.EncodeFont(BarcodeString, BarcodeSymbology2D);

            //         // Generate Job QR Code
            //         JobCodeString := Format("Prod. Order Line"."Item No.");
            //         JobCodeString := DelChr(JobCodeString, '=', ' ');
            //         BarcodeFontProvider.ValidateInput(JobCodeString, BarcodeSymbology);
            //         JobQRCode := BarcodeFontProvider2D.EncodeFont(JobCodeString, BarcodeSymbology2D);
            //     end;
            // end;
            trigger OnAfterGetRecord()
            var
                BarcodeFontProvider: Interface "Barcode Font Provider";
                BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
                MinDateDiff: Integer;
                MaxDateDiff: Integer;
                SingleInstance: Codeunit "QC Subcriber";
            begin
                Clear(MachineNo);
                Clear(WorkShiftCode);
                // Declare the barcode provider using the barcode provider interface and enum
                BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;

                If Item.Get("Item No.") then
                    If PackSizeRec.Get(Item."Pack Size") then;
                If QCPlanHeader.Get("Shortcut Dimension 2 Code") then;
                
                 WorkShift.Reset();
                WorkShift.SetRange(Code,"Prod. Order Line"."Work Shift");
                If WorkShift.FindFirst() then
                   WorkShiftCode := WorkShift.Description;

                GeneralLedgerSetup.Get();
                DimensionSetEntry.Reset();
                DimensionSetEntry.SetRange("Dimension Set ID","Prod. Order Line"."Dimension Set ID");
                DimensionSetEntry.SetRange("Dimension Code",GeneralLedgerSetup."Shortcut Dimension 8 Code");
                If DimensionSetEntry.FindFirst() then
                   MachineNo := DimensionSetEntry."Dimension Value Code";

                SingleInstance.Get();
                RecordingSlipNo := GetTextAfterLastChar(Format(SingleInstance.Get()), '-');

                // Construct BarcodeString properly - only if Shortcut Dimension 2 Code exists
                if "Shortcut Dimension 2 Code" <> '' then begin
                    BarcodeString := Format("Shortcut Dimension 2 Code") + '-' +
                                    Format(Item."Pack Size") + '-' +
                                    Format("Due Date", 0, '<Day,2>/<Month,2>/<Year4>') + '-' +
                                    RecordingSlipNo;

                    // Validate the input
                    BarcodeString := DelChr(BarcodeString, '=', ' ');
                    BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);

                    JobCodeString := Format("Prod. Order Line"."Item No.");
                    JobCodeString := DelChr(JobCodeString, '=', ' ');
                    BarcodeFontProvider.ValidateInput(JobCodeString, BarcodeSymbology);

                    // Encode the data string to the barcode font
                    GTINBarCode := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
                    GTINQRCode := BarcodeFontProvider2D.EncodeFont(BarcodeString, BarcodeSymbology2D);
                    JobQRCode := BarcodeFontProvider2D.EncodeFont(JobCodeString, BarcodeSymbology2D);
                end;
            end;
        }
    }


    trigger OnInitReport()
    begin
        Rejected := False;
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
        ProductionProgram: Record "Production Programme Line";
        ProductionProgramLine: Record "Production Programme Line";
        ReservationEntry: Record "Reservation Entry";
        TrackingSpecification: Record "Tracking Specification";
        DimensionSetEntry : Record "Dimension Set Entry";
        GeneralLedgerSetup : Record "General Ledger Setup";
        MachineNo : Text[20];
        QtyPerPack: Text;
        QtyofCarton_TraysPerPallet: Text;
        QtyofPiecePerPack: Text;
        PackSize: Text;
        Color: Text;
        WorkShiftCode: Text;
        WorkShift : Record "Work Shift";
        CustomerName: Text;
        Finish: Text;
        CompanyCounty: Text;
        CompanyCountry: Text;
        Rejected: Boolean;
        SetRejectedVar: Boolean;
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
        RecordingSlipNo: Text[40];
        BarcodeSymbology: Enum "Barcode Symbology";
        BarcodeSymbology2D: Enum "Barcode Symbology 2D";
        GTINBarCode: Text[500];
        GTINQRCode: Text[500];
        BarcodeString: Text[500];
        JobCodeString: Text[20];
        JobQRCode: Text[200];
        ProductionOrder: Record "Production Order";
        SerialNo: Code[50];
        ProdOrderLine: Record "Prod. Order Line";
        SingleInstance: Codeunit "QC Subcriber";

    procedure ReverseString(Value: Text): Text
    var
        i: Integer;
        ResultTxt: Text;
    begin
        for i := StrLen(Value) downto 1 do
            ResultTxt += CopyStr(Value, i, 1);
        exit(ResultTxt);
    end;

    procedure GetTextAfterLastChar(SourceTxt: Text; Separator: Text): Text
    var
        Pos: Integer;
    begin
        Pos := StrPos(ReverseString(SourceTxt), Separator);
        if Pos = 0 then
            exit('');

        exit(CopyStr(SourceTxt, StrLen(SourceTxt) - Pos + 2));
    end;

}