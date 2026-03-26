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
        field(50003; "FG Passed Move To Location"; Code[20] )
        {
            Caption = 'FG Passed Move To Location';
            DataClassification = CustomerContent;
            TableRelation = Location.Code;
        }
        field(50004; "FG Rejected Move To Location"; Code[20] )
        {
            Caption = 'FG Rejected Move To Location';
            DataClassification = CustomerContent;
            TableRelation = Location.Code;
        }
         field(50005; "Work Shift Hours"; Integer )
        {
            Caption = 'Work Shift Hours';
            DataClassification = CustomerContent;
        }
        field(50006; "Machine Draining Batch"; Code[10] )
        {
            Caption = 'Machine Draining Batch';
            DataClassification = CustomerContent;
            TableRelation = "Item Journal Batch".Name where ("Journal Template Name" = FILTER('ITEM'));
        }
    }
}
