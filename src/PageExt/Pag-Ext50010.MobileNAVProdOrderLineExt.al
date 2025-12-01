pageextension 50010 "MobileNAV Prod Order Line Ext" extends "MobileNAV ReleasedProdOrd.Line"
{
    layout
    {
        addafter(Quantity)
        {
            field("Work Shift"; Rec."Work Shift")
            {
                ApplicationArea = All;
            }
        }
        addlast(Group)
        {
            field("Recording_Slip"; '')
            {
                ApplicationArea = All;
                Caption = 'Recording Slip';
            }
        }
    }

    [ServiceEnabled]
    procedure PrintReport() Result: Text
    var
        ProdOrderLine: Record "Prod. Order Line";
        MyReportID: Integer;
        DocumentNo: Record "Prod. Order Line";
        Count: Integer;
        QtyToPrint: Integer;
        MobileNAVReportHelper: Codeunit "MobileNAV Report Helper";
        MNResultHelper: Codeunit "MobileNAV Result Helper";
        Base64Result: BigText;
        RecRef: RecordRef;
        SaveAsFormat: Option Excel,HTML,PDF,Word,XML;
    begin
        MyReportID := Report::RecordingSlipReport;
        MobileNAVReportHelper.Initialize('MNReleasedProdOrderLine');
        MobileNAVReportHelper.AddDataItemFilter(5406, 'Prod. Order Line', 'Status', Format(Rec.Status::Planned, 0, 9));
        MobileNAVReportHelper.AddDataItemFilter(5406, 'Prod. Order Line', '"Prod. Order No."', Format(Rec."Prod. Order No.", 0, 9));
        MobileNAVReportHelper.AddDataItemFilter(5406, 'Prod. Order Line', 'Line No.', Format(Rec."Line No.", 0, 9));
        RecRef.GetTable(Rec);
        MobileNAVReportHelper.ReportSaveAs(50005,MobileNAVReportHelper.GetReportParameters(), SaveAsFormat::PDF,RecRef, Base64Result);
        Result := MNResultHelper.ConvertReturnValuesToResult(Base64Result, '', '');
       
    end;

}
