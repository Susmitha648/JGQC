tableextension 50000 "Manufacturing Setup Ext" extends "Manufacturing Setup"
{
    fields
    {
        field(50000; "Production Programme No."; Code[20] )
        {
            Caption = 'Production Programme No.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series".Code;
        }
        field(50001; "From Batch Location"; Code[20] )
        {
            Caption = 'From Batch Location';
            DataClassification = CustomerContent;
            TableRelation = Location.Code;
        }
        field(50002; "To Batch Location"; Code[20] )
        {
            Caption = 'To Batch Location';
            DataClassification = CustomerContent;
            TableRelation = Location.Code;
        }
    }
}
