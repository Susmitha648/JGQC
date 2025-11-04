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
                Item: Record Item;
                WorkShift : Record "Work Shift";
            begin
                If Item.Get(JobNo) then;
                If WorkShift.FindSet() then;
                While FromDate <= ToDate do begin
                    ProductionProgramLine.Reset();
                    ProductionProgramLine.SetRange("No.", "No.");
                    ProductionProgramLine.SetRange(Date, FromDate);
                    ProductionProgramLine.SetRange(Job, JobNo);
                    If not ProductionProgramLine.FindFirst() then begin
                        ProductionProgramLine.Init();
                        ProductionProgramLine."No." := "No.";
                        ProductionProgramLine.Date := FromDate;
                        ProductionProgramLine.Job := JobNo;
                        ProductionProgramLine.Insert();
                    End;
                    ProductionProgramLine.Speed := Speed;
                    ProductionProgramLine.Pallet := Pallet;
                    ProductionProgramLine.Tray := Tray;
                    ProductionProgramLine."Bottles Per Minute" := BottlesPerMinute;
                    ProductionProgramLine.WT := Item."Net Weight";
                    ProductionProgramLine.Furnace := Furnace;
                    ProductionProgramLine.Day := Format(FromDate, 0, '<Weekday Text>');
                    ProductionProgramLine.Ton := BottlesPerMinute*8*60*WorkShift.Count*Item."Net Weight"/1000000;
                    ProductionProgramLine.Modify();
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
                            if Page.RunModal(537,DimensionValue) = Action::LookupOK then begin
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
        BottlesPerMinute : Integer;
        GeneralLegderSetup: Record "General Ledger Setup";
        DimensionValue: Record "Dimension Value";
        ShortCutDimension: Code[20];

}
