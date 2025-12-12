page 50362 "Item Reclass Posting"
{
    ApplicationArea = All;
    Caption = 'Batch House Automation';
    PageType = Card;
    SourceTable = "Item Reclass Posting";
    AutoSplitKey = true;
    RefreshOnActivate = true;
    UsageCategory = Tasks;
    PromotedActionCategoriesML = ENU = 'Post';
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;

                }
                field("Batch No."; Rec."Batch No.")
                {
                    ApplicationArea = All;

                }
                field("Item Type"; Rec."Item Type")
                {
                    ApplicationArea = All;
                    TableRelation = "Item Type".Code;
                }
                field("Item Weight"; Rec."Item Weight")
                {
                    ApplicationArea = All;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            group(Action12)
            {
                Caption = 'Post';
                Image = Post;

                action(Release)
                {
                    ApplicationArea = Suite;
                    Caption = 'Post';
                    Image = Post;
                    Promoted = True;
                    PromotedIsBig = True;
                    PromotedCategory = New;
                    ToolTip = 'Post Item Reclassification Journal';
                    trigger OnAction()
                    var
                        ItemJournalLine: Record "Item Journal Line";
                        ItemJournalLinePost: Record "Item Journal Line";
                        ItemJournalLineNo: Record "Item Journal Line";
                        ManufacturingSetup: Record "Manufacturing Setup";
                        ItemJournalTemplate: Record "Item Journal Template";
                        ItemJournalBatch: Record "Item Journal Batch";
                        ItemType: Record "Item Type";
                        NoSeries: Codeunit "No. Series";
                        ItemReclassPost: Record "Item Reclass Posting";
                        ReservationEntry: Record "Reservation Entry";
                        ItemJnlPostBatch: Codeunit "Item Jnl.-Post Batch";
                        LineNo: Integer;
                    begin


                        ManufacturingSetup.Get();

                        ItemJournalTemplate.Reset();
                        ItemJournalTemplate.SetRange("Source Code", 'RECLASSJNL');
                        If ItemJournalTemplate.FindFirst() then;

                        ItemJournalLine.Init();
                        ItemJournalLine.Validate("Journal Template Name", ItemJournalTemplate.Name);

                        ItemJournalBatch.Reset();
                        ItemJournalBatch.SetRange("Journal Template Name", ItemJournalTemplate.Name);
                        ItemJournalBatch.SetRange(Name, 'DEFAULT');
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
                        ItemJournalLine.Insert();
                        ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::Transfer;
                        ItemJournalLine.Validate("Item No.", Rec."Item No.");
                        ItemJournalLine.Validate("Posting Date", WorkDate());
                        ItemJournalLine."Document No." := NoSeries.PeekNextNo(ItemJournalBatch."No. Series", ItemJournalLine."Posting Date");
                        ItemJournalLine.Validate("Location Code", ManufacturingSetup."From Batch Location");
                        ItemJournalLine.Validate("New Location Code", ManufacturingSetup."To Batch Location");

                        If ItemType.Get(Rec."Item No.", Rec."Item Type") then
                            ItemJournalLine.Validate(Quantity, ItemType.Quantity)
                        Else
                            ItemJournalLine.Validate(Quantity, Rec."Item Weight");

                        If Rec."Bin Code" <> '' then
                            ItemJournalLine.Validate("Bin Code", Rec."Bin Code");
                        LineNo := ItemJournalLine."Line No.";



                        ItemJournalLine.Modify();
                        ItemJournalLinePost.Reset();
                        ItemJournalLinePost.SetRange("Journal Template Name", ItemJournalTemplate.Name);
                        ItemJournalLinePost.SetRange("Journal Batch Name", ItemJournalBatch.Name);
                        ItemJournalLinePost.SetRange("Line No.", LineNo);
                        If ItemJournalLinePost.FindFirst() then
                            ReservationEntry.Init();
                        ReservationEntry."Entry No." := 0;
                        ReservationEntry.Validate("Item No.", Rec."Item No.");
                        ReservationEntry.Validate("Location Code", ManufacturingSetup."From Batch Location");
                        ReservationEntry.Validate(Positive, false);
                        ReservationEntry.Validate("Quantity (Base)", -1 * ItemJournalLinePost.Quantity);
                        ReservationEntry.Validate("Reservation Status", ReservationEntry."Reservation Status"::Prospect);
                        ReservationEntry.Validate("Lot No.", Rec."Batch No.");
                        ReservationEntry.Validate("New Lot No.", Rec."Batch No.");
                        ReservationEntry.Validate("Source ID", ItemJournalLinePost."Journal Template Name");
                        ReservationEntry.Validate("Source Batch Name", ItemJournalLinePost."Journal Batch Name");
                        ReservationEntry.Validate("Source Type", 83);
                        ReservationEntry.Validate("Source Subtype", 4);
                        ReservationEntry.Validate("Source Ref. No.", LineNo);
                        ReservationEntry.Validate("Shipment Date", ItemJournalLinePost."Posting Date");
                        ReservationEntry.Validate("Planning Flexibility", ReservationEntry."Planning Flexibility"::Unlimited);
                        ReservationEntry.Validate("Item Tracking", ReservationEntry."Item Tracking"::"Lot No.");
                        ReservationEntry.Insert();



                        ItemJnlPostBatch.Run(ItemJournalLinePost);
                        Rec."Journal Posted" := true;
                        Rec.Modify();
                        Message('Posted Succesfully');
                    end;
                }
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        If rec.FindFirst() then;
    end;

    trigger OnOpenPage()
    var
        ItemReclass: Record "Item Reclass Posting";
        ItemReclass1: Record "Item Reclass Posting";
    begin
        ItemReclass.Reset();
        ItemReclass.SetRange("Journal Posted", True);
        If ItemReclass.FindFirst() then
            ItemReclass.Delete();
        ItemReclass1.Reset();
        If ItemReclass1.IsEmpty then begin
            Rec.Init();
            Rec."Line No" := 1000;
            Rec.Insert();
        end;
    end;

    var
        ItemNo: Code[20];
        BatchNo: Code[20];
        ItemType: Code[20];
        ItemWeight: Decimal;
}

