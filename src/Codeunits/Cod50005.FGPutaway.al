codeunit 50005 "FG Putaway"
{
    TableNo = "FG Posting Tracking";
    trigger OnRun()
    begin
        ManufacturingSetup.Get();
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
                ItemJnlTemplate.Validate(Type, PageTemplate::"Prod. Order");
                ItemJnlTemplate.Validate("Page ID", Page::"Production Journal");

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
            If ItemJnlLinePost.FindFirst() then;
            ItemJnlPostBatch.SetSuppressCommit(true);
            ItemJnlPostBatch.Run(ItemJnlLinePost);
            Commit();

        end;
    end;




    var
        ReservationEntry1: Record "Reservation Entry";
        ReservationEntrytemp: Record "Reservation Entry";
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
        WhseReceiptLine1: Record "Warehouse Receipt Line";
        ManufacturingSetup: Record "Manufacturing Setup";
        LineNo: Integer;
        TransferOrderPostShipment: Codeunit "TransferOrder-Post Shipment";
        ProdJnrlMgt: Codeunit "Production Journal Mgt";
        PageTemplate: Option Item,Transfer,"Phys. Inventory",Revaluation,Consumption,Output,Capacity,"Prod. Order";
        Text000: Label '%1 journal';
        ToBatchName: Code[10];
        Text004: Label 'Production Journal';
        TempReservEntry: Record "Reservation Entry" temporary;
        TransLine: Record "Transfer Line";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ReservStatus: Enum "Reservation Status";
        CurrentSourceRowID: Text[250];
        SecondSourceRowID: Text[250];
}
