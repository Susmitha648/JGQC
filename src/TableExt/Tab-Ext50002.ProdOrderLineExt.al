tableextension 50002 "Prod Order Line Ext" extends "Prod. Order Line"
{
    fields
    {
        field(50000; "Work Shift"; Code[20] )
        {
            Caption = 'Work Shift';
            DataClassification = CustomerContent;
            TableRelation = "Work Shift".Code;
        }
          field(50001; "Work Center"; Code[20] )
        {
            Caption = 'Work Center';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code;
        }
    }
}
