tableextension 50006 "Reservation Entry Ext" extends "Reservation Entry"
{
    fields
    {
        field(50000; "Recording Slip Printed"; Boolean)
        {
            Caption = 'Recording Slip Printed';
            DataClassification = CustomerContent;
        }
        field(50001; "Output Posted"; Boolean)
        {
            Caption = 'Output Posted';
            DataClassification = CustomerContent;
        }
    }
}
