report 50008 "Generate Production Programme"
{
    ApplicationArea = All;
    Caption = 'Generate Production Programme';
    ProcessingOnly = True;
    dataset
    {
        dataitem(ProductionProgrammeHeader; "Production Programme Header")
        {
            trigger OnAfterGetRecord()
            var
                ProductionProgramLine: Record "Production Programme Line";
                ProductionProgramLine1: Record "Production Programme Line";
                ProductionProgramLine2: Record "Production Programme Line";
                ProductionProgramLine3: Record "Production Programme Line";
                ProductionProgramLine4: Record "Production Programme Line";
                ProductionProgramLine5: Record "Production Programme Line";
                ProductionProgramLine6: Record "Production Programme Line";
                ProductionProgramLine7: Record "Production Programme Line";
                ProductionProgramLine8: Record "Production Programme Line";
                ProductionProgramLine9: Record "Production Programme Line";
                ProductionProgramLine10: Record "Production Programme Line";
                ProductionProgramLine11: Record "Production Programme Line";
                ProductionProgramLineSequence: Record "Production Programme Line";
                LastDate: Date;
                Item: Record Item;
                FirstLineDate: Date;
                WorkShift: Record "Work Shift";
                Sequence: Integer;
                OldSequence: Integer;
                SameSequence: Boolean;
                PreviousJobNo: Code[20];
                Previousjobnotfound: Boolean;
                FirstLinePreviousJob: Boolean;
                SameJobFound: Boolean;
                LastSeq: Integer;
            begin
                If Item.Get(JobNo) then;
                If WorkShift.FindSet() then;
                FirstLineDate := FromDate;
                ProductionProgramLine9.Reset();
                ProductionProgramLine9.SetRange("No.", "No.");
                ProductionProgramLine9.SetRange(Furnace, Furnace);
               // ProductionProgramLine9.SetRange(Job, JobNo);
                ProductionProgramLine9.SetRange("Prod Order Created", true);
                ProductionProgramLine9.SetRange(Date, FirstLineDate, ToDate);
                If ProductionProgramLine9.Findfirst() then
                    Error('Production Order created for Furnace %1, Date %2', ProductionProgramLine9.Furnace, ProductionProgramLine9.Date);
                FirstLinePreviousJob := false;
                LastSeq := 0;
                While FromDate <= ToDate do begin
                    PreviousJobNo := '';
                    Previousjobnotfound := false;
                    ProductionProgramLine.Reset();
                    ProductionProgramLine.SetRange("No.", "No.");
                    ProductionProgramLine.SetRange(Date, FromDate);
                    ProductionProgramLine.SetRange(Furnace, Furnace);
                    If not ProductionProgramLine.FindFirst() then begin
                        ProductionProgramLine.Init();
                        ProductionProgramLine."No." := "No.";
                        ProductionProgramLine.Date := FromDate;
                        ProductionProgramLine.Furnace := Furnace;
                        ProductionProgramLine.Insert();
                        Previousjobnotfound := True;
                    End;

                    If not Previousjobnotfound then
                        PreviousJobNo := ProductionProgramLine.Job;
                    If not ProductionProgramLine."Prod Order Created" then begin
                        ProductionProgramLine.Speed := Speed;
                        ProductionProgramLine.Pallet := Pallet;
                        ProductionProgramLine.Tray := Tray;
                        ProductionProgramLine."Bottles Per Minute" := BottlesPerMinute;
                        If WT = 0 then
                            ProductionProgramLine.WT := Item."Net Weight"
                        else
                            ProductionProgramLine.WT := WT;
                        ProductionProgramLine.Job := JobNo;
                        ProductionProgramLine.Day := Format(FromDate, 0, '<Weekday Text>');
                        ProductionProgramLine.Ton := (BottlesPerMinute * 8 * 60 * WorkShift.Count * ProductionProgramLine.WT) / 1000000;
                        ProductionProgramLine1.Reset();
                        ProductionProgramLine1.SetRange("No.", "No.");
                        ProductionProgramLine1.SetRange(Job, JobNo);
                        ProductionProgramLine1.SetRange(Furnace, Furnace);
                        If ProductionProgramLine1.Count > 0 then begin
                            ProductionProgramLine1.SetRange(Date, CalcDate('<-1D>', ProductionProgramLine.Date));
                            If ProductionProgramLine1.FindFirst() then begin
                                SameJobFound := false;
                                ProductionProgramLine1."Last Line" := false;
                                ProductionProgramLine."First Line" := false;
                                ProductionProgramLine1.Modify();
                                SameJobFound := True;
                                ProductionProgramLine."Sequence No" := ProductionProgramLine1."Sequence No";
                                If (ProductionProgramLine.Date = ToDate) and (PreviousJobNo <> JobNo) then begin
                                    If PreviousJobNo <> JobNo then
                                    ProductionProgramLine."Last Line" := True;
                                   /* If FirstLineDate <> ToDate then
                                        ProductionProgramLine."First Line" := false
                                    else
                                        ProductionProgramLine."First Line" := true;*/
                                end;
                                ProductionProgramLine3.Reset();
                                ProductionProgramLine3.SetRange("No.", "No.");
                                ProductionProgramLine3.SetRange(Job, JobNo);
                                ProductionProgramLine3.SetRange(Furnace, Furnace);
                                ProductionProgramLine3.SetRange(Date, CalcDate('<+1D>', ProductionProgramLine.Date));
                                If ProductionProgramLine3.FindFirst() then begin
                                    ProductionProgramLine."Last Line" := False;
                                    If SameJobFound then
                                      ProductionProgramLine."First Line" := false;
                                    
                                    ProductionProgramLine3."First Line" := false;
                                    ProductionProgramLine3.Modify();
                                    //SameJobFound := True;
                                    ProductionProgramLine4.Reset();
                                    ProductionProgramLine4.SetRange("No.", "No.");
                                    ProductionProgramLine4.SetRange(Job, JobNo);
                                    ProductionProgramLine4.SetRange(Furnace, Furnace);
                                    ProductionProgramLine4.SetRange("Sequence No", ProductionProgramLine3."Sequence No");
                                    If ProductionProgramLine4.FindSet() then
                                        repeat
                                            ProductionProgramLine4."Sequence No" := ProductionProgramLine."Sequence No";
                                            ProductionProgramLine4.Modify();
                                        until ProductionProgramLine4.Next() = 0;
                                end;
                            end else begin
                                ProductionProgramLine2.Reset();
                                ProductionProgramLine2.SetRange("No.", "No.");
                                ProductionProgramLine2.SetRange(Job, JobNo);
                                ProductionProgramLine2.SetRange(Furnace, Furnace);
                                ProductionProgramLine2.SetRange(Date, CalcDate('<+1D>', ToDate));
                                If ProductionProgramLine2.FindFirst() then begin
                                    If ProductionProgramLine2."First Line" then begin
                                        ProductionProgramLine2."First Line" := false;
                                        ProductionProgramLine2.Modify();
                                    end;
                                    ProductionProgramLine."Sequence No" := ProductionProgramLine2."Sequence No";
                                    if ProductionProgramLine.Date = FirstLineDate then
                                        ProductionProgramLine."First Line" := True;
                                end else begin
                                    ProductionProgramLine1.SetRange(Date);
                                    If ProductionProgramLine1.FindSet() then
                                        repeat
                                            If ProductionProgramLine1."Sequence No" > LastSeq then
                                                LastSeq := ProductionProgramLine1."Sequence No";
                                        until ProductionProgramLine1.Next() = 0;

                                    If ProductionProgramLine.Date = FirstLineDate then
                                        ProductionProgramLine."First Line" := True;
                                    If ProductionProgramLine.Date = ToDate then begin
                                        ProductionProgramLine."Last Line" := True;
                                    end;
                                    ProductionProgramLine."Sequence No" := LastSeq + 1;

                                end;
                            end;


                        end else begin
                            If ProductionProgramLine.Date = FirstLineDate then
                                ProductionProgramLine."First Line" := True;
                            If ProductionProgramLine.Date = ToDate then
                                ProductionProgramLine."Last Line" := True;
                            ProductionProgramLine."Sequence No" := 1;
                        end;

                        ProductionProgramLine.Modify(false);

                        If (PreviousJobNo <> '') then begin

                            If ProductionProgramLine.Date = FirstLineDate then begin
                                ProductionProgramLine5.Reset();
                                ProductionProgramLine5.SetRange("No.", "No.");
                                ProductionProgramLine5.SetRange(Furnace, Furnace);
                                ProductionProgramLine5.SetRange(Job, PreviousJobNo);
                                ProductionProgramLine5.SetRange(Date, CalcDate('<-1D>', FirstLineDate));
                                If ProductionProgramLine5.FindFirst() then begin
                                    If PreviousJobNo <> JobNo then begin
                                        ProductionProgramLine5."Last Line" := true;
                                        ProductionProgramLine5.Modify();
                                        FirstLinePreviousJob := true;
                                    end;
                                end;
                            end;
                            If ProductionProgramLine.Date = ToDate then begin
                                ProductionProgramLine6.Reset();
                                ProductionProgramLine6.SetRange("No.", "No.");
                                ProductionProgramLine6.SetRange(Furnace, Furnace);
                                ProductionProgramLine6.SetRange(Job, PreviousJobNo);
                                ProductionProgramLine6.SetRange(Date, CalcDate('<+1D>', ToDate));
                                If ProductionProgramLine6.FindFirst() then begin
                                    If PreviousJobNo <> JobNo then begin
                                        ProductionProgramLine6."First Line" := true;
                                        ProductionProgramLine6.Modify();

                                        If FirstLinePreviousJob then begin
                                            ProductionProgramLine11.Reset();
                                            ProductionProgramLine11.SetRange("No.", "No.");
                                            ProductionProgramLine11.SetRange(Furnace, Furnace);
                                            ProductionProgramLine11.SetRange(Job, PreviousJobNo);
                                            If ProductionProgramLine11.FindLast() then;
                                            ProductionProgramLine10.Reset();
                                            ProductionProgramLine10.SetRange("No.", "No.");
                                            ProductionProgramLine10.SetRange(Furnace, Furnace);
                                            ProductionProgramLine10.SetRange(Job, PreviousJobNo);
                                            ProductionProgramLine10.SetRange("Sequence No", ProductionProgramLine6."Sequence No");
                                            ProductionProgramLine10.SetFilter(Date, '>=%1', CalcDate('<+1D>', ToDate));
                                            If ProductionProgramLine10.FindSet() then
                                                repeat
                                                    ProductionProgramLine10."Sequence No" := ProductionProgramLine11."Sequence No" + 1;
                                                    ProductionProgramLine10.Modify();
                                                until ProductionProgramLine10.Next() = 0;
                                        end;
                                    end;
                                end;
                            end;


                        end;
                    end;
                    FromDate := FromDate + 1;

                end;


                ProductionProgramLine8.Reset();
                ProductionProgramLine8.SetRange("No.", "No.");
                ProductionProgramLine8.SetRange(Furnace, Furnace);
                ProductionProgramLine8.SetRange(Job, JobNo);
                ProductionProgramLine8.SetRange("Prod Order Created", false);
                ProductionProgramLine8.SetRange(Date, CalcDate('<+1D>', FirstLineDate), CalcDate('<-1D>', ToDate));
                If ProductionProgramLine8.FindSet() then
                    repeat
                        ProductionProgramLine8."First Line" := false;
                        ProductionProgramLine8."Last Line" := false;
                        ProductionProgramLine8.Modify();
                    until ProductionProgramLine8.Next() = 0;

            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(FromDate; FromDate)
                    {
                        ApplicationArea = All;
                        Caption = 'From Date';
                        ToolTip = 'Specifies From Date.';
                    }
                    field(ToDate; ToDate)
                    {
                        ApplicationArea = All;
                        Caption = 'To Date';
                        ToolTip = 'Specifies To Date.';
                    }
                    field(Furnace; Furnace)
                    {
                        ApplicationArea = All;
                        Caption = 'Work Center';
                        ToolTip = 'Specifies Work Center.';
                        trigger OnDrillDown()

                        begin
                            GeneralLegderSetup.Get();
                            DimensionValue.Reset();
                            DimensionValue.SetRange("Dimension Code", GeneralLegderSetup."Shortcut Dimension 8 Code");
                            If DimensionValue.FindSet() then;
                            if Page.RunModal(537, DimensionValue) = Action::LookupOK then begin
                                Furnace := DimensionValue.Code;

                            end;
                        end;
                    }
                    field(JobNo; JobNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Job No.';
                        ToolTip = 'Specifies To Date.';
                        TableRelation = Item."No.";
                        trigger OnValidate()
                        var
                            ItemNo: Record Item;
                        begin
                            If ItemNo.Get(JobNo) then
                                WT := ItemNo."Net Weight";
                        end;
                    }
                    field(WT; WT)
                    {
                        ApplicationArea = All;
                        Caption = 'Weight';
                        ToolTip = 'Specifies Weight.';
                        BlankZero = True;
                    }
                    field(Speed; Speed)
                    {
                        ApplicationArea = All;
                        Caption = 'Section';
                        ToolTip = 'Specifies Section.';
                    }
                    field(BottlesPerMinute; BottlesPerMinute)
                    {
                        ApplicationArea = All;
                        Caption = 'Bottles Per Minute';
                        ToolTip = 'Bottles Per Minute.';
                    }
                    field(Tray; Tray)
                    {
                        ApplicationArea = All;
                        Caption = 'Tray';
                        ToolTip = 'Specifies Tray.';
                    }
                    field(Pallet; Pallet)
                    {
                        ApplicationArea = All;
                        Caption = 'Pallet';
                        ToolTip = 'Specifies Pallet.';
                    }
                }
            }
        }

    }
    var
        FromDate: Date;
        ToDate: Date;
        Furnace: Code[20];
        JobNo: Code[20];
        Ton: Decimal;
        Tray: Text[50];
        Pallet: Text[50];
        Speed: Enum Speed;
        WT: Decimal;
        BottlesPerMinute: Integer;
        GeneralLegderSetup: Record "General Ledger Setup";
        DimensionValue: Record "Dimension Value";
        ShortCutDimension: Code[20];

}
