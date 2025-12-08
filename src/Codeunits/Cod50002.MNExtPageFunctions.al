codeunit 50002 MNExtPageFunctions
{
    procedure ItemJournalPost("Key": Record "Item Reclass Posting")
    var
        ItemJournalLine: Record "Item Journal Line";
        ItemJournalLineNo: Record "Item Journal Line";
        ManufacturingSetup: Record "Manufacturing Setup";
        ItemJournalTemplate: Record "Item Journal Template";
        ItemJournalBatch: Record "Item Journal Batch";
        ItemType: Record "Item Type";
        NoSeries: Codeunit "No. Series";
        ItemReclassPost: Record "Item Reclass Posting";
        ReservationEntry : Record "Reservation Entry";
    begin
        

        ManufacturingSetup.Get();

        ItemJournalTemplate.Reset();
        ItemJournalTemplate.SetRange("Source Code", 'RECLASSJNL');
        If ItemJournalTemplate.FindFirst() then;

        ItemJournalLine.Init();
        ItemJournalLine.Validate("Journal Template Name", ItemJournalTemplate.Name);

        ItemJournalBatch.Reset();
        ItemJournalBatch.SetRange("Journal Template Name", ItemJournalTemplate.Name);
        If ItemJournalBatch.FindFirst() then;
        ItemJournalLine.Validate("Journal Batch Name", ItemJournalBatch.Name);

        ItemJournalLineNo.Reset();
        ItemJournalLineNo.SetAscending("Line No.", false);
        ItemJournalLineNo.SetRange("Journal Batch Name", ItemJournalBatch.Name);
        ItemJournalLineNo.SetRange("Journal Template Name", ItemJournalTemplate.Name);
        If ItemJournalLineNo.FindFirst() then
            ItemJournalLine."Line No." := ItemJournalLineNo."Line No." + 10000
        else
            ItemJournalLine."Line No." := 10000;
        ItemJournalLine.Insert(True);
        ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::Transfer;
        ItemJournalLine.Validate("Item No.", "Key"."Item No.");
        ItemJournalLine.Validate("Posting Date", WorkDate());
        ItemJournalLine.Validate("Document No.", NoSeries.GetNextNo(ItemJournalBatch."No. Series"));
        ItemJournalLine.Validate("Location Code", ManufacturingSetup."From Batch Location");
        ItemJournalLine.Validate("New Location Code", ManufacturingSetup."To Batch Location");

        If ItemType.Get("Key"."Item Type") then;
        ItemJournalLine.Validate(Quantity, ItemType.Quantity);
        ItemJournalLine.Modify();

        ReservationEntry.Init();
        ReservationEntry."Entry No." := 0;
        ReservationEntry.Validate("Item No.", "Key"."Item No.");
        ReservationEntry."Location Code" := ManufacturingSetup."From Batch Location";
        ReservationEntry.Positive := false;
        ReservationEntry.Validate("Quantity (Base)", ItemJournalLine.Quantity);
        ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Prospect;
        ReservationEntry.Validate("Lot No.", "Key"."Batch No.");
        ReservationEntry."Source ID" := ItemJournalLine."Journal Template Name";
        ReservationEntry."Source Batch Name" := ItemJournalLine."Journal Batch Name";
        ReservationEntry."Source Type" := 83;
        ReservationEntry."Source Subtype" := 4;
        ReservationEntry."Source Ref. No." := 10000;
        ReservationEntry."Shipment Date" := ItemJournalLine."Posting Date";
        ReservationEntry."Planning Flexibility" := ReservationEntry."Planning Flexibility"::Unlimited;
        ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot No.";
        ReservationEntry.Insert(True);

        "Key"."Journal Posted" := True;
        "Key".Modify();

    end;
}
