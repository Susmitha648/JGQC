codeunit 50003 "FG Posting"
{
    TableNo = "Reservation Entry";
    trigger OnRun()
    begin
                Clear(LineNo);
                Clear(TransferNo);
                ProdOrderLine.Reset();
                ProdOrderLine.SetRange("Prod. Order No.", Rec."Source ID");
                ProdOrderLine.SetRange("Line No.", Rec."Source Prod. Order Line");
                If ProdOrderLine.FindFirst() then begin
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

                    if UpperCase(UserId) <> '' then
                        if (StrLen(UpperCase(UserId)) < MaxStrLen(ItemJnlLine."Journal Batch Name")) and (ItemJnlLine."Journal Batch Name" <> '') then
                            ToBatchName := CopyStr(ItemJnlLine."Journal Batch Name", 1, MaxStrLen(ItemJnlLine."Journal Batch Name") - 1) + 'A'
                        else
                            ToBatchName := DelChr(CopyStr(UpperCase(UserId), 1, MaxStrLen(ItemJnlLine."Journal Batch Name")), '>', '0123456789');

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
                    ProdJnrlMgt.DeleteJnlLines(ItemJnlTemplate.Name, ToBatchName, ProdOrderLine."Prod. Order No.", ProdOrderLine."Line No.");
                    ItemJnlLine.Init();


                    ItemJnlLine."Journal Template Name" := ItemJnlTemplate.Name;
                    ItemJnlLine."Journal Batch Name" := ToBatchName;
                    ItemJnlLine1.Reset();
                    ItemJnlLine1.SetAscending("Line No.", false);
                    ItemJnlLine1.SetRange("Journal Template Name", ItemJnlTemplate.Name);
                    ItemJnlLine1.SetRange("Journal Batch Name", ToBatchName);
                    If ItemJnlLine1.FindFirst() then
                        ItemJnlLine."Line No." := ItemJnlLine1."Line No." + 10000
                    Else
                        ItemJnlLine."Line No." := 10000;
                    LineNo := ItemJnlLine."Line No.";
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
                    ItemJnlLine.Validate("Unit of Measure Code", ProdOrderLine."Unit of Measure Code");
                    ItemJnlLine.Validate("Setup Time", 0);
                    ItemJnlLine.Validate("Run Time", 0);


                    //ItemJnlLine.CheckWhse(ProdOrderLine."Location Code", ItemJnlLine."Quantity (Base)");
                    ItemJnlLine.Validate("Output Quantity", 1);
                    ItemJnlLine."Flushing Method" := ProdOrderRoutingLine."Flushing Method";
                    ItemJnlLine."Source Code" := ItemJnlTemplate."Source Code";
                    ItemJnlLine."Reason Code" := ItemJnlBatch."Reason Code";
                    ItemJnlLine."Posting No. Series" := ItemJnlBatch."Posting No. Series";
                    ItemJnlLine."Serial No." := Rec."Serial No.";
                    ItemJnlLine.Insert();

                    ReservationEntry1.Init();
                    ReservationEntry1."Entry No." := 0;
                    ReservationEntry1.Validate("Item No.", ItemJnlLine."Item No.");
                    ReservationEntry1."Location Code" := ItemJnlLine."Location Code";


                    ReservationEntry1.Validate("Planning Flexibility", ReservationEntry1."Planning Flexibility"::Unlimited);
                    ReservationEntry1.Validate("Item Tracking", ReservationEntry1."Item Tracking"::"Serial No.");
                    ReservationEntry1."Reservation Status" := ReservationEntry1."Reservation Status"::Prospect;
                    ReservationEntry1.Validate("Serial No.", Rec."Serial No.");
                    ReservationEntry1.Validate("Source ID", ItemJnlLine."Journal Template Name");
                    ReservationEntry1.Validate("Source Type", 83);
                    ReservationEntry1.Validate("Source Subtype", 6);
                    ReservationEntry1.Validate("Source Batch Name", ItemJnlLine."Journal Batch Name");
                    ReservationEntry1.Validate(Positive, true);
                    ReservationEntry1.Validate("Quantity (Base)", 1);

                    ReservationEntry1.Validate("Source Ref. No.", ItemJnlLine."Line No.");
                    ReservationEntry1.Validate("Expected Receipt Date", ProdOrderLine."Due Date");
                    ReservationEntry1."Created By" := UserId;
                    ReservationEntry1.Insert();

                    ItemJnlLinePost.Reset();
                    ItemJnlLinePost.SetRange("Journal Template Name", ItemJnlTemplate.Name);
                    ItemJnlLinePost.SetRange("Journal Batch Name", ToBatchName);
                    ItemJnlLinePost.SetRange("Order No.", ProdOrderLine."Prod. Order No.");
                    ItemJnlLinePost.SetRange("Entry Type", ItemJnlLinePost."Entry Type"::Output);
                    ItemJnlLinePost.SetRange("Line No.", LineNo);
                    If ItemJnlLinePost.FindFirst() then
                        ItemJnlPostBatch.Run(ItemJnlLinePost);

                    TransferOrder.Init();
                    TransferOrder.Insert(True);
                    TransferOrder.Validate("Transfer-from Code", ProdOrderLine."Location Code");
                    TransferOrder.Validate("Transfer-to Code", 'FGWH');
                    TransferOrder.Validate("In-Transit Code", 'INTRANSIT');
                    TransferNo := TransferOrder."No.";
                    TransferOrder.Modify(true);
                    TransferLine.Init();
                    TransferLine.Validate("Document No.", TransferNo);
                    TransferLine."Line No." := 10000;
                    TransferLine.Validate("Item No.", ProdOrderLine."Item No.");
                    TransferLine.Validate(Quantity, 1);
                    If TransferLine."Transfer-To Bin Code" = '' then begin
                        Location.Reset();
                        Location.SetRange(Code, TransferOrder."Transfer-to Code");
                        If Location.FindFirst() then
                            TransferLine.Validate("Transfer-To Bin Code", Location."Receipt Bin Code");
                    End;
                    //TransferLine.Validate("Qty. to Ship", 1);
                    TransferLine.Insert(True);
                    TransferLine1.Reset();
                    TransferLine1.SetRange("Document No.", TransferNo);
                    If TransferLine1.FindFirst() then begin
                        ReservationEntry1.Init();
                        ReservationEntry1."Entry No." := 0;
                        ReservationEntry1.Validate("Item No.", TransferLine1."Item No.");
                        ReservationEntry1."Location Code" := TransferLine1."Transfer-from Code";


                        ReservationEntry1.Validate("Planning Flexibility", ReservationEntry1."Planning Flexibility"::Unlimited);
                        ReservationEntry1.Validate("Item Tracking", ReservationEntry1."Item Tracking"::"Serial No.");
                        ReservationEntry1."Reservation Status" := ReservationEntry1."Reservation Status"::Surplus;
                        ReservationEntry1.Validate("Serial No.", Rec."Serial No.");
                        ReservationEntry1.Validate("Source ID", TransferNo);
                        ReservationEntry1.Validate("Source Type", 5741);
                        ReservationEntry1.Validate("Source Subtype", 0);
                        ReservationEntry1.Validate("Source Batch Name", '');
                        ReservationEntry1.Validate(Positive, false);
                        ReservationEntry1.Validate("Quantity (Base)", -1);

                        ReservationEntry1.Validate("Source Ref. No.", TransferLine1."Line No.");
                        ReservationEntry1.Validate("Shipment Date", WorkDate());
                        ReservationEntry1."Created By" := UserId;
                        ReservationEntry1."Creation Date" := WorkDate();
                        ReservationEntry1.Insert(True);
                       ReservationEntry1.Init();
                        ReservationEntry1."Entry No." := 0;
                        ReservationEntry1.Validate("Item No.", TransferLine."Item No.");
                        ReservationEntry1."Location Code" := TransferLine."Transfer-to Code";


                        ReservationEntry1.Validate("Planning Flexibility", ReservationEntry1."Planning Flexibility"::Unlimited);
                        ReservationEntry1.Validate("Item Tracking", ReservationEntry1."Item Tracking"::"Serial No.");
                        ReservationEntry1."Reservation Status" := ReservationEntry1."Reservation Status"::Surplus;
                        ReservationEntry1.Validate("Serial No.", Rec."Serial No.");
                        ReservationEntry1.Validate("Source ID", TransferNo);
                        ReservationEntry1.Validate("Source Type", 5741);
                        ReservationEntry1.Validate("Source Subtype", 1);
                        ReservationEntry1.Validate("Source Batch Name", '');
                        ReservationEntry1.Validate(Positive, true);
                        ReservationEntry1.Validate("Quantity (Base)", 1);

                        ReservationEntry1.Validate("Source Ref. No.", TransferLine."Line No.");
                        ReservationEntry1.Validate("Expected Receipt Date", WorkDate());
                        ReservationEntry1."Created By" := UserId;
                        ReservationEntry1."Creation Date" := WorkDate();
                        ReservationEntry1.Insert();
                    End;
                    If TransferOrderPost.Get(TransferNo) then
                        TransferOrderPostShipment.Run(TransferOrderPost);

                    if TransferOrderPost.Status <> TransferOrderPost.Status::Released then begin
                        CODEUNIT.Run(CODEUNIT::"Release Transfer Document", TransferOrderPost);
                        Commit();
                    end;
                    TransferOrderPost.TestField(Status, TransferOrderPost.Status::Released);
                    WarehouseRequest.SetRange(Type, WarehouseRequest.Type::Inbound);
                    WarehouseRequest.SetRange("Source Type", Database::"Transfer Line");
                    WarehouseRequest.SetRange("Source Subtype", 1);
                    WarehouseRequest.SetRange("Source No.", TransferOrderPost."No.");
                    WarehouseRequest.SetRange("Document Status", WarehouseRequest."Document Status"::Released);
                    GetSourceDocInbound.GetRequireReceiveRqst(WarehouseRequest);

                    if not WarehouseRequest.IsEmpty() then begin


                        Clear(GetSourceDocuments);
                        GetSourceDocuments.UseRequestPage(false);
                        GetSourceDocuments.SetTableView(WarehouseRequest);
                        GetSourceDocuments.SetHideDialog(true);
                        GetSourceDocuments.RunModal();

                        GetSourceDocuments.GetLastReceiptHeader(WarehouseReceiptHeader);
                        If WarehouseReceiptHeader1.Get(WarehouseReceiptHeader."No.") then begin
                            WarehouseReceiptHeader1.Status := WarehouseReceiptHeader1.Status::Released;
                            WarehouseReceiptHeader1.Modify();
                            WhseReceiptLine.Reset();
                            WhseReceiptLine.SetRange("No.", WarehouseReceiptHeader1."No.");
                            If WhseReceiptLine.FindFirst() then;
                            WhsePostReceipt.Run(WhseReceiptLine);
                        end;
                    end;

                end;
    end;

    var
        ReservationEntry1: Record "Reservation Entry";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        ItemJnlLine: Record "Item Journal Line";
        ItemJnlLine1: Record "Item Journal Line";
        ItemJnlLinePost: Record "Item Journal Line";
        TransferOrderPost: Record "Transfer Header";
        TransferNo: Code[20];
        ItemJnlTemplate: Record "Item Journal Template";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        ItemJnlBatch: Record "Item Journal Batch";
        ItemJnlPostBatch: Codeunit "Item Jnl.-Post Batch";
        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
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
        LineNo: Integer;
        TransferOrderPostShipment: Codeunit "TransferOrder-Post Shipment";
        ProdJnrlMgt: Codeunit "Production Journal Mgt";
        PageTemplate: Option Item,Transfer,"Phys. Inventory",Revaluation,Consumption,Output,Capacity,"Prod. Order";
        Text000: Label '%1 journal';
        ToBatchName: Code[10];
        Text004: Label 'Production Journal';
}
