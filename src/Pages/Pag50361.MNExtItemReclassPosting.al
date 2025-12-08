page 50361 "MNExt Item Reclass Posting"
{
    ApplicationArea = All;
    Caption = 'Item Reclass Posting';
    PageType = Card;
    SourceTable = "Item Reclass Posting";
    AutoSplitKey = true;
    RefreshOnActivate = true;

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
                field("Post"; '')
                {
                    ApplicationArea = All;
                    Caption = 'Post';
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
