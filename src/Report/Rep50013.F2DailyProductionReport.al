report 50013 "F2 Daily Production Report"
{
    ApplicationArea = All;
    Caption = 'F2 - Daily Production Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/DailyProductionReportF2.rdl';
    dataset
    {
        dataitem(ProductionProgrammeLine; "Production Programme Line")
        {
            RequestFilterFields = Date, "No.";
            column(No; "No.")
            {
            }
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
            column(Tray; Tray)
            {
            }
            column(Pallet; Pallet)
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
            dataitem("Production Order"; "Production Order")
            {
                DataItemLink = "No." = field("Production Order No.");
                DataItemLinkReference = ProductionProgrammeLine;
                column(Description; Description) { }
                dataitem(ProdOrderLine; "Prod. Order Line")
                {
                    DataItemLink = "Prod. Order No." = field("No.");
                    DataItemLinkReference = "Production Order";
                    column(Work_Shift; "Work Shift") { }
                    column(GobCutOutPutQuantity; Quantity) { }
                    column(TonPerLine; TonPerLine) { }
                    dataitem(ItemLedgerEntry; "Item Ledger Entry")
                    {
                        DataItemLink = "Document No." = field("Prod. Order No."), "Order Line No." = Field("Line No.");
                        DataItemTableView = Where("Entry Type" = Filter(Output));
                        DataItemLinkReference = ProdOrderLine;
                        column(PackQty; ItemLedgerEntry.Quantity) { }
                        column(ActPackQty; ActPackQty) { }
                        column(NetPackPerc; NetPackPerc) { }
                        column(PackTon; PackTon) { }
                        trigger OnAfterGetRecord()
                        begin
                            If ProdOrderLine.Quantity <> 0 then begin
                                ActPackQty := Round((ItemLedgerEntry.Quantity / ProdOrderLine.Quantity) * 100);
                                NetPackPerc := Round((ItemLedgerEntry.Quantity / ProdOrderLine.Quantity) * 100, 0.1);
                            end;

                            PackTon := (ItemLedgerEntry.Quantity * TonPerLine) / ProdOrderLine.Quantity;
                        end;
                    }
                    trigger OnAfterGetRecord()
                    begin

                        Clear(TonPerLine);
                        ProdOrdLine.Reset();
                        ProdOrdLine.SetRange("Prod. Order No.", ProductionProgrammeLine."Production Order No.");
                        If ProdOrdLine.Count > 1 then
                            TonPerLine := ProductionProgrammeLine.Ton / ProdOrdLine.Count
                        Else
                            TonPerLine := ProductionProgrammeLine.Ton;
                    end;
                }
                dataitem("QC Details"; "QC Details")
                {
                    DataItemLink = "Work Order No" = field("No.");
                    DataItemLinkReference = "Production Order";
                    column(MachineNo; "Machine No.") { }
                    column(Shift1; Shift) { }
                    column(IRIZ; "IRIZ %") { }
                    column(SL; "SL %") { }
                    column(DefectCodeArray1; DefectTxt) { }
                    column(DeptTxt; DeptTxt) {}
                    column(RemarksTxt; RemarksTxt) {}
                    column(StoppageTxt; StoppageTxt) {}
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
                        StoppageTxt := CopyStr(StoppageTxt, 1, StrLen(StoppageTxt) - 2);
                        RemarksTxt := CopyStr(RemarksTxt, 1, StrLen(RemarksTxt) - 2);
                        DeptTxt := CopyStr(DeptTxt, 1, StrLen(DeptTxt) - 2);
                    end;
                }
            }
            trigger OnPreDataItem()
            begin
                ProductionProgrammeLine.SetFilter(Furnace, '%1', 'F2*');
                ProductionProgrammeLine.SetFilter("Production Order No.", '<>%1', '');
            end;

            trigger OnAfterGetRecord()
            begin

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

            end;
        }
    }

    var
        TonPerLine: Decimal;
        ProdOrdLine: Record "Prod. Order Line";
        ProdOrdLine1: Record "Prod. Order Line";
        ProdProgramLine: Record "Production Programme Line";
        ItemLedgerEntry1: Record "Item Ledger Entry";
        DefectCodeArray: array[3] of Text[100];
        DefectCode: Record "Defect Code";
        ActPackQty: Decimal;
        NetPackPerc: Decimal;
        TotalPackQty: Integer;
        DefectTxt: Text[300];
        cr: Char;
        lf: Char;
        StoppagesArray: array[3] of Text[100];
        StoppageTxt: Text[500];
        DeptTxt : Text[100];
        RemarksTxt : Text[300];
        PackTon: Decimal;
        MachineSectionStoppages: Record "Machine/Section Stoppages";
}