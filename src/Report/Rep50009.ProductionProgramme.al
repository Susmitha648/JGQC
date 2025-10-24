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

            dataitem(ProductionProgrammeLine; "Production Programme Line")
            {
                DataItemLink = "No." = field("No.");
                column(No_; "No.")
                {
                }
                column(Date; Date)
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
            }

            dataitem("Production Forecast Entry"; "Production Forecast Entry")
            {
                DataItemLink = "Production Forecast Name" = field("Demand Forecast Name");
                column(Production_Forecast_Name; "Production Forecast Name")
                {
                }
                column(Entry_No_; "Entry No.")
                {
                }
                column(Item_No_; "Item No.")
                {
                }
                column(Forecast_Date; "Forecast Date")
                {
                }
                column(Forecast_Quantity; "Forecast Quantity")
                {
                }
                column(Forecast_Quantity__Base_; "Forecast Quantity (Base)")
                {
                }
                column(Unit_of_Measure_Code; "Unit of Measure Code")
                {
                }
                column(Qty__per_Unit_of_Measure; "Qty. per Unit of Measure")
                {
                }
                column(Location_Code; "Location Code")
                {
                }
                column(Variant_Code; "Variant Code")
                {
                }
                column(Component_Forecast; "Component Forecast")
                {
                }

                dataitem("Sales Line"; "Sales Line")
                {
                    DataItemLink = "Quantity" = field("Forecast Quantity");
                    column(Document_No_; "Document No.")
                    {
                    }
                    column(Line_No_; "Line No.")
                    {

                    }
                    column(Quantity; Quantity)
                    {
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
