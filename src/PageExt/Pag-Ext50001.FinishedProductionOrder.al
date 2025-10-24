pageextension 50001 "Finished Production Order" extends "Finished Production Order"
{
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
                PromotedCategory = Process;
                RunObject = Page "COA Details";
                RunPageLink = "Released Prod Order No." = field("No.");
            }
            action(BatchOperatorEntry)
            {
                ApplicationArea = All;
                Caption = 'Batch Operators Daily Entry';
                Image = List;
                ToolTip = 'Batch Operators Daily Entry';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Batch Operators Daily Entries";
                RunPageLink = "Production Order No." = field("No.");
            }
        }
    }
}
