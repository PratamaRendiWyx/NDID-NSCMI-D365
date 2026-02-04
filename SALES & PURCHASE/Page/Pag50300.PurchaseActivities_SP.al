page 50300 PurchaseActivities_SP
{
    Caption = 'Return Orders';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = PurchaseCue_SP;
    Permissions = tabledata PurchaseCue_SP = rm;

    layout
    {
        area(Content)
        {
            cuegroup(Control54)
            {
                Caption = 'Outstdanding Purch. Return';
                field("Purch. Return Orders - Qty"; Rec."Purch. Return Orders - Qty")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                }
            }

        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
