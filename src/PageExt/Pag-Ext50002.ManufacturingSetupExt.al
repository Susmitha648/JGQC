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
    }
}
