codeunit 50501 "Event Subscriber"
{
    //    OnAfterSalesHeaderOnAfterGetRecord
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Source Doc. Outbound", OnBeforeGetSourceDocForHeader, '', false, false)]
    local procedure OnBeforeGetSourceDocForHeader(var WarehouseShipmentHeader: Record "Warehouse Shipment Header"; var WarehouseRequest: Record "Warehouse Request"; var IsHandled: Boolean)
    begin
        WarehouseRequest.SetFilter("Gen. Bus. Posting Group", '<>%1', 'DOMESTIC');
        if WarehouseShipmentHeader."Whse. Sales Type" = WarehouseShipmentHeader."Whse. Sales Type"::Domestic then begin
            WarehouseRequest.SetRange("Gen. Bus. Posting Group", 'DOMESTIC');
        end;
    end;

    // "Invt. Doc.-Post Shipment"
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Invt. Doc.-Post Shipment", 'OnRunOnBeforeInvtShptHeaderInsert', '', false, false)]
    local procedure OnRunOnBeforeInvtShptHeaderInsert(var InvtShptHeader: Record "Invt. Shipment Header"; InvtDocHeader: Record "Invt. Document Header")
    begin
        InvtShptHeader.Remarks := InvtDocHeader.Remarks;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnBeforePostedWhseShptHeaderInsert', '', false, false)]
    local procedure OnBeforePostedWhseShptHeaderInsert(var PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header"; WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    begin
        PostedWhseShipmentHeader."Prepared By" := WarehouseShipmentHeader."Prepared By";
        PostedWhseShipmentHeader."Prepared By Name" := WarehouseShipmentHeader."Prepared By Name";
        PostedWhseShipmentHeader."Checked By" := WarehouseShipmentHeader."Checked By";
        PostedWhseShipmentHeader."Checked By Name" := WarehouseShipmentHeader."Checked By Name";
        PostedWhseShipmentHeader."Warehouse Person" := WarehouseShipmentHeader."Warehouse Person";
        PostedWhseShipmentHeader."Warehouse Person Name" := WarehouseShipmentHeader."Warehouse Person Name";
        PostedWhseShipmentHeader."Trucking No." := WarehouseShipmentHeader."Trucking No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Transfer", OnRunWithCheckOnBeforeTestRequireReceive, '', false, false)]
    local procedure OnRunWithCheckOnBeforeTestRequireReceive(var Location: Record Location; var RequireReceiveValueToTest: Boolean)
    var
        InvntSetup: Record "Inventory Setup";
    begin
        if Location."No Handling Direct Transfer" then
            RequireReceiveValueToTest := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", OnCheckWarehouseOnBeforeShowDialog, '', false, false)]
    local procedure OnCheckWarehouseOnBeforeShowDialog(TransferLine: Record "Transfer Line"; Location: Record Location; var ShowDialog: Option " ",Message,Error; var DialogText: Text[50])
    begin
        if Location."No Handling Direct Transfer" then
            ShowDialog := ShowDialog::" ";
    end;

    // "TransferOrder-Post Receipt"
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", OnBeforeCheckWarehouse, '', false, false)]
    local procedure OnBeforeCheckWarehouse(var TransferLine: Record "Transfer Line"; var IsHandled: Boolean)
    var
        Location: Record Location;
    begin
        Location.Get(TransferLine."Transfer-to Code");
        if Location."No Handling Direct Transfer" then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Put-away", OnBeforeWhseActivHeaderInsert, '', false, false)]
    local procedure OnBeforeWhseActivHeaderInsert(var WarehouseActivityHeader: Record "Warehouse Activity Header"; PostedWhseReceiptLine: Record "Posted Whse. Receipt Line")
    begin
        // Pastikan ini Put-away, bukan Pick
        if WarehouseActivityHeader."Type" <> WarehouseActivityHeader."Type"::"Put-away" then
            exit;

        if PostedWhseReceiptLine."Posting Date" <> 0D then begin
            WarehouseActivityHeader.Validate("Posting Date", PostedWhseReceiptLine."Posting Date");
        end;
    end;


    //CR : Implement BIN 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Line", 'OnBeforeInsertWhseEntry', '', false, false)]
    local procedure OnBeforeInsertWhseEntry(var WarehouseEntry: Record "Warehouse Entry"; var WarehouseJournalLine: Record "Warehouse Journal Line")
    begin
        WarehouseEntry.Operator := WarehouseJournalLine.Operator;
        WarehouseEntry."Operator Name" := WarehouseJournalLine."Operator Name";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Act.-Register (Yes/No)", OnBeforeRegisterRun, '', false, false)]
    local procedure OnBeforeRegisterRun(var WarehouseActivityLine: Record "Warehouse Activity Line"; var IsHandled: Boolean)
    var
        WhseActivityRegister: Codeunit "Whse.-Activity-Register Cstm";
    begin
        IsHandled := true;
        WhseActivityRegister.Run(WarehouseActivityLine);
        Clear(WhseActivityRegister);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Register Cstm", 'OnBeforeWhseJnlRegisterLine', '', false, false)]
    local procedure OnBeforeWhseJnlRegisterLine(var WarehouseJournalLine: Record "Warehouse Journal Line"; WarehouseActivityLine: Record "Warehouse Activity Line")
    var
        WhseActivityHeader: Record "Warehouse Activity Header";
    begin
        Clear(WhseActivityHeader);
        WhseActivityHeader.Reset();
        WhseActivityHeader.SetRange("No.", WarehouseActivityLine."No.");
        if WhseActivityHeader.Find('-') then begin
            WarehouseJournalLine.Operator := WhseActivityHeader.Operator;
            WarehouseJournalLine."Operator Name" := WhseActivityHeader."Operator Name";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Register Cstm", 'OnBeforeRegisteredWhseActivHeaderInsert', '', false, false)]
    local procedure OnBeforeRegisteredWhseActivHeaderInsert(var RegisteredWhseActivityHdr: Record "Registered Whse. Activity Hdr."; WarehouseActivityHeader: Record "Warehouse Activity Header")
    begin
        RegisteredWhseActivityHdr.Operator := WarehouseActivityHeader.Operator;
        RegisteredWhseActivityHdr."Operator Name" := WarehouseActivityHeader."Operator Name";
        RegisteredWhseActivityHdr."Posting Date" := WarehouseActivityHeader."Posting Date";
    end;
    //-

    //"Posted Sales Inv. - Update"
    [EventSubscriber(ObjectType::Page, Page::"Posted Return Shpt. - Update", OnAfterRecordChanged, '', false, false)]
    local procedure OnAfterRecordChanged(var ReturnShipmentHeader: Record "Return Shipment Header"; xReturnShipmentHeader: Record "Return Shipment Header"; var IsChanged: Boolean; xReturnShipmentHeaderGlobal: Record "Return Shipment Header");
    begin
        IsChanged := (ReturnShipmentHeader."Prepared By" <> xReturnShipmentHeaderGlobal."Prepared By") OR
                     (ReturnShipmentHeader."Checked By" <> xReturnShipmentHeaderGlobal."Checked By") OR
                     (ReturnShipmentHeader."Warehouse Person" <> xReturnShipmentHeaderGlobal."Warehouse Person");
    end;
    //"Sales Inv. Header - Edit"
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Return Shipment Header - Edit", OnBeforeReturnShipmentHeaderModify, '', false, false)]
    local procedure OnBeforeReturnShipmentHeaderModify(var ReturnShipmentHeader: Record "Return Shipment Header"; ReturnShipmentHeaderRec: Record "Return Shipment Header")
    begin
        ReturnShipmentHeader."Prepared By" := ReturnShipmentHeaderRec."Prepared By";
        ReturnShipmentHeader."Checked By" := ReturnShipmentHeaderRec."Checked By";
        ReturnShipmentHeader."Warehouse Person" := ReturnShipmentHeaderRec."Warehouse Person";
        ReturnShipmentHeader."Prepared By Name" := ReturnShipmentHeaderRec."Prepared By Name";
        ReturnShipmentHeader."Checked By Name" := ReturnShipmentHeaderRec."Checked By Name";
        ReturnShipmentHeader."Warehouse Person Name" := ReturnShipmentHeaderRec."Warehouse Person Name";
    end;
}
