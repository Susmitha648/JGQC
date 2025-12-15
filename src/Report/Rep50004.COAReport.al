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
                column(Max_Result; "Max Result") { }
                column(UserId; UserId) { }
                column(SystemCreatedAt; "SystemCreatedAt") { }
                column(QC_Parameter_Code; "QC Parameter Code") { }
                column(QC_Parameter_Name; "QC Parameter Name") { }
                column(Min; Min) { }
                column(Max; Max) { }
                column(Section_No_; "Section No.") { }
                column(Front_Back; "Front/Back") { }
                column(Line_No_; "Line No.") { }
                column(Mould_Numbers; MouldNumber) { }
                column(WeightEmpty; WeightEmpty) { }
                column(Water_Temp_Line; COAHeader."Water Temp") { }

                trigger OnPreDataItem()
                begin
                    COALines.SetFilter("QC Parameter Code", '<>%1', '');
                end;

                trigger OnAfterGetRecord()
                var
                    UploadMouldNo: Record "Update Mould No";
                begin
                    Clear(MouldNumber);
                    Clear(WeightEmpty);

                    UploadMouldNo.Reset();
                    UploadMouldNo.SetRange("Work Order No.", COALines."Released Prod Order No.");
                    UploadMouldNo.SetRange("Section No.", COALines."Section No.");

                    if UploadMouldNo.FindFirst() then begin
                        if COALines."Front/Back" = COALines."Front/Back"::F then
                            MouldNumber := UploadMouldNo."Front Mould No"

                        else
                            MouldNumber := UploadMouldNo."Back Mould No";

                        WeightEmpty := UploadMouldNo."Weight Empty";
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
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        MouldNumber: Integer;
        WeightEmpty: Decimal;
}
