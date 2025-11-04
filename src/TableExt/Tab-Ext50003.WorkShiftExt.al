tableextension 50003 "Work Shift Ext" extends "Work Shift"
{
    fields
    {
        field(50000; "Starting Time"; Time)
        {
            Caption = 'Starting Time';
            DataClassification = CustomerContent;
        }
        field(50001; "Ending Time"; Time)
        {
            Caption = 'Ending Time';
            DataClassification = CustomerContent;
        }
    }
}
