codeunit 50001 "MobileNav Ext"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"MobileNAV Page Functions", OnProdOrderLineExtGenBlob, '', true, true)]
    local procedure RecordingSlip("Key": Record "Prod. Order Line"; var Base64Result: BigText; ServiceName: Text[100]; FieldName: Text[75]; DeviceID: Text[190])
    var
        ProdOrderLine: Record "Prod. Order Line";
        MyReportID: Integer;
        DocumentNo: Record "Prod. Order Line";
        Count: Integer;
        QtyToPrint: Integer;
        MobileNAVReportHelper: Codeunit "MobileNAV Report Helper";
        MNResultHelper: Codeunit "MobileNAV Result Helper";
        ReportInstrpdf: InStream;
        ReportOutStrpdf: OutStream;
        RecRef: RecordRef;
        SaveAsFormat: Option Excel,HTML,PDF,Word,XML;
        TempBlob: Codeunit "Temp Blob";
        Test : Text;
    begin
        
        If (ServiceName = 'MNReleasedProdOrderLine') and (FieldName = 'Recording_Slip') then begin
            DocumentNo.Reset();
            DocumentNo.SetRange(Status,"Key".Status);
            DocumentNo.SetRange("Prod. Order No.","Key"."Prod. Order No.");
            DocumentNo.SetRange("Line No.","Key"."Line No.");
            If DocumentNo.FindFirst() then;
            MobileNAVReportHelper.Initialize('MNReleasedProdOrderLine');
            MobileNAVReportHelper.AddDataItemFilter(5406, 'Prod. Order Line', 'Status', Format(DocumentNo.Status, 0, 9));
            MobileNAVReportHelper.AddDataItemFilter(5406, 'Prod. Order Line', '"Prod. Order No."', Format(DocumentNo."Prod. Order No.", 0, 9));
            MobileNAVReportHelper.AddDataItemFilter(5406, 'Prod. Order Line', 'Line No.', Format(DocumentNo."Line No.", 0, 9));
            
            RecRef.GetTable(DocumentNo);
            MobileNAVReportHelper.ReportSaveAs(50005, MobileNAVReportHelper.GetReportParameters(), SaveAsFormat::PDF, RecRef, Base64Result);
            
           //SaveDocumentAsPDFToStream(50005,"Key",ReportOutStrpdf);
          // TempBlob.CreateInStream(ReportInstrpdf);
          // DownloadFromStream(ReportInstrpdf,'','','',Test);
            MNResultHelper.ConvertReturnValuesToResult(Base64Result,'Recordingslip.pdf','');
            
        end;

    end;
    local procedure SaveDocumentAsPDFToStream(ReportId: Integer; DocumentVariant: Variant; var VarOutStream: OutStream): Boolean;
    var
        DataTypeMgt: Codeunit "Data Type Management";

        DocumentRef: RecordRef;
    begin
        Clear(DocumentRef);
        DocumentRef.GetTable(DocumentVariant);
        if Report.SaveAs(ReportID, '', ReportFormat::Pdf, VarOutStream, DocumentRef) then
            exit(true);
    end;
}
