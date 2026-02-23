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
            var
                ProdProgramDate1: Record "Production Programme Line";
                ProdProgramDate2: Record "Production Programme Line";
                ProdProgramDate3: Record "Production Programme Line";
                ProdProgramDate4: Record "Production Programme Line";
                ProdProgramDate5: Record "Production Programme Line";
                ProdProgramDate6: Record "Production Programme Line";
                ProdProgramDate7: Record "Production Programme Line";
                ProdProgramDate8: Record "Production Programme Line";
                ProdProgramDate9: Record "Production Programme Line";
                OldSequenceDate: Boolean;
                SequencDate1: Integer;
                SequencDate2: Integer;
            begin
                TestStatusOpen();
                If (xRec.Date <> 0D) and (Rec.Job <> '') then
                    Error('Please delete the line and insert new line');
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
                Handled: Boolean;
                OldSequence: Boolean;
                ProdProgLine9: Record "Production Programme Line";
                ProdProgLine2: Record "Production Programme Line";
                ProdProgLine3: Record "Production Programme Line";
                ProdProgLine4: Record "Production Programme Line";
                ProdProgLine5: Record "Production Programme Line";
                ProdProgLine6: Record "Production Programme Line";
                ProdProgLine7: Record "Production Programme Line";
                ProdProgLine8: Record "Production Programme Line";
                Sequence1: Integer;
                Sequence2: Integer;
                Sequence: Integer;
                DayAfter: Date;
                LastDay: Date;
                DayAfter1: Date;
                LastDay1: Date;
            begin
                TestStatusOpen();
                If Rec."Record Slip No" > 0 then
                    Error('Recording slip generated for this job cannot change the job');
                If Job = '' then
                    Exit;
                if Rec.Job = xRec.Job then
                    exit;
                Handled := false;
                OldSequence := false;
                Sequence := 0;
                ProdProgLine2.Reset();
                ProdProgLine2.SetRange(Job, Rec.Job);
                ProdProgLine2.SetRange("No.", Rec."No.");
                ProdProgLine2.SetRange(Furnace, Rec.Furnace);
                If ProdProgLine2.Count > 0 then begin
                    ProdProgLine2.SetRange(Date, CalcDate('<-1D>', Date));
                    If ProdProgLine2.FindFirst() then begin
                        // Previous line adjustment
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
                            // Next line adjustment
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
                        ProdProgLine5.Reset();
                        ProdProgLine5.SetRange(Job, xRec.Job);
                        ProdProgLine5.SetRange(Furnace, xRec.Furnace);
                        ProdProgLine5.SetRange("No.", xRec."No.");
                        ProdProgLine5.SetRange(Date, DayAfter);
                        If ProdProgLine5.FindFirst() then begin
                            ProdProgLine5."First Line" := True;
                            ProdProgLine5.Modify();
                            ProdProgLine4.Reset();
                            ProdProgLine4.SetRange(Job, xRec.Job);
                            ProdProgLine4.SetRange(Furnace, xRec.Furnace);
                            ProdProgLine4.SetRange("No.", xRec."No.");
                            ProdProgLine4.SetRange("Sequence No", xRec."Sequence No");
                            If ProdProgLine4.FindLast() then
                                LastDay := ProdProgLine4.Date;

                            ProdProgLine9.Reset();
                            ProdProgLine9.SetRange(Job, xRec.Job);
                            ProdProgLine9.SetRange(Furnace, xRec.Furnace);
                            ProdProgLine9.SetRange("No.", xRec."No.");
                            If ProdProgLine9.FindSet() then
                                repeat
                                    If ProdProgLine9."Sequence No" > Sequence then
                                        Sequence := ProdProgLine9."Sequence No";
                                until ProdProgLine9.Next() = 0;


                            ProdProgLine6.Reset();
                            ProdProgLine6.SetRange(Job, xRec.Job);
                            ProdProgLine6.SetRange(Furnace, xRec.Furnace);
                            ProdProgLine6.SetRange("No.", xRec."No.");
                            ProdProgLine6.SetRange("Sequence No", xRec."Sequence No");
                            ProdProgLine6.SetFilter(Date, '%1..%2', DayAfter, LastDay);
                            If ProdProgLine6.FindSet() then
                                repeat
                                    ProdProgLine6."Sequence No" := Sequence + 1;
                                    ProdProgLine6.Modify();
                                until ProdProgLine6.Next() = 0;

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
                        If ProdProgLine3.Findfirst() then begin
                            ProdProgLine3."Last Line" := True;
                            ProdProgLine3.Modify();
                        end;
                        DayAfter := CalcDate('<+1D>', Date);
                        ProdProgLine5.Reset();
                        ProdProgLine5.SetRange(Job, xRec.Job);
                        ProdProgLine5.SetRange(Furnace, xRec.Furnace);
                        ProdProgLine5.SetRange("No.", xRec."No.");
                        ProdProgLine5.SetRange(Date, DayAfter);
                        If ProdProgLine5.FindFirst() then begin
                            ProdProgLine5."First Line" := True;
                            ProdProgLine5.Modify();

                            ProdProgLine4.Reset();
                            ProdProgLine4.SetRange(Job, xRec.Job);
                            ProdProgLine4.SetRange(Furnace, xRec.Furnace);
                            ProdProgLine4.SetRange("No.", xRec."No.");
                            ProdProgLine4.SetRange("Sequence No", xRec."Sequence No");
                            If ProdProgLine4.FindLast() then
                                LastDay := ProdProgLine4.Date;

                            ProdProgLine9.Reset();
                            ProdProgLine9.SetRange(Job, xRec.Job);
                            ProdProgLine9.SetRange(Furnace, xRec.Furnace);
                            ProdProgLine9.SetRange("No.", xRec."No.");
                            If ProdProgLine9.FindSet() then
                                repeat
                                    If ProdProgLine9."Sequence No" > Sequence then
                                        Sequence := ProdProgLine9."Sequence No";
                                until ProdProgLine9.Next() = 0;
                            ProdProgLine6.Reset();
                            ProdProgLine6.SetRange(Job, xRec.Job);
                            ProdProgLine6.SetRange(Furnace, xRec.Furnace);
                            ProdProgLine6.SetRange("No.", xRec."No.");
                            ProdProgLine6.SetRange("Sequence No", xRec."Sequence No");
                            ProdProgLine6.SetFilter(Date, '%1..%2', DayAfter, LastDay);
                            If ProdProgLine6.FindSet() then
                                repeat
                                    ProdProgLine6."Sequence No" := Sequence + 1;
                                    ProdProgLine6.Modify();
                                until ProdProgLine6.Next() = 0;
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
            var
                ProdProgramFurn1: Record "Production Programme Line";
                ProdProgramFurn2: Record "Production Programme Line";
                ProdProgramFurn3: Record "Production Programme Line";
                ProdProgramFurn4: Record "Production Programme Line";
                ProdProgramFurn5: Record "Production Programme Line";
                ProdProgramFurn6: Record "Production Programme Line";
                ProdProgramFurn7: Record "Production Programme Line";
                ProdProgramFurn8: Record "Production Programme Line";
                OldSequenceFur: Boolean;
                SequencFurn1: Integer;
                SequencFurn2: Integer;
            begin
                TestStatusOpen();
                If Rec."Record Slip No" > 0 then
                    Error('Recording slip generated for this job cannot change the Furnace');
                If Job <> '' then
                    Error('Cannot modify furnace');
                /* If (Rec.Furnace <> xRec.Furnace) and (xRec.Furnace <> '') and (Rec.Job <> '') then begin

                     ProdProgramFurn1.Reset();
                     ProdProgramFurn1.SetRange(Job, Rec.Job);
                     ProdProgramFurn1.SetRange("No.", Rec."No.");
                     ProdProgramFurn1.SetRange(Furnace, Rec.Furnace);
                     If ProdProgramFurn1.Count > 0 then begin
                         ProdProgramFurn1.SetRange(Date, CalcDate('<-1D>', Date));
                         If ProdProgramFurn1.FindFirst() then begin
                             Rec."Sequence No" := ProdProgramFurn1."Sequence No";
                             OldSequenceFur := True;
                             SequencFurn1 := ProdProgramFurn1."Sequence No";
                             If ProdProgramFurn1."Last Line" then begin
                                 ProdProgramFurn1."Last Line" := false;
                                 ProdProgramFurn1.Modify();
                                 Rec."Last Line" := True;
                                 Rec."First Line" := false;
                             End;

                             ProdProgramFurn2.Reset();
                             ProdProgramFurn2.SetRange(Job, Rec.Job);
                             ProdProgramFurn2.SetRange("No.", Rec."No.");
                             ProdProgramFurn2.SetRange(Furnace, Rec.Furnace);
                             ProdProgramFurn2.SetRange(Date, CalcDate('<+1D>', Date));
                             If ProdProgramFurn2.FindFirst() then begin
                                 ProdProgramFurn2."First Line" := false;
                                 Rec."Last Line" := False;
                                 DayAfter1 := ProdProgramFurn2.Date;
                                 ProdProgramFurn2.Modify();
                                 SequencFurn2 := ProdProgramFurn2."Sequence No";
                             end;
                             ProdProgramFurn3.Reset();
                             ProdProgramFurn3.SetRange(Job, Rec.Job);
                             ProdProgramFurn3.SetRange("No.", Rec."No.");
                             ProdProgramFurn3.SetRange(Furnace, Rec.Furnace);
                             ProdProgramFurn3.SetRange("Sequence No", SequencFurn2);
                             If ProdProgramFurn3.FindSet() then
                                 repeat
                                     ProdProgramFurn3."First Line" := false;
                                     ProdProgramFurn3."Sequence No" := Rec."Sequence No";
                                     ProdProgramFurn3.Modify();
                                 until ProdProgramFurn3.Next() = 0;
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
                                 OldSequenceFur := True;
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
                         If not OldSequenceFur then begin
                             ProdProgramFurn1.SetRange(Date);
                             If ProdProgramFurn1.FindLast() then begin
                                 Rec."Sequence No" := ProdProgramFurn1."Sequence No" + 1;
                                 Rec."First Line" := True;
                                 Rec."Last Line" := True;
                                 ProdProgLine3.Reset();
                                 ProdProgLine3.SetRange(Job, xRec.Job);
                                 ProdProgLine3.SetRange(Furnace, xRec.Furnace);
                                 ProdProgLine3.SetRange("No.", xRec."No.");
                                 ProdProgLine3.SetRange("Sequence No", xRec."Sequence No");
                                 ProdProgLine3.SetRange(Date, CalcDate('<-1D>', Date));
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

                                 ProdProgramFurn4.Reset();
                                 ProdProgramFurn4.SetRange(Job, xRec.Job);
                                 ProdProgramFurn4.SetRange(Furnace, xRec.Furnace);
                                 ProdProgramFurn4.SetRange("No.", xRec."No.");
                                 If ProdProgramFurn4.FindLast() then;


                                 ProdProgLine6.Reset();
                                 ProdProgLine6.SetRange(Job, xRec.Job);
                                 ProdProgLine6.SetRange(Furnace, xRec.Furnace);
                                 ProdProgLine6.SetRange("No.", xRec."No.");
                                 ProdProgLine6.SetRange("Sequence No", xRec."Sequence No");
                                 ProdProgLine6.SetFilter(Date, '%1..%2', DayAfter, LastDay);
                                 If ProdProgLine6.FindSet() then
                                     repeat
                                         ProdProgLine6."Sequence No" := ProdProgramFurn4."Sequence No" + 1;
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
                     end else begin
                         Rec."Sequence No" := 1;
                         Rec."First Line" := True;
                         Rec."Last Line" := True;
                         If xRec.Job <> '' then begin
                             ProdProgramFurn6.Reset();
                             ProdProgramFurn6.SetRange(Job, xRec.Job);
                             ProdProgramFurn6.SetRange(Furnace, xRec.Furnace);
                             ProdProgramFurn6.SetRange("No.", xRec."No.");
                             ProdProgramFurn6.SetRange("Sequence No", xRec."Sequence No");
                             ProdProgramFurn6.SetRange(Date, CalcDate('<-1D>', Date));
                             If ProdProgramFurn6.Findfirst() then begin
                                 ProdProgramFurn6."Last Line" := True;
                                 ProdProgramFurn6.Modify();
                             end;
                             DayAfter := CalcDate('<+1D>', Date);
                             ProdProgramFurn7.Reset();
                             ProdProgramFurn7.SetRange(Job, xRec.Job);
                             ProdProgramFurn7.SetRange(Furnace, xRec.Furnace);
                             ProdProgramFurn7.SetRange("No.", xRec."No.");
                             ProdProgramFurn7.SetRange("Sequence No", xRec."Sequence No");
                             If ProdProgramFurn7.FindLast() then
                                 LastDay := ProdProgramFurn7.Date;

                             ProdProgramFurn4.Reset();
                             ProdProgramFurn4.SetRange(Job, xRec.Job);
                             ProdProgramFurn4.SetRange(Furnace, xRec.Furnace);
                             ProdProgramFurn4.SetRange("No.", xRec."No.");
                             If ProdProgramFurn4.FindLast() then;

                             ProdProgramFurn8.Reset();
                             ProdProgramFurn8.SetRange(Job, xRec.Job);
                             ProdProgramFurn8.SetRange(Furnace, xRec.Furnace);
                             ProdProgramFurn8.SetRange("No.", xRec."No.");
                             ProdProgramFurn8.SetRange("Sequence No", xRec."Sequence No");
                             ProdProgramFurn8.SetFilter(Date, '%1..%2', DayAfter, LastDay);
                             If ProdProgramFurn8.FindSet() then
                                 repeat
                                     ProdProgramFurn8."Sequence No" := ProdProgramFurn4."Sequence No" + 1;
                                     ProdProgramFurn8.Modify();
                                 until ProdProgramFurn8.Next() = 0;

                             ProdProgramFurn5.Reset();
                             ProdProgramFurn5.SetRange(Job, xRec.Job);
                             ProdProgramFurn5.SetRange(Furnace, xRec.Furnace);
                             ProdProgramFurn5.SetRange("No.", xRec."No.");
                             ProdProgramFurn5.SetRange(Date, DayAfter);
                             If ProdProgramFurn5.FindFirst() then begin
                                 ProdProgramFurn5."First Line" := True;
                                 ProdProgramFurn5.Modify();
                             end;
                         end;

                     end;
                 end;*/
            end;

            trigger OnLookup()
            begin
                GeneralLegderSetup.Get();
                DimensionValue.Reset();
                DimensionValue.SetRange("Dimension Code", GeneralLegderSetup."Shortcut Dimension 8 Code");
                If DimensionValue.FindSet() then;
                if Page.RunModal(537, DimensionValue) = Action::LookupOK then
                    Validate(Furnace, DimensionValue.Code);
            end;
        }
        field(6; WT; Decimal)
        {
            Caption = 'WT';
            trigger OnValidate()
            var
                WorkShift: Record "Work Shift";
            begin
                TestStatusOpen();
                If WorkShift.FindSet() then;
                If "Bottles Per Minute" <> 0 then
                    Ton := ("Bottles Per Minute" * 8 * 60 * WorkShift.Count * WT) / 1000000;
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
            var
                WorkShift: Record "Work Shift";
            begin
                TestStatusOpen();
                If WorkShift.FindSet() then;
                If WT <> 0 then
                    Ton := ("Bottles Per Minute" * 8 * 60 * WorkShift.Count * WT) / 1000000;
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
        If Rec."Record Slip No" > 0 then
            Error('Recording slip generated for this job cannot delete the line');
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
                If ProdProg4.FindSet() then
                    repeat
                        If ProdProg4."Sequence No" > SeqBefore then
                            SeqBefore := ProdProg4."Sequence No";
                    until ProdProg4.Next() = 0;
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




}
