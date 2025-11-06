/*report 50014 "QC Update Details"
{
    ApplicationArea = All;
    Caption = 'QC Update Details';
    UsageCategory = Tasks;
    dataset
    {
        dataitem(ProductionOrder; "Production Order")
        {
            trigger OnAfterGetRecord()
            begin
              QCDetail.Init();
              QCDetail
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(Shift; Shift)
                    {
                        ApplicationArea = All;
                        Caption = 'From Date';
                        ToolTip = 'Specifies From Date.';
                    }
                    field(ToDate; ToDate)
                    {
                        ApplicationArea = All;
                        Caption = 'To Date';
                        ToolTip = 'Specifies To Date.';
                    }
                    field(Furnace; Furnace)
                    {
                        ApplicationArea = All;
                        Caption = 'Work Center';
                        ToolTip = 'Specifies Work Center.';
                        trigger OnDrillDown()

                        begin
                            GeneralLegderSetup.Get();
                            DimensionValue.Reset();
                            DimensionValue.SetRange("Dimension Code", GeneralLegderSetup."Shortcut Dimension 8 Code");
                            If DimensionValue.FindSet() then;
                            if Page.RunModal(537,DimensionValue) = Action::LookupOK then begin
                               Furnace := DimensionValue.Code;
                               
                            end;
                        end;
                    }
                    field(JobNo; JobNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Job No.';
                        ToolTip = 'Specifies To Date.';
                        TableRelation = Item."No.";
                    }
                    field(Speed; Speed)
                    {
                        ApplicationArea = All;
                        Caption = 'Section';
                        ToolTip = 'Specifies Section.';
                    }
                    field(BottlesPerMinute; BottlesPerMinute)
                    {
                        ApplicationArea = All;
                        Caption = 'Bottles Per Minute';
                        ToolTip = 'Bottles Per Minute.';
                    }
                    field(Tray; Tray)
                    {
                        ApplicationArea = All;
                        Caption = 'Tray';
                        ToolTip = 'Specifies Tray.';
                    }
                    field(Pallet; Pallet)
                    {
                        ApplicationArea = All;
                        Caption = 'Pallet';
                        ToolTip = 'Specifies Pallet.';
                    }
                }
            }
        }

    }
    var
    QCDetail : Record "QC Details";
    Shift : Code[20];
    IRIZ :Integer;
    SL : Integer;
    DefectCode1 : Code[20];
    DefectCode2 : Code[20];
    DefectCode3 : Code[20];

}*/
