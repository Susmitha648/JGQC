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

            dataitem(ShiftGroup; Integer)
            {
                DataItemTableView = sorting(Number);

                column(Shift; CurrentShift)
                {
                }
                column(Shift_Tonnage; ShiftTonnage)
                {
                }
                column(Shift_Batch_Count; ShiftBatchCount)
                {
                }
                column(Shift_Batch_Unit; ShiftBatchUnit)
                {
                }

                dataitem(BatchSequence; Integer)
                {
                    DataItemTableView = sorting(Number) where(Number = filter(1 .. 15));

                    column(Batching_Text; BatchingText)
                    {
                    }
                    column(Batch_Unit; TempBatchUnit)
                    {
                    }
                    column(Tonnage; TempTonnage)
                    {
                    }
                    column(Moisture_Compensated; TempMoistureCompensated)
                    {
                    }
                    column(Sand_Moisture_Test; TempSandMoistureTest)
                    {
                    }
                    column(Time; TempTime)
                    {
                    }

                    trigger OnAfterGetRecord()
                    var
                        BatchOperatorsLine: Record "Batch Operators Line";
                    begin
                        // Initialize all temp variables
                        Clear(TempBatchUnit);
                        Clear(TempTonnage);
                        Clear(TempMoistureCompensated);
                        Clear(TempSandMoistureTest);
                        Clear(TempTime);

                        // Generate batching text (e.g., "1 to 10", "11 to 20")
                        case Number of
                            1:
                                BatchingText := '1 to 10';
                            2:
                                BatchingText := '11 to 20';
                            3:
                                BatchingText := '21 to 30';
                            4:
                                BatchingText := '31 to 40';
                            5:
                                BatchingText := '41 to 50';
                            6:
                                BatchingText := '51 to 60';
                            7:
                                BatchingText := '61 to 70';
                            8:
                                BatchingText := '71 to 80';
                            9:
                                BatchingText := '81 to 90';
                            10:
                                BatchingText := '91 to 100';
                            11:
                                BatchingText := '101 to 110';
                            12:
                                BatchingText := '111 to 120';
                            13:
                                BatchingText := '121 to 130';
                            14:
                                BatchingText := '131 to 140';
                            15:
                                BatchingText := '141 to 150';
                        end;

                        // Look for data that matches this batching range AND current shift
                        BatchOperatorsLine.SetRange("Production Order No.", BatchOperatorsDailyEntry."Production Order No.");
                        BatchOperatorsLine.SetRange(Shift, CurrentShift);
                        BatchOperatorsLine.SetFilter(Batching, BatchingText);

                        if BatchOperatorsLine.FindSet() then begin
                            repeat
                                TempBatchUnit += BatchOperatorsLine."Batch Unit";
                                TempTonnage += BatchOperatorsLine.Tonnage;
                                TempMoistureCompensated += BatchOperatorsLine."Moisture Compensated";
                                TempSandMoistureTest += BatchOperatorsLine."Sand Moisture Test";
                                TempTime := BatchOperatorsLine.Time;
                            until BatchOperatorsLine.Next() = 0;
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange(Number, 1, 15);
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    BatchOperatorsLine: Record "Batch Operators Line";
                begin
                    if Number > TempShiftList.Count then
                        CurrReport.Break();

                    CurrentShift := TempShiftList.Get(Number);

                    // Calculate shift totals
                    ShiftTonnage := 0;
                    ShiftBatchCount := 0;
                    ShiftBatchUnit := 0;

                    BatchOperatorsLine.SetRange("Production Order No.", BatchOperatorsDailyEntry."Production Order No.");
                    BatchOperatorsLine.SetRange(Shift, CurrentShift);
                    if BatchOperatorsLine.FindSet() then begin
                        repeat
                            ShiftTonnage += BatchOperatorsLine.Tonnage;
                            ShiftBatchCount += 1;
                            ShiftBatchUnit += BatchOperatorsLine."Batch Unit";
                        until BatchOperatorsLine.Next() = 0;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, 999);
                end;
            }

            dataitem("Prod. Order Component"; "Prod. Order Component")
            {
                DataItemLink = "Prod. Order No." = field("Production Order No.");

                column(Item_No_; "Item No.")
                {
                }
                column(Description; Description)
                {
                }
                column(Quantity_per_Prod_Order; "Quantity per")
                {
                }
                column(Line_No_; "Line No.")
                {
                }
            }

            trigger OnAfterGetRecord()
            var
                BatchOperatorsLine: Record "Batch Operators Line";
                ShiftValue: Code[20];
            begin
                // Build list of unique shifts for this production order
                Clear(TempShiftList);
                BatchOperatorsLine.SetRange("Production Order No.", "Production Order No.");
                if BatchOperatorsLine.FindSet() then begin
                    repeat
                        if not TempShiftList.Contains(BatchOperatorsLine.Shift) then
                            TempShiftList.Add(BatchOperatorsLine.Shift);
                    until BatchOperatorsLine.Next() = 0;
                end;
            end;
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

    var
        TempShiftList: List of [Code[20]];
        CurrentShift: Code[20];
        ShiftTonnage: Decimal;
        ShiftBatchCount: Integer;
        ShiftBatchUnit: Decimal;
        BatchingText: Text;
        TempBatchUnit: Decimal;
        TempTonnage: Decimal;
        TempMoistureCompensated: Decimal;
        TempSandMoistureTest: Decimal;
        TempTime: Time;
}