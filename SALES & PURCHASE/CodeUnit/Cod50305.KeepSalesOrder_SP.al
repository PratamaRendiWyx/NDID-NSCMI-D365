codeunit 50305 KeepSalesOrder_SP
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforeFinalizePosting, '', false, false)]
    local procedure "Sales-Post_OnBeforeFinalizePosting"(var Sender: Codeunit "Sales-Post"; var SalesHeader: Record "Sales Header"; var TempSalesLineGlobal: Record "Sales Line" temporary; var EverythingInvoiced: Boolean; SuppressCommit: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line");
    begin
         EverythingInvoiced := false;
    end;
    
}