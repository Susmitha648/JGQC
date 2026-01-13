codeunit 50006 "FG PutAway Queue"
{
    trigger OnRun()
    begin
        PostWareReceipts();
        ReservationEntry.Reset();
        ReservationEntry.SetRange("Recording Slip Printed", True);
        ReservationEntry.SetRange("Output Posted", false);
        If ReservationEntry.FindSet() then begin
            repeat
                FGPostingTracking.Reset();
                FGPostingTracking.SetRange("Source ID", ReservationEntry."Source ID");
                FGPostingTracking.SetRange("Serial No.", ReservationEntry."Serial No.");
                If not FGPostingTracking.FindFirst() then begin
                    FGPostingTracking.Init();
                    FGPostingTracking."Source ID" := ReservationEntry."Source ID";
                    FGPostingTracking."Serial No." := ReservationEntry."Serial No.";
                    FGPostingTracking.Insert()
                end;
                FGPostingTracking."Source Prod. Order Line" := ReservationEntry."Source Prod. Order Line";
                FGPostingTracking."Creation Date" := WorkDate();
                FGPostingTracking."Item No." := ReservationEntry."Item No.";
                FGPostingTracking.Rejected := ReservationEntry.Rejected;
                FGPostingTracking."Transferred from Entry No." := ReservationEntry."Entry No.";
                FGPostingTracking.Status := FGPostingTracking.Status::Inserted;
                FGPostingTracking.Modify();
            until ReservationEntry.Next() = 0;
        end;
        FGPostingTracking1.Reset();
        FGPostingTracking1.SetFilter(Status, '%1|%2', FGPostingTracking1.Status::Inserted, FGPostingTracking1.Status::Error);
        FGPostingTracking1.SetRange("Output Posted", false);
        If FGPostingTracking1.FindSet() then
            repeat
                Commit();
                If not Codeunit.Run(CodeUnit::"FG Putaway", FGPostingTracking1) then begin
                    FGPostingTracking1.Status := FGPostingTracking1.Status::Error;
                    FGPostingTracking1."Creation Date" := WorkDate();
                    FGPostingTracking1."Error Text" := GetLastErrorText();
                    FGPostingTracking1.Modify();
                end else begin
                    FGPostingTracking1.Status := FGPostingTracking1.Status::Sucess;
                    FGPostingTracking1.Modify();
                end;
            until FGPostingTracking1.Next() = 0;
    end;

    var
        ReservationEntry: Record "Reservation Entry";
        FGPostingError: Record "FG Posting Error Log";
        FGPostingError1: Record "FG Posting Error Log";
        FGPostingError2: Record "FG Posting Error Log";
        RESourceID: Code[20];
        RESerialNo: Code[50];
        FGPostingTracking: Record "FG Posting Tracking";
        FGPostingTracking1: Record "FG Posting Tracking";
         FGPostingTrack: Record "FG Posting Tracking";
         WhseReceiptLine1: Record "Warehouse Receipt Line";
         WhsePostReceipt1: Codeunit "Whse.-Post Receipt";

    procedure PostWareReceipts()
    begin
        FGPostingTrack.Reset();
        FGPostingTrack.SetRange("Output Posted", True);
        FGPostingTrack.SetRange("Transfer Shipment Posted", True);
        FGPostingTrack.SetRange("Transfer Receipt Posted", false);
        FGPostingTrack.SetFilter("Warehouse Receipt No", '<>%1', '');
        If FGPostingTrack.FindSet() then
            repeat
                WhseReceiptLine1.Reset();
                WhseReceiptLine1.SetRange("No.", FGPostingTrack."Warehouse Receipt No");
                If WhseReceiptLine1.FindFirst() then
                    WhsePostReceipt1.Run(WhseReceiptLine1);
            until FGPostingTrack.Next() = 0;
    end;
}
