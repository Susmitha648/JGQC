page 50367 "Reservation Entry"
{
    ApplicationArea = All;
    Caption = 'Reservation Entry';
    PageType = List;
    SourceTable = "Reservation Entry";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the number of the item that has been reserved in this entry.';
                }
                field("Quantity (Base)"; Rec."Quantity (Base)")
                {
                    ToolTip = 'Specifies the quantity of the item that has been reserved in the entry.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies a description of the reservation entry.';
                }
                field("Source ID"; Rec."Source ID")
                {
                    ToolTip = 'Specifies which source ID the reservation entry is related to.';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ToolTip = 'Specifies the serial number of the item that is being handled on the document line.';
                }
            }
        }
    }
}
