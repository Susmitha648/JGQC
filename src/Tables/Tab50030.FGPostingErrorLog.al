table 50030 "FG Posting Error Log"
{
    Caption = 'FG Posting Error Log';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Line No"; Integer)
        {
            Caption = 'Line No';
        }
        field(2; "Document No"; Code[20])
        {
            Caption = 'Document No';
        }
        field(3; Error; Text[2048])
        {
            Caption = 'Error';
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
