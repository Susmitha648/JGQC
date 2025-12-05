report 50014 "Item Reclas Journal Posting"
{
    ApplicationArea = All;
    Caption = 'Item Reclas Journal Posting';
    UsageCategory = Tasks;
    dataset
    {
        dataitem(Integer; Integer)
        {
            
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                 group(Options)
                {
                    field(ItemNo; ItemNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Item No.';
                        TableRelation = Item."No.";
                    }
                    field(BatchNo; BatchNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Batch No';
                    }
                    field(ItemType; ItemType)
                    {
                        ApplicationArea = All;
                        Caption = 'Item Type';
                        TableRelation = "Item Type".Code;
                    }
                    field(ItemWeight; ItemWeight)
                    {
                        ApplicationArea = All;
                        Caption = 'Item Weight';
                        BlankZero = true;
                    }
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    var
    ItemNo : Code[20];
    BatchNo : Code[20];
    ItemType : Code[20];
    ItemWeight : Decimal;
}
