report 50021 "Update Dimensions"
{
    ApplicationArea = All;
    Caption = 'Update Dimensions';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    dataset
    {
        dataitem(ProductionProgrammeLine; "Production Programme Line")
        {
            trigger OnAfterGetRecord()
            begin

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
    ProductionOrder : Record  "Production Order";
}
