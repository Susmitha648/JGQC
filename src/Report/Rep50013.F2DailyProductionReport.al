report 50013 "F2 Daily Production Report"
{
    ApplicationArea = All;
    Caption = 'F2 - Daily Production Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/DailyProductionReportF2.rdl';
    dataset
    {
        dataitem(ProductionProgrammeLine; "Prod Prog Temp")
        {
            UseTemporary = True;
            column(Date; "Date")
            {
            }
            column(Day; Day)
            {
            }
            column(Furnace; Furnace)
            {
            }
            column(Job; Job)
            {
            }
            column(WT; WT)
            {
            }
            column(Speed; Speed)
            {
            }
            column(Ton; Ton)
            {
            }
            column(BottlesPerMinute; "Bottles Per Minute")
            {
            }
            column(ProductionOrderNo; "Production Order No.")
            {
            }
            column(ProdOrderCreated; "Prod Order Created")
            {
            }
            column(TotalPackQty; TotalPackQty)
            {
            }
            /* column(Work_Shift; "Work Shift") { }
             column(GobCutOutPutQuantity; Quantity) { }*/

            // column(TonPerLine; TonPerLine) { }
            column(TonPerLineTot; TonPerLineTot) { }
            column(TonPerLineTot1; TonPerLineTot1) { }
            column(GobCutTot; GobCutTot) { }
            column(MTDTonnageWithDraining; MTDTonnageWithDraining) { }
            column(MTDTonnageWithOutDraining; MTDTonnageWithOutDraining) { }
            column(MTDPackTonWithDraining; MTDPackTonWithDraining) { }
            column(YTDTonnageWithDraining; YTDTonnageWithDraining) { }
            column(YTDTonnageWithOutDraining; YTDTonnageWithOutDraining) { }
            column(YTDPackTonWithDraining; YTDPackTonWithDraining) { }
            column(MTDPPDraw; MTDPPDraw) { }
            dataitem(ProdOrderLine; "Prod. Order Line")
            {
                DataItemLink = "Prod. Order No." = field("Production Order No.");
                DataItemLinkReference = "ProductionProgrammeLine";
                UseTemporary = True;
                column(Work_Shift; "Work Shift") { }
                column(GobCutOutPutQuantity; Quantity) { }
                column(TonPerLine; TonPerLine) { }
                column(GobCut; GobCut) { }
                dataitem(ItemLedgerEntry; "Item Ledger Entry")
                {
                    DataItemLink = "Document No." = field("Prod. Order No."), "Order Line No." = Field("Line No.");
                    DataItemTableView = Where("Entry Type" = Filter(Output));
                    DataItemLinkReference = ProdOrderLine;
                    column(PackQty; ItemLedgerEntry.Quantity) { }
                    column(ActPackQty; ActPackQty) { }
                    column(NetPackPerc; NetPackPerc) { }
                    column(PackTon; PackTon) { }
                    column(PackTonTot; PackTonTot) { }
                    column(DailyPackPer; DailyPackPer) { }
                    trigger OnAfterGetRecord()
                    begin
                        Clear(ActPackQty);
                        Clear(NetPackPerc);
                        Clear(PackTon);
                        If ProdOrderLine.Quantity <> 0 then begin
                            ActPackQty := Round((ItemLedgerEntry.Quantity / ProdOrderLine.Quantity) * 100);
                            NetPackPerc := Round((ItemLedgerEntry.Quantity / ProdOrderLine.Quantity) * 100, 0.1);
                            PackTon := (ItemLedgerEntry.Quantity * (ProdOrderLine."Net Weight" / 1000)) / 1000;
                            PackTonTot += (ItemLedgerEntry.Quantity * (ProdOrderLine."Net Weight" / 1000)) / 1000;
                        end;
                    end;
                }
                trigger OnAfterGetRecord()
                var
                    ProdOrderL: Record "Prod. Order Line";
                begin
                    // Clear(TonPerLineTot1);
                    If ProdOrderLine."Work Shift" = '' then begin
                        TonPerLine := ProductionProgrammeLine.Ton;
                        TonPerLineTot += ProductionProgrammeLine.Ton;

                    end else begin
                        ProdOrderL.Reset();
                        ProdOrderL.SetRange("Prod. Order No.", ProductionProgrammeLine."Production Order No.");

                        TonPerLine := ABS(ProdOrderLine.Quantity * (ProdOrderLine."Net Weight" / 1000)) / 1000;
                        TonPerLineTot += ABS(ProdOrderLine.Quantity * (ProdOrderLine."Net Weight" / 1000)) / 1000;
                        //TonPerLineTot1 += ABS(ProductionProgrammeLine.Quantity * (ProductionProgrammeLine.WT / 1000)) / 1000;
                        GobCut := ABS(ProdOrderLine.Quantity * (ProdOrderLine."Net Weight" / 1000)) / 1000;
                        GobCutTot += ABS(ProdOrderLine.Quantity * (ProdOrderLine."Net Weight" / 1000)) / 1000;

                    End;

                end;
            }
            dataitem("QC Details"; "QC Details")
            {
                DataItemLink = "Work Order No" = field("Production Order No.");
                DataItemLinkReference = ProductionProgrammeLine;
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
            trigger OnAfterGetRecord()
            begin
                Clear(TotalPackQty);
                ProdProgramLine.Reset();
                ProdProgramLine.SetRange(Furnace, ProductionProgrammeLine.Furnace);
                ProdProgramLine.SetRange("No.", ProductionProgrammeLine."No.");
                ProdProgramLine.SetFilter(Date, '<=%1', ProductionProgrammeLine.Date);
                If ProdProgramLine.FindSet() then
                    repeat
                        ProdOrdLine1.Reset();
                        ProdOrdLine1.SetRange("Prod. Order No.", ProdProgramLine."Production Order No.");
                        If ProdOrdLine1.FindSet() then
                            repeat
                                ItemLedgerEntry1.Reset();
                                ItemLedgerEntry1.SetRange("Entry Type", ItemLedgerEntry1."Entry Type"::Output);
                                ItemLedgerEntry1.SetRange("Document No.", ProdOrdLine1."Prod. Order No.");
                                ItemLedgerEntry1.SetRange("Order Line No.", ProdOrdLine1."Line No.");
                                if ItemLedgerEntry1.FindFirst() then
                                    TotalPackQty += ItemLedgerEntry1.Quantity;
                            until ProdOrdLine1.Next() = 0;
                    until ProdProgramLine.Next() = 0;
                If ProductionProgrammeLine.WT <> 0 then
                    TonPerLineTot1 += ProductionProgrammeLine.Ton;
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
        ProductionProgrammeLine.DeleteAll();
        ManufacturingSetup.Get();
        ProductionProgrammeLineFilter.Reset();
        ProductionProgrammeLineFilter.SetFilter(Furnace, '%1', 'F2*');
        ProductionProgrammeLineFilter.SetFilter("Production Order No.", '<>%1', '');
        ProductionProgrammeLineFilter.SetRange(Date, DailyProdReport);
        If ProductionProgrammeLineFilter.FindSet() then
            repeat

                ProductionProgrammeLine.Init();
                ProductionProgrammeLine.TransferFields(ProductionProgrammeLineFilter);
                /*ProductionProgrammeLine."Work Shift" := ProductionOrderLine."Work Shift";
                ProductionProgrammeLine."Line No" := ProductionOrderLine."Line No.";
                ProductionProgrammeLine.Quantity := ProductionOrderLine.Quantity;
                ProductionProgrammeLine.WT := ProductionOrderLine."Net Weight";
                ProductionProgrammeLine.Ton := ABS(ProductionOrderLine.Quantity * (ProductionOrderLine."Net Weight" / 1000)) / 1000;*/
                ProductionProgrammeLine.Insert();
                ProductionOrderLine.Reset();
                ProductionOrderLine.SetRange("Prod. Order No.", ProductionProgrammeLineFilter."Production Order No.");
                If ProductionOrderLine.FindSet() then
                    repeat
                        ProdOrderLine.Init();
                        ProdOrderLine.TransferFields(ProductionOrderLine);
                        ProdOrderLine.Insert();
                    until ProductionOrderLine.Next() = 0;
            until ProductionProgrammeLineFilter.Next() = 0;

        ItemLedgerEntryMCDrawing.Reset();
        ItemLedgerEntryMCDrawing.SetAutoCalcFields("Shortcut Dimension 8 Code");
        ItemLedgerEntryMCDrawing.SetRange("Posting Date", DailyProdReport);
        ItemLedgerEntryMCDrawing.SetFilter("Shortcut Dimension 8 Code", '%1', 'F2*');
        ItemLedgerEntryMCDrawing.SetRange("Entry Type", ItemLedgerEntryMCDrawing."Entry Type"::"Negative Adjmt.");
        ItemLedgerEntryMCDrawing.SetRange("Document Type", ItemLedgerEntryMCDrawing."Document Type"::" ");
        If ItemLedgerEntryMCDrawing.FindSet() then
            repeat
                //ItemLedgerEntryMCDrawing.CalcFields("Shortcut Dimension 8 Code");
                ProductionProgrammeLine.Init();
                ProductionProgrammeLine."No." := ItemLedgerEntryMCDrawing."Document No.";
                ProductionProgrammeLine.Date := DailyProdReport;
                ProductionProgrammeLine.Furnace := ItemLedgerEntryMCDrawing."Shortcut Dimension 8 Code";
                ProductionProgrammeLine.Ton := ABS(ItemLedgerEntryMCDrawing.Quantity / 1000);
                ProductionProgrammeLine.Job := 'MC DRAINING';
                ProductionProgrammeLine."Production Order No." := ItemLedgerEntryMCDrawing."Document No.";
                ProductionProgrammeLine.Insert();
                ProdOrderLine.Init();
                ProdOrderLine."Prod. Order No." := ItemLedgerEntryMCDrawing."Document No.";
                ProdOrderLine."Line No." := ItemLedgerEntryMCDrawing."Entry No.";
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
        ProdOrdLine1: Record "Prod. Order Line";
        ProdProgramLine: Record "Production Programme Line";
        ItemLedgerEntryMTD: Record "Item Ledger Entry";
        ItemLedgerEntryMTDPackTon: Record "Item Ledger Entry";
        ItemLedgerEntryYTD: Record "Item Ledger Entry";
        ProdProgramLinetemp: Record "Production Programme Line" temporary;
        ItemLedgerEntry1: Record "Item Ledger Entry";
        DefectCodeArray: array[3] of Text[100];
        DefectCode: Record "Defect Code";
        ActPackQty: Decimal;
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
}