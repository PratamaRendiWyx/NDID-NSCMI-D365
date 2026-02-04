page 50115 RegisterTaxNumberLineDoc_FT
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = RegTaxNumLine_FT;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(RegTaxNumId;Rec.RegTaxNumId)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()begin
                end;
            }
        }
    }
    var 
    //myInt: Integer;
}
