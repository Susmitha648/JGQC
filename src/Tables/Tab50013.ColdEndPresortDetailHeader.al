table 50013 "Cold End Presort Detail Header"
{
    Caption = 'Cold End Presort Detail Header';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Released Prod Order No."; Code[20])
        {
            Caption = 'Released Prod Order No.';
            Editable = false;
        }
        field(2; "Production Order Date"; Date)
        {
            Caption = 'Production Order Date';
            Editable = false;
        }
        field(3; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            Editable = false;
            trigger OnValidate()
             var
                QCPlanHeader: Record "QC Plan Header";
            begin
                If QCPlanHeader.Get("Job No.") then;
                Description := QCPlanHeader.Description;
                "Customer Name" := QCPlanHeader."Customer Name";
                "Finish" := QCPlanHeader.Finish;
            end;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(5; Finish; Text[80])
        {
            Caption = 'Finish';
            Editable = false;
        }
        field(6; "MC No."; Code[20])
        {
            Caption = 'MC No.';
            TableRelation = "Machine Center"."No.";
        }
        field(7; "Machine Speed"; Text[20])
        {
            Caption = 'Machine Speed';
        }
        field(8; "LEHR Time"; Time)
        {
            Caption = 'LEHR Time';
        }
         field(9; "Customer Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(10; "Weight Issue Min"; Decimal)
        {
            DataClassification = CustomerContent;
            BlankZero = True;
        }
        field(11; "Weight Issue Max"; Decimal)
        {
            DataClassification = CustomerContent;
            BlankZero = True;
        }
         field(12; "Shift 1 Leading Hand"; Text[80])
        {
            DataClassification = CustomerContent;
            trigger OnLookup()
            var
              Employee : Record Employee;
            begin
                 If Page.RunModal(5201,Employee) = Action::LookupOK then
                   "Shift 1 Leading Hand" := Employee."First Name" + ' ' + Employee."Last Name" + ' (' + Employee."No." + ')';
            end; 
        }
         field(13; "Shift 2 Leading Hand"; Text[80])
        {
            DataClassification = CustomerContent;
            trigger OnLookup()
            var
              Employee : Record Employee;
            begin
                 If Page.RunModal(5201,Employee) = Action::LookupOK then
                   "Shift 2 Leading Hand" := Employee."First Name" + ' ' + Employee."Last Name" + ' (' + Employee."No." + ')';
            end; 
        }
         field(14; "Shift 3 Leading Hand"; Text[80])
        {
            DataClassification = CustomerContent;
            trigger OnLookup()
            var
              Employee : Record Employee;
            begin
                 If Page.RunModal(5201,Employee) = Action::LookupOK then
                   "Shift 3 Leading Hand" := Employee."First Name" + ' ' + Employee."Last Name" + ' (' + Employee."No." + ')';
            end; 
        }
         field(15; "Shift 1 Foreman"; Text[80])
        {
            DataClassification = CustomerContent;
            trigger OnLookup()
            var
              Employee : Record Employee;
            begin
                 If Page.RunModal(5201,Employee) = Action::LookupOK then
                   "Shift 1 Foreman" := Employee."First Name" + ' ' + Employee."Last Name" + ' (' + Employee."No." + ')';
            end; 
        }
         field(16; "Shift 2 Foreman"; Text[80])
        {
            DataClassification = CustomerContent;
            trigger OnLookup()
            var
              Employee : Record Employee;
            begin
                 If Page.RunModal(5201,Employee) = Action::LookupOK then
                   "Shift 2 Foreman" := Employee."First Name" + ' ' + Employee."Last Name" + ' (' + Employee."No." + ')';
            end; 
        }
         field(17; "Shift 3 Foreman"; Text[80])
        {
            DataClassification = CustomerContent;
            trigger OnLookup()
            var
              Employee : Record Employee;
            begin
                 If Page.RunModal(5201,Employee) = Action::LookupOK then
                   "Shift 3 Foreman" := Employee."First Name" + ' ' + Employee."Last Name" + ' (' + Employee."No." + ')';
            end; 
        }
        field(18; "Cold End Coating"; Enum "Cold End Coating")
        {
            Caption = 'Cold End Coating';
        }
        
    }
    keys
    {
        key(PK; "Released Prod Order No.","Production Order Date")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
    ColdEndLine : Record "Cold End Presort Detail Lines";
    begin
       ColdEndLine.Reset();
       ColdEndLine.SetRange("Released Prod Order No.","Released Prod Order No.");
       ColdEndLine.SetRange("Production Order Date","Production Order Date");
       ColdEndLine.DeleteAll();
    end;
    trigger OnInsert()
    var
        ReleaseProdOrder: Record "Production Order";
        DimensionSetEntry: Record "Dimension Set Entry";
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        GeneralLedgerSetup.Get();
        If ReleaseProdOrder.Get(ReleaseProdOrder.Status::Released, Rec."Released Prod Order No.") then
            If ReleaseProdOrder."Source Type" = ReleaseProdOrder."Source Type"::Item then begin
                Rec."Production Order Date" := ReleaseProdOrder."Due Date";
                Rec.Validate("Job No.", ReleaseProdOrder."Source No.");
                 If DimensionSetEntry.Get(ReleaseProdOrder."Dimension Set ID", GeneralLedgerSetup."Shortcut Dimension 8 Code") then
                    Rec."MC No." := DimensionSetEntry."Dimension Value Code";
                    
            end;


    end;
}
