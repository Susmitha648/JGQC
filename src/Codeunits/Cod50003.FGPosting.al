codeunit 50003 "FG Posting"
{
    trigger OnRun()
    begin
        ReservationEntry.Reset();
        ReservationEntry.SetRange("Recording Slip Printed", True);
        ReservationEntry.SetRange("Output Posted", false);
        If ReservationEntry.FindSet() then begin
            repeat
                ProdOrderLine.Reset();
                ProdOrderLine.SetRange("Prod. Order No.", ReservationEntry."Source ID");
                ProdOrderLine.SetRange("Line No.", ReservationEntry."Source Prod. Order Line");
                If ProdOrderLine.FindFirst() then begin
                    ItemJnlLine.Init();
                    ItemJnlTemplate.Reset();
                    ItemJnlTemplate.SetRange("Page ID", Page::"Production Journal");
                    ItemJnlTemplate.SetRange(Recurring, false);
                    ItemJnlTemplate.SetRange(Type, PageTemplate::"Prod. Order");
                    if not ItemJnlTemplate.FindFirst() then begin
                        ItemJnlTemplate.Init();
                        ItemJnlTemplate.Recurring := false;
                        ItemJnlTemplate.Validate(Type, PageTemplate);
                        ItemJnlTemplate.Validate("Page ID");

                        ItemJnlTemplate.Name := Format(ItemJnlTemplate.Type, MaxStrLen(ItemJnlTemplate.Name));
                        ItemJnlTemplate.Description := StrSubstNo(Text000, ItemJnlTemplate.Type);
                        ItemJnlTemplate.Insert();
                    end;

                    /*if UpperCase(UserId) <> '' then
                        if (StrLen(UpperCase(UserId)) < MaxStrLen(ItemJnlLine."Journal Batch Name")) and (ItemJnlLine."Journal Batch Name" <> '') then
                            ToBatchName := CopyStr(ItemJnlLine."Journal Batch Name", 1, MaxStrLen(ItemJnlLine."Journal Batch Name") - 1) + 'A'
                        else
                            ToBatchName := DelChr(CopyStr(UpperCase(UserId), 1, MaxStrLen(ItemJnlLine."Journal Batch Name")), '>', '0123456789');*/

                    if ToBatchName = '' then
                        ToBatchName := 'DEFAULT';

                    if not ItemJnlBatch.Get(ItemJnlTemplate.Name, ToBatchName) then begin
                        ItemJnlBatch.Init();
                        ItemJnlBatch."Journal Template Name" := ItemJnlTemplate.Name;
                        ItemJnlBatch.SetupNewBatch();
                        ItemJnlBatch.Name := ToBatchName;
                        ItemJnlBatch.Description := Text004;
                        ItemJnlBatch.Insert(true);
                    end;

                    ItemJnlLine."Journal Template Name" := ItemJnlTemplate.Name;
                    ItemJnlLine."Journal Batch Name" := ToBatchName;
                    ItemJnlLine."Line No." := 10000;
                    ItemJnlLine.Validate("Posting Date", WorkDate());
                    ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::Output);
                    ItemJnlLine.Validate("Order Type", ItemJnlLine."Order Type"::Production);
                    ItemJnlLine.Validate("Order No.", ProdOrderLine."Prod. Order No.");
                    ItemJnlLine.Validate("Order Line No.", ProdOrderLine."Line No.");
                    ItemJnlLine.Validate("Item No.", ProdOrderLine."Item No.");
                    ItemJnlLine.Validate("Variant Code", ProdOrderLine."Variant Code");
                    ItemJnlLine.Validate("Location Code", ProdOrderLine."Location Code");
                    ItemJnlLine.Validate("Dimension Set ID", ProdOrderLine."Dimension Set ID");
                    if ProdOrderLine."Bin Code" <> '' then
                        ItemJnlLine.Validate("Bin Code", ProdOrderLine."Bin Code");
                    ItemJnlLine.Validate("Routing No.", ProdOrderLine."Routing No.");
                    ItemJnlLine.Validate("Routing Reference No.", ProdOrderLine."Routing Reference No.");

                    ItemJnlLine.Validate("Unit of Measure Code", ProdOrderLine."Unit of Measure Code");
                    ItemJnlLine.Validate("Setup Time", 0);
                    ItemJnlLine.Validate("Run Time", 0);
                    ItemJnlLine.Validate("Output Quantity", 1);


                    ProdOrderRoutingLine.Reset();
                    ProdOrderRoutingLine.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
                    ProdOrderRoutingLine.SetRange("Routing No.", ProdOrderLine."Routing No.");
                    ProdOrderRoutingLine.SetRange(Status, ProdOrderLine.Status);
                    ProdOrderRoutingLine.SetRange("Routing Reference No.", ProdOrderLine."Routing Reference No.");
                    If ProdOrderRoutingLine.FindLast() then begin
                        if ProdOrderRoutingLine."Routing Status" = ProdOrderRoutingLine."Routing Status"::Finished then
                            ItemJnlLine.Finished := true;
                        if ProdOrderRoutingLine."Prod. Order No." <> '' then
                            ItemJnlLine.Validate("Operation No.", ProdOrderRoutingLine."Operation No.");
                    end;
                    ItemJnlLine."Flushing Method" := ProdOrderRoutingLine."Flushing Method";
                    ItemJnlLine."Source Code" := ItemJnlTemplate."Source Code";
                    ItemJnlLine."Reason Code" := ItemJnlBatch."Reason Code";
                    ItemJnlLine."Posting No. Series" := ItemJnlBatch."Posting No. Series";

                    ItemJnlLine.Insert();

                    ItemTrackingMgt.CopyItemTracking(ProdOrderLine.RowID1(), ItemJnlLine.RowID1(), false);
                end;
            until ReservationEntry.Next() = 0;

            ItemJnlPostBatch.Run(ItemJnlLine);
            TransferOrder.Init();

            TransferOrder.Insert(True);
            TransferOrder.Validate("Transfer-from Code", ProdOrderLine."Location Code");
            TransferOrder.Validate("Transfer-to Code", 'FGWH');
            TransferOrder.Validate("In-Transit Code", 'INTRANSIT');
            TransferOrder.Modify(true);
            TransferLine.Init();
            TransferLine.Validate("Document No.", TransferOrder."No.");
            TransferLine."Line No." := 10000;
            TransferLine.Validate("Item No.", ProdOrderLine."Item No.");
            TransferLine.Validate(Quantity, 1);
            Location.Reset();
            Location.SetRange(Code, TransferOrder."Transfer-to Code");
            If Location.FindFirst() then
                TransferLine.Validate("Transfer-To Bin Code", Location."Receipt Bin Code");
            TransferLine.Validate("Qty. to Ship", 1);
            TransferLine.Insert(True);

            TransferOrderPostShipment.Run(TransferOrder);

            if TransferOrder.Status <> TransferOrder.Status::Released then begin
                CODEUNIT.Run(CODEUNIT::"Release Transfer Document", TransferOrder);
                Commit();
            end;
            TransferOrder.TestField(Status, TransferOrder.Status::Released);
            WarehouseRequest.SetRange(Type, WarehouseRequest.Type::Inbound);
            WarehouseRequest.SetRange("Source Type", Database::"Transfer Line");
            WarehouseRequest.SetRange("Source Subtype", 1);
            WarehouseRequest.SetRange("Source No.", TransferOrder."No.");
            WarehouseRequest.SetRange("Document Status", WarehouseRequest."Document Status"::Released);
            GetSourceDocInbound.GetRequireReceiveRqst(WarehouseRequest);

            if not WarehouseRequest.IsEmpty() then begin


                Clear(GetSourceDocuments);
                GetSourceDocuments.UseRequestPage(false);
                GetSourceDocuments.SetTableView(WarehouseRequest);
                GetSourceDocuments.SetHideDialog(true);
                GetSourceDocuments.RunModal();

                GetSourceDocuments.GetLastReceiptHeader(WarehouseReceiptHeader);
            end;
            If WarehouseReceiptHeader.FindFirst() then begin
                WarehouseReceiptHeader.Status := WarehouseReceiptHeader.Status::Released;
                WhseReceiptLine.Reset();
                WhseReceiptLine.SetRange("No.",WarehouseReceiptHeader."No.");
                If WhseReceiptLine.FindFirst() then;
                WhsePostReceipt.Run(WhseReceiptLine);
            end;

        end;
    end;

    var
        ReservationEntry: Record "Reservation Entry";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        ItemJnlLine: Record "Item Journal Line";
        ItemJnlTemplate: Record "Item Journal Template";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        ItemJnlBatch: Record "Item Journal Batch";
        ItemJnlPostBatch: Codeunit "Item Jnl.-Post Batch";
        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
        TransferOrder: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        WarehouseRequest: Record "Warehouse Request";
        GetSourceDocuments: Report "Get Source Documents";
        WarehouseReceiptHeader: Record "Warehouse Receipt Header";
        WhsePostReceipt: Codeunit "Whse.-Post Receipt";
        Location: Record Location;
        WhseReceiptLine : Record "Warehouse Receipt Line";
        TransferOrderPostShipment: Codeunit "TransferOrder-Post Shipment";
        PageTemplate: Option Item,Transfer,"Phys. Inventory",Revaluation,Consumption,Output,Capacity,"Prod. Order";
        Text000: Label '%1 journal';
        ToBatchName: Code[10];
        Text004: Label 'Production Journal';
}
