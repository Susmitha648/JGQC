page 50010 "QC Role Center"
{
    ApplicationArea = All;
    Caption = 'QC Role Center';
    PageType = RoleCenter;
    actions
    {
        area(Sections)
        {
            ToolTip = 'Manage processes, view KPIs, and access your favorite items and customers.';
            group(Action46)
            {
                Caption = 'Reference Data';
                action(Items)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Items';
                    Image = Item;
                    RunObject = Page "Item List";
                    ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
                }
            }
            group(Action42)
            {
                Caption = 'Production';
                action("Transfer Orders")
                {
                    ApplicationArea = Location;
                    Caption = 'Transfer Orders';
                    RunObject = Page "Transfer Orders";
                    ToolTip = 'Move inventory items between company locations. With transfer orders, you ship the outbound transfer from one location and receive the inbound transfer at the other location. This allows you to manage the involved warehouse activities and provides more certainty that inventory quantities are updated correctly.';
                }
                action(ReleasedProductionOrders)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Released Production Orders';
                    Image = "Order";
                    RunObject = Page "Released Production Orders";
                    ToolTip = 'Show the list of Released Production orders.';
                }
                action(FinishedProductionOrders)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Finished Production Orders';
                    Image = "Order";
                    RunObject = Page "Finished Production Orders";
                    ToolTip = 'Show the list of Finished Production Orders.';
                }
                action(ProductionBOM)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Production BOM';
                    RunObject = Page "Production BOM";
                    ToolTip = 'View Production BOM';
                }
                action(Routing)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Routing';
                    RunObject = Page "Routing";
                    ToolTip = 'View Routing';
                }
                action(MachineCenter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Machine Centres';
                    RunObject = Page "Machine Center List";
                    ToolTip = 'View Machine Centre';
                }
                action(WorkCenter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Work Centres';
                    RunObject = Page "Work Center List";
                    ToolTip = 'View Work Centre';
                }
            }
            group(Action43)
            {
                Caption = 'Purchase';
                action(PurchaseRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Purchase Request';
                    RunObject = Page "Purchase Request";
                    ToolTip = 'View Purchase Request';
                }
            }
            group(Action44)
            {
                Caption = 'Customer Complaint';
                action(CustomerComplaintLog)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer Complaint Log';
                    RunObject = Page "Customer Complaint Log List";
                    ToolTip = 'View Customer Complaint Log';
                }
                action(CustomerComplaintReport)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer Complaint Report';
                    RunObject = Page "Customer Complaint Report List";
                    ToolTip = 'View Customer Complaint Report';
                }
            }
        }
    }
}

