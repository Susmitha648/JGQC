pageextension 50002 "Manufacturing Setup Ext" extends "Manufacturing Setup"
{
    layout{
        addafter("Routing Nos.")
        {
            field("Production Programme No."; Rec."Production Programme No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Default Flushing Method")
        {
            field("From Batch Loaction"; Rec."From Batch Location")
            {
                ApplicationArea = All;
            }
            field("To Batch Loaction"; Rec."To Batch Location")
            {
                ApplicationArea = All;
            }
            field("FG Passed Move To Location"; Rec."FG Passed Move To Location")
            {
                ApplicationArea = All;
            }
            field("FG Rejected Move To Location"; Rec."FG Rejected Move To Location")
            {
                ApplicationArea = All;
            }
            field("Work Shift Hours"; Rec."Work Shift Hours")
            {
                ApplicationArea = All;
            }
        }
    }
}
