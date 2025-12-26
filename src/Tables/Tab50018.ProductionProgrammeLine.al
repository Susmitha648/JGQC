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
                ProdProgLine3: Record "Production Programme Line";
                ProdProgLine4: Record "Production Programme Line";
                ProdProgLine5: Record "Production Programme Line";
                ProdProgLine6: Record "Production Programme Line";
                ProdProgLine7: Record "Production Programme Line";
                ProdProgLine8: Record "Production Programme Line";
                DayAfter: Date;
                LastDay: Date;
                DayAfter1: Date;
                LastDay1: Date;
                Sequence1: Integer;
                Sequence2: Integer;
                Handled: Boolean;
                OldSequence: Boolean;
                Sequence: Integer;
            begin
                TestStatusOpen();
                If Job <> '' then
                    If (Rec.Job <> xRec.Job) then begin
                        ProdProgLine2.Reset();
                        ProdProgLine2.SetRange(Job, Rec.Job);
                        ProdProgLine2.SetRange("No.", Rec."No.");
                        ProdProgLine2.SetRange(Furnace, Rec.Furnace);
                        If ProdProgLine2.Count > 0 then begin
                            ProdProgLine2.SetRange(Date, CalcDate('<-1D>', Date));
                            If ProdProgLine2.FindFirst() then begin
                                Rec."Sequence No" := ProdProgLine2."Sequence No";
                                OldSequence := True;
                                Sequence1 := ProdProgLine2."Sequence No";
                                If ProdProgLine2."Last Line" then begin
                                    ProdProgLine2."Last Line" := false;
                                    ProdProgLine2.Modify();
                                    Rec."Last Line" := True;
                                    Rec."First Line" := false;
                                End;

                                ProdProgLine7.Reset();
                                ProdProgLine7.SetRange(Job, Rec.Job);
                                ProdProgLine7.SetRange("No.", Rec."No.");
                                ProdProgLine7.SetRange(Furnace, Rec.Furnace);
                                ProdProgLine7.SetRange(Date, CalcDate('<+1D>', Date));
                                If ProdProgLine7.FindFirst() then begin
                                    ProdProgLine7."First Line" := false;
                                    Rec."Last Line" := False;
                                    DayAfter1 := ProdProgLine7.Date;
                                    ProdProgLine7.Modify();
                                    Sequence2 := ProdProgLine7."Sequence No";
                                end;
                                ProdProgLine8.Reset();
                                ProdProgLine8.SetRange(Job, Rec.Job);
                                ProdProgLine8.SetRange("No.", Rec."No.");
                                ProdProgLine8.SetRange(Furnace, Rec.Furnace);
                                ProdProgLine8.SetRange("Sequence No", Sequence2);
                                If ProdProgLine8.FindSet() then
                                    repeat
                                        ProdProgLine8."First Line" := false;
                                        ProdProgLine8."Sequence No" := Rec."Sequence No";
                                        ProdProgLine8.Modify();
                                    until ProdProgLine8.Next() = 0;
                                Handled := True;
                            end;
                            If not Handled then begin
                                ProdProgLine7.Reset();
                                ProdProgLine7.SetRange(Job, Rec.Job);
                                ProdProgLine7.SetRange("No.", Rec."No.");
                                ProdProgLine7.SetRange(Furnace, Rec.Furnace);
                                ProdProgLine7.SetRange(Date, CalcDate('<+1D>', Date));
                                If ProdProgLine7.FindFirst() then begin
                                    ProdProgLine7."First Line" := false;
                                    Rec."Last Line" := False;
                                    Rec."First Line" := True;
                                    Rec."Sequence No" := ProdProgLine7."Sequence No";
                                    Sequence1 := ProdProgLine7."Sequence No";
                                    DayAfter1 := ProdProgLine7.Date;
                                    ProdProgLine7.Modify();
                                    OldSequence := True;
                                end;
                                ProdProgLine8.Reset();
                                ProdProgLine8.SetRange(Job, Rec.Job);
                                ProdProgLine8.SetRange("No.", Rec."No.");
                                ProdProgLine8.SetRange(Furnace, Rec.Furnace);
                                ProdProgLine8.SetRange("Sequence No", Sequence1);
                                If ProdProgLine8.FindSet() then
                                    repeat
                                        ProdProgLine8."First Line" := false;
                                        ProdProgLine8."Sequence No" := Rec."Sequence No";
                                        ProdProgLine8.Modify();
                                    until ProdProgLine8.Next() = 0;
                            end;
                            If not OldSequence then begin
                                ProdProgLine2.SetRange(Date);
                                If ProdProgLine2.FindLast() then begin
                                    Rec."Sequence No" := ProdProgLine2."Sequence No" + 1;
                                    Rec."First Line" := True;
                                    Rec."Last Line" := True;
                                end;
                            end;
                            If xRec.Job <> '' then begin
                                ProdProgLine3.Reset();
                                ProdProgLine3.SetRange(Job, xRec.Job);
                                ProdProgLine3.SetRange(Furnace, xRec.Furnace);
                                ProdProgLine3.SetRange("No.", xRec."No.");
                                ProdProgLine3.SetRange("Sequence No", xRec."Sequence No");
                                ProdProgLine3.SetRange(Date, CalcDate('<-1D>', xRec.Date));
                                If ProdProgLine3.Findfirst() then begin
                                    ProdProgLine3."Last Line" := True;
                                    ProdProgLine3.Modify();
                                end;
                                DayAfter := CalcDate('<+1D>', Date);
                                ProdProgLine4.Reset();
                                ProdProgLine4.SetRange(Job, xRec.Job);
                                ProdProgLine4.SetRange(Furnace, xRec.Furnace);
                                ProdProgLine4.SetRange("No.", xRec."No.");
                                ProdProgLine4.SetRange("Sequence No", xRec."Sequence No");
                                If ProdProgLine4.FindLast() then
                                    LastDay := ProdProgLine4.Date;

                                ProdProgLine6.Reset();
                                ProdProgLine6.SetRange(Job, xRec.Job);
                                ProdProgLine6.SetRange(Furnace, xRec.Furnace);
                                ProdProgLine6.SetRange("No.", xRec."No.");
                                ProdProgLine6.SetRange("Sequence No", xRec."Sequence No");
                                ProdProgLine6.SetFilter(Date, '%1..%2', DayAfter, LastDay);
                                If ProdProgLine6.FindSet() then
                                    repeat
                                        ProdProgLine6."Sequence No" := ProdProgLine6."Sequence No" + 1;
                                        Sequence := ProdProgLine6."Sequence No" + 1;
                                        ProdProgLine6.Modify();
                                    until ProdProgLine6.Next() = 0;
                                ProdProgLine5.Reset();
                                ProdProgLine5.SetRange(Job, xRec.Job);
                                ProdProgLine5.SetRange(Furnace, xRec.Furnace);
                                ProdProgLine5.SetRange("No.", xRec."No.");
                                ProdProgLine5.SetRange(Date, DayAfter);
                                If ProdProgLine5.FindFirst() then begin
                                    ProdProgLine5."First Line" := True;
                                    ProdProgLine5.Modify();
                                end;
                            end;
                        end else begin
                            Rec."Sequence No" := 1;
                            Rec."First Line" := True;
                            Rec."Last Line" := True;
                            If xRec.Job <> '' then begin
                                ProdProgLine3.Reset();
                                ProdProgLine3.SetRange(Job, xRec.Job);
                                ProdProgLine3.SetRange(Furnace, xRec.Furnace);
                                ProdProgLine3.SetRange("No.", xRec."No.");
                                ProdProgLine3.SetRange("Sequence No", xRec."Sequence No");
                                ProdProgLine3.SetRange(Date, CalcDate('<-1D>', Date));
                                If ProdProgLine3.Findfirst() then
                                    If not (Rec.Job = ProdProgLine3.Job) and (Rec.Furnace = ProdProgLine3.Furnace) then begin
                                        ProdProgLine3."Last Line" := True;
                                        ProdProgLine3.Modify();
                                    end else
                                        Rec."Sequence No" := ProdProgLine3."Sequence No";
                                DayAfter := CalcDate('<+1D>', Date);
                                ProdProgLine4.Reset();
                                ProdProgLine4.SetRange(Job, xRec.Job);
                                ProdProgLine4.SetRange(Furnace, xRec.Furnace);
                                ProdProgLine4.SetRange("No.", xRec."No.");
                                ProdProgLine4.SetRange("Sequence No", xRec."Sequence No");
                                If ProdProgLine4.FindLast() then
                                    LastDay := ProdProgLine4.Date;

                                ProdProgLine6.Reset();
                                ProdProgLine6.SetRange(Job, xRec.Job);
                                ProdProgLine6.SetRange(Furnace, xRec.Furnace);
                                ProdProgLine6.SetRange("No.", xRec."No.");
                                ProdProgLine6.SetRange("Sequence No", xRec."Sequence No");
                                ProdProgLine6.SetFilter(Date, '%1..%2', DayAfter, LastDay);
                                If ProdProgLine6.FindSet() then
                                    repeat
                                        ProdProgLine6."Sequence No" := ProdProgLine6."Sequence No" + 1;
                                        Sequence := ProdProgLine6."Sequence No" + 1;
                                        ProdProgLine6.Modify();
                                    until ProdProgLine6.Next() = 0;
                                ProdProgLine5.Reset();
                                ProdProgLine5.SetRange(Job, xRec.Job);
                                ProdProgLine5.SetRange(Furnace, xRec.Furnace);
                                ProdProgLine5.SetRange("No.", xRec."No.");
                                ProdProgLine5.SetRange(Date, DayAfter);
                                If ProdProgLine5.FindFirst() then begin
                                    ProdProgLine5."First Line" := True;
                                    ProdProgLine5.Modify();
                                end;
                            end;
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
        field(19; "Line No"; Integer)
        {
            Caption = 'Line No';
        }
        field(20; "Work Shift"; Code[10])
        {
            Caption = 'Work Shift';
        }
        field(21; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
        }
        field(22; "Ton Per Line"; Decimal)
        {
            Caption = 'Ton Per Line';
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
    var
        ProdProg1: Record "Production Programme Line";
        ProdProg2: Record "Production Programme Line";
        ProdProg3: Record "Production Programme Line";
        ProdProg4: Record "Production Programme Line";
        ProdProg5: Record "Production Programme Line";
        SeqBefore: Integer;
        SeqAfter: Integer;
        LastDate: Date;
        FirstDate: Date;
    begin
        TestStatusOpen();
        ProdProg1.Reset();
        ProdProg1.SetRange(Job, Rec.Job);
        ProdProg1.SetRange("No.", Rec."No.");
        ProdProg1.SetRange(Furnace, Rec.Furnace);
        If ProdProg1.Count > 0 then begin
            ProdProg1.SetRange(Date, CalcDate('<-1D>', Date));
            If ProdProg1.FindFirst() then begin
                ProdProg1."Last Line" := True;
                ProdProg1.Modify();
            end;
            ProdProg2.Reset();
            ProdProg2.SetRange(Job, Rec.Job);
            ProdProg2.SetRange("No.", Rec."No.");
            ProdProg2.SetRange(Furnace, Rec.Furnace);
            ProdProg2.SetRange(Date, CalcDate('<+1D>', Date));
            If ProdProg2.FindFirst() then begin
                ProdProg2."First Line" := True;
                FirstDate := ProdProg2.Date;
                ProdProg2.Modify();
                ProdProg3.Reset();
                ProdProg3.SetRange(Job, Rec.Job);
                ProdProg3.SetRange("No.", Rec."No.");
                ProdProg3.SetRange(Furnace, Rec.Furnace);
                ProdProg3.SetRange("Sequence No", Rec."Sequence No");
                ProdProg3.SetRange("Last Line", True);
                If ProdProg3.FindLast() then
                    LastDate := ProdProg3.Date;
                ProdProg4.Reset();
                ProdProg4.SetRange(Job, Rec.Job);
                ProdProg4.SetRange("No.", Rec."No.");
                ProdProg4.SetRange(Furnace, Rec.Furnace);
                If ProdProg4.FindLast() then
                    SeqBefore := ProdProg4."Sequence No";
                ProdProg5.Reset();
                ProdProg5.SetRange(Job, Rec.Job);
                ProdProg5.SetRange("No.", Rec."No.");
                ProdProg5.SetRange(Furnace, Rec.Furnace);
                ProdProg5.SetRange("Sequence No", Rec."Sequence No");
                ProdProg5.SetFilter(Date, '%1..%2', FirstDate, LastDate);
                If ProdProg5.FindSet() then
                    repeat
                        ProdProg5."Sequence No" := SeqBefore + 1;
                        ProdProg5.Modify();
                    until ProdProg5.Next() = 0;
            end;

        End;

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
