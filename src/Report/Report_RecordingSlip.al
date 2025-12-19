report 50005 RecordingSlipReport
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/RecordingSlipReport.rdl';
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
            column(WorkShiftCode; "Work Shift") { }
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
            dataitem("Reservation Entry";"Reservation Entry")
            {
                DataItemLink = "Source ID" = field("Prod. Order No.");
                RequestFilterFields = "Serial No.";
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
                MinDateDiff: Integer;
                MaxDateDiff: Integer;
            begin
                // Declare the barcode provider using the barcode provider interface and enum
                BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
                If Item.Get("Item No.") then
                    If PackSizeRec.Get(Item."Pack Size") then;
                If QCPlanHeader.Get("Item No.") then;
                
               
                ProductionProgram.Reset();
                ProductionProgram.SetRange(Job, "Shortcut Dimension 2 Code");
                ProductionProgram.SetRange(Date, "Due Date");
                If ProductionProgram.FindFirst() then begin
                    ProductionProgramLine.Reset();
                    ProductionProgramLine.SetAscending(Date, True);
                    ProductionProgramLine.SetRange("No.", ProductionProgram."No.");
                    ProductionProgramLine.SetRange(Job, "Shortcut Dimension 2 Code");
                    ProductionProgramLine.SetRange("First Line", True);
                    ProductionProgramLine.SetRange("Sequence No", ProductionProgram."Sequence No");
                    If ProductionProgramLine.FindFirst() then begin
                        RecordingSlipNo := ProductionProgramLine."Record Slip No" + 1;
                        ProductionProgramLine."Record Slip No" := RecordingSlipNo;
                        ProductionProgramLine.Modify();
                    end;

                end else begin
                    ProductionProgram.SetRange(Date, CalcDate('<-1D>', "Due Date"));
                    If ProductionProgram.FindFirst() then begin
                        ProductionProgramLine.Reset();
                        ProductionProgramLine.SetRange("No.", ProductionProgram."No.");
                        ProductionProgramLine.SetRange(Job, "Shortcut Dimension 2 Code");
                        ProductionProgramLine.SetRange("First Line", True);
                        ProductionProgramLine.SetRange("Sequence No", ProductionProgram."Sequence No");
                        If ProductionProgramLine.FindFirst() then begin
                            RecordingSlipNo := ProductionProgramLine."Record Slip No" + 1;
                            ProductionProgramLine."Record Slip No" := RecordingSlipNo;
                            ProductionProgramLine.Modify();
                        end;
                    end
                end;
                if "Shortcut Dimension 2 Code" <> '' then begin
                    BarcodeString := Format("Shortcut Dimension 2 Code") + '-' + Format(Item."Pack Size") + '-' + Format("Due Date", 0, '<Day,2>/<Month,2>/<Year4>') + '-' + Format(RecordingSlipNo);
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
                ReservationEntry.Init();
                ReservationEntry."Entry No." := 0;
                ReservationEntry.Validate("Item No.", "Prod. Order Line"."Item No.");
                ReservationEntry.Validate("Source ID" , "Prod. Order Line"."Prod. Order No.");
                ReservationEntry."Location Code" := "Prod. Order Line"."Location Code";
                
                ReservationEntry.Validate("Quantity (Base)", 1);
                ReservationEntry.Positive := true;
                ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Surplus;
                ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Serial No.";
                ReservationEntry.Validate("Serial No.", BarcodeString);
                
                ReservationEntry."Source Type" := 5406;
                ReservationEntry."Source Subtype" := 3;
                ReservationEntry."Source Prod. Order Line" := "Prod. Order Line"."Line No.";
                ReservationEntry."Expected Receipt Date" := "Prod. Order Line"."Due Date";
                ReservationEntry."Planning Flexibility" := ReservationEntry."Planning Flexibility"::Unlimited;
                ReservationEntry."Created By" :=  UserId;
                ReservationEntry."Creation Date" := WorkDate();
                ReservationEntry."Recording Slip Printed" := True;
                ReservationEntry.Insert(True);
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
        ProductionProgram: Record "Production Programme Line";
        ProductionProgramLine: Record "Production Programme Line";
        ReservationEntry: Record "Reservation Entry";
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
        RecordingSlipNo: Integer;
        BarcodeSymbology: Enum "Barcode Symbology";
        BarcodeSymbology2D: Enum "Barcode Symbology 2D";
        GTINBarCode: Text[500];
        GTINQRCode: Text[500];
        BarcodeString: Text[500];
        JobCodeString: Text[20];
        JobQRCode: Text[200];
        ProductionOrder : Record "Production Order";
}