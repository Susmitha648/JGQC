report 50012 "F1 - Daily Production Report"
{
    ApplicationArea = All;
    Caption = 'F1 - Daily Production Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/DailyProductionReport.rdl';
    dataset
    {
        dataitem(ProductionProgrammeLine; "Production Programme Line")
        {
            column(No; "No.")
            {
            }
            column(Date; "Date")
            {
            }
            column(Day; Day)
            {
            }
            column(Furnace; Furnace)
            {
            }
            column(Job; Job)
            {
            }
            column(WT; WT)
            {
            }
            column(Speed; Speed)
            {
            }
            column(Ton; Ton)
            {
            }
            column(Tray; Tray)
            {
            }
            column(Pallet; Pallet)
            {
            }
            column(BottlesPerMinute; "Bottles Per Minute")
            {
            }
            column(ProductionOrderNo; "Production Order No.")
            {
            }
            column(ProdOrderCreated; "Prod Order Created")
            {
            }
            dataitem("Production Order";"Production Order")
            {
                DataItemLink = "No." = field("Production Order No.");
                column(Description;Description){}
                dataitem("Prod. Order Line";"Prod. Order Line")
                {
                   DataItemLink = "Prod. Order No." = field("No.");
                   column(Work_Shift;"Work Shift"){}
                   column(GobCutOutPutQuantity;Quantity){}
                   dataitem("Item Ledger Entry";"Item Ledger Entry")
                   {
                       DataItemLink = "Document No." = field("Prod. Order No."),"Order Line No." = Field("Line No.");
                       DataItemTableView = Where ("Entry Type" = Filter(Output));
                   }
                }
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
}
