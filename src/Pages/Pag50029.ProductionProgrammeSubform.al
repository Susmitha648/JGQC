page 50029 "Production Programme Subform"
{
    ApplicationArea = All;
    Caption = 'Production Programme Subform';
    PageType = ListPart;
    SourceTable = "Production Programme Line";
    //DeleteAllowed = True;
    // Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                    Editable = false;
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.', Comment = '%';

                }
                field(Day; Rec.Day)
                {
                    ToolTip = 'Specifies the value of the Day field.', Comment = '%';

                }
                field(Furnace; Rec.Furnace)
                {
                    ToolTip = 'Specifies the value of the Furnace field.', Comment = '%';

                }
                field(Job; Rec.Job)
                {
                    ToolTip = 'Specifies the value of the Job field.', Comment = '%';

                }
                field(WT; Rec.WT)
                {
                    ToolTip = 'Specifies the value of the WT field.', Comment = '%';

                }
                field(Speed; Rec.Speed)
                {
                    ToolTip = 'Specifies the value of the Speed field.', Comment = '%';

                }
                field("Bottles Per Minute"; Rec."Bottles Per Minute")
                {
                    ToolTip = 'Specifies the value of the Bottles Per Minute field.', Comment = '%';

                }
                field(Ton; Rec.Ton)
                {
                    ToolTip = 'Specifies the value of the Ton field.', Comment = '%';

                }
                field(Tray; Rec.Tray)
                {
                    ToolTip = 'Specifies the value of the Tray field.', Comment = '%';

                }
                field(Pallet; Rec.Pallet)
                {
                    ToolTip = 'Specifies the value of the Pallet field.', Comment = '%';
                }
                field("Production Order No."; Rec."Production Order No.")
                {
                    ToolTip = 'Specifies the value of the Production Order No. field.', Comment = '%';
                }
                field("Prod Order Created"; Rec."Prod Order Created")
                {
                    ToolTip = 'Specifies the value of the Prod Order Created field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(CreatePO)
            {
                Caption = 'Create Work Order & Print';
                action(Create)
                {
                    ApplicationArea = Suite;
                    Caption = 'Create Work Order';
                    Image = Create;
                    ToolTip = 'Create Production Orders based on the Production Programme Lines';
                    trigger OnAction()
                    var
                        ProdProgLine: Record "Production Programme Line";
                    begin
                        CurrPage.SetSelectionFilter(ProdProgLine);
                        If ProdProgLine.FindSet() then
                            repeat
                                CreateProductionOrders(ProdProgLine);
                            until ProdProgLine.Next() = 0;
                            Message('Production Orders Created');
                    end;
                }
                action(F2DailyProduction)
                {
                    ApplicationArea = Suite;
                    Caption = 'F2 - Daily Production Report';
                    Image = Print;
                    ToolTip = 'Print the F2 - Daily Production Report.';
                    trigger OnAction()
                    var
                        ProdProgHeader: Record "Production Programme Line";
                    begin
                        //ProdProgHeader.Reset();
                        //ProdProgHeader.SetRange("No.",Rec."No.");
                        CurrPage.SetSelectionFilter(ProdProgHeader);
                        ProdProgHeader.SetRange(Furnace,'');
                        Report.RunModal(Report::"F2 Daily Production Report", true, false,ProdProgHeader);
                    end;
                }
            }
        }
    }
    procedure CreateProductionOrders(var ProdProgramLine: Record "Production Programme Line")
    var
        ProductionHdr: Record "Production Order";
        ProductionLine: Record "Prod. Order Line";
        ProdLine: Record "Prod. Order Line";
        ManufacturingSetup: Record "Manufacturing Setup";
        NoSeries: Codeunit "No. Series";
        WorkShift: Record "Work Shift";
        ShopCalender: Record "Shop Calendar Working Days";
        HdrQty: Decimal;
    begin
        Clear(HdrQty);
        WorkShift.Reset();
        If ManufacturingSetup.Get() then;
        ProductionHdr.InitRecord();
        ProductionHdr."No." := NoSeries.GetNextNo(ManufacturingSetup."Released Order Nos.");
        ProductionHdr.Status := ProductionHdr.Status::Released;
        ProductionHdr.Insert(true);
        ProductionHdr.Validate("Source Type", ProductionHdr."Source Type"::Item);
        ProductionHdr.Validate("Source No.", ProdProgramLine.Job);
        ProductionHdr.Validate("Due Date", ProdProgramLine.Date);
        ProductionHdr."Dimension Set ID" := CreateDimension(ProdProgramLine);
        ProductionHdr.Validate(Quantity, (8 * 60 * ProdProgramLine."Bottles Per Minute") * WorkShift.Count);
        ProductionHdr.Modify();
        If WorkShift.FindSet() then
            repeat
                ProductionLine.Init();
                ProductionLine.Status := ProductionLine.Status::Released;
                ProductionLine.Validate("Prod. Order No.", ProductionHdr."No.");
                ProdLine.Reset();
                ProdLine.SetAscending("Line No.", false);
                ProdLine.SetRange(Status, ProdLine.Status::Released);
                ProdLine.SetRange("Prod. Order No.", ProductionHdr."No.");
                If ProdLine.FindFirst() then
                    ProductionLine."Line No." := ProdLine."Line No." + 10000
                Else
                    ProductionLine."Line No." := 10000;
                ProductionLine.Insert(true);
                ProductionLine.Validate("Item No.", ProdProgramLine.Job);
                ProductionLine.Validate("Due Date", ProductionHdr."Due Date");
                ProductionLine.Validate(Quantity, 8 * 60 * ProdProgramLine."Bottles Per Minute");
                HdrQty += 8 * 60 * ProdProgramLine."Bottles Per Minute";
                ProductionLine.Validate("Net Weight", ProdProgramLine.WT);

                ShopCalender.Reset();
                ShopCalender.SetRange("Work Shift Code", WorkShift.Code);

                If ProdProgramLine.Day = 'MONDAY' then
                    ShopCalender.SetRange(Day, ShopCalender.Day::Monday);
                If ProdProgramLine.Day = 'TUESDAY' then
                    ShopCalender.SetRange(Day, ShopCalender.Day::Tuesday);
                If ProdProgramLine.Day = 'WEDNESDAY' then
                    ShopCalender.SetRange(Day, ShopCalender.Day::Wednesday);
                If ProdProgramLine.Day = 'THURSDAY' then
                    ShopCalender.SetRange(Day, ShopCalender.Day::Thursday);
                If ProdProgramLine.Day = 'FRIDAY' then
                    ShopCalender.SetRange(Day, ShopCalender.Day::Friday);
                If ProdProgramLine.Day = 'SATURDAY' then
                    ShopCalender.SetRange(Day, ShopCalender.Day::Saturday);
                If ProdProgramLine.Day = 'SUNDAY' then
                    ShopCalender.SetRange(Day, ShopCalender.Day::Sunday);
                If ShopCalender.FindFirst() then;
               // ProductionLine.Validate("Starting Date-Time", CreateDateTime(ProdProgramLine.Date, ShopCalender."Starting Time"));
                //ProductionLine.Validate("Ending Date-Time", CreateDateTime(ProdProgramLine.Date, ShopCalender."Ending Time"));
                ProductionLine."Work Shift" := WorkShift.Code;
                ProductionLine."Work Center" := ProdProgramLine.Furnace;
                ProductionLine."Starting Time WO" := WorkShift."Starting Time";
                ProductionLine."Ending Time WO" := WorkShift."Ending Time";
                ProductionLine.Validate("Starting Date-Time", CreateDateTime(ProdProgramLine.Date,WorkShift."Starting Time"));
                ProductionLine.Validate("Ending Date-Time", CreateDateTime(ProdProgramLine.Date,WorkShift."Ending Time"));
                ProductionLine.Modify();
            until WorkShift.Next() = 0;

        ProdProgramLine."Production Order No." := ProductionHdr."No.";
        ProdProgramLine."Prod Order Created" := True;
        ProdProgramLine.Modify();
        
    end;

    procedure CreateDimension(ProdProgramDim: Record "Production Programme Line"): Integer
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        TempDimensionSetEntry: Record "Dimension Set Entry" temporary;
        DimensionSetEntry: Record "Dimension Set Entry";
        DimensionValue: Record "Dimension Value";
        DimensionManagement: Codeunit DimensionManagement;
        DimSetID: Integer;
        Item: Record Item;
    begin
        GeneralLedgerSetup.Get();

        If not DimensionValue.Get(GeneralLedgerSetup."Shortcut Dimension 2 Code", ProdProgramDim.Job) then begin
            DimensionValue.Init();
            DimensionValue.Validate("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 2 Code");
            DimensionValue.Validate(Code, ProdProgramDim.Job);
            If Item.Get(ProdProgramDim.Job) then;
            DimensionValue.Validate(Name, Item.Description);
            DimensionValue.Validate("Dimension Value Type", DimensionValue."Dimension Value Type"::Standard);
            DimensionValue.Insert();
        end;

        If not DimensionValue.Get(GeneralLedgerSetup."Shortcut Dimension 8 Code", ProdProgramDim.Furnace) then begin
            DimensionValue.Init();
            DimensionValue.Validate("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 8 Code");
            DimensionValue.Validate(Code, ProdProgramDim.Furnace);
            DimensionValue.Validate(Name,'');
            DimensionValue.Validate("Dimension Value Type", DimensionValue."Dimension Value Type"::Standard);
            DimensionValue.Insert();
        end;

        DimSetID := 0;
        TempDimensionSetEntry.DeleteAll();


        TempDimensionSetEntry.Init();
        TempDimensionSetEntry.Validate("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 2 Code");
        TempDimensionSetEntry.Validate("Dimension Value Code", ProdProgramDim.Job);
        TempDimensionSetEntry.Insert();


        If ProdProgramDim.Furnace <> '' then begin
            TempDimensionSetEntry.Init();
            TempDimensionSetEntry.Validate("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 8 Code");
            TempDimensionSetEntry.Validate("Dimension Value Code", ProdProgramDim.Furnace);
            TempDimensionSetEntry.Insert();
        end;

        DimSetID := DimensionManagement.GetDimensionSetID(TempDimensionSetEntry);

        DimensionSetEntry.Reset();
        DimensionSetEntry.SetRange("Dimension Set ID", DimSetID);
        if not DimensionSetEntry.FindFirst() then begin
            TempDimensionSetEntry.Reset();
            if TempDimensionSetEntry.FindSet() then
                repeat
                    DimensionSetEntry.Init();
                    DimensionSetEntry.Validate("Dimension Set ID", DimSetID);
                    DimensionSetEntry.Validate("Dimension Code", TempDimensionSetEntry."Dimension Code");
                    DimensionSetEntry.Validate("Dimension Value Code", TempDimensionSetEntry."Dimension Value Code");
                    DimensionSetEntry.Insert();
                until TempDimensionSetEntry.Next() = 0;
        end;

        TempDimensionSetEntry.Reset();
        TempDimensionSetEntry.DeleteAll();
        exit(DimSetID);
    end;


}
