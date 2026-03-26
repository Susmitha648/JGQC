report 50023 "Work Order Summary"
{
    ApplicationArea = All;
    Caption = 'Work Order Summary';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/WOSummary.rdl';
    dataset
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            DataItemTableView = where ("Entry Type" = Filter(Output|Consumption),"Order Type" = Filter(Production));
            RequestFilterFields = "Posting Date","Item No.","Entry Type";
            column(EntryType; "Entry Type")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(JobNo; "Job No.")
            {
            }
            column(Quantity; ABS(Quantity))
            {
            }
            column(QuantityPieces; "Quantity Pieces")
            {
            }
            column(ItemCategoryCode; "Item Category Code")
            {
            }
            column(UnitofMeasureCode; "Unit of Measure Code")
            {
            }
            column(ShortcutDimension8Code; "Shortcut Dimension 8 Code")
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            column(LocationCode; "Location Code")
            {
            }
            column(ItemNo; "Item No.")
            {
            }
            column(ItemDescription; "Item Description")
            {
            }
            column(SourceNo; "Source No.")
            {
            }
            column(SourceType; "Source Type")
            {
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
