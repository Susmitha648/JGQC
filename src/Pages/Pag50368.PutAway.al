page 50368 "MNExt Put Away"
{
    ApplicationArea = All;
    Caption = 'Put Away';
    PageType = Card;
    SourceTable = "Put Away";
    RefreshOnActivate = true;
    AutoSplitKey = true;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Entry No"; Rec."Entry No")
                {
                }
                field("Serial No"; Rec."Serial No")
                {
                    ApplicationArea = All;
                }
                field("Put Away"; '')
                {
                    ApplicationArea = All;
                    Caption = 'Whse Put Away';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        PutAway: Record "Put Away";
        PutAway1: Record "Put Away";
        WareHeader: Record "Warehouse Activity Header";
    begin
       
        PutAway.Reset();
        If PutAway.IsEmpty then begin
            Rec.Init();
            Rec."Entry No" := 1000;
            Rec.Insert();
        end;
    end;
    
    trigger OnAfterGetCurrRecord()
    begin
        If rec.FindFirst() then;
    end;


}
