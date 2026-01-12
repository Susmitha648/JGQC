codeunit 50006 "FG PutAway Queue"
{
    trigger OnRun()
    begin
        ReservationEntry.Reset();
        ReservationEntry.SetRange("Recording Slip Printed", True);
        ReservationEntry.SetRange("Output Posted", false);
        If ReservationEntry.FindSet() then begin
            repeat
                 FGPostingTracking.Reset();
                 FGPostingTracking.SetRange("Source ID",ReservationEntry."Source ID");
                 FGPostingTracking.SetRange("Serial No.",ReservationEntry."Serial No.");
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
        FGPostingTracking1.SetRange(Status,FGPostingTracking1.Status::Inserted);
        If FGPostingTracking1.FindSet() then 
            repeat
                Commit();
                 RESourceID := FGPostingTracking1."Source ID";
                 RESerialNo := FGPostingTracking1."Serial No.";
                If not Codeunit.Run(CodeUnit::"FG Putaway", FGPostingTracking1) then begin
                    FGPostingTracking1.Status := FGPostingTracking1.Status::Error;
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
        RESourceID : Code[20];
        RESerialNo : Code[50];
        FGPostingTracking : Record "FG Posting Tracking";
        FGPostingTracking1 : Record "FG Posting Tracking";
}
