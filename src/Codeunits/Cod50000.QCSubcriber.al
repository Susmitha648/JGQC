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
                    if MachineSectionStoppages.Get(DocumentAttachment."No.",DocumentAttachment."Line No.") then
                        RecRef.GetTable(MachineSectionStoppages);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
         LineNo : Integer;
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
        LineNo : Integer;
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

    Procedure SetProductionHdr(ProductionHdr: Record "Production Order")
    begin
        ProductionOrder := ProductionHdr;
    end;

    Procedure GetProductionHdr(): Code[20];
    begin
        Exit(ProductionOrder."No.");
    end;

    var
        ProductionOrder: Record "Production Order";
}

