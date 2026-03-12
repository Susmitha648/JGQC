tableextension 50005 "Released PH Ext" extends "Production Order"
{
    DataCaptionFields = "No.", "Source No.", Description;
    fields
    {
        field(50000; "Production Programme"; Code[20])
        {
            Caption = 'Production Programme';
            DataClassification = CustomerContent;
            TableRelation = "Production Programme Header"."No.";
            Editable = false;
        }
        modify("Source No.")
        {
            trigger OnBeforeValidate()
            var
                ProdOrder: Record "Production Order";

            begin
                /*If ("Source No." <> '') and (Rec."Source No." <> xRec."Source No.") then begin
                    ProdOrder.Reset();
                    ProdOrder.SetRange("Due Date", "Due Date");
                    ProdOrder.SetRange("Source No.", "Source No.");
                    ProdOrder.SetRange("Gen. Prod. Posting Group", 'FG');
                    If ProdOrder.FindFirst() then
                        Error('Workorder already exists for the Job %1', "Source No.");
                end;*/
            end;
        }
        modify("Due Date")
        {
            trigger OnBeforeValidate()
            var
                ProdOrderDue: Record "Production Order";

            begin
               /* If ("Source No." <> '') and (Rec."Source No." <> xRec."Source No.") then begin
                    ProdOrderDue.Reset();
                    ProdOrderDue.SetRange("Due Date", "Due Date");
                    ProdOrderDue.SetRange("Source No.", "Source No.");
                    ProdOrderDue.SetRange("Gen. Prod. Posting Group", 'FG');
                    If ProdOrderDue.FindFirst() then
                        Error('Workorder already exists for the Job %1', "Source No.");
                end;*/
            end;
        }
    }
}
