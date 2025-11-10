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


                    dataitem(ProductionProgrammeLine; "Production Programme Line")
                    {
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
        CurrentDate: Date;
        DayName: Text[30];
        FirstMonthStart: Date;
        LastMonthStart: Date;
        CurrentMonthStart: Date;
        CurrentMonthEnd: Date;
        TotalMonths: Integer;
        DaysInCurrentMonth: Integer;
        MonthYearText: Text[50];
}
