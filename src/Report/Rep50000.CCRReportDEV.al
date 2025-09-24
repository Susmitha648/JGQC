report 50000 "CCR Report (DEV)"
{
    ApplicationArea = All;
    Caption = 'CCR Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/CCRReport.rdl';
    dataset
    {
        dataitem(CustomerComplaintReport; "Customer Complaint Report")
        {
            RequestFilterFields = "CCR Date", "No.", "Job No", Status;

            column(No_; "No.") { }
            column(CCR_Date; "CCR Date") { }
            column(Customer_No; "Customer No") { }
            column(Customer_Name; "Customer Name") { }
            column(Job_No; "Job No") { }
            column(Description; Description) { }
            column(Ring_Finish; "Ring Finish") { }
            column(Complaint_Received_Date; "Complaint Received Date") { }
            column(Complaint_Raised_by; "Complaint Raised by") { }
            column(Customer_Contact; "Customer Contact") { }
            column(Complaint_Details; "Complaint Details") { }
            column(Complaint_Type; "Complaint Type") { }
            column(Defect_Name; "Defect Name") { }
            column(Complaint_Category; "Complaint Category ") { }
            column(Complaint_Category_Remarks; "Complaint Category Remarks") { }
            column(Status; Status) { }

            dataitem(DefaultDimension; "Default Dimension")
            {
                DataItemLink = "No." = field("Job No");
                DataItemTableView = where("Table ID" = const(167));

                column(Dimension_Code; "Dimension Code") { }
                column(Dimension_Value_Code; "Dimension Value Code") { }
                column(Value_Posting; "Value Posting") { }
                column(Table_ID; "Table ID") { }
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