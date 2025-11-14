page 50044 "Update Mould & Weight"
{
    ApplicationArea = All;
    Caption = 'Update Mould & Weight';
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
                field(FrontBackEnum; FrontBackEnum)
                {
                    ApplicationArea = All;
                    Caption = 'Front/Back';
                }
                field(MouldNumber; MouldNumber)
                {
                    ApplicationArea = All;
                }
                field(Weight; Weight)
                {
                    ApplicationArea = All;
                }

            }
        }
    }
    var
        SectionEnum: Enum "Section No.";
        FrontBackEnum: Enum "Front Back";
        MouldNumber : Integer;
        Weight : Decimal;
}
