report 50020 "F2 Daily Production Report New"
{
    ApplicationArea = All;
    Caption = 'F2 - Daily Production Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/DailyProductionReportF2New.rdl';
    dataset
    {
        dataitem(ProductionOrder; "Production Order")
        {
            column(Due_Date; "Due Date") { }
            column(MTDTonnageWithDraining; MTDTonnageWithDraining) { }
            column(MTDTonnageWithOutDraining; MTDTonnageWithOutDraining) { }
            column(MTDPackTonWithDraining; MTDPackTonWithDraining) { }
            column(YTDTonnageWithDraining; YTDTonnageWithDraining) { }
            column(YTDTonnageWithOutDraining; YTDTonnageWithOutDraining) { }
            column(YTDPackTonWithDraining; YTDPackTonWithDraining) { }
            column(MTDPPDraw; MTDPPDraw) { }
            dataitem(ProdOrderLine; "Prod. Order Line")
            {
                UseTemporary = True;
                DataItemLinkReference = ProductionOrder;
                DataItemLink = "Prod. Order No." = field("No.");
                column(Work_Shift; "Work Shift") { }
                column(GobCutOutPutQuantity; Quantity) { }
                column(TonPerLine; TonPerLine) { }
                column(GobCut; GobCut) { }
                column(TotalPackQty; TotalPackQty) { }
                column(TonPerLineTot; TonPerLineTot) { }
                column(TonPerLineTot1; TonPerLineTot1) { }
                column(GobCutTot; GobCutTot) { }
                column(Furnace; Furnace) { }
                column(Job; "Item No.") { }
                column(WT; "Net Weight") { }
                column(Speed; Section) { }
                column(BottlesPerMinute; "Speed Bpm") { }
                column(ProductionOrderNo; "Prod. Order No.") { }
                column(Hours; Hours) { }
                column(ActPackQty; ActPackQty) { }
                column(QCDQty; QCDQty) { }
                column(FurnaceDraw; FurnaceDraw) { }
                column(GobCutFurnace; GobCutFurnace) { }
                column(ActPackEff; ActPackEff) { }
                column(PassQuantity; PassQuantity) { }
                column(PackTon; PackTon) { }
                column(NetPackPerc; NetPackPerc) { }
                trigger OnAfterGetRecord()
                var
                    ProdOrderL: Record "Prod. Order Line";
                    ItemPacksize: Record Item;
                    PackSize: Record "Pack Size";
                    NetWeight: Decimal;
                begin
                    Clear(FurnaceDraw);
                    Clear(GobCut);
                    Clear(GobCutFurnace);
                    Clear(ActPackQty);
                    Clear(QCDQty);
                    Clear(ActPackEff);
                    Clear(PackTon);
                    Clear(NetPackPerc);
                    Clear(PassQuantity);
                    Clear(TonPerLineTot1);
                    Clear(NetWeight);
                    Clear(AvgWt);
                    //Clear(Furnace);

                    If "Starting Time WO" < "Ending Time WO" then
                        Hours := ("Ending Time WO" - "Starting Time WO") / 3600000
                    else
                        Hours := ("Ending Time WO" - "Starting Time WO") / 3600000 + 24;
                    If "Work Shift" = '' then
                        FurnaceDraw := Quantity
                    else
                        FurnaceDraw := "Speed Bpm" * 60 * "Net Weight" * Hours / 1000000;
                    GobCut := "Speed Bpm" * 60 * Hours;
                    GobCutFurnace := "Speed Bpm" * 60 * "Net Weight" * Hours / 1000000;

                    ProdOrdLineFG.Reset();
                    ProdOrdLineFG.SetRange("Due Date", "Due Date");
                    ProdOrdLineFG.SetRange("Shortcut Dimension 2 Code", "Item No.");
                    ProdOrdLineFG.SetRange("Work Shift", "Work Shift");
                    ProdOrdLineFG.SetRange("Inventory Posting Group", 'FG');
                    If ProdOrdLineFG.FindSet() then
                        repeat
                            ItemLedgerEntryFG.Reset();
                            ItemLedgerEntryFG.SetLoadFields("Entry Type", "Document No.", "Order Line No.", "Quantity Pieces");
                            ItemLedgerEntryFG.SetRange("Entry Type", ItemLedgerEntryFG."Entry Type"::Output);
                            ItemLedgerEntryFG.SetRange("Document No.", ProdOrdLineFG."Prod. Order No.");
                            ItemLedgerEntryFG.SetRange("Order Line No.", ProdOrdLineFG."Line No.");
                            If ItemLedgerEntryFG.FindSet() then
                                repeat
                                    ActPackQty += ItemLedgerEntryFG."Quantity Pieces";
                                until ItemLedgerEntryFG.Next() = 0;
                            If ProdOrdLineFG."QCD Quantity" > 0 then
                                If ItemPacksize.Get(ProdOrdLineFG."Item No.") then
                                    If PackSize.Get(ItemPacksize."Pack Size") then
                                        QCDQty := PackSize."Qty Per Pack" * ProdOrdLineFG."QCD Quantity";
                        until ProdOrdLineFG.Next() = 0;

                    PassQuantity := ActPackQty - QCDQty;
                    ProdOrderL.Reset();
                    ProdOrderL.SetLoadFields("Item No.","Due Date","Prod. Order No.","Work Shift","Starting Time WO","Ending Time WO","Speed Bpm","Net Weight");
                    ProdOrderL.SetRange("Item No.", "Item No.");
                    ProdOrderL.SetRange("Due Date", "Due Date");
                    ProdOrderL.SetFilter("Prod. Order No.", '<>%1', "Prod. Order No.");
                    ProdOrderL.SetRange("Work Shift", "Work Shift");
                    If ProdOrderL.FindSet() then
                        repeat
                            If ProdOrderL."Starting Time WO" < ProdOrderL."Ending Time WO" then
                                CurrLineHrs := (ProdOrderL."Ending Time WO" - ProdOrderL."Starting Time WO") / 3600000
                            else
                                CurrLineHrs := (ProdOrderL."Ending Time WO" - ProdOrderL."Starting Time WO") / 3600000 + 24;

                            GobCut += ProdOrderL."Speed Bpm" * 60 * CurrLineHrs;
                            GobCutFurnace += ProdOrderL."Speed Bpm" * 60 * ProdOrderL."Net Weight" * CurrLineHrs / 1000000;
                            FurnaceDraw += ProdOrderL."Speed Bpm" * 60 * ProdOrderL."Net Weight" * CurrLineHrs / 1000000;

                        until ProdOrderL.Next() = 0;

                    ProdOrderLineNetWeight.Reset();
                    ProdOrderLineNetWeight.SetRange("Item No.", "Item No.");
                    ProdOrderLineNetWeight.SetRange("Due Date", "Due Date");
                    ProdOrderLineNetWeight.SetRange("Inventory Posting Group", 'PB');
                    ProdOrderLineNetWeight.SetRange("Work Shift", "Work Shift");
                    If ProdOrderLineNetWeight.Count > 1 then begin
                        If ProdOrderLineNetWeight.FindSet() then
                            repeat
                                AvgWt += ProdOrderLineNetWeight."Net Weight";
                            until ProdOrderLineNetWeight.Next() = 0;
                        NetWeight := AvgWt / ProdOrderLineNetWeight.Count;
                    end;
                    If NetWeight > 0 then
                        PackTon := (NetWeight * PassQuantity) / 1000000
                    Else
                        PackTon := ("Net Weight" * PassQuantity) / 1000000;
                    If GobCut <> 0 then begin
                        ActPackEff := Round((ActPackQty / GobCut) * 100, 1);
                        NetPackPerc := Round((PassQuantity / GobCut) * 100, 0.1);
                    end;
                    TonPerLineTot1 += ("Quantity" * ("Net Weight" / 1000)) / 1000;

                end;

                trigger OnPreDataItem()
                begin
                    SetFilter(Furnace, '%1', 'F2*');
                end;
            }
            dataitem(ProductionOrderFG; "Production Order")
            {
                DataItemLinkReference = ProductionOrder;
                DataItemLink = "Shortcut Dimension 2 Code" = field("Source No.");


                trigger OnPreDataItem()
                begin
                    SetRange("Due Date", DailyProdReport);
                    SetRange("Inventory Posting Group", 'FG');
                end;
            }
            trigger OnPreDataItem()

            begin
                SetRange("Due Date", DailyProdReport);
                SetRange("Inventory Posting Group", 'PB');
            end;

            trigger OnAfterGetRecord()
            var
                ProdOrderLineTot: Record "Prod. Order Line";
                ILE: Record "Item Ledger Entry";
                ItemTotPack : Record Item;
                PacksizeTotPakc : Record "Pack Size";
            begin
                Clear(TotalPackQty);
                ProdOrderLineTot.Reset();
                ProdOrderLineTot.SetRange("Shortcut Dimension 2 Code", "Source No.");
                ProdOrderLineTot.SetRange("Due Date", CalcDate('<-CM>', "Due Date"), DailyProdReport);
                ProdOrderLineTot.SetRange("Inventory Posting Group", 'FG');
                If ProdOrderLineTot.FindSet() then
                    repeat
                       /* ILE.Reset();
                        ILE.SetLoadFields("Entry Type", "Document No.", "Order Line No.", "Quantity Pieces");
                        ILE.SetRange("Entry Type", ILE."Entry Type"::Output);
                        ILE.SetRange("Document No.", ProdOrderLineTot."Prod. Order No.");
                        ILE.SetRange("Order Line No.", ProdOrderLineTot."Line No.");
                        if ILE.FindSet() then
                            repeat
                                TotalPackQty += ILE."Quantity Pieces";
                            until ILE.Next() = 0;*/
                        if ItemTotPack.Get(ProdOrderLineTot."Item No.") then
                        If PacksizeTotPakc.Get(ItemTotPack."Pack Size") then
                           TotalPackQty += PacksizeTotPakc."Qty Per Pack" * ProdOrderLineTot."Finished Quantity";
                    until ProdOrderLineTot.Next() = 0;
            end;
        }
        dataitem(QCDetails; "Temp QC Details")
        {
            //DataItemLink = "Work Order No" = field("No.");
            //DataItemLinkReference = ProductionOrderFG;
            UseTemporary = True;
            column(MachineNo; "Machine No.") { }
            column(Shift1; Shift) { }
            column(IRIZ; "IRIZ %") { }
            column(SL; "SL %") { }
            column(DefectCodeArray1; DefectTxt) { }
            column(DeptTxt; DeptTxt) { }
            column(RemarksTxt; RemarksTxt) { }
            column(StoppageTxt; StoppageTxt) { }
            trigger OnAfterGetRecord()
            begin
                Clear(DefectCodeArray);
                Clear(DefectTxt);
                Clear(DeptTxt);
                Clear(RemarksTxt);

                cr := 13;
                lf := 10;
                If DefectCode.Get("Defect Code 1") then
                    DefectCodeArray[1] := DefectCode."Defect Name";
                If DefectCode.Get("Defect Code 2") then
                    DefectCodeArray[2] := DefectCode."Defect Name";
                If DefectCode.Get("Defect Code 3") then
                    DefectCodeArray[3] := DefectCode."Defect Name";

                if DefectCodeArray[1] <> '' then
                    DefectTxt += DefectCodeArray[1] + Format(cr) + Format(lf);
                if DefectCodeArray[2] <> '' then
                    DefectTxt += DefectCodeArray[2] + Format(cr) + Format(lf);
                if DefectCodeArray[3] <> '' then
                    DefectTxt += DefectCodeArray[3];
                Clear(StoppagesArray);
                Clear(StoppageTxt);
                MachineSectionStoppages.Reset();
                MachineSectionStoppages.SetRange("Incident Date", DailyProdReport);
                MachineSectionStoppages.SetRange(Shift, QCDetails.Shift);
                MachineSectionStoppages.SetRange("Machine Number", "Machine No.");
                If MachineSectionStoppages.FindSet() then
                    repeat
                        StoppagesArray[1] := MachineSectionStoppages."Machine Stoppage Description";
                        StoppagesArray[2] := MachineSectionStoppages."Section Stoppage Description";
                        if StoppagesArray[1] <> '' then
                            StoppageTxt += StoppagesArray[1] + Format(cr) + Format(lf);
                        if StoppagesArray[2] <> '' then
                            StoppageTxt += StoppagesArray[2] + Format(cr) + Format(lf);
                        RemarksTxt += MachineSectionStoppages.Remarks + Format(cr) + Format(lf);
                        DeptTxt += MachineSectionStoppages.Department + Format(cr) + Format(lf);
                    until MachineSectionStoppages.Next() = 0;
                //to remove extra line on the last line
                If StoppageTxt <> '' then
                    StoppageTxt := CopyStr(StoppageTxt, 1, StrLen(StoppageTxt) - 2);
                If RemarksTxt <> '' then
                    RemarksTxt := CopyStr(RemarksTxt, 1, StrLen(RemarksTxt) - 2);
                If DeptTxt <> '' then
                    DeptTxt := CopyStr(DeptTxt, 1, StrLen(DeptTxt) - 2);
            end;

            trigger OnPreDataItem()
            begin
                SetFilter("Machine No.", '%1', 'F2*');
            end;

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
                    field(DailyProdReport; DailyProdReport)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Date';
                    }
                }
            }
        }
    }
    trigger OnPreReport()
    var
        ItemLedgerEntryMCDrawing: Record "Item Ledger Entry";
        ManufacturingSetup: Record "Manufacturing Setup";
        ProductionProgrammeLineFilter: Record "Production Programme Line";
        ProductionOrderLine: Record "Prod. Order Line";
        PO: Record "Production Order";
        Hrs: Decimal;
        CurHrs: Decimal;
        ItemRec: Record Item;
        PackSize: Record "Pack Size";

        Netwt: Decimal;
        NetwtM: Decimal;
    begin
        Clear(TonPerLineTot);
        Clear(GobCutTot);
        Clear(MTDTonnageWithDraining);
        Clear(MTDTonnageWithOutDraining);
        Clear(MTDPackTonWithDraining);
        Clear(TonPerLineTot1);
        Clear(YTDPackTonWithDraining);
        Clear(YTDTonnageWithDraining);
        Clear(YTDTonnageWithOutDraining);
        Clear(MTDPPDraw);
        If DailyProdReport = 0D then
            Error('Date value should not be blank');
        //ProdOrderLine.DeleteAll();
        ManufacturingSetup.Get();
        GeneralLedgerSetup.Get();
        ProductionOrderLine.Reset();
        ProductionOrderLine.SetRange("Due Date", DailyProdReport);
        ProductionOrderLine.SetFilter("Work Shift", '<>%1', '');
        // ProductionOrderLine.SetFilter(Furnace, '%1', 'F2*');
        ProductionOrderLine.SetRange("Inventory Posting Group", 'PB');
        If ProductionOrderLine.FindSet() then
            repeat
                ProdOrderLine.Reset();
                ProdOrderLine.SetRange("Item No.", ProductionOrderLine."Item No.");
                ProdOrderLine.SetRange("Due Date", ProductionOrderLine."Due Date");
                ProdOrderLine.SetRange("Inventory Posting Group", 'PB');
                ProdOrderLine.SetRange("Work Shift", ProductionOrderLine."Work Shift");
                If not ProdOrderLine.FindFirst() then begin
                    ProdOrderLine.Init();
                    ProdOrderLine.TransferFields(ProductionOrderLine);
                    If PO.Get(ProductionOrderLine.Status, ProductionOrderLine."Prod. Order No.") then;
                    DimensionSetEntry.Reset();
                    DimensionSetEntry.SetRange("Dimension Set ID", PO."Dimension Set ID");
                    DimensionSetEntry.SetRange("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 8 Code");
                    If DimensionSetEntry.FindFirst() then
                        ProdOrderLine.Furnace := DimensionSetEntry."Dimension Value Code"
                    else begin
                        ProdProgramLine.Reset();
                        ProdProgramLine.SetRange("No.", PO."Production Programme");
                        ProdProgramLine.SetRange(Date, PO."Due Date");
                        ProdProgramLine.SetRange(Job, ProductionOrderLine."Item No.");
                        If ProdProgramLine.FindFirst() then
                            ProdOrderLine.Furnace := ProdProgramLine.Furnace;
                    end;

                    ProdOrderLine.Insert();
                end;
            until ProductionOrderLine.Next() = 0;


        ItemLedgerEntryMCDrawing.Reset();
        ItemLedgerEntryMCDrawing.SetLoadFields("Shortcut Dimension 8 Code", "Posting Date", "Entry Type", "Document Type", "Entry No.", Quantity);
        ItemLedgerEntryMCDrawing.SetAutoCalcFields("Shortcut Dimension 8 Code");
        ItemLedgerEntryMCDrawing.SetRange("Posting Date", DailyProdReport);
        ItemLedgerEntryMCDrawing.SetFilter("Shortcut Dimension 8 Code", '%1', 'F2*');
        ItemLedgerEntryMCDrawing.SetRange("Entry Type", ItemLedgerEntryMCDrawing."Entry Type"::"Positive Adjmt.");
        ItemLedgerEntryMCDrawing.SetRange("Document Type", ItemLedgerEntryMCDrawing."Document Type"::" ");
        If ItemLedgerEntryMCDrawing.FindSet() then
            repeat
                //ItemLedgerEntryMCDrawing.CalcFields("Shortcut Dimension 8 Code");
                ProdOrderLine.Init();
                ProdOrderLine.Status := ProdOrderLine.Status::Released;
                ProdOrderLine."Prod. Order No." := PO."No.";
                ProdOrderLine."Line No." := ItemLedgerEntryMCDrawing."Entry No.";
                ProdOrderLine."Item No." := 'DRAINING';
                ProdOrderLine."Due Date" := ItemLedgerEntryMCDrawing."Posting Date";
                //ProdOrderLine.Furnace := ItemLedgerEntryMCDrawing."Shortcut Dimension 8 Code";
                ProdOrderLine.Quantity := ItemLedgerEntryMCDrawing.Quantity;
                ProdOrderLine.Furnace := ItemLedgerEntryMCDrawing."Shortcut Dimension 8 Code";
                ProdOrderLine.Insert();
            until ItemLedgerEntryMCDrawing.Next() = 0;


        ProductioProgLineMTD.Reset();
        ProductioProgLineMTD.SetRange(Date, CalcDate('<-CM>', DailyProdReport), DailyProdReport);
        ProductioProgLineMTD.SetFilter(Furnace, '%1', 'F2*');
        ProductioProgLineMTD.SetFilter("Production Order No.", '<>%1', '');
        If ProductioProgLineMTD.FindSet() then
            repeat
                MTDPPDraw += ProductioProgLineMTD.Ton;
            until ProductioProgLineMTD.Next() = 0;

        //MTD calculation
        ProductionOrderLine.Reset();
        //ProductionOrderLine.SetRange("Prod. Order No.", ProductioProgLineMTD."Production Order No.");
        ProductionOrderLine.SetRange("Due Date", CalcDate('<-CM>', DailyProdReport), DailyProdReport);
        ProductionOrderLine.SetRange("Inventory Posting Group", 'PB');
        If ProductionOrderLine.FindSet() then
            repeat
                DimensionSetEntry.Reset();
                DimensionSetEntry.SetRange("Dimension Set ID", ProductionOrderLine."Dimension Set ID");
                DimensionSetEntry.SetRange("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 8 Code");
                DimensionSetEntry.Setfilter("Dimension Value Code", '%1', 'F2*');
                If DimensionSetEntry.FindFirst() then begin
                    NetwtM := 0;
                    Hrs := 0;
                    Netwt := 0;
                    CurHrs := 0;
                    ProdOrdLineNt.Reset();
                    ProdOrdLineNt.SetRange("Due Date", ProductionOrderLine."Due Date");
                    ProdOrdLineNt.SetRange("Work Shift", ProductionOrderLine."Work Shift");
                    ProdOrdLineNt.SetRange("Item No.", ProductionOrderLine."Item No.");
                    If ProdOrdLineNt.Count > 1 then begin
                        If ProdOrdLineNt.Findset() then
                            repeat
                                Netwt += ProdOrdLineNt."Net Weight";
                            until ProdOrdLineNt.Next() = 0;
                        NetwtM := Netwt / ProdOrdLineNt.Count;
                    end;
                    ProdOrdLineMonth.Reset();
                    ProdOrdLineMonth.SetRange("Due Date", ProductionOrderLine."Due Date");
                    ProdOrdLineMonth.SetRange("Work Shift", ProductionOrderLine."Work Shift");
                    ProdOrdLineMonth.SetRange("Item No.", ProductionOrderLine."Item No.");
                    If not ProdOrdLineMonth.FindFirst() then begin
                        ProdOrdLineMonth.Init();
                        ProdOrdLineMonth.TransferFields(ProductionOrderLine);
                        ProdOrdLineMonth.Insert();
                        ProdOrdLineFGMTD.Reset();
                        ProdOrdLineFGMTD.SetRange("Shortcut Dimension 2 Code", ProductionOrderLine."Item No.");
                        ProdOrdLineFGMTD.SetRange("Due Date", ProductionOrderLine."Due Date");
                        ProdOrdLineFGMTD.SetRange("Inventory Posting Group", 'FG');
                        ProdOrdLineFGMTD.SetRange("Work Shift", ProductionOrderLine."Work Shift");
                        If ProdOrdLineFGMTD.FindSet() then
                            repeat
                                ItemLedgerEntryMTDPackTon.Reset();
                                ItemLedgerEntryMTDPackTon.SetLoadFields("Entry Type", "Document No.", "Order Line No.", "Quantity Pieces", "Net Weight");
                                ItemLedgerEntryMTDPackTon.SetRange("Entry Type", ItemLedgerEntryMTDPackTon."Entry Type"::Output);
                                ItemLedgerEntryMTDPackTon.SetRange("Document No.", ProdOrdLineFGMTD."Prod. Order No.");
                                ItemLedgerEntryMTDPackTon.SetRange("Order Line No.", ProdOrdLineFGMTD."Line No.");
                                If ItemLedgerEntryMTDPackTon.FindSet() then
                                    repeat
                                        If ProdOrdLineNt.Count > 1 then
                                            MTDPackTonWithDraining += (ItemLedgerEntryMTDPackTon."Quantity Pieces" * (NetwtM / 1000)) / 1000
                                        Else
                                            MTDPackTonWithDraining += (ItemLedgerEntryMTDPackTon."Quantity Pieces" * (ProductionOrderLine."Net Weight" / 1000)) / 1000;
                                    until ItemLedgerEntryMTDPackTon.Next() = 0;

                            until ProdOrdLineFGMTD.Next() = 0;
                        If ProductionOrderLine."Starting Time WO" < ProductionOrderLine."Ending Time WO" then
                            Hrs := (ProductionOrderLine."Ending Time WO" - ProductionOrderLine."Starting Time WO") / 3600000
                        else
                            Hrs := (ProductionOrderLine."Ending Time WO" - ProductionOrderLine."Starting Time WO") / 3600000 + 24;

                        ProdOrdLineHrs.Reset();
                        ProdOrdLineHrs.SetRange("Item No.", ProductionOrderLine."Item No.");
                        ProdOrdLineHrs.SetRange("Due Date", ProductionOrderLine."Due Date");
                        ProdOrdLineHrs.SetFilter("Prod. Order No.", '<>%1', ProductionOrderLine."Prod. Order No.");
                        ProdOrdLineHrs.SetRange("Work Shift", ProductionOrderLine."Work Shift");
                        If ProdOrdLineHrs.FindSet() then
                            repeat
                                If ProdOrdLineHrs."Starting Time WO" < ProdOrdLineHrs."Ending Time WO" then begin
                                    // Hrs += (ProdOrdLineHrs."Ending Time WO" - ProdOrdLineHrs."Starting Time WO") / 3600000;
                                    CurHrs := (ProdOrdLineHrs."Ending Time WO" - ProdOrdLineHrs."Starting Time WO") / 3600000;
                                    MTDTonnageWithDraining += ProdOrdLineHrs."Speed Bpm" * 60 * ProdOrdLineHrs."Net Weight" * CurHrs / 1000000;
                                    MTDTonnageWithOutDraining += ProdOrdLineHrs."Speed Bpm" * 60 * ProdOrdLineHrs."Net Weight" * CurHrs / 1000000;
                                end else begin
                                    //Hrs += (ProdOrdLineHrs."Ending Time WO" - ProdOrdLineHrs."Starting Time WO") / 3600000 + 24;
                                    CurHrs := (ProdOrdLineHrs."Ending Time WO" - ProdOrdLineHrs."Starting Time WO") / 3600000 + 24;
                                    MTDTonnageWithDraining += ProdOrdLineHrs."Speed Bpm" * 60 * ProdOrdLineHrs."Net Weight" * CurHrs / 1000000;
                                    MTDTonnageWithOutDraining += ProdOrdLineHrs."Speed Bpm" * 60 * ProdOrdLineHrs."Net Weight" * CurHrs / 1000000;
                                end;
                            until ProdOrdLineHrs.Next() = 0;
                        MTDTonnageWithDraining += ProductionOrderLine."Speed Bpm" * 60 * ProductionOrderLine."Net Weight" * Hrs / 1000000;
                        MTDTonnageWithOutDraining += ProductionOrderLine."Speed Bpm" * 60 * ProductionOrderLine."Net Weight" * Hrs / 1000000;
                    end;
                end;
            until ProductionOrderLine.Next() = 0;

        ItemLedgerEntryMTD.Reset();
        ItemLedgerEntryMTD.SetLoadFields("Shortcut Dimension 8 Code", "Posting Date", "Entry Type", "Document Type", Quantity);
        ItemLedgerEntryMTD.SetAutoCalcFields("Shortcut Dimension 8 Code");
        ItemLedgerEntryMTD.SetRange("Posting Date", CalcDate('<-CM>', DailyProdReport), DailyProdReport);
        ItemLedgerEntryMTD.SetFilter("Shortcut Dimension 8 Code", '%1', 'F2*');
        ItemLedgerEntryMTD.SetRange("Entry Type", ItemLedgerEntryMCDrawing."Entry Type"::"Positive Adjmt.");
        ItemLedgerEntryMTD.SetRange("Document Type", ItemLedgerEntryMCDrawing."Document Type"::" ");
        If ItemLedgerEntryMTD.FindSet() then
            repeat
                MTDTonnageWithDraining += ABS(ItemLedgerEntryMTD.Quantity);
            until ItemLedgerEntryMTD.Next() = 0;

        // YTD calculation
        ProductionOrderLine.Reset();
        //ProductionOrderLine.SetRange("Prod. Order No.", ProductioProgLineMTD."Production Order No.");
        ProductionOrderLine.SetRange("Due Date", CalcDate('<-CY>', DailyProdReport), DailyProdReport);
        ProductionOrderLine.SetRange("Inventory Posting Group", 'PB');
        If ProductionOrderLine.FindSet() then
            repeat
                DimensionSetEntry.Reset();
                DimensionSetEntry.SetRange("Dimension Set ID", ProductionOrderLine."Dimension Set ID");
                DimensionSetEntry.SetRange("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 8 Code");
                DimensionSetEntry.Setfilter("Dimension Value Code", '%1', 'F2*');
                If DimensionSetEntry.FindFirst() then begin
                    ProdOrdLineFGYTD.Reset();
                    ProdOrdLineFGYTD.SetRange("Shortcut Dimension 2 Code", ProductionOrderLine."Item No.");
                    ProdOrdLineFGYTD.SetRange("Due Date", ProductionOrderLine."Due Date");
                    ProdOrdLineFGYTD.SetRange("Inventory Posting Group", 'FG');
                    ProdOrdLineFGYTD.SetRange("Work Shift", ProductionOrderLine."Work Shift");
                    If ProdOrdLineFGYTD.FindSet() then
                        repeat
                            /* ItemLedgerEntryMTDPackTon.Reset();
                             ItemLedgerEntryMTDPackTon.SetLoadFields("Entry Type","Document No.","Order Line No.");
                             ItemLedgerEntryMTDPackTon.SetRange("Entry Type", ItemLedgerEntryMTDPackTon."Entry Type"::Output);
                             ItemLedgerEntryMTDPackTon.SetRange("Document No.", ProdOrdLineFGYTD."Prod. Order No.");
                             ItemLedgerEntryMTDPackTon.SetRange("Order Line No.", ProdOrdLineFGYTD."Line No.");
                             If ItemLedgerEntryMTDPackTon.FindSet() then
                                 repeat*/
                            If ItemRec.Get(ProdOrdLineFGYTD."Item No.") then
                                If PackSize.Get(ItemRec."Pack Size") then
                                    YTDPackTonWithDraining += (PackSize."Qty Per Pack" * (ProductionOrderLine."Net Weight" / 1000)) / 1000;
                            //until ItemLedgerEntryMTDPackTon.Next() = 0;
                            If ProductionOrderLine."Starting Time WO" < ProductionOrderLine."Ending Time WO" then
                                Hrs := (ProductionOrderLine."Ending Time WO" - ProductionOrderLine."Starting Time WO") / 3600000
                            else
                                Hrs := (ProductionOrderLine."Ending Time WO" - ProductionOrderLine."Starting Time WO") / 3600000 + 24;
                            YTDTonnageWithDraining += ProductionOrderLine."Speed Bpm" * 60 * ProductionOrderLine."Net Weight" * Hrs / 1000000;
                            YTDTonnageWithOutDraining += ProductionOrderLine."Speed Bpm" * 60 * ProductionOrderLine."Net Weight" * Hrs / 1000000;
                        until ProdOrdLineFGYTD.Next() = 0;
                End else begin
                    ProductioProgLineYTD.Reset();
                    ProductioProgLineYTD.SetRange("Production Order No.", ProductionOrderLine."Prod. Order No.");
                    ProductioProgLineYTD.SetFilter(Furnace, '%1', 'F2*');
                    If ProductioProgLineYTD.Findfirst then begin
                        ProdOrdLineFGYTD.Reset();
                        ProdOrdLineFGYTD.SetRange("Shortcut Dimension 2 Code", ProductionOrderLine."Item No.");
                        ProdOrdLineFGYTD.SetRange("Due Date", ProductionOrderLine."Due Date");
                        ProdOrdLineFGYTD.SetRange("Inventory Posting Group", 'FG');
                        ProdOrdLineFGYTD.SetRange("Work Shift", ProductionOrderLine."Work Shift");
                        If ProdOrdLineFGYTD.FindSet() then
                            repeat
                                /*  ItemLedgerEntryMTDPackTon.Reset();
                                  ItemLedgerEntryMTDPackTon.SetRange("Entry Type", ItemLedgerEntryMTDPackTon."Entry Type"::Output);
                                  ItemLedgerEntryMTDPackTon.SetRange("Document No.", ProdOrdLineFGYTD."Prod. Order No.");
                                  ItemLedgerEntryMTDPackTon.SetRange("Order Line No.", ProdOrdLineFGYTD."Line No.");
                                  If ItemLedgerEntryMTDPackTon.FindSet() then
                                      repeat*/
                                If ItemRec.Get(ProdOrdLineFGYTD."Item No.") then
                                    If PackSize.Get(ItemRec."Pack Size") then
                                        YTDPackTonWithDraining += ((PackSize."Qty Per Pack" * ProdOrdLineFGYTD."Finished Quantity") * (ProductionOrderLine."Net Weight" / 1000)) / 1000;
                                // until ItemLedgerEntryMTDPackTon.Next() = 0;
                                If ProductionOrderLine."Starting Time WO" < ProductionOrderLine."Ending Time WO" then
                                    Hrs := (ProductionOrderLine."Ending Time WO" - ProductionOrderLine."Starting Time WO") / 3600000
                                else
                                    Hrs := (ProductionOrderLine."Ending Time WO" - ProductionOrderLine."Starting Time WO") / 3600000 + 24;
                                YTDTonnageWithDraining += ProductionOrderLine."Speed Bpm" * 60 * ProductionOrderLine."Net Weight" * Hrs / 1000000;
                                YTDTonnageWithOutDraining += ProductionOrderLine."Speed Bpm" * 60 * ProductionOrderLine."Net Weight" * Hrs / 1000000;
                            until ProdOrdLineFGYTD.Next() = 0;
                    end;
                end;
            until ProductionOrderLine.Next() = 0;


        ItemLedgerEntryYTD.Reset();
        ItemLedgerEntryYTD.SetLoadFields("Posting Date", "Shortcut Dimension 8 Code", "Entry Type", "Document Type", Quantity);
        ItemLedgerEntryYTD.SetAutoCalcFields("Shortcut Dimension 8 Code");
        ItemLedgerEntryYTD.SetRange("Posting Date", DailyProdReport);
        ItemLedgerEntryYTD.SetFilter("Shortcut Dimension 8 Code", '%1', 'F2*');
        ItemLedgerEntryYTD.SetRange("Entry Type", ItemLedgerEntryMCDrawing."Entry Type"::"Positive Adjmt.");
        ItemLedgerEntryYTD.SetRange("Document Type", ItemLedgerEntryMCDrawing."Document Type"::" ");
        If ItemLedgerEntryYTD.FindSet() then
            repeat
                YTDTonnageWithDraining += ABS(ItemLedgerEntryYTD.Quantity);
            until ItemLedgerEntryYTD.Next() = 0;
        QCDetails.DeleteAll();
        ProdHdr.Reset();
        ProdHdr.SetRange("Due Date", DailyProdReport);
        ProdHdr.SetFilter("Inventory Posting Group",'%1|%2','FG','PB');
        If ProdHdr.FindSet() then
            repeat
                QCDetailFound := false;
                QCDetails2.Reset();
                QCDetails2.SetRange("Work Order No", ProdHdr."No.");
                If QCDetails2.FindSet() then
                    repeat
                        QCDetailFound := true;
                        QCDetails.Reset();
                        QCDetails.SetRange(Shift, QCDetails2.Shift);
                        QCDetails.SetRange("Machine No.", QCDetails2."Machine No.");
                        If not QCDetails.FindFirst() then begin
                            QCDetails.Init();
                            QCDetails.TransferFields(QCDetails2);
                            QCDetails.Insert();
                        end else begin
                            QCDetails."IRIZ %" := QCDetails2."IRIZ %";
                            QCDetails."SL %" := QCDetails2."SL %";
                            QCDetails."Defect Code 1" := QCDetails2."Defect Code 1";
                            QCDetails."Defect Code 2" := QCDetails2."Defect Code 2";
                            QCDetails."Defect Code 3" := QCDetails2."Defect Code 3";
                            QCDetails."Action Plan" := QCDetails2."Action Plan";
                            QCDetails.Modify();
                        end;
                    until QCDetails2.Next() = 0;
                MachineSecStop.Reset();
                MachineSecStop.SetRange("Production Order No.", ProdHdr."No.");
                MachineSecStop.SetFilter("Machine Number", '<>%1', '');
                If MachineSecStop.FindSet() then
                    repeat
                        QCDetails.Reset();
                        QCDetails.SetRange(Shift, MachineSecStop.Shift);
                        QCDetails.SetRange("Machine No.", MachineSecStop."Machine Number");
                        If not QCDetails.FindFirst() then begin
                            QCDetails.Init();
                            QCDetails."Work Order No" := ProdHdr."No.";
                            QCDetails."Machine No." := MachineSecStop."Machine Number";
                            QCDetails.Shift := MachineSecStop.Shift;
                            QCDetails.Insert();

                        end;
                    until MachineSecStop.Next() = 0;
            until ProdHdr.Next() = 0;


    end;

    var
        TonPerLine: Decimal;
        GobCut: Decimal;
        TonPerLineTot: Decimal;
        TonPerLineTot1: Decimal;
        GobCutTot: Decimal;
        DailyPackPer: Decimal;
        MTDTonnageWithDraining: Decimal;
        MTDTonnageWithOutDraining: Decimal;
        MTDPackTonWithDraining: Decimal;
        MTDPPDraw: Decimal;
        YTDTonnageWithDraining: Decimal;
        YTDTonnageWithOutDraining: Decimal;
        YTDPackTonWithDraining: Decimal;
        ProdHdr: Record "Production Order";
        ProdOrdLineFG: Record "Prod. Order Line";
        ProdOrdLineFGMTD: Record "Prod. Order Line";
        ProdOrdLineHrs: Record "Prod. Order Line";
        ProdOrdLineMonth: Record "Prod. Order Line" temporary;
        ProdOrdLineNt: Record "Prod. Order Line";
        ProdOrdLineFGYTD: Record "Prod. Order Line";
        ProdOrderLineNetWeight: Record "Prod. Order Line";
        ProdProgramLine: Record "Production Programme Line";
        ItemLedgerEntryMTD: Record "Item Ledger Entry";
        ItemLedgerEntryMTDPackTon: Record "Item Ledger Entry";
        ItemLedgerEntryYTD: Record "Item Ledger Entry";
        ProdProgramLinetemp: Record "Production Programme Line" temporary;
        ItemLedgerEntry1: Record "Item Ledger Entry";
        DefectCodeArray: array[3] of Text[100];
        DefectCode: Record "Defect Code";
        NetPackPerc: Decimal;
        TotalPackQty: Decimal;
        DailyProdReport: Date;
        DefectTxt: Text[300];
        ProductioProgLineMTD: Record "Production Programme Line";
        ProductioProgLineYTD: Record "Production Programme Line";
        cr: Char;
        lf: Char;
        StoppagesArray: array[3] of Text[100];
        StoppageTxt: Text[500];
        DeptTxt: Text[100];
        RemarksTxt: Text[300];
        PackTon: Decimal;
        PackTonTot: Decimal;
        MachineSectionStoppages: Record "Machine/Section Stoppages";
        FurnaceDraw: Decimal;
        DurationResult: Duration;
        Hours: Decimal;
        GobCutFurnace: Decimal;
        ActPackQty: Decimal;
        ActPackEff: Decimal;
        QCDQty: Decimal;
        ItemLedgerEntryFG: Record "Item Ledger Entry";
        PassQuantity: Decimal;
        MachineSecStop: Record "Machine/Section Stoppages";
        QCDetails2: Record "QC Details";
        GeneralLedgerSetup: Record "General Ledger Setup";
        DimensionSetEntry: Record "Dimension Set Entry";
        QCDetailFound: Boolean;
        CurrLineHrs: Decimal;
        AvgWt: Decimal;
}