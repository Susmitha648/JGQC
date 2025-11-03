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

            RequestFilterFields = "Production Order No.";

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
                DataItemTableView = sorting("Production Order No.", Shift, Batching);
                column(Production_Order_No_Line; "Production Order No.")
                {
                }
                column(Shift; Shift)
                {
                }
                column(Batching; Batching)
                {
                }
                column(BatchingValue; GetBatchingValue())
                {
                }
                column(BatchingCaption; Format(Batching))
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
                column(Time; Time)
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
                group(Options)
                {
                    Caption = 'Options';
                }
            }
        }
    }

    local procedure GetBatchingValue(): Integer
    begin
        // Map the Batching enum to the expected integer values (0-14)
        case "Batch Operators Line".Batching of
            "Batch Operators Line".Batching::"1 to 10":
                exit(0);
            "Batch Operators Line".Batching::"11 to 20":
                exit(1);
            "Batch Operators Line".Batching::"21 to 30":
                exit(2);
            "Batch Operators Line".Batching::"31 to 40":
                exit(3);
            "Batch Operators Line".Batching::"41 to 50":
                exit(4);
            "Batch Operators Line".Batching::"51 to 60":
                exit(5);
            "Batch Operators Line".Batching::"61 to 70":
                exit(6);
            "Batch Operators Line".Batching::"71 to 80":
                exit(7);
            "Batch Operators Line".Batching::"81 to 90":
                exit(8);
            "Batch Operators Line".Batching::"91 to 100":
                exit(9);
            "Batch Operators Line".Batching::"101 to 110":
                exit(10);
            "Batch Operators Line".Batching::"111 to 120":
                exit(11);
            "Batch Operators Line".Batching::"121 to 130":
                exit(12);
            "Batch Operators Line".Batching::"131 to 140":
                exit(13);
            "Batch Operators Line".Batching::"141 to 150":
                exit(14);
            else
                exit(0);
        end;
    end;

}