codeunit 50001 "MobileNav Ext"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"MobileNAV Page Functions", OnProdOrderLineExtFunc, '', true, true)]
    local procedure RecordingSlip("Key": Record "Prod. Order Line"; ServiceName: Text[100]; FieldName: Text[75]; var FieldControlFactory: Codeunit "MobileNAV Object Functions"; DeviceID: Text[190])
    var
        ProdOrderLine: Record "Prod. Order Line";
        MyReportID: Integer;
        DocumentNo: Record "Prod. Order Line";
        Count: Integer;
        QtyToPrint: Integer;
    begin
        If (ServiceName = 'MNReleasedProdOrderLine') and (FieldName = 'Recording_Slip') then
            MyReportID := Report::RecordingSlipReport;

        Report.Run(MyReportID, true, false, "Key");

    end;
}
