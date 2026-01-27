table 50033 "FG Posting Tracking"
{
    Caption = 'FG Posting Tracking';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Source ID"; Code[20])
        {
            Caption = 'Source ID';
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }

        field(3; "Creation Date"; Date)
        {
            Caption = 'Last Modified';
        }
        field(4; "Transferred from Entry No."; Integer)
        {
            Caption = 'Transferred from Entry No.';
            TableRelation = "Reservation Entry";
        }
        field(5; "Source Prod. Order Line"; Integer)
        {
            Caption = 'Source Prod. Order Line';
        }
        field(6; "Serial No."; Code[50])
        {
            Caption = 'Serial No.';
        }
        field(8; "Rejected"; Boolean)
        {
            Caption = 'Rejected';
        }
        field(9; "Status"; enum "FG Track Status")
        {
            Caption = 'Status';
        }
        field(10; "Error Text"; Text[2048])
        {
            Caption = 'Error Text';
        }
        field(11; "Output Posted"; Boolean)
        {
            Caption = 'Output Posted';
        }
        field(12; "Transfer Order Created"; Boolean)
        {
            Caption = 'Transfer Order Created';
        }
        field(13; "Transfer Shipment Posted"; Boolean)
        {
            Caption = 'Transfer Shipment Posted';
        }
        field(14; "Transfer Receipt Posted"; Boolean)
        {
            Caption = 'Transfer Receipt Posted';
        }
        field(15; "Transfer Order No"; Code[20])
        {
            Caption = 'Transfer Order No';
        }
        field(16; "Warehouse Receipt No"; Code[20])
        {
            Caption = 'Warehouse Receipt No';
        }
          field(17; "Receipt Posting Attempt"; Integer)
        {
            Caption = 'Receipt Posting Attempt';
        }
    }

    keys
    {
        key(Key1; "Source ID", "Serial No.")
        {
            Clustered = true;
        }

    }
}
