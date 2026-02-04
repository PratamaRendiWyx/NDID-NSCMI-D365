codeunit 50306 KeepPurchaseOrder_SP
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnBeforeFinalizePosting, '', false, false)]
    local procedure "Purch.-Post_OnBeforeFinalizePosting"(var PurchaseHeader: Record "Purchase Header"; var TempPurchLineGlobal: Record "Purchase Line" temporary; var EverythingInvoiced: Boolean; CommitIsSupressed: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line");
    begin
        EverythingInvoiced := false;
    end;

}