codeunit 50002 MNExtPageFunctions
{
    procedure ItemJournalPost("Key" : Record "Item Reclass Posting" )
    var
        ItemJournalLine: Record "Item Journal Line";
        ItemJournalLineNo: Record "Item Journal Line";
        ManufacturingSetup : Record "Manufacturing Setup";
        ItemJournalTemplate : Record "Item Journal Template";
        ItemJournalBatch : Record "Item Journal Batch";
        ItemType : Record "Item Type";
        NoSeries: Codeunit "No. Series";
    begin
        ManufacturingSetup.Get();

        ItemJournalTemplate.Reset();
        ItemJournalTemplate.SetRange("Source Code",'RECLASSJNL');
        If ItemJournalTemplate.FindFirst() then;

        ItemJournalLine.Init();
        ItemJournalLine.Validate("Journal Template Name",ItemJournalTemplate.Name);

        ItemJournalBatch.Reset();
        ItemJournalBatch.SetRange("Journal Template Name",ItemJournalTemplate.Name);
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
        ItemJournalLine.Validate("Item No.","Key"."Item No.");
        ItemJournalLine.Validate("Posting Date",WorkDate());
        ItemJournalLine.Validate("Document No.",NoSeries.GetNextNo(ItemJournalBatch."No. Series"));
        ItemJournalLine.Validate("Location Code",ManufacturingSetup."From Batch Location");
        ItemJournalLine.Validate("New Location Code",ManufacturingSetup."To Batch Location");
        
        If ItemType.Get("Key"."Item Type") then;
        ItemJournalLine.Validate(Quantity,ItemType.Quantity);
        ItemJournalLine.Modify();
    end;
}
