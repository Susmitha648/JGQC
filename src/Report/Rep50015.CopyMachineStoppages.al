report 50015 "Copy Machine Stoppages"
{
    Caption = 'Copy Machine Stoppages';
    ProcessingOnly = true;
    dataset
    {

    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(LineNo; LineNo)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Line No.';
                        ShowMandatory = true;
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            MachineSectionStoppage1: Record "Machine/Section Stoppages";
                        begin
                            MachineSectionStoppage1.Reset();
                            MachineSectionStoppage1.SetRange("Production Order No.", MachineSectionStoppages."Production Order No.");
                            if Page.RunModal(0, MachineSectionStoppage1) = Action::LookupOK then
                                LineNo := MachineSectionStoppage1."Line No.";
                        end;
                    }
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    procedure Set(var MachineSectionStoppagesNew: Record "Machine/Section Stoppages")
    begin

        MachineSectionStoppages := MachineSectionStoppagesNew;
    end;

    var
        LineNo: Integer;
        MachineSectionStoppages: Record "Machine/Section Stoppages";

    trigger OnPostReport()
    var
        MachineSectionStoppages2: Record "Machine/Section Stoppages";
    begin
        MachineSectionStoppages2.Reset();
        MachineSectionStoppages2.SetRange("Production Order No.", MachineSectionStoppages."Production Order No.");
        MachineSectionStoppages2.SetRange("Line No.", LineNo);
        If MachineSectionStoppages2.FindFirst() then; 
        If MachineSectionStoppages2.IsEmpty then
            Error('Machine/Section Stoppages Line does not exist')
        else begin
        
            MachineSectionStoppages.TransferFields(MachineSectionStoppages2,false);
           MachineSectionStoppages.Modify();
           
        end;
    end;
}
