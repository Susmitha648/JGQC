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
                ProductionProgramLineSequence: Record "Production Programme Line";
                Item: Record Item;
                FirstLineDate: Date;
                WorkShift: Record "Work Shift";
                Sequence: Integer;
            begin
                Clear(Sequence);
                ProductionProgramLineSequence.Reset();
                ProductionProgramLineSequence.SetAscending(Date, true);
                ProductionProgramLineSequence.SetRange("No.", ProductionProgrammeHeader."No.");
                ProductionProgramLineSequence.SetRange(Job, JobNo);
                If ProductionProgramLineSequence.FindLast() then
                    Sequence := ProductionProgramLineSequence."Sequence No" + 1
                else
                    Sequence := 1;

                If Item.Get(JobNo) then;
                If WorkShift.FindSet() then;
                FirstLineDate := FromDate;
                While FromDate <= ToDate do begin
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
                    End;
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
                    If ProductionProgramLine.Date = ToDate then
                        ProductionProgramLine."Last Line" := True;
                    If ProductionProgramLine.Date = FirstLineDate then
                        ProductionProgramLine."First Line" := True;
                    ProductionProgramLine."Sequence No" := Sequence;
                    ProductionProgramLine.Modify(false);
                    FromDate := FromDate + 1;
                end;
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
