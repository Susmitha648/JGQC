codeunit 50009 "UndoShipment Post"
{
    TableNo = "FG Posting Tracking";
    trigger OnRun()
    begin
        If Rec."Receipt Posting Attempt" = 2 then begin
            TransferOrder.Reset();
            TransferOrder.SetRange("External Document No.", Rec."Serial No.");
            If TransferOrder.FindFirst() then begin
                TransferShipmentLine.Reset();
                TransferShipmentLine.SetRange("Transfer Order No.", TransferOrder."No.");
                If TransferShipmentLine.FindFirst() then
                    If CODEUNIT.Run(CODEUNIT::"Undo Transfer Shipment", TransferShipmentLine) then begin
                        TransferOrderPostShipment.SetSuppressCommit(True);
                        TransferOrderPostShipment.Run(TransferOrder);
                        commit();
                    end;
            end;
        end;
    end;

    var
        TransferOrder: Record "Transfer Header";
        TransferShipmentLine: Record "Transfer Shipment Line";
        TransferOrderPostShipment: Codeunit "TransferOrder-Post Shipment";
}
