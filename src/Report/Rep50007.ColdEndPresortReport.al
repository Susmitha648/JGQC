report 50007 "Cold End Presort Report"
{
    ApplicationArea = All;
    Caption = 'Cold End Presort Report';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/Report/Layouts/ColdEndPresortReport.rdlc';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem(ColdEndPresortDetailHeader; "Cold End Presort Detail Header")
        {
            column(released_Prod_Order_No; "Released Prod Order No.")
            {
            }
            column(Production_Order_Date; "Production Order Date")
            {
            }
            column(MC_No_; "MC No.")
            {
            }
            column(Finish; Finish)
            {
            }
            column(Machine_Speed; "Machine Speed")
            {
            }
            column(Job_No_; "Job No.")
            {
            }
            column(Description; Description)
            {
            }
            column(LEHR_Time; "LEHR Time")
            {
            }
            column(Customer_Name; "Customer Name")
            {
            }

            dataitem(ColdEndPresortDetailLine; "Cold End Presort Detail Lines")
            {
                DataItemLink = "Released Prod Order No." = field("Released Prod Order No.");
                column(released_Prod_Order_No_li; "Released Prod Order No.")
                {
                }
                column(Line_No; "Line No.")
                {
                }
                column(Production_Order_Date_li; "Production Order Date")
                {
                }
                column(Time; Time)
                {
                }
                column(Section_No_; "Section No.")
                {
                }
                column(Front_Back; "Front/Back")
                {

                }
                column(Cavity_No; "Cavity No")
                {
                }
                column(QC_Defect_Code; "QC Defect Code")
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
