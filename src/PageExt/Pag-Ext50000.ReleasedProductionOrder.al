pageextension 50000 "Released Production Order" extends "Released Production Order"
{
     actions
    {
        addafter("Re&plan")
        {
            action(MachineSectionStoppages)
            {
                ApplicationArea = All;
                Caption = 'Machine/Section Stoppages Details';
                Image = List;
                ToolTip = 'Machine/Section Stoppages Details';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Machine/Section Stoppages List";
                RunPageLink = "Production Order No." = field("No.");
            }
        }
    }
}
