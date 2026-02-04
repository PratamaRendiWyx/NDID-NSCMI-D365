codeunit 50307 KeepPurchaseQuote_SP
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Quote to Order", OnBeforeDeletePurchQuote, '', false, false)]
    local procedure "Purch.-Quote to Order_OnBeforeDeletePurchQuote"(var QuotePurchHeader: Record "Purchase Header"; var OrderPurchHeader: Record "Purchase Header"; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

}