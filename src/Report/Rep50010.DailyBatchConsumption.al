report 50010 "Daily Batch Consumption"
{
    ApplicationArea = All;
    Caption = 'Daily Batch Consumption';
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/DailyBatchConsumption.rdl';
    UsageCategory = Documents;
    dataset
    {
        dataitem(BatchOperatorsDailyEntry; "Batch Operators Daily Entry")
        {
            column(Production_Order_No_; "Production Order No.")
            {

            }
            column(Due_Date; "Due Date")
            {

            }
            column(Furnace; Furnace)
            {

            }

            dataitem("Batch Operators Line"; "Batch Operators Line")
            {
                DataItemLink = "Production Order No." = field("Production Order No.");
                column(Production_Order_No_Line; "Production Order No.")
                {

                }
                column(Shift; Shift)
                {

                }
                column(Batching; Batching)
                {

                }
                column(Batch_Unit; "Batch Unit")
                {

                }
                column(Tonnage; Tonnage)
                {

                }
                column(Moisture_Compensated; "Moisture Compensated")
                {

                }
                column(Sand_Moisture_Test; "Sand Moisture Test")
                {

                }
            }
        }
    }
   
}
