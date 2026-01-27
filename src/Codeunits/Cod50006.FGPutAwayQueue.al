codeunit 50006 "FG PutAway Queue"
{
    trigger OnRun()
    begin
     //staging preparation
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
                    FGPostingTracking1."Creation Date" := WorkDate();
                    FGPostingTracking1."Error Text" := '';
                    FGPostingTracking1."Output Posted" := True;
                    FGPostingTracking1.Modify();
                end;
            until FGPostingTracking1.Next() = 0;

        FGPostingTrackShip.Reset();
        FGPostingTrackShip.SetRange("Output Posted", True);
        FGPostingTrackShip.SetRange("Transfer Shipment Posted", false);
        FGPostingTrackShip.SetRange("Transfer Receipt Posted", false);
        //FGPostingTrack.SetFilter("Warehouse Receipt No", '<>%1', '');
        If FGPostingTrackShip.FindSet() then
            repeat
                Commit();
                If not Codeunit.Run(CodeUnit::"Post Shipment Receipts", FGPostingTrackShip) then begin
                    FGPostingTrackShip."Error Text" := GetLastErrorText();
                    FGPostingTrackShip.Modify();
                end else begin
                    FGPostingTrackShip."Creation Date" := WorkDate();
                    FGPostingTrackShip."Error Text" := '';
                    FGPostingTrackShip."Transfer Shipment Posted" := True;
                    FGPostingTrackShip.Modify();
                end;
            until FGPostingTrackShip.Next() = 0;

        FGPostingTrack.Reset();
        FGPostingTrack.SetRange("Output Posted", True);
        FGPostingTrack.SetRange("Transfer Shipment Posted", True);
        FGPostingTrack.SetRange("Transfer Receipt Posted", false);
        //FGPostingTrack.SetFilter("Warehouse Receipt No", '<>%1', '');
        If FGPostingTrack.FindSet() then
            repeat
                Commit();
                If not Codeunit.Run(CodeUnit::"Ware Receipts Posting", FGPostingTrack) then begin
                    FGPostingTrack."Error Text" := GetLastErrorText();
                    FGPostingTrack."Receipt Posting Attempt" += 1;
                    FGPostingTrack.Modify();
                    //If FGPostingTrack."Receipt Posting Attempt" = 2 then
                     // If Codeunit.Run(CodeUnit::"UndoShipment Post", FGPostingTrack) then;
                end else begin
                    FGPostingTrack."Error Text" := '';
                    FGPostingTrack."Transfer Receipt Posted" := True;
                    FGPostingTrack.Status := FGPostingTrack.Status::Sucess;
                    FGPostingTrack.Modify();
                end;
            until FGPostingTrack.Next() = 0;


       
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
        FGPostingTrackShip: Record "FG Posting Tracking";
        WhseReceiptLine1: Record "Warehouse Receipt Line";
        WhsePostReceipt1: Codeunit "Whse.-Post Receipt";
}
