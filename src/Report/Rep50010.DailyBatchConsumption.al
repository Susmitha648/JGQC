report 50010 "Daily Batch Consumption"
{
    ApplicationArea = All;
    Caption = 'Daily Batch Consumption';
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/DailyBatchConsumption.rdl';
    UsageCategory = Documents;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(BatchOperatorsDailyEntry; "Batch Operators Daily Entry")
        {
            RequestFilterFields = "Production Order No.", "Due Date", Furnace;

            column(CompanyName; CompanyInformation.Name)
            {
            }
            column(ReportTitle; ReportTitleText)
            {
            }
            column(Production_Order_No_; "Production Order No.")
            {
            }
            column(Due_Date; "Due Date")
            {
            }
            column(Furnace; Furnace)
            {
            }
            column(Total_Batching; TotalBatchingText)
            {
            }
            column(Total_Batch_Unit_Sum; TotalBatchUnitSum)
            {
            }
            column(Silica_Sand_Label; SilicaSandLabel)
            {
            }
            column(Total_Consumption_KG; TotalConsumptionKG)
            {
            }
            column(Summary_Moisture_Compensated; SummaryMoistureCompensated)
            {
            }

            dataitem(BatchSequence; Integer)
            {
                DataItemTableView = sorting(Number) where(Number = filter(1 .. 15));

                column(Batch_Sequence_Text; BatchSequenceText)
                {
                }
                column(Batch_Unit; TempBatchUnit)
                {
                }
                column(Product_Code; TempProductCode)
                {
                }
                column(Description; TempDescription)
                {
                }
                column(Batching_Value; TempBatchingValue)
                {
                }
                column(Total_Consumption_Per_Day_KG; TempTotalConsumption)
                {
                }
                column(Moisture_KG; TempMoistureKG)
                {
                }
                column(Yield_Percent; TempYieldPercent)
                {
                }
                column(Glass_Yield_KG; TempGlassYieldKG)
                {
                }
                column(Moist_Compense; SingleMoistCompensated)
                {

                }
                trigger OnAfterGetRecord()
                var
                    BatchOperatorsLine: Record "Batch Operators Line";
                    StartBatch: Integer;
                    EndBatch: Integer;
                    BatchingText: Text;
                    LocalBatchUnit: Decimal;
                    LocalTotalConsumption: Decimal;
                    LocalMoistureKG: Decimal;
                begin
                    // Calculate the range for this row
                    StartBatch := ((Number - 1) * 10) + 1;
                    EndBatch := Number * 10;

                    // Generate batch sequence text and batching filter text
                    BatchSequenceText := StrSubstNo('Batch %1-%2', StartBatch, EndBatch);
                    BatchingText := StrSubstNo('%1 to %2', StartBatch, EndBatch);

                    // Initialize all values as blank
                    Clear(TempBatchUnit);
                    Clear(TempProductCode);
                    Clear(TempDescription);
                    Clear(TempBatchingValue);
                    Clear(TempTotalConsumption);
                    Clear(TempMoistureKG);
                    Clear(TempYieldPercent);
                    Clear(TempGlassYieldKG);

                    // Initialize local variables
                    Clear(LocalBatchUnit);
                    Clear(LocalTotalConsumption);
                    Clear(LocalMoistureKG);
                    Clear(SingleMoistCompensated);
                    // DO NOT reset SummaryMoistureCompensated here - we want to accumulate across all batches

                    // Note: TempDescription will be set to 'SILICA SAND' only when
                    // the aggregated Batch Unit for this batch range is non-zero.
                    // This assignment is done after computing LocalBatchUnit below.

                    // Look for data that matches this exact batching text
                    BatchOperatorsLine.SetRange("Production Order No.", BatchOperatorsDailyEntry."Production Order No.");
                    BatchOperatorsLine.SetFilter(Batching, BatchingText);
                    if BatchOperatorsLine.FindSet() then begin
                        repeat
                            LocalBatchUnit += BatchOperatorsLine."Batch Unit";
                            LocalTotalConsumption += (BatchOperatorsLine."Batch Unit" * 1000);
                            LocalMoistureKG += (BatchOperatorsLine."Moisture Compensated" - 1000) * (BatchOperatorsLine."Batch Unit");
                        until BatchOperatorsLine.Next() = 0;

                        // Assign to temp variables for display
                        TempBatchUnit := LocalBatchUnit;
                        SummaryMoistureCompensated += LocalMoistureKG;  // CHANGED: Accumulate instead of assign
                        TempTotalConsumption := LocalTotalConsumption;
                        TempMoistureKG := LocalMoistureKG;
                        SingleMoistCompensated := BatchOperatorsLine."Moisture Compensated";

                        // Set description to SILICA SAND only when there is a batch unit value
                        if LocalBatchUnit <> 0 then
                            TempDescription := 'SILICA SAND';

                        // Calculate batching value for this specific batch range
                        // Formula: (Total Consumption Per Day KG + Moisture KG) / 10
                        // Where Total Consumption = Batch Unit * 1000
                        TempBatchingValue := ((LocalTotalConsumption + LocalMoistureKG) / 10);
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, 15);
                end;
            }

            dataitem(ProdOrderComponent; "Prod. Order Component")
            {
                DataItemLink = "Prod. Order No." = field("Production Order No.");
                DataItemTableView = where("Prod. Order Line No." = const(10000), "Item No." = filter(<> ''));

                column(Component_Item_No; "Item No.")
                {
                }
                column(Component_Description; Description)
                {
                }
                column(Component_Expected_Quantity; "Expected Quantity")
                {
                }
                column(Component_Total_Consumption; TotalConsumptionKG)
                {
                }
                column(Component_Moisture_Summary; SummaryMoistureCompensated)
                {
                }
                column(Component_Yield_Percent; YieldPercent)
                {
                }
                column(Component_Glass_Yield; ComponentGlassYield)
                {
                }
                column(Quantity_per; "Quantity per")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    // If description contains 'cullet' (case-insensitive) use 100% yield
                    if StrPos(UpperCase(Description), 'CULLET') > 0 then
                        YieldPercent := 100
                    else
                        YieldPercent := 82.5;

                    ComponentGlassYield := Round("Expected Quantity" * (YieldPercent / 100), 0.01);
                end;
            }

            trigger OnAfterGetRecord()
            var
                BatchOperatorsLine: Record "Batch Operators Line";
            begin
                // Initialize SummaryMoistureCompensated before processing batch sequences
                SummaryMoistureCompensated := 0;

                // Calculate totals for this daily entry
                BatchOperatorsLine.SetRange("Production Order No.", "Production Order No.");
                TotalBatchUnitSum := 0;

                if BatchOperatorsLine.FindSet() then begin
                    repeat
                        TotalBatchUnitSum += BatchOperatorsLine."Batch Unit";
                    until BatchOperatorsLine.Next() = 0;
                end;

                // Calculate the total consumption for the entire day
                // Note: SummaryMoistureCompensated will be populated by BatchSequence dataitem
                TotalConsumptionKG := (TotalBatchUnitSum + SummaryMoistureCompensated) / 10;

                SilicaSandLabel := 'SILICA SAND';
                TotalBatchingText := 'Total Batching Option';
            end;

            trigger OnPreDataItem()
            begin
                CompanyInformation.Get();
                ReportTitleText := 'Daily Batch Consumption Report';
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {

            }
        }

        trigger OnOpenPage()
        begin
            StartDate := Today();
            EndDate := Today();
        end;
    }

    trigger OnPreReport()
    begin
        if StartDate = 0D then
            StartDate := Today();
        if EndDate = 0D then
            EndDate := Today();

        BatchOperatorsDailyEntry.SetRange("Due Date", StartDate, EndDate);

        if FurnaceFilter <> '' then
            BatchOperatorsDailyEntry.SetRange(Furnace, FurnaceFilter);
    end;

    local procedure GetMaxBatchNumber(): Integer
    var
        BatchOperatorsLine: Record "Batch Operators Line";
        MaxBatch: Integer;
        CurrentBatch: Integer;
    begin
        MaxBatch := 0;
        BatchOperatorsLine.SetRange("Production Order No.", BatchOperatorsDailyEntry."Production Order No.");
        if BatchOperatorsLine.FindSet() then begin
            repeat
                CurrentBatch := BatchOperatorsLine.Batching.AsInteger();
                if CurrentBatch > MaxBatch then
                    MaxBatch := CurrentBatch;
            until BatchOperatorsLine.Next() = 0;
        end;

        // Round up to nearest 10
        exit(((MaxBatch div 10) + 1) * 10);
    end;

    var
        CompanyInformation: Record "Company Information";
        StartDate: Date;
        EndDate: Date;
        FurnaceFilter: Text;
        TotalBatchUnitSum: Decimal;
        TotalConsumptionKG: Decimal;
        SummaryMoistureCompensated: Decimal;
        BatchSequenceText: Text;
        TempBatchUnit: Decimal;
        TempProductCode: Code[20];
        TempDescription: Text[100];
        TempBatchingValue: Decimal;
        TempTotalConsumption: Decimal;
        TempMoistureKG: Decimal;
        TempYieldPercent: Decimal;
        TempGlassYieldKG: Decimal;
        ComponentYieldPercent: Decimal;
        ComponentGlassYield: Decimal;
        ReportTitleText: Text;
        TotalBatchingText: Text;
        SilicaSandLabel: Text;
        YieldPercent: Decimal;
        SingleMoistCompensated: Decimal;
}
