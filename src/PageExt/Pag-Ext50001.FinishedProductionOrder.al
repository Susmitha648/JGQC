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
        }
    }
}
