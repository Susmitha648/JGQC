report 50020 "F2 Daily Production Report New"
{
    ApplicationArea = All;
    Caption = 'F2 - Daily Production Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/DailyProductionReportF2New.rdl';
    dataset
    {
        dataitem(ProdOrderLine; "Prod. Order Line")
        {
            UseTemporary = True;
            column(Work_Shift; "Work Shift") { }
            column(GobCutOutPutQuantity; Quantity) { }
            column(TonPerLine; TonPerLine) { }
            column(GobCut; GobCut) { }
            column(MTDTonnageWithDraining; MTDTonnageWithDraining) { }
            column(MTDTonnageWithOutDraining; MTDTonnageWithOutDraining) { }
            column(MTDPackTonWithDraining; MTDPackTonWithDraining) { }
            column(YTDTonnageWithDraining; YTDTonnageWithDraining) { }
            column(YTDTonnageWithOutDraining; YTDTonnageWithOutDraining) { }
            column(YTDPackTonWithDraining; YTDPackTonWithDraining) { }
            column(MTDPPDraw; MTDPPDraw) { }
            column(TotalPackQty; TotalPackQty) { }
            column(TonPerLineTot; TonPerLineTot) { }
            column(TonPerLineTot1; TonPerLineTot1) { }
            column(GobCutTot; GobCutTot) { }
            column(Furnace; '') { }
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
                Hours := ("Ending Time WO" - "Starting Time WO") / 3600000;
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

                ActPackEff := Round((ActPackQty / GobCut) * 100);
                PassQuantity := ActPackQty - QCDQty;
                PackTon := ("Net Weight" * PassQuantity) / 1000000;
                NetPackPerc := Round((PassQuantity/GobCut) * 100,0.1);
            end;
        }
        dataitem("QC Details"; "QC Details")
        {
            //DataItemLink = "Work Order No" = field("Production Order No.");
            //DataItemLinkReference = ProductionProgrammeLine;
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
                MachineSectionStoppages.SetRange("Production Order No.", "QC Details"."Work Order No");
                MachineSectionStoppages.SetRange(Shift, "QC Details".Shift);
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
        ProdOrderLine.DeleteAll();
        ManufacturingSetup.Get();

        ProductionOrderLine.Reset();
        ProductionOrderLine.SetRange("Due Date", DailyProdReport);
        ProductionOrderLine.SetFilter("Work Shift", '<>%1', '');
        //ProductionOrderLine.SetFilter(Furnace, '%1', 'F2*');
        ProductionOrderLine.SetRange("Inventory Posting Group", 'PB');
        If ProductionOrderLine.FindSet() then
            repeat
                ProdOrderLine.Init();
                ProdOrderLine.TransferFields(ProductionOrderLine);
                ProdOrderLine.Insert();
            until ProductionOrderLine.Next() = 0;


        ItemLedgerEntryMCDrawing.Reset();
        ItemLedgerEntryMCDrawing.SetAutoCalcFields("Shortcut Dimension 8 Code");
        ItemLedgerEntryMCDrawing.SetRange("Posting Date", DailyProdReport);
        ItemLedgerEntryMCDrawing.SetFilter("Shortcut Dimension 8 Code", '%1', 'F2*');
        ItemLedgerEntryMCDrawing.SetRange("Entry Type", ItemLedgerEntryMCDrawing."Entry Type"::"Positive Adjmt.");
        ItemLedgerEntryMCDrawing.SetRange("Document Type", ItemLedgerEntryMCDrawing."Document Type"::" ");
        If ItemLedgerEntryMCDrawing.FindSet() then
            repeat
                //ItemLedgerEntryMCDrawing.CalcFields("Shortcut Dimension 8 Code");
                ProdOrderLine.Init();
                ProdOrderLine."Prod. Order No." := ItemLedgerEntryMCDrawing."Document No.";
                ProdOrderLine."Line No." := ItemLedgerEntryMCDrawing."Entry No.";
                ProdOrderLine."Due Date" := ItemLedgerEntryMCDrawing."Posting Date";
                //ProdOrderLine.Furnace := ItemLedgerEntryMCDrawing."Shortcut Dimension 8 Code";
                ProdOrderLine.Quantity := ItemLedgerEntryMCDrawing.Quantity;
                ProdOrderLine.Insert();
            until ItemLedgerEntryMCDrawing.Next() = 0;

        ProductioProgLineMTD.Reset();
        ProductioProgLineMTD.SetRange(Date, CalcDate('<-CM>', DailyProdReport), DailyProdReport);
        ProductioProgLineMTD.SetFilter(Furnace, '%1', 'F2*');
        ProductioProgLineMTD.SetFilter("Production Order No.", '<>%1', '');
        If ProductioProgLineMTD.FindSet() then
            repeat
                MTDPPDraw += ProductioProgLineMTD.Ton;
                ProductionOrderLine.Reset();
                ProductionOrderLine.SetRange("Prod. Order No.", ProductioProgLineMTD."Production Order No.");
                If ProductionOrderLine.FindSet() then
                    repeat
                        ItemLedgerEntryMTDPackTon.Reset();
                        ItemLedgerEntryMTDPackTon.SetRange("Entry Type", ItemLedgerEntryMTDPackTon."Entry Type"::Output);
                        ItemLedgerEntryMTDPackTon.SetRange("Document No.", ProductionOrderLine."Prod. Order No.");
                        ItemLedgerEntryMTDPackTon.SetRange("Order Line No.", ProductionOrderLine."Line No.");
                        If ItemLedgerEntryMTDPackTon.FindSet() then
                            repeat
                                MTDPackTonWithDraining += (ItemLedgerEntryMTDPackTon.Quantity * (ProductionOrderLine."Net Weight" / 1000)) / 1000;
                            until ItemLedgerEntryMTDPackTon.Next() = 0;
                        MTDTonnageWithDraining += ABS(ProductionOrderLine.Quantity * (ProductionOrderLine."Net Weight" / 1000)) / 1000;
                        MTDTonnageWithOutDraining += ABS(ProductionOrderLine.Quantity * (ProductionOrderLine."Net Weight" / 1000)) / 1000;
                    until ProductionOrderLine.Next() = 0;
            until ProductioProgLineMTD.Next() = 0;

        ItemLedgerEntryMTD.Reset();
        ItemLedgerEntryMTD.SetAutoCalcFields("Shortcut Dimension 8 Code");
        ItemLedgerEntryMTD.SetRange("Posting Date", DailyProdReport);
        ItemLedgerEntryMTD.SetFilter("Shortcut Dimension 8 Code", '%1', 'F2*');
        ItemLedgerEntryMTD.SetRange("Entry Type", ItemLedgerEntryMCDrawing."Entry Type"::"Negative Adjmt.");
        ItemLedgerEntryMTD.SetRange("Document Type", ItemLedgerEntryMCDrawing."Document Type"::" ");
        If ItemLedgerEntryMTD.FindSet() then
            repeat
                MTDTonnageWithDraining += ABS(ItemLedgerEntryMTD.Quantity / 1000);
            until ItemLedgerEntryMTD.Next() = 0;

        // YTD 
        ProductioProgLineYTD.Reset();
        ProductioProgLineYTD.SetRange(Date, CalcDate('<-CY>', DailyProdReport), DailyProdReport);
        ProductioProgLineYTD.SetFilter(Furnace, '%1', 'F2*');
        ProductioProgLineYTD.SetFilter("Production Order No.", '<>%1', '');
        If ProductioProgLineYTD.FindSet() then
            repeat
                ProductionOrderLine.Reset();
                ProductionOrderLine.SetRange("Prod. Order No.", ProductioProgLineYTD."Production Order No.");
                If ProductionOrderLine.FindSet() then
                    repeat
                        ItemLedgerEntryMTDPackTon.Reset();
                        ItemLedgerEntryMTDPackTon.SetRange("Entry Type", ItemLedgerEntryMTDPackTon."Entry Type"::Output);
                        ItemLedgerEntryMTDPackTon.SetRange("Document No.", ProductionOrderLine."Prod. Order No.");
                        ItemLedgerEntryMTDPackTon.SetRange("Order Line No.", ProductionOrderLine."Line No.");
                        If ItemLedgerEntryMTDPackTon.FindSet() then
                            repeat
                                YTDPackTonWithDraining += (ItemLedgerEntryMTDPackTon.Quantity * (ProductionOrderLine."Net Weight" / 1000)) / 1000;
                            until ItemLedgerEntryMTDPackTon.Next() = 0;
                        YTDTonnageWithDraining += ABS(ProductionOrderLine.Quantity * (ProductionOrderLine."Net Weight" / 1000)) / 1000;
                        YTDTonnageWithOutDraining += ABS(ProductionOrderLine.Quantity * (ProductionOrderLine."Net Weight" / 1000)) / 1000;
                    until ProductionOrderLine.Next() = 0;
            until ProductioProgLineYTD.Next() = 0;

        ItemLedgerEntryYTD.Reset();
        ItemLedgerEntryYTD.SetAutoCalcFields("Shortcut Dimension 8 Code");
        ItemLedgerEntryYTD.SetRange("Posting Date", DailyProdReport);
        ItemLedgerEntryYTD.SetFilter("Shortcut Dimension 8 Code", '%1', 'F2*');
        ItemLedgerEntryYTD.SetRange("Entry Type", ItemLedgerEntryMCDrawing."Entry Type"::"Negative Adjmt.");
        ItemLedgerEntryYTD.SetRange("Document Type", ItemLedgerEntryMCDrawing."Document Type"::" ");
        If ItemLedgerEntryYTD.FindSet() then
            repeat
                YTDTonnageWithDraining += ABS(ItemLedgerEntryYTD.Quantity / 1000);
            until ItemLedgerEntryYTD.Next() = 0;

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
        ProdOrdLine: Record "Prod. Order Line";
        ProdOrdLineFG: Record "Prod. Order Line";
        ProdOrdLine1: Record "Prod. Order Line";
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
        PassQuantity : Decimal;
}