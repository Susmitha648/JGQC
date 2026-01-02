codeunit 50004 "FG Posting Queue"
{
    trigger OnRun()
    begin
        ReservationEntry.Reset();
        ReservationEntry.SetRange("Recording Slip Printed", True);
        ReservationEntry.SetRange("Output Posted", false);
        If ReservationEntry.FindSet() then begin
            repeat
                Commit();
                 RESourceID := ReservationEntry."Source ID";
                 RESerialNo := ReservationEntry."Serial No.";
                If not Codeunit.Run(CodeUnit::"FG Posting", ReservationEntry) then begin
                    FGPostingError2.Reset();
                    FGPostingError2.SetRange("Document No", ReservationEntry."Source ID");
                    FGPostingError2.SetRange("Serial No.",ReservationEntry."Serial No.");
                    If Not FGPostingError2.FindFirst() then begin
                        FGPostingError.Init();
                        FGPostingError1.SetAscending("Line No", false);
                        If FGPostingError1.FindFirst() then
                            FGPostingError."Line No" := FGPostingError1."Line No" + 1
                        Else
                            FGPostingError."Line No" := 1;
                        FGPostingError."Document No" := ReservationEntry."Source ID";
                        FGPostingError."Serial No." := ReservationEntry."Serial No.";
                        FGPostingError."Created Date" := CurrentDateTime;
                        FGPostingError.Error := GetLastErrorText();
                        FGPostingError.Insert();
                    end else begin
                        FGPostingError2.Error := GetLastErrorText();
                        FGPostingError2.Modify();
                    end;
                end else begin
                    FGPostingError2.Reset();
                    FGPostingError2.SetRange("Document No", RESourceID);
                    FGPostingError2.SetRange("Serial No.",RESerialNo);
                    If FGPostingError2.FindFirst() then
                      FGPostingError2.Delete();
                end;
                 
            until ReservationEntry.Next() = 0;
        end;
    end;

    var
        ReservationEntry: Record "Reservation Entry";
        FGPostingError: Record "FG Posting Error Log";
        FGPostingError1: Record "FG Posting Error Log";
        FGPostingError2: Record "FG Posting Error Log";
        RESourceID : Code[20];
        RESerialNo : Code[50];
}
