page 50008 "Customer Complaint Report List"
{
    ApplicationArea = All;
    Caption = 'Customer Complaint Report List';
    PageType = List;
    SourceTable = "Customer Complaint Report";
    UsageCategory = Lists;
    DeleteAllowed = false;
    Editable = false;
    CardPageId = "Customer Complaint Report";
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the CCR No field.', Comment = '%';
                }
                field("CCR Date"; Rec."CCR Date")
                {
                    ToolTip = 'Specifies the value of the CCR Date field.', Comment = '%';
                }
                field("Customer No"; Rec."Customer No")
                {
                    ToolTip = 'Specifies the value of the Customer No field.', Comment = '%';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field.', Comment = '%';
                }
                field("Job No"; Rec."Job No")
                {
                    ToolTip = 'Specifies the value of the Job No field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Ring Finish"; Rec."Ring Finish")
                {
                    ToolTip = 'Specifies the value of the Ring Finish field.', Comment = '%';
                }
                field("Complaint Received Date"; Rec."Complaint Received Date")
                {
                    ToolTip = 'Specifies the value of the Complaint Received Date field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
            }
        }
    }
}
