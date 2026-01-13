table 50026 "Item Reclass Posting"
{
    Caption = 'Item Reclass Posting';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(2; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
        }
        field(3; "Item Type"; Code[20])
        {
            Caption = 'Item Type';
            TableRelation = "Item Type".Code where("Item No." = field("Item No."));
        }
        field(4; "Item Weight"; Decimal)
        {
            Caption = 'Item Weight';
            DecimalPlaces = 0 : 3;
            BlankZero = true;
        }
        field(5; "Line No"; Integer)
        {
            Caption = 'Line No';
        }
        field(6; "Journal Posted"; Boolean)
        {
            Caption = 'Journal Posted';
        }
        field(7; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            trigger OnLookup()
            var
                ManufacturingSetup: Record "Manufacturing Setup";
                BinCode : Record Bin;
            begin
                ManufacturingSetup.Get();
                BinCode.Reset();
                BinCode.SetRange("Location Code",ManufacturingSetup."From Batch Location");
                If Page.RunModal(7303,BinCode) = Action::LookupOK then
                   "Bin Code" := BinCode.Code;
            end;
        }
    }
    keys
    {
        key(PK; "Line No")
        {
            Clustered = true;
        }
    }
}
