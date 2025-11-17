page 50044 "Update Mould & Weight"
{
    ApplicationArea = All;
    Caption = 'Update Mould No';
    PageType = Card;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field(SectionEnum; SectionEnum)
                {
                    ApplicationArea = All;
                    Caption = 'Section No.';
                }
                field(FrontMouldNumber; FrontMouldNumber)
                {
                    ApplicationArea = All;
                    Caption = 'Front Mould No';
                }
                field(BackMouldNumber; BackMouldNumber)
                {
                    ApplicationArea = All;
                    Caption = 'Back Mould No';
                }

            }
        }
    }
    var
        SectionEnum: Enum "Section No.";
        FrontBackEnum: Enum "Front Back";
        FrontMouldNumber : Integer;
        BackMouldNumber : Integer;
        Weight : Decimal;
    procedure GetFrontMouldNo(): Integer
    begin
        exit(FrontMouldNumber);
    end;
    procedure GetBackMouldNo(): Integer
    begin
        exit(BackMouldNumber);
    end;
}
