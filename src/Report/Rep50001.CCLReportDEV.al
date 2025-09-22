report 50001 "CCI Report (DEV)"
{
    ApplicationArea = All;
    Caption = 'CCI Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/CCIReport.rdlc';

    dataset
    {
        dataitem(CustomerComplaintLog; "Customer Complaint Log")
        {
            column(Customer_Name; "Customer Name") { }
            column(CCI_No; "No.") { }
            column(CCL_Date; "CCR Date") { }
            column(Job_No; "Job No") { }
            column(CCI_Report_Date; "CCI Report Date") { }
            column(Complaint_Category_Remarks; "Complaint Category Remarks ") { }
            column(Customer_ComplaintNo; "Customer No") { }
            column(Description; Description) { }
            column(CustomerContact; CustomerContact) { }
            column(Picture; Compinfo.Picture) { }

            dataitem(CustomerComplaintReport; "Customer Complaint Report")
            {
                DataItemLink = "No." = field("No.");
                DataItemLinkReference = CustomerComplaintLog;

                column(Ring_Finish; "Ring Finish") { }
                column(CCR_No_; "No.") { }
            }


            trigger OnAfterGetRecord()
            var
                CustomerRec: Record Customer;
            begin
                if CustomerRec.Get("Customer No") then begin
                    CustomerContact := CustomerRec.Contact;
                    CustomerExists := true;
                end else begin
                    CustomerContact := 'Customer Not Found';
                    CustomerExists := false;
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
                group(Parameters)
                {
                    // Add filter parameters here if needed
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

    trigger OnInitReport()
    begin
        Compinfo.Get();
        Compinfo.Init();
        Compinfo.CalcFields(Picture);
    end;

    var
        CompInfo: Record "Company Information";
        CustomerContact: Text[100];
        CustomerExists: Boolean;
}