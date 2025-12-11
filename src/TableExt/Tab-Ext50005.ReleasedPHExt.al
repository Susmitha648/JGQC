tableextension 50005 "Released PH Ext" extends "Production Order"
{
    fields
    {
        field(50000; "Production Programme"; Code[20])
        {
            Caption = 'Production Programme';
            DataClassification = CustomerContent;
            TableRelation = "Production Programme Header"."No.";
            Editable = false;
        }
    }
}
