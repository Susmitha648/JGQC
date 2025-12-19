report 50006 "Inspection Challenge Report"
{
    ApplicationArea = All;
    Caption = 'Inspection Challenge Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/InspectionChallengeReport.rdlc';

    dataset
    {
        dataitem(Header; "Inspection Challenge Sample He")
        {
            DataItemTableView = sorting("Released Prod Order No.", "Production Order Date");
            column(ReleasedProdOrderNo; "Released Prod Order No.") { }
            column(ProductionOrderDate; "Production Order Date") { }
            column(JobNo; "Job No.") { }
            column(Description; Description) { }
            column(Ring; Ring) { }
            column(MCNo; "MC No.") { }
            column(FurnaceNo; "Furnace No.") { }

            // 1. New Page Loop to handle overflow
            dataitem(PageLoop; Integer)
            {
                DataItemTableView = sorting(Number);
                column(PageNo; Number) { }

                dataitem(CCP; CCP)
                {
                    // ERROR FIXED HERE: Removed DataItemLink property
                    DataItemTableView = sorting("Production Order No", "Type", "Work Shift");

                    column(CCP_Type; "Type") { }
                    column(CCP_ResultObtained; "Result Obtained") { }
                    column(CCP_Inspection1; "Inspection 1") { }
                    column(CCP_Inspection2; "Inspection 2") { }
                    column(CCP_Inspection3; "Inspection 3") { }
                    column(CCP_WorkShift; "Work Shift") { }

                    // ADDED: Manual filtering to link to Header (Grandparent)
                    trigger OnPreDataItem()
                    begin
                        SetRange("Production Order No", Header."Released Prod Order No.");
                    end;
                }

                dataitem(TimeLoop; Integer)
                {
                    DataItemTableView = sorting(Number);

                    column(FrequencyText; FrequencyText) { }
                    column(TimeAsInteger; TimeAsInteger) { }
                    column(SectionGroup; SectionGroupNo) { }

                    dataitem(Line; "Inspection Challenge Sample li")
                    {
                        DataItemTableView = sorting("Released Prod Order No.", "Line No.");

                        column(LineNo; "Line No.") { }
                        column(Time; Frequency) { }
                        column(Inspection_Type; "Inspection Type") { }
                        column(QC_Defect_Code; "QC Defect Code") { }
                        column(QC_Defect_Name; DefectName) { }
                        column(Reject_Percent; "Reject %") { }

                        trigger OnPreDataItem()
                        begin
                            SetRange("Released Prod Order No.", Header."Released Prod Order No.");
                            SetRange(Frequency, CurrentFrequency);
                        end;

                        trigger OnAfterGetRecord()
                        var
                            DefectCodeRec: Record "Defect Code";
                            DefectPage: Integer;
                        begin
                            DefectName := '';
                            if DefectCodeRec.Get("QC Defect Code") then
                                DefectName := DefectCodeRec."Defect Name";

                            // Filter QC Defects based on Page logic
                            if QCDefectPageMap.ContainsKey("QC Defect Code") then begin
                                DefectPage := QCDefectPageMap.Get("QC Defect Code");
                                if DefectPage <> PageLoop.Number then
                                    CurrReport.Skip();
                            end else
                                CurrReport.Skip();
                        end;
                    }

                    dataitem(MNR_DefectLoop; "Defect Code")
                    {
                        column(MNR_Label; 'MNR') { }
                        column(MNR_DefectCode; "Defect Code") { }
                        column(MNR_DefectName; "Defect Name") { }
                        column(MNR_CavityNo; CavityNoText) { }

                        trigger OnAfterGetRecord()
                        var
                            MNR_TransRec: Record MNR;
                            DefectPage: Integer;
                        begin
                            // Filter MNR Defects based on Page logic
                            if MNRDefectPageMap.ContainsKey("Defect Code") then begin
                                DefectPage := MNRDefectPageMap.Get("Defect Code");
                                if DefectPage <> PageLoop.Number then
                                    CurrReport.Skip();
                            end else
                                CurrReport.Skip();

                            CavityNoText := '';
                            MNR_TransRec.SetRange("Production Order No", Header."Released Prod Order No.");
                            MNR_TransRec.SetRange(Frequency, CurrentFrequency);
                            MNR_TransRec.SetRange("Defect Code List", "Defect Code");

                            if MNR_TransRec.FindFirst() then begin
                                CavityNoText := MNR_TransRec."Cavity No";
                            end;
                        end;
                    }

                    trigger OnPreDataItem()
                    begin
                        SetRange(Number, 0, 23);
                    end;

                    trigger OnAfterGetRecord()
                    var
                        StartHour: Integer;
                    begin
                        CurrentFrequency := Enum::"Time".FromInteger(Number);
                        FrequencyText := Format(CurrentFrequency);
                        StartHour := CurrentFrequency.AsInteger();

                        if StartHour < 6 then
                            TimeAsInteger := StartHour + 24
                        else
                            TimeAsInteger := StartHour;

                        SectionGroupNo := (TimeAsInteger - 6) div 8;
                    end;
                }

                trigger OnPreDataItem()
                begin
                    if TotalPages = 0 then TotalPages := 1; // Safety check
                    SetRange(Number, 1, TotalPages);
                end;
            }

            trigger OnAfterGetRecord()
            var
                TempLine: Record "Inspection Challenge Sample li";
                TempMNR: Record MNR;
                QCCount: Integer;
                MNRCount: Integer;
                QCMaxPage: Integer;
                MNRMaxPage: Integer;
            begin
                // Calculate Total Pages and Map Defects
                Clear(QCDefectPageMap);
                Clear(MNRDefectPageMap);
                QCCount := 0;
                MNRCount := 0;

                // 1. Analyze QC Defects (Max 8 per page)
                TempLine.SetRange("Released Prod Order No.", "Released Prod Order No.");
                if TempLine.FindSet() then
                    repeat
                        // Only count unique defect codes
                        if not QCDefectPageMap.ContainsKey(TempLine."QC Defect Code") then begin
                            QCCount += 1;
                            QCDefectPageMap.Add(TempLine."QC Defect Code", ((QCCount - 1) div 8) + 1);
                        end;
                    until TempLine.Next() = 0;

                // 2. Analyze MNR Defects (Max 5 per page)
                TempMNR.SetRange("Production Order No", "Released Prod Order No.");
                if TempMNR.FindSet() then
                    repeat
                        if not MNRDefectPageMap.ContainsKey(TempMNR."Defect Code List") then begin
                            MNRCount += 1;
                            MNRDefectPageMap.Add(TempMNR."Defect Code List", ((MNRCount - 1) div 5) + 1);
                        end;
                    until TempMNR.Next() = 0;

                if QCCount = 0 then QCMaxPage := 1 else QCMaxPage := ((QCCount - 1) div 8) + 1;
                if MNRCount = 0 then MNRMaxPage := 1 else MNRMaxPage := ((MNRCount - 1) div 5) + 1;

                if QCMaxPage > MNRMaxPage then
                    TotalPages := QCMaxPage
                else
                    TotalPages := MNRMaxPage;
            end;
        }
    }

    var
        DefectName: Text[80];
        SectionGroupNo: Integer;
        TimeAsInteger: Integer;
        CurrentFrequency: Enum "Time";
        FrequencyText: Text;
        CavityNoText: Code[20];
        QCDefectPageMap: Dictionary of [Code[20], Integer];
        MNRDefectPageMap: Dictionary of [Code[20], Integer];
        TotalPages: Integer;
}