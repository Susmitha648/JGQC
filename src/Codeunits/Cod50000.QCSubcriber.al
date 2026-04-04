codeunit 50000 "QC Subcriber"
{
    SingleInstance = true;
    [EventSubscriber(ObjectType::Page, Page::"Doc. Attachment List Factbox", 'OnAfterGetRecRefFail', '', false, false)]
    local procedure OnBeforeDrillDown(var Sender: Page "Doc. Attachment List Factbox"; DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        CustComplLog: Record "Customer Complaint Log";
        CustComplRep: Record "Customer Complaint Report";
        QCPlanHdr: Record "QC Plan Header";
        MachineSectionStoppages: Record "Machine/Section Stoppages";
    begin
        case DocumentAttachment."Table ID" of
            DATABASE::"Customer Complaint Log":
                begin
                    RecRef.Open(DATABASE::"Customer Complaint Log");
                    if CustComplLog.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(CustComplLog);
                end;
        end;
        case DocumentAttachment."Table ID" of
            DATABASE::"Customer Complaint Report":
                begin
                    RecRef.Open(DATABASE::"Customer Complaint Report");
                    if CustComplRep.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(CustComplRep);
                end;
        end;
        case DocumentAttachment."Table ID" of
            DATABASE::"QC Plan Header":
                begin
                    RecRef.Open(DATABASE::"QC Plan Header");
                    if QCPlanHdr.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(QCPlanHdr);
                end;
        end;
        case DocumentAttachment."Table ID" of
            DATABASE::"Machine/Section Stoppages":
                begin
                    RecRef.Open(DATABASE::"Machine/Section Stoppages");
                    if MachineSectionStoppages.Get(DocumentAttachment."No.", DocumentAttachment."Line No.") then
                        RecRef.GetTable(MachineSectionStoppages);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        LineNo: Integer;
    begin
        case RecRef.Number of
            DATABASE::"Customer Complaint Log":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;
        case RecRef.Number of
            DATABASE::"Customer Complaint Report":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;
        case RecRef.Number of
            DATABASE::"QC Plan Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;
        case RecRef.Number of
            DATABASE::"Machine/Section Stoppages":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                    FieldRef := RecRef.Field(2);
                    LineNo := FieldRef.Value;
                    DocumentAttachment.SetRange("Line No.", LineNo);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', false, false)]
    local procedure OnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        LineNo: Integer;
    begin
        case RecRef.Number of
            DATABASE::"Customer Complaint Log":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
        end;
        case RecRef.Number of
            DATABASE::"Customer Complaint Report":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
        end;
        case RecRef.Number of
            DATABASE::"QC Plan Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
        end;
        case RecRef.Number of
            DATABASE::"Machine/Section Stoppages":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                    FieldRef := RecRef.Field(2);
                    LineNo := FieldRef.Value;
                    DocumentAttachment.Validate("Line No.", LineNo);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Refresh Production Order", 'OnAfterOnInit', '', false, false)]
    local procedure OnAfterOnInitPreprod(var Direction: Option; var CalcLines: Boolean)
    var
        Direction1: Option Forward,Backward;
    begin
        Direction := Direction1::Forward;
        CalcLines := false;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Production Order", 'OnAfterValidateEvent', 'Location Code', false, false)]
    local procedure UpdateLineLocationCode(var Rec: Record "Production Order"; var xRec: Record "Production Order"; CurrFieldNo: Integer)
    var
        ProdOrderLine: Record "Prod. Order Line";
    begin
        ProdOrderLine.Reset();
        ProdOrderLine.SetRange("Prod. Order No.", Rec."No.");
        If ProdOrderLine.FindSet(True) then
            repeat
                ProdOrderLine.Validate("Location Code", Rec."Location Code");
                ProdOrderLine.Modify();
            until ProdOrderLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnAfterCreatePutAwayDoc', '', false, false)]
    local procedure UpdateSerialNo(var WarehouseReceiptHeader: Record "Warehouse Receipt Header"; var CounterPutAways: Integer; var WhseActivHeader: Record "Warehouse Activity Header")
    var
        WarehouseActivityH: Record "Warehouse Activity Header";
        WareActivityLine: Record "Warehouse Activity Line";
    begin

        WareActivityLine.Reset();
        WareActivityLine.SetRange("Activity Type", WareActivityLine."Activity Type"::"Put-away");
        WareActivityLine.SetRange("No.", WhseActivHeader."No.");
        WareActivityLine.Setfilter("Serial No.", '<>%1', '');
        If WareActivityLine.FindFirst() then begin
            WarehouseActivityH.Reset();
            WarehouseActivityH.SetRange(Type, WarehouseActivityH.Type::"Put-away");
            WarehouseActivityH.SetRange("No.", WareActivityLine."No.");
            If WarehouseActivityH.FindFirst() then begin
                WarehouseActivityH."External Document No.2" := WareActivityLine."Serial No.";
                WarehouseActivityH.Modify();
            end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Register", 'OnAfterRegisterWhseActivity', '', false, false)]
    local procedure UpdateRegisterMarked(var WarehouseActivityHeader: Record "Warehouse Activity Header")
    var
        PutAway: Record "Put Away";
    begin
        PutAway.Reset();
        PutAway.SetRange("Serial No", WarehouseActivityHeader."External Document No.2");
        If PutAway.FindFirst() then begin
            PutAway.Registered := True;
            PutAway.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post", 'OnBeforeCode', '', false, false)]
    local procedure OnBeforeCodeCheckWorkCenter(var ItemJournalLine: Record "Item Journal Line"; var HideDialog: Boolean; var SuppressCommit: Boolean; var IsHandled: Boolean)
    var
        ManufSetup: Record "Manufacturing Setup";
        DimensionSetEntry: Record "Dimension Set Entry";
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        ManufSetup.Get();
        GeneralLedgerSetup.Get();
        If ItemJournalLine."Journal Batch Name" = ManufSetup."Machine Draining Batch" then begin
            DimensionSetEntry.Reset();
            DimensionSetEntry.SetRange("Dimension Set ID", ItemJournalLine."Dimension Set ID");
            DimensionSetEntry.SetRange("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 8 Code");
            If Not DimensionSetEntry.FindFirst() then
                Error('Dimension Work Center Code should have value');
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Line", 'OnBeforeBinContentInsert', '', false, false)]
    local procedure OnBeforeBinContentInsert(var BinContent: Record "Bin Content"; WarehouseEntry: Record "Warehouse Entry"; Bin: Record Bin);
    var
        PutAway: Record "Put Away";
        Location: Record Location;
    begin
        If Location.Get(Bin."Location Code") then
            If Location."Skip Default Bin Update" then begin
                BinContent.Default := false;
                BinContent.Fixed := false;
            end;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Production Order", 'OnAfterCreateDim', '', false, false)]
    local procedure OnAfterCreateDimOnAfterCreateDim(var ProductionOrder: Record "Production Order"; DefaultDimSource: List of [Dictionary of [Integer, Code[20]]])

    var
        ProductionProgramme: Record "Production Programme Line";
        DimMgt: Codeunit DimensionManagement;
        NewDimSetID: Integer;
        OldDimSetID: Integer;
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimSetEntry: Record "Dimension Set Entry";
        GeneralLedgerSetup: Record "General Ledger Setup";
        ProdOrderLine: Record "Prod. Order Line";
        LineOldDimSetID: Integer;
        LineNewDimSetID: Integer;
    begin
        GeneralLedgerSetup.Get();
        If ProductionOrder."Inventory Posting Group" = 'PB' then begin
            ProductionProgramme.Reset();
            ProductionProgramme.SetRange(Job, ProductionOrder."Source No.");
            ProductionProgramme.SetRange(Date, ProductionOrder."Due Date");
            If ProductionProgramme.FindFirst() then begin
                OldDimSetID := ProductionOrder."Dimension Set ID";
                DimMgt.GetDimensionSet(TempDimSetEntry, OldDimSetID);

                //assign new/update existing dimension with data from external system
                TempDimSetEntry.Init();
                TempDimSetEntry.Validate("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 8 Code");
                TempDimSetEntry.Validate("Dimension Value Code", ProductionProgramme.Furnace);
                TempDimSetEntry.Insert();


                //obtain DimSetID after line dimension update
                NewDimSetID := DimMgt.GetDimensionSetID(TempDimSetEntry);

                //update line dimension set id 
                if OldDimSetID <> NewDimSetID then begin
                    ProductionOrder."Dimension Set ID" := NewDimSetID;
                    ProductionOrder.Modify();
                end;

                //update line's global dimensions
                ProdOrderLine.Reset();
                ProdOrderLine.SetRange("Prod. Order No.", ProductionOrder."No.");
                ProdOrderLine.SetRange(Status, ProdOrderLine.Status::Released);
                ProdOrderLine.SetRange("Inventory Posting Group", 'PB');
                ProdOrderLine.SetRange("Item No.", ProductionOrder."Source No.");
                If ProdOrderLine.FindSet(true) then
                    repeat
                        LineOldDimSetID := ProdOrderLine."Dimension Set ID";
                        LineNewDimSetID := DimMgt.GetDeltaDimSetID(ProdOrderLine."Dimension Set ID", NewDimSetID, OldDimSetID);
                        if ProdOrderLine."Dimension Set ID" <> LineNewDimSetID then begin
                            ProdOrderLine."Dimension Set ID" := LineNewDimSetID;
                            DimMgt.UpdateGlobalDimFromDimSetID(
                              ProdOrderLine."Dimension Set ID", ProdOrderLine."Shortcut Dimension 1 Code", ProdOrderLine."Shortcut Dimension 2 Code");
                            ProdOrderLine.Modify();
                            ProdOrderLine.UpdateProdOrderCompDim(LineNewDimSetID, LineOldDimSetID);
                        end;
                    until ProdOrderLine.Next() = 0;
            end;
        end;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Prod. Order Line", 'OnAfterCreateDim', '', false, false)]
    local procedure OnAfterCreateDimLine(var ProdOrderLine: Record "Prod. Order Line"; DefaultDimSource: List of [Dictionary of [Integer, Code[20]]])

    var
        ProductionProgramme: Record "Production Programme Line";
        DimMgt: Codeunit DimensionManagement;
        NewDimSetID: Integer;
        OldDimSetID: Integer;
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimSetEntry: Record "Dimension Set Entry";
        GeneralLedgerSetup: Record "General Ledger Setup";
        LineOldDimSetID: Integer;
        LineNewDimSetID: Integer;
        ProdOrder: Record "Production Order";
    begin
        GeneralLedgerSetup.Get();
        If (ProdOrderLine."Inventory Posting Group" = 'PB') and not (ProdOrderLine."Line No." = 0) then
            If ProdOrder.Get(ProdOrder.Status::Released, ProdOrderLine."Prod. Order No.") then begin
                //update line's global dimensions

                if ProdOrderLine."Dimension Set ID" <> ProdOrder."Dimension Set ID" then begin
                    ProdOrderLine."Dimension Set ID" := ProdOrder."Dimension Set ID";
                    DimMgt.UpdateGlobalDimFromDimSetID(
                      ProdOrderLine."Dimension Set ID", ProdOrderLine."Shortcut Dimension 1 Code", ProdOrderLine."Shortcut Dimension 2 Code");
                    ProdOrderLine.Modify();
                end;
            end;

    end;

    Procedure SetProductionHdr(ProductionHdr: Record "Production Order")
    begin
        ProductionOrder := ProductionHdr;
    end;

    Procedure GetProductionHdr(): Code[20];
    begin
        Exit(ProductionOrder."No.");
    end;

    procedure Set(SerialNo: Code[50])
    begin

        GSerialNo := SerialNo;
    end;

    procedure Get(): Code[50];
    begin

        Exit(GSerialNo);
    end;

    procedure SetRejected()
    begin
        SetRejectedVar := True;
    end;

    procedure GetRejected(): Boolean
    begin
        Exit(SetRejectedVar);
    end;


    var
        ProductionOrder: Record "Production Order";
        ProdOrderLine: Record "Prod. Order Line";
        GSerialNo: Code[50];
        SetRejectedVar: Boolean;
}

