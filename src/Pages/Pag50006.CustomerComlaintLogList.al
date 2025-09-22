page 50006 "Customer Complaint Log List"
{
    ApplicationArea = All;
    Caption = 'Customer Complaint Log List';
    PageType = List;
    SourceTable = "Customer Complaint Log";
    UsageCategory = Lists;
    CardPageId = "Customer Complaint Log";
    DeleteAllowed = false;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("CCR No"; Rec."No.")
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
                field("Complaint Details"; Rec."Complaint Details")
                {
                    ToolTip = 'Specifies the value of the Complaint Details field.', Comment = '%';
                }
                field("Complaint Type"; Rec."Complaint Type")
                {
                    ToolTip = 'Specifies the value of the Complaint Type field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
            }
        }
    }
}
