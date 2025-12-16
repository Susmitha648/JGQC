report 50009 "Production Programme"
{
    ApplicationArea = All;
    Caption = 'Production Programme';
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/ProductionProgramme.rdl';
    UsageCategory = Documents;
    dataset
    {
        dataitem(ProductionProgrammeHeader; "Production Programme Header")
        {
            DataItemTableView = sorting("No.");
            column(No; "No.")
            {
            }
            column(Description; Description)
            {
            }
            column(No_of_Archived_Versions; "No of Archived Versions")
            {
            }
            column(Created_Date; "Created Date")
            {
            }
            column(Remarks; Remarks)
            {
            }
            column(Demand_Forecast_Name; "Demand Forecast Name")
            {
            }
            column(Status; Status)
            {
            }


            dataitem(MonthRange; Integer)
            {
                column(MonthYear; MonthYearText)
                {
                }


                dataitem(DateRange; Integer)
                {
                    DataItemTableView = sorting(Number) where(Number = filter(1 .. 31));


                    column(Date; CurrentDate)
                    {
                    }
                    column(Day; DayName)
                    {
                    }
                    column(IsHoliday; IsHolidayFlag)
                    {
                    }

                    dataitem(ShopCalendarHoliday; "Shop Calendar Holiday")
                    {
                        DataItemTableView = sorting(Date);

                        trigger OnPreDataItem()
                        begin
                            SetRange(Date, CurrentDate);
                        end;

                        trigger OnAfterGetRecord()
                        begin
                            IsHolidayFlag := true;
                        end;
                    }

                    dataitem(ProductionProgrammeLine; "Production Programme Line")
                    {
                        DataItemTableView = sorting("No.", Furnace, Date);
                        DataItemLinkReference = ProductionProgrammeHeader;
                        DataItemLink = "No." = field("No.");

                        column(No_; "No.")
                        {
                        }
                        column(Item_No_PPL; Job)
                        {
                            Caption = 'Item No.';
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
                        column(Ton; Ton)
                        {
                        }
                        column(Tray; Tray)
                        {
                        }
                        column(Pallet; Pallet)
                        {
                        }
                        column(Speed; Speed)
                        {
                        }
                        column(Bottles_Per_Minute; "Bottles Per Minute")
                        {

                        }
                        column(IsFirstJobRow; IsFirstJobRow)
                        {
                        }
                        column(Total_Job_Forecast; TotalJobForecast)
                        {
                        }

                        dataitem(ProdForecastEntry; "Production Forecast Entry")
                        {
                            column(Forecast_Quantity_Base; "Forecast Quantity (Base)")
                            {
                            }
                            column(Forecast_Quantity; "Forecast Quantity")
                            {
                            }
                            column(Unit_of_Measure_Code; "Unit of Measure Code")
                            {
                            }
                            column(Location_Code; "Location Code")
                            {
                            }
                            column(Variant_Code; "Variant Code")
                            {
                            }

                            trigger OnPreDataItem()
                            var
                                DemandForecastName: Code[10];
                                JobNo: Code[20];
                                ForecastDateValue: Date;
                            begin
                                // Reset the record to clear any previous filters
                                Reset();

                                // Get parent field values
                                DemandForecastName := ProductionProgrammeHeader."Demand Forecast Name";
                                JobNo := ProductionProgrammeLine.Job;
                                ForecastDateValue := ProductionProgrammeLine.Date;

                                // Filter forecast entries by Demand Forecast Name, Item No (Job), and Date
                                SetCurrentKey("Production Forecast Name", "Item No.", "Component Forecast", "Forecast Date", "Location Code", "Variant Code");
                                SetRange("Production Forecast Name", DemandForecastName);
                                SetRange("Item No.", JobNo);
                                SetRange("Forecast Date", ForecastDateValue);
                            end;
                        }

                        trigger OnAfterGetRecord()
                        var
                            PrevLine: Record "Production Programme Line";

                        begin
                            IsFirstJobRow := false;

                            // Check if there's a previous line with the same Job on an earlier date
                            PrevLine.Reset();
                            PrevLine.SetCurrentKey(Date);
                            PrevLine.SetAscending(Date, True);
                            PrevLine.SetRange("No.", ProductionProgrammeLine."No.");
                            PrevLine.SetRange(Job, ProductionProgrammeLine.Job);
                            PrevLine.SetRange(Furnace, ProductionProgrammeLine.Furnace);
                            if PrevLine.FindFirst() then
                                If (PrevLine.Date = ProductionProgrammeLine.Date) then begin
                                    IsFirstJobRow := True;
                                end;

                            If ProductionProgrammeLine."First Line" then
                                IsFirstJobRow := True;

                            if IsFirstJobRow then begin
                                If Job = '' then
                                    IsFirstJobRow := false
                                else begin
                                    PrevLine.Reset();
                                    PrevLine.SetCurrentKey(Date);
                                    PrevLine.SetAscending(Date, True);
                                    PrevLine.SetRange("No.", ProductionProgrammeLine."No.");
                                    PrevLine.SetRange(Furnace, ProductionProgrammeLine.Furnace);
                                    If PrevLine.FindFirst() then
                                        If PrevLine.Date = ProductionProgrammeLine.Date then
                                            IsFirstJobRow := false;
                                end;
                            end;

                            // Calculate total forecast for this job across all dates
                            CalculateTotalJobForecast();
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange(Date, CurrentDate);
                        end;
                    }


                    trigger OnPreDataItem()
                    begin
                        // Filter to show only valid days in the current month
                        SetRange(Number, 1, DaysInCurrentMonth);
                    end;


                    trigger OnAfterGetRecord()
                    begin
                        CurrentDate := CalcDate('<' + Format(Number - 1) + 'D>', CurrentMonthStart);
                        DayName := Format(CurrentDate, 0, '<Weekday Text>');
                        IsHolidayFlag := false;
                    end;
                }


                trigger OnPreDataItem()
                begin
                    // Calculate the number of months to iterate
                    SetRange(Number, 1, TotalMonths);
                end;


                trigger OnAfterGetRecord()
                var
                    MonthStart: Date;
                    MonthEnd: Date;
                begin
                    // Calculate the start date of the current month in the iteration
                    CurrentMonthStart := CalcDate('<' + Format(Number - 1) + 'M>', FirstMonthStart);
                    CurrentMonthEnd := CalcDate('<CM>', CurrentMonthStart);


                    // Calculate days in this month
                    DaysInCurrentMonth := Date2DMY(CurrentMonthEnd, 1);


                    // Format month/year for display (optional)
                    MonthYearText := Format(CurrentMonthStart, 0, '<Month Text> <Year4>');
                end;
            }


            trigger OnAfterGetRecord()
            var
                ProdLine: Record "Production Programme Line";
                MinDate: Date;
                MaxDate: Date;
                YearDiff: Integer;
                MonthDiff: Integer;
            begin
                // Find the min and max dates in the production lines
                ProdLine.SetRange("No.", "No.");
                if ProdLine.FindSet() then begin
                    MinDate := ProdLine.Date;
                    MaxDate := ProdLine.Date;


                    repeat
                        if ProdLine.Date < MinDate then
                            MinDate := ProdLine.Date;
                        if ProdLine.Date > MaxDate then
                            MaxDate := ProdLine.Date;
                    until ProdLine.Next() = 0;


                    // Calculate the first month's start date
                    FirstMonthStart := CalcDate('<-CM>', MinDate);
                    LastMonthStart := CalcDate('<-CM>', MaxDate);


                    // Calculate total number of months between min and max dates
                    YearDiff := Date2DMY(MaxDate, 3) - Date2DMY(MinDate, 3);
                    MonthDiff := Date2DMY(MaxDate, 2) - Date2DMY(MinDate, 2);
                    TotalMonths := (YearDiff * 12) + MonthDiff + 1;
                end else begin
                    // Fallback if no lines exist
                    FirstMonthStart := CalcDate('<-CM>', "Created Date");
                    TotalMonths := 1;
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


    var
        PrevLine1: Record "Production Programme Line";
        PrevLinetemp: Record "Production Programme Line" temporary;
        CurrentDate: Date;
        DayName: Text[30];
        IsHolidayFlag: Boolean;
        FirstMonthStart: Date;
        LastMonthStart: Date;
        CurrentMonthStart: Date;
        CurrentMonthEnd: Date;
        TotalMonths: Integer;
        DaysInCurrentMonth: Integer;
        MonthYearText: Text[50];
        IsFirstJobRow: Boolean;
        PrevJobNo: Code[20];
        TotalJobForecast: Decimal;

    local procedure CalculateTotalJobForecast()
    var
        ProdForecast: Record "Production Forecast Entry";
    begin
        TotalJobForecast := 0;

        // Exit if no job specified
        if ProductionProgrammeLine.Job = '' then
            exit;

        ProdForecast.Reset();
        ProdForecast.SetRange("Production Forecast Name", ProductionProgrammeHeader."Demand Forecast Name");
        ProdForecast.SetRange("Item No.", ProductionProgrammeLine.Job);
        ProdForecast.SetRange("Component Forecast", false);

        if ProdForecast.FindSet() then
            repeat
                TotalJobForecast += ProdForecast."Forecast Quantity (Base)";
            until ProdForecast.Next() = 0;
    end;
}