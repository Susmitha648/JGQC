tableextension 50007 "Tracking Specification Ext" extends "Tracking Specification"
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
        field(50002; "Rejected"; Boolean)
        {
            Caption = 'Rejected';
            DataClassification = CustomerContent;
        }
    }
}
