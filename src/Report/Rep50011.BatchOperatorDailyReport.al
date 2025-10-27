report 50011 "Batch Operator Daily Report"
{
    ApplicationArea = All;
    Caption = 'Batch Operator Daily Report';
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/BatchOperatorDaily.rdl';
    UsageCategory = Documents;
    dataset
    {
        dataitem(BatchOperatorsDailyEntry; "Batch Operators Daily Entry")
        {
            column(Production_Order_No_; "Production Order No.")
            {

            }
            column(Work_Order_No_; "Work Order No.")
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
