table 50018 "Production Programme Line"
{
    Caption = 'Production Programme Line';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = "Production Programme Header"."No.";
        }
        field(2; "Date"; Date)
        {
            Caption = 'Date';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(3; Day; Code[10])
        {
            Caption = 'Day';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(5; Job; Code[20])
        {
            Caption = 'Job';
            TableRelation = Item."No.";

            trigger OnValidate()
            var
                ProdProgLine2: Record "Production Programme Line";
            begin
                TestStatusOpen();
                If Job <> '' then
                    If Rec.Job <> xRec.Job then begin
                        ProdProgLine2.Reset();
                        ProdProgLine2.SetRange(Job, Rec.Job);
                        ProdProgLine2.SetRange("No.", Rec."No.");
                        ProdProgLine2.SetRange(Furnace, Rec.Furnace);
                        If ProdProgLine2.Count > 1 then begin
                            ProdProgLine2.SetRange(Date, CalcDate('<-1D>', Date));
                            If ProdProgLine2.FindFirst() then begin
                                Rec."Sequence No" := ProdProgLine2."Sequence No";
                                If ProdProgLine2."Last Line" then begin
                                    ProdProgLine2."Last Line" := false;
                                    ProdProgLine2.Modify();
                                    Rec."Last Line" := True;

                                    Rec."First Line" := false;
                                End;

                            end Else begin
                                ProdProgLine2.SetRange(Date, CalcDate('<+1D>', Date));
                                If ProdProgLine2.FindFirst() then begin
                                    Rec."Sequence No" := ProdProgLine2."Sequence No";
                                    If ProdProgLine2."First Line" then begin
                                        ProdProgLine2."First Line" := false;
                                        ProdProgLine2.Modify();
                                        rec."First Line" := true;
                                        Rec."Last Line" := false;
                                        Rec."Record Slip No" := ProdProgLine2."Record Slip No";
                                    end;
                                end;
                            end;
                        end else begin
                            Rec."Sequence No" := 1;
                            Rec."First Line" := True;
                            Rec."Last Line" := True;
                        end;
                    end;
            end;
        }
        field(4; Furnace; Code[20])
        {
            Caption = 'Work Center';
            TableRelation = "Dimension Value".Code;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;

            trigger OnLookup()
            begin
                GeneralLegderSetup.Get();
                DimensionValue.Reset();
                DimensionValue.SetRange("Dimension Code", GeneralLegderSetup."Shortcut Dimension 8 Code");
                If DimensionValue.FindSet() then;
                if Page.RunModal(537, DimensionValue) = Action::LookupOK then
                    Furnace := DimensionValue.Code;
            end;
        }
        field(6; WT; Decimal)
        {
            Caption = 'WT';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(7; Speed; Enum Speed)
        {
            Caption = 'Section';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(8; Ton; Decimal)
        {
            Caption = 'Ton';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(9; Tray; Text[50])
        {
            Caption = 'Tray';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(10; Pallet; Text[50])
        {
            Caption = 'Pallet';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(12; "Bottles Per Minute"; Integer)
        {
            Caption = 'Bottles Per Minute';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(13; "Production Order No."; Code[20])
        {
            Caption = 'Production Order No.';
            Editable = false;
            TableRelation = "Production Order"."No.";
        }
        field(14; "Prod Order Created"; Boolean)
        {
            Caption = 'Production Order Created';
            Editable = false;
        }
        field(15; "First Line"; Boolean)
        {
            Caption = 'First Line';
        }
        field(16; "Last Line"; Boolean)
        {
            Caption = 'Last Line';
        }
        field(17; "Record Slip No"; Integer)
        {
            Caption = 'Record Slip No';
        }
        field(18; "Sequence No"; Integer)
        {
            Caption = 'Sequence No';
        }

    }
    keys
    {
        key(PK; "No.", Date, Furnace)
        {
            Clustered = true;
        }
        key(PK2; Furnace, Job)
        {
        }
    }
    trigger OnDelete()

    begin
        TestStatusOpen();
    end;

    procedure TestStatusOpen()
    var
        ProgramingHeader: Record "Production Programme Header";
    begin
        If ProgramingHeader.Get("No.") then
            If ProgramingHeader.Status = ProgramingHeader.Status::Released then
                Error('Status must be equal to released');

    end;

    procedure CheckFurncae()
    var
        ProdProgLine: Record "Production Programme Line";
    begin
        ProdProgLine.Reset();
        ProdProgLine.SetRange(Date, Rec.Date);
        ProdProgLine.SetRange(Furnace, Rec.Furnace);
    end;

    var
        GeneralLegderSetup: Record "General Ledger Setup";
        DimensionValue: Record "Dimension Value";

    /*trigger OnModify()
    var
        ProdProgLine2: Record "Production Programme Line";
    begin
        If Rec.Job <> xRec.Job then begin
            Message('Test');
            ProdProgLine2.Reset();
            ProdProgLine2.SetAscending(Date, True);
            ProdProgLine2.SetRange(Job, Rec.Job);
            ProdProgLine2.SetRange(Furnace, Rec.Furnace);
            If ProdProgLine2.Count > 1 then begin
                ProdProgLine2.SetRange(Date, CalcDate('<-1D>', Date));
                If ProdProgLine2.FindFirst() then begin
                    Rec."Sequence No" := ProdProgLine2."Sequence No";
                    If ProdProgLine2."Last Line" then begin
                        ProdProgLine2."Last Line" := false;
                        ProdProgLine2.Modify();
                    End;
                    Rec."Last Line" := True;
                end Else begin
                    ProdProgLine2.SetRange(Date, CalcDate('<+1D>', Date));
                    If ProdProgLine2.FindFirst() then begin
                        Rec."Sequence No" := ProdProgLine2."Sequence No";
                        If ProdProgLine2."First Line" then begin
                            ProdProgLine2."First Line" := false;
                            ProdProgLine2.Modify();
                            rec."First Line" := true;
                        end;
                    end;
                end;
            end else begin
                Rec."Sequence No" := 1;
                Rec."First Line" := True;
                Rec."Last Line" := True;
            end;
        end;
    end;

     trigger OnInsert()
     var
         ProdProgLine1: Record "Production Programme Line";
     begin


         ProdProgLine1.Reset();
         ProdProgLine1.SetAscending(Date,True);
         ProdProgLine1.SetRange(Job, Rec.Job);
         ProdProgLine1.SetRange(Furnace, Rec.Furnace);
         If ProdProgLine1.Count > 1 then begin
             ProdProgLine1.SetRange(Date, CalcDate('<-1D>', Date));
             If ProdProgLine1.FindFirst() then begin
                 Rec."Sequence No" := ProdProgLine1."Sequence No";
                 If ProdProgLine1."Last Line" then begin
                     ProdProgLine1."Last Line" := false;
                     ProdProgLine1.Modify();
                 End;
                 Rec."Last Line" := True;
             end Else begin
                 ProdProgLine1.SetRange(Date, CalcDate('<+1D>', Date));
                 If ProdProgLine1.FindFirst() then begin
                     Rec."Sequence No" := ProdProgLine1."Sequence No";
                     If ProdProgLine1."First Line" then begin
                         ProdProgLine1."First Line" := false;
                         ProdProgLine1.Modify();
                         rec."First Line" := true;
                     end;
                 end;
             end;
         end else begin
             Rec."Sequence No" := 1;
             Rec."First Line" := True;
             Rec."Last Line" := True;
         end;

     end;*/


    /*trigger OnInsert()
    var
        ProdProgLine2: Record "Production Programme Line";
    begin
        ProdProgLine2.Reset();
        ProdProgLine2.SetRange(Job, Rec.Job);
        ProdProgLine2.SetRange(Furnace,Rec.Furnace);
        If ProdProgLine2.Count > 1 then begin
            ProdProgLine2.SetRange(Date, CalcDate('<-1D>', Date));
            If ProdProgLine2.FindFirst() then begin
                Rec."Sequence No" := ProdProgLine2."Sequence No";
                If ProdProgLine2."Last Line" then
                    ProdProgLine2."Last Line" := false;
                    Rec."Last Line" := True;
            end Else begin
                ProdProgLine2.SetRange(Date, CalcDate('<+1D>', Date));
                If ProdProgLine2.FindLast() then begin
                    Rec."Sequence No" := ProdProgLine2."Sequence No" + 1;
                    Rec."First Line" := True;
                    Rec."Last Line" := True;
                end;
            end;
        end else begin
            Rec."Sequence No" := 1;
            Rec."First Line" := True;
            Rec."Last Line" := True;
        end;
    end;*/
}
