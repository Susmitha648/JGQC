pageextension 50001 "Finished Production Order" extends "Finished Production Order"
{
    layout{
        modify("Starting Date-Time")
        {
            Visible = false;
        }
        modify("Ending Date-Time")
        {
            Visible = false;
        }
    }
     actions
    {
        addafter("E&ntries")
        {
            action(MachineSectionStoppages)
            {
                ApplicationArea = All;
                Caption = 'Machine/Section Stoppages Details';
                Image = List;
                ToolTip = 'Machine/Section Stoppages Details';
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page "Machine/SectionStoppagesFinLis";
                RunPageLink = "Production Order No." = field("No.");
            }
            action(COADetails)
            {
                ApplicationArea = All;
                Caption = 'COA Details';
                Image = List;
                ToolTip = 'COA Details';
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page "COA Details Finished";
                RunPageLink = "Released Prod Order No." = field("No.");
            }
            action(BatchOperatorEntry)
            {
                ApplicationArea = All;
                Caption = 'Batch Operators Daily Entries';
                Image = List;
                ToolTip = 'Batch Operators Daily Entries';
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page "Batch Operator Entries Finishe";
                RunPageLink = "Production Order No." = field("No.");
            }
        }
    }
}
