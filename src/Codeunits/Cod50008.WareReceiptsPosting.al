codeunit 50008 "Ware Receipts Posting"
{
    TableNo = "FG Posting Tracking";
    trigger OnRun()
    begin
        TransferOrder.Reset();
        TransferOrder.SetRange("External Document No.", Rec."Serial No.");
        If TransferOrder.FindFirst() then begin
            /*ReservationEntry1.Reset();
            ReservationEntry1.SetRange("Serial No.", Rec."Serial No.");
            ReservationEntry1.SetRange("Source Type", 5741);
            ReservationEntry1.SetRange("Source Subtype", 0);
            ReservationEntry1.SetRange("Source ID", TransferOrder."No.");
            if not ReservationEntry1.FindFirst() then begin
                TransferLine.Reset();
                TransferLine.SetRange("Document No.", TransferOrder."No.");
                If TransferLine.FindFirst() then;
                ReservationEntry1.Init();
                ReservationEntry1."Entry No." := 0;
                ReservationEntry1.Validate("Item No.", TransferLine."Item No.");


                ReservationEntry1."Location Code" := TransferLine."Transfer-to Code";
                ReservationEntry1."Planning Flexibility" := ReservationEntry1."Planning Flexibility"::Unlimited;
                ReservationEntry1."Item Tracking" := ReservationEntry1."Item Tracking"::"Serial No.";
                ReservationEntry1."Reservation Status" := ReservationEntry1."Reservation Status"::Surplus;
                ReservationEntry1."Serial No." := Rec."Serial No.";
                ReservationEntry1."Source ID" := TransferOrder."No.";
                ReservationEntry1."Source Type" := 5741;
                ReservationEntry1."Source Subtype" := 0;
                ReservationEntry1."Source Batch Name" := '';
                ReservationEntry1.Positive := true;
                ReservationEntry1.Validate("Quantity (Base)", 1);
                ReservationEntry1."Source Ref. No." := TransferLine."Line No.";
                ReservationEntry1."Shipment Date" := WorkDate();
                ReservationEntry1."Created By" := UserId;
                ReservationEntry1."Creation Date" := WorkDate();
                ReservationEntry1.Insert();
            end;
            ReservationEntry1.Reset();
            ReservationEntry1.SetRange("Serial No.", Rec."Serial No.");
            ReservationEntry1.SetRange("Source Type", 5741);
            ReservationEntry1.SetRange("Source Subtype", 1);
            ReservationEntry1.SetRange("Source ID", TransferNo);
            if not ReservationEntry1.FindFirst() then begin
                TransferLine.Reset();
                TransferLine.SetRange("Document No.", TransferOrder."No.");
                If TransferLine.FindFirst() then;
                ReservationEntry1.Init();
                ReservationEntry1."Entry No." := 0;
                ReservationEntry1.Validate("Item No.", TransferLine."Item No.");


                ReservationEntry1."Location Code" := TransferLine."Transfer-to Code";
                ReservationEntry1."Planning Flexibility" := ReservationEntry1."Planning Flexibility"::Unlimited;
                ReservationEntry1."Item Tracking" := ReservationEntry1."Item Tracking"::"Serial No.";
                ReservationEntry1."Reservation Status" := ReservationEntry1."Reservation Status"::Surplus;
                ReservationEntry1."Serial No." := Rec."Serial No.";
                ReservationEntry1."Source ID" := TransferOrder."No.";
                ReservationEntry1."Source Type" := 5741;
                ReservationEntry1."Source Subtype" := 1;
                ReservationEntry1."Source Batch Name" := '';
                ReservationEntry1.Positive := true;
                ReservationEntry1.Validate("Quantity (Base)", 1);
                ReservationEntry1."Source Ref. No." := TransferLine."Line No.";
                ReservationEntry1."Expected Receipt Date" := WorkDate();
                ReservationEntry1."Created By" := UserId;
                ReservationEntry1."Creation Date" := WorkDate();
                ReservationEntry1.Insert();
            end;*/

            //TransferOrderPostShipment.SetSuppressCommit(True);
            If not (TransferOrder.Status = TransferOrder.Status::Released) then
                CODEUNIT.Run(CODEUNIT::"Release Transfer Document", TransferOrder);

            TransferOrder.TestField(Status, TransferOrder.Status::Released);

            WarehouseRequest.SetRange(Type, WarehouseRequest.Type::Inbound);
            WarehouseRequest.SetRange("Source Type", Database::"Transfer Line");
            WarehouseRequest.SetRange("Source Subtype", 1);
            WarehouseRequest.SetRange("Source No.", TransferOrder."No.");
            WarehouseRequest.SetRange("Document Status", WarehouseRequest."Document Status"::Released);
            GetSourceDocInbound.GetRequireReceiveRqst(WarehouseRequest);


            Clear(GetSourceDocuments);
            GetSourceDocuments.UseRequestPage(false);
            GetSourceDocuments.SetTableView(WarehouseRequest);
            GetSourceDocuments.SetHideDialog(true);
            GetSourceDocuments.SetSuppressCommit(True);
            GetSourceDocuments.RunModal();

            GetSourceDocuments.GetLastReceiptHeader(WarehouseReceiptHeader);
            WarehouseReceiptHeader1.Get(WarehouseReceiptHeader."No.");
            WarehouseReceiptHeader1.Status := WarehouseReceiptHeader1.Status::Released;
            WarehouseReceiptHeader1."Serial No" := Rec."Serial No.";
            WarehouseReceiptHeader1.Modify();
            WhseReceiptLine.Reset();
            WhseReceiptLine.SetRange("No.", WarehouseReceiptHeader1."No.");
            If not WhseReceiptLine.FindFirst() then
                Error('Warehouse Receipt Line does not exist');

            WhsePostReceipt.SetSuppressCommit(true);
            WhsePostReceipt.Run(WhseReceiptLine);
            Commit();
        end;
    end;

    var
        WhseReceiptLine1: Record "Warehouse Receipt Line";
        WhsePostReceipt1: Codeunit "Whse.-Post Receipt";
        TransferOrder: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        TransferLine1: Record "Transfer Line";
        WarehouseRequest: Record "Warehouse Request";
        GetSourceDocuments: Report "Get Source Documents";
        WarehouseReceiptHeader: Record "Warehouse Receipt Header";
        WarehouseReceiptHeader1: Record "Warehouse Receipt Header";
        WhsePostReceipt: Codeunit "Whse.-Post Receipt";
        Location: Record Location;
        WhseReceiptLine: Record "Warehouse Receipt Line";
        ManufacturingSetup: Record "Manufacturing Setup";
        LineNo: Integer;
        TransferOrderPostShipment: Codeunit "TransferOrder-Post Shipment";
        ReservationEntry1: Record "Reservation Entry";
        ProdOrderLine: Record "Prod. Order Line";
        TransferNo: Code[20];
        TransferOrderPost: Record "Transfer Header";
        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";

    procedure CreateTransferOrder(var FGTracking: Record "FG Posting Tracking")
    begin
        TransferOrder.Reset();
        TransferOrder.SetRange("External Document No.", FGTracking."Serial No.");
        If TransferOrder.FindFirst() then begin
            ReservationEntry1.Reset();
            ReservationEntry1.SetRange("Serial No.", FGTracking."Serial No.");
            ReservationEntry1.SetRange("Source Type", 5741);
            ReservationEntry1.SetRange("Source Subtype", 0);
            ReservationEntry1.SetRange("Source ID", TransferNo);
            if not ReservationEntry1.FindFirst() then begin
                TransferLine.Reset();
                TransferLine.SetRange("Document No.", TransferOrder."No.");
                If TransferLine.FindFirst() then;
                ReservationEntry1.Init();
                ReservationEntry1."Entry No." := 0;
                ReservationEntry1.Validate("Item No.", TransferLine."Item No.");


                ReservationEntry1."Location Code" := TransferLine."Transfer-to Code";
                ReservationEntry1."Planning Flexibility" := ReservationEntry1."Planning Flexibility"::Unlimited;
                ReservationEntry1."Item Tracking" := ReservationEntry1."Item Tracking"::"Serial No.";
                ReservationEntry1."Reservation Status" := ReservationEntry1."Reservation Status"::Surplus;
                ReservationEntry1."Serial No." := FGTracking."Serial No.";
                ReservationEntry1."Source ID" := TransferOrder."No.";
                ReservationEntry1."Source Type" := 5741;
                ReservationEntry1."Source Subtype" := 0;
                ReservationEntry1."Source Batch Name" := '';
                ReservationEntry1.Positive := true;
                ReservationEntry1.Validate("Quantity (Base)", 1);
                ReservationEntry1."Source Ref. No." := TransferLine."Line No.";
                ReservationEntry1."Shipment Date" := WorkDate();
                ReservationEntry1."Created By" := UserId;
                ReservationEntry1."Creation Date" := WorkDate();
                ReservationEntry1.Insert();
            end;
            ReservationEntry1.Reset();
            ReservationEntry1.SetRange("Serial No.", FGTracking."Serial No.");
            ReservationEntry1.SetRange("Source Type", 5741);
            ReservationEntry1.SetRange("Source Subtype", 1);
            ReservationEntry1.SetRange("Source ID", TransferNo);
            if not ReservationEntry1.FindFirst() then begin
                TransferLine.Reset();
                TransferLine.SetRange("Document No.", TransferOrder."No.");
                If TransferLine.FindFirst() then;
                ReservationEntry1.Init();
                ReservationEntry1."Entry No." := 0;
                ReservationEntry1.Validate("Item No.", TransferLine."Item No.");


                ReservationEntry1."Location Code" := TransferLine."Transfer-to Code";
                ReservationEntry1."Planning Flexibility" := ReservationEntry1."Planning Flexibility"::Unlimited;
                ReservationEntry1."Item Tracking" := ReservationEntry1."Item Tracking"::"Serial No.";
                ReservationEntry1."Reservation Status" := ReservationEntry1."Reservation Status"::Surplus;
                ReservationEntry1."Serial No." := FGTracking."Serial No.";
                ReservationEntry1."Source ID" := TransferOrder."No.";
                ReservationEntry1."Source Type" := 5741;
                ReservationEntry1."Source Subtype" := 1;
                ReservationEntry1."Source Batch Name" := '';
                ReservationEntry1.Positive := true;
                ReservationEntry1.Validate("Quantity (Base)", 1);
                ReservationEntry1."Source Ref. No." := TransferLine."Line No.";
                ReservationEntry1."Expected Receipt Date" := WorkDate();
                ReservationEntry1."Created By" := UserId;
                ReservationEntry1."Creation Date" := WorkDate();
                ReservationEntry1.Insert();
            end;

            //TransferOrderPostShipment.SetSuppressCommit(True);

            CODEUNIT.Run(CODEUNIT::"Release Transfer Document", TransferOrder);

            TransferOrder.TestField(Status, TransferOrder.Status::Released);
            WarehouseRequest.SetRange(Type, WarehouseRequest.Type::Inbound);
            WarehouseRequest.SetRange("Source Type", Database::"Transfer Line");
            WarehouseRequest.SetRange("Source Subtype", 1);
            WarehouseRequest.SetRange("Source No.", TransferOrder."No.");
            WarehouseRequest.SetRange("Document Status", WarehouseRequest."Document Status"::Released);
            GetSourceDocInbound.GetRequireReceiveRqst(WarehouseRequest);


            Clear(GetSourceDocuments);
            GetSourceDocuments.UseRequestPage(false);
            GetSourceDocuments.SetTableView(WarehouseRequest);
            GetSourceDocuments.SetHideDialog(true);
            GetSourceDocuments.SetSuppressCommit(True);
            GetSourceDocuments.RunModal();

            GetSourceDocuments.GetLastReceiptHeader(WarehouseReceiptHeader);
            FGTracking."Warehouse Receipt No" := WarehouseReceiptHeader."No.";
            FGTracking.Modify();
            WarehouseReceiptHeader1.Get(WarehouseReceiptHeader."No.");
            WarehouseReceiptHeader1.Status := WarehouseReceiptHeader1.Status::Released;
            WarehouseReceiptHeader1.Modify();
            WhseReceiptLine.Reset();
            WhseReceiptLine.SetRange("No.", WarehouseReceiptHeader1."No.");
            If not WhseReceiptLine.FindFirst() then
                Error('Warehouse Receipt Line does not exist');

            WhsePostReceipt.SetSuppressCommit(true);
            WhsePostReceipt.Run(WhseReceiptLine);

            Commit();
        end;
    end;
}
