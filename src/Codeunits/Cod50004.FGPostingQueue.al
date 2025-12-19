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
                If not Codeunit.Run(CodeUnit::"FG Posting", ReservationEntry) then begin
                    FGPostingError.Init();
                    FGPostingError1.SetAscending("Line No", false);
                    If FGPostingError1.FindFirst() then
                        FGPostingError."Line No" := FGPostingError1."Line No" + 1
                    Else
                        FGPostingError."Line No" := 1;
                    FGPostingError."Document No" := ReservationEntry."Source ID";
                    FGPostingError.Error := GetLastErrorText();
                    FGPostingError.Insert();
                end;
            until ReservationEntry.Next() = 0;
        end;
    end;

    var
        ReservationEntry: Record "Reservation Entry";
        FGPostingError: Record "FG Posting Error Log";
        FGPostingError1: Record "FG Posting Error Log";
}
