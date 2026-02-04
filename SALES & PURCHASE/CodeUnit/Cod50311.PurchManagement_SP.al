codeunit 50311 PurchManagement_SP
{
    procedure checkDimValue(iDimEntryID: Integer; iItemNo: Code[20]; iLineNo: Integer; iDimCode: Code[20])
    var
        Dimentry: Record "Dimension Set Entry";
    begin
        Dimentry.Reset();
        Dimentry.SetRange("Dimension Set ID", iDimEntryID);
        Dimentry.SetRange("Dimension Code", iDimCode);
        if Not Dimentry.Find('-') then
            Error('%1 Code value is required, Line No. %2, Item No. %3', iDimCode, iLineNo, iItemNo);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", OnBeforeTestStatusOpen, '', false, false)]
    local procedure OnBeforeTestStatusOpen(var PurchaseLine: Record "Purchase Line"; var PurchaseHeader: Record "Purchase Header"; xPurchaseLine: Record "Purchase Line"; CallingFieldNo: Integer; var IsHandled: Boolean)
    begin
        if CallingFieldNo <> 0 then
            exit;
        if PurchaseHeader."Posting Date" <> PurchaseHeader."Last Posting Date" then begin
            if PurchaseHeader.Status = PurchaseHeader.Status::Released then begin
                IsHandled := true;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Quote to Order", OnCreatePurchHeaderOnBeforePurchOrderHeaderModify, '', false, false)]
    local procedure OnCreatePurchHeaderOnBeforePurchOrderHeaderModify(var PurchOrderHeader: Record "Purchase Header"; var PurchHeader: Record "Purchase Header")
    var
        PurchaseQuote: Record "Purchase Header";
    begin
        Clear(PurchaseQuote);
        PurchaseQuote.Reset();
        PurchaseQuote.SetRange("No.", PurchHeader."No.");
        PurchaseQuote.SetRange("Document Type", PurchaseQuote."Document Type"::Quote);
        if PurchaseQuote.FindSet() then begin
            PurchaseQuote."PO No." := PurchOrderHeader."No.";
            PurchaseQuote.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnBeforePurchInvHeaderInsert, '', false, false)]
    local procedure OnBeforePurchInvHeaderInsert(var PurchInvHeader: Record "Purch. Inv. Header"; var PurchHeader: Record "Purchase Header"; CommitIsSupressed: Boolean)
    begin
        PurchInvHeader."Invoice Received Date" := PurchHeader."Invoice Received Date";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", OnBeforeCreateDimensionsFromValidatePayToVendorNo, '', false, false)]
    local procedure OnBeforeCreateDimensionsFromValidatePayToVendorNo(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    begin
        if PurchaseHeader."Quote No." <> '' then
            IsHandled := true;
    end;

    // "Correct Posted Purch. Invoice" 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Correct Posted Purch. Invoice", 'OnBeforeUpdatePurchaseOrderLineInvoicedQuantity', '', false, false)]
    local procedure OnBeforeUpdatePurchaseOrderLineInvoicedQuantity(var PurchaseLine: Record "Purchase Line"; CancelledQuantity: Decimal; CancelledQtyBase: Decimal; var IsHandled: Boolean)
    begin
        IsHandled := true;
        PurchaseLine."Quantity Invoiced" -= CancelledQuantity;
        PurchaseLine."Qty. Invoiced (Base)" -= CancelledQtyBase;
        PurchaseLine.Modify();
    end;
    //-

    // OnRecreatePurchLinesOnBeforeTransferSavedFields
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterTransferSavedFields', '', false, false)]
    local procedure OnAfterTransferSavedFields(var DestinationPurchaseLine: Record "Purchase Line"; SourcePurchaseLine: Record "Purchase Line")
    begin
        DestinationPurchaseLine.Description := SourcePurchaseLine.Description;
        DestinationPurchaseLine."Shortcut Dimension 1 Code" := SourcePurchaseLine."Shortcut Dimension 1 Code";
        DestinationPurchaseLine.Remarks := SourcePurchaseLine.Remarks;
        DestinationPurchaseLine."Expected Receipt Date" := SourcePurchaseLine."Expected Receipt Date";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeValidateEmptySellToCustomerAndLocation', '', false, false)]
    local procedure OnBeforeValidateEmptySellToCustomerAndLocation(var PurchaseHeader: Record "Purchase Header"; Vendor: Record Vendor; var IsHandled: Boolean; var xPurchaseHeader: Record "Purchase Header")
    begin
        IsHandled := true;
        PurchaseHeader.Validate("Sell-to Customer No.", '');

        if PurchaseHeader."Buy-from Vendor No." <> '' then
            PurchaseHeader.GetVend(PurchaseHeader."Buy-from Vendor No.");
    end;

    procedure checkCountCompleteInvoicedPO(iNo: Code[20])
    var
        PurchaseLine: Record "Purchase Line";
        PurchaseHeader: Record "Purchase Header";
        Counter: Integer;
        CounterOrig: Integer;
        Result: Boolean;
    begin
        Clear(Counter);
        Clear(CounterOrig);
        Clear(PurchaseHeader);
        Clear(Result);
        PurchaseHeader.SetRange("No.", iNo);
        PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
        PurchaseHeader.SetRange(Status, PurchaseHeader.Status::Released);
        PurchaseHeader.SetRange(IsClose, false);
        if PurchaseHeader.Find('-') then begin
            Clear(PurchaseLine);
            PurchaseLine.SetRange("Document No.", iNo);
            PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
            PurchaseLine.SetFilter(Type, '<>%1', PurchaseLine.Type::" ");
            PurchaseLine.SetFilter("No.", '<>%1', '');
            PurchaseLine.SetFilter(Quantity, '<>%1', 0);
            if PurchaseLine.FindSet() then begin
                CounterOrig := PurchaseLine.Count();
                repeat
                    if PurchaseLine.Quantity = PurchaseLine."Quantity Invoiced" then begin
                        Counter := Counter + 1;
                    end;
                until PurchaseLine.Next() = 0;
                //check data orig vs complete invoice
                if CounterOrig = Counter then begin
                    PurchaseHeader.IsClose := true;
                    PurchaseHeader.Modify();
                end;
                //-
            end;
        end;
    end;

}
