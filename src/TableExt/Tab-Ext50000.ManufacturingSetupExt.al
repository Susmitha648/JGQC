tableextension 50000 "Manufacturing Setup Ext" extends "Manufacturing Setup"
{
    fields
    {
        field(50000; "Production Programme No."; Code[20] )
        {
            Caption = 'Production Programme No.';
            DataClassification = CustomerContent;
        }
    }
}
