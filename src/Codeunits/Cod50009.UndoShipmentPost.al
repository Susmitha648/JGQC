codeunit 50009 "UndoShipment Post"
{
    TableNo = "FG Posting Tracking";
    trigger OnRun()
    begin
        If (Rec."Receipt Posting Attempt" = 2) or (Rec."Receipt Posting Attempt" = 3) then begin
            TransferOrder.Reset();
            TransferOrder.SetRange("External Document No.", Rec."Serial No.");
            If TransferOrder.FindFirst() then begin
                TransferShipmentLine.Reset();
                TransferShipmentLine.SetRange("Transfer Order No.", TransferOrder."No.");
                If TransferShipmentLine.FindFirst() then begin
                    UndoShipment.SetHideDialog(True);
                    UndoShipment.Run(TransferShipmentLine);
                end;
            end;
        end;
    end;

    var
        TransferOrder: Record "Transfer Header";
        TransferShipmentLine: Record "Transfer Shipment Line";
        TransferOrderPostShipment: Codeunit "TransferOrder-Post Shipment";
        UndoShipment: Codeunit "Undo Transfer Shipment";
}
