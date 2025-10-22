report 50008 "Generate Production Programme"
{
    ApplicationArea = All;
    Caption = 'Generate Production Programme';
    UsageCategory = Tasks;
    ProcessingOnly = True;
    dataset
    {
        dataitem(ProductionProgrammeHeader; "Production Programme Header")
        {
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
                    field(FromDate; FromDate)
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
                        Caption = 'Furnace';
                        TableRelation = "Work Center"."No.";
                        ToolTip = 'Specifies Furnace.';
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
                        Caption = 'Speed';
                        ToolTip = 'Specifies Speed.';
                    }
                    field(Ton; Ton)
                    {
                        ApplicationArea = All;
                        Caption = 'Ton';
                        ToolTip = 'Specifies Ton.';
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
    FromDate : Date;
    ToDate : Date;
    Furnace : Code[20];
    JobNo : Code[20];
    Ton : Decimal;
    Tray : Text[50];
    Pallet : Text[50];
    Speed : Enum Speed;
}
