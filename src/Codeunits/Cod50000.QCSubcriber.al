codeunit 50000 "QC Subcriber"
{
    SingleInstance = true;
    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', false, false)]
    local procedure OnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
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
    local procedure OnAfterCreateDim(var ProductionOrder: Record "Production Order"; DefaultDimSource: List of [Dictionary of [Integer, Code[20]]])
    var
        ProductionProgramme: Record "Production Programme Line";
        DimMgt: Codeunit DimensionManagement;
        NewDimSetID: Integer;
        OldDimSetID: Integer;
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimSetEntry: Record "Dimension Set Entry";
    begin
        /*If ProductionOrder."Inventory Posting Group" = 'PB' then begin
            ProductionProgramme.Reset();
            ProductionProgramme.SetRange(Job, ProductionOrder."Source No.");
            ProductionProgramme.SetRange(Date, ProductionOrder."Due Date");
            If ProductionProgramme.FindFirst() then begin
                OldDimSetID := ProductionOrder."Dimension Set ID";
                DimMgt.GetDimensionSet(TempDimSetEntry, OldDimSetID);

                //assign new/update existing dimension with data from external system
                TempDimSetEntry.Reset();
                TempDimSetEntry.SetRange("Dimension Code", ProductionOrderDimensionCode);
                if TempDimSetEntry.FindFirst() then begin
                    TempDimSetEntry.Validate("Dimension Value Code", DimensionValue);
                    TempDimSetEntry.Modify();
                end

                else begin
                    TempDimSetEntry.Init();
                    TempDimSetEntry.Validate("Dimension Code", DimensionCode);
                    TempDimSetEntry.Validate("Dimension Value Code", DimensionValue);
                    TempDimSetEntry.Insert();
                end;

                //obtain DimSetID after line dimension update
                NewDimSetID := DimMgt.GetDimensionSetID(TempDimSetEntry);

                //update line dimension set id 
                if OldDimSetID <> NewDimSetID then begin
                    PurchaseLine."Dimension Set ID" := NewDimSetID;
                    PurchaseLine.Modify();
                end;

                //update line's global dimensions
                DimMgt.UpdateGlobalDimFromDimSetID(PurchaseLine."Dimension Set ID", PurchaseLine."Shortcut Dimension 1 Code", PurchaseLine."Shortcut Dimension 2 Code");
            end;
        end;*/

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

