codeunit 50702 QCTableSubscribers_PQ
{
    // version QC11

    // Documentation Triggers for Tables:
    //
    // 18 - Customer
    // //QC3.7   Add 'Has Quality Specification' field
    //
    // 27 - Item
    // //QC3.7   Add field 'Has Quality Specification'
    // //QC37.05 Added new field 60041 "Auto Enter Serial No. Master"
    // //QC80.2 Renumbered Fields 60040 and 60041 to 60340 and 60341, respectively
    // //QC11.01 Added Key: Blocked
    //
    // //QC10.0  Renumbered Field 60341 (Auto Enter Serial No. Master) BACK to 60041 to avoid Merge Conflict with FP
    //
    // 32 - Item Ledger Entry
    // //QC3.7  Added Two New Keys:
    //           - (Lot No.,Posting Date) and (Item No.,Variant Code,Lot No.,Location Code,Remaining Quantity -- SumIndex:Remaining Quantity)
    //          Enabled Key: Item No.,Location Code,Open,Variant Code,Unit of Measure Code,Lot No.,Serial No.
    //
    // 39 - Purchase Line
    // //QC4.0  Added field QC Required #60199 (non editable)
    //          Added global variable to the QC Requirements table
    //          Added code on the No. field (Could not find 03/20/18)
    // //QC11.01 03/20/18 Doug McIntosh
    //   - Removed Global Variable QCReqT
    //   - Removed Code in Function "CopyFromItem" and placed in Table Subscribers CU
    //
    // 91 - User Setup
    // QC7.4 09/27/13  Doug McIntosh, Cost Control Software
    //   - Added "Quality Manager" Field to Control certain functions in Quality Control Granule
    //
    // 121 - Purch. Rcpt. Line
    // QC80  12/4/14 Doug McIntosh, Cost Control Software
    //   - Added Field "CCS QC Required"
    //
    // 337 - Reservation Entry
    // QC5.01  Added Key: "Source Type,Source Subtype,Source ID,Source Batch Name,
    //           Source Prod. Order Line,Source Ref. No.,Reservation Status,Expected Receipt Date"
    //
    // 338 - Entry Summary
    // //QC   Added new fields 60500 - 60507
    //
    // QC7.7 03/13/14 Doug McIntosh, Cost Control Software
    //   - Added Fields  60508 - 60511
    //   - Expanded "QC Compliance" Field from 4 chars to 20
    //
    // 5405 - Production Order
    //   - Added Key: Blocked
    //
    // 6504 - Serial No. Information
    // //QC37.05  Changed the Default Lookup and drill down Page for Table to Page 14004614
    // //QC11.01 Changed the Default Lookup and Drill Down Page back to the Default (P 6509)
    //
    // 6505 - Lot No. Information
    // //QC   Add two new fields: 'Lot Test Exists', 'Qty on Hand'
    //        Make lookup table the Lot No. List
    //
    // //QC7.2 08/23/13 Doug McIntosh, Cost Control Software
    //   - Added "Non-Conformance" Flowfield
    //
    // 6507 - Item Entry Relation
    // //QC  Added Quantity field


    trigger OnRun();
    begin
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterAssignItemValues', '', false, false)]
    local procedure PurchaseLineOnAfterAssignItemValues(var PurchLine: Record "Purchase Line"; Item: Record Item);
    var
        QCReqT: Record QCRequirements_PQ;
        QCFunctionLibrary: Codeunit QCFunctionLibrary_PQ;
        QCRequired: Boolean;
        QCSpecHeader: Record QCSpecificationHeader_PQ;
        //QCTransactionArea: Record "AM Transaction Area";
        Lbl003: Label 'Please specify transaction areas for Sales, Purchases, Output and Phys. Inventory.';
        QualityType: Enum ItemQualityRequirement_PQ;
        CodeunitSubscribers: Codeunit QCCodeunitSubscribers_PQ;
        SpecificationNo: Code[20];
    begin
        //QC11.01 - Code and local Variable QCReqT moved from Purchase Line Table

        //QC4
        /*
        QCTransactionArea.SetRange("Transaction Area", QCTransactionArea."Transaction Area"::Purchase);
        if not QCTransactionArea.FindFirst() then
            error(Lbl003);
        */
        SpecificationNo := CodeunitSubscribers.GetSpecificationFromItemQualityRequirement(QualityType::"Purchase Receipt", PurchLine."No.", PurchLine."Variant Code", PurchLine."Location Code");
        if SpecificationNo = '' then begin
            PurchLine."CCS QC Required" := false;
            exit;
        end;

        if QCFunctionLibrary.VerifyValidQualitySpecification2(PurchLine."No.", '', QCRequired, SpecificationNo) then
            PurchLine."CCS QC Required" := QCRequired;

        /*
        QCReqT.SETRANGE("Item No.", PurchLine."No.");
        if QCReqT.FIND('-') then
            repeat
                if QCReqT."Quality Testing Required" = true then
                    PurchLine."CCS QC Required" := true;
            until (QCReqT.NEXT = 0) or (PurchLine."CCS QC Required" = true);
        */
        //end QC4
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterValidateEvent', 'Location Code', false, false)]
    local procedure PurchaseLine__OnAfterValidateEvent__LocationCode(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; CurrFieldNo: Integer);
    var
        QCFunctionLibrary: Codeunit QCFunctionLibrary_PQ;
        QCRequired: Boolean;
        QualityType: Enum ItemQualityRequirement_PQ;
        CodeunitSubscribers: Codeunit QCCodeunitSubscribers_PQ;
        SpecificationNo: Code[20];
    begin
        SpecificationNo := CodeunitSubscribers.GetSpecificationFromItemQualityRequirement(QualityType::"Purchase Receipt", Rec."No.", Rec."Variant Code", Rec."Location Code");
        if SpecificationNo = '' then begin
            Rec."CCS QC Required" := false;
            exit;
        end;

        if QCFunctionLibrary.VerifyValidQualitySpecification2(Rec."No.", '', QCRequired, SpecificationNo) then
            Rec."CCS QC Required" := QCRequired;
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterValidateEvent', 'Variant Code', false, false)]
    local procedure PurchaseLine__OnAfterValidateEvent__VariantCode(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; CurrFieldNo: Integer);
    var
        QCFunctionLibrary: Codeunit QCFunctionLibrary_PQ;
        QCRequired: Boolean;
        QualityType: Enum ItemQualityRequirement_PQ;
        CodeunitSubscribers: Codeunit QCCodeunitSubscribers_PQ;
        SpecificationNo: Code[20];
    begin
        SpecificationNo := CodeunitSubscribers.GetSpecificationFromItemQualityRequirement(QualityType::"Purchase Receipt", Rec."No.", Rec."Variant Code", Rec."Location Code");
        if SpecificationNo = '' then begin
            Rec."CCS QC Required" := false;
            exit;
        end;

        if QCFunctionLibrary.VerifyValidQualitySpecification2(Rec."No.", '', QCRequired, SpecificationNo) then
            Rec."CCS QC Required" := QCRequired;
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterAssignItemValues', '', false, false)]
    local procedure OnAfterAssignItemValues(var SalesLine: Record "Sales Line"; Item: Record Item)
    var
        QCReqT: Record QCRequirements_PQ;
        QCFunctionLibrary: Codeunit QCFunctionLibrary_PQ;
        QCRequired: Boolean;
        QCSpecHeader: Record QCSpecificationHeader_PQ;
        //QCTransactionArea: Record "AM Transaction Area";
        Lbl003: Label 'Please specify transaction areas for Sales, Purchases, Output and Phys. Inventory.';
        QualityType: Enum ItemQualityRequirement_PQ;
        CodeunitSubscribers: Codeunit QCCodeunitSubscribers_PQ;
        SpecificationNo: Code[20];
    begin
        SpecificationNo := CodeunitSubscribers.GetSpecificationFromItemQualityRequirement(QualityType::"Sales Shipment", SalesLine."No.", SalesLine."Variant Code", SalesLine."Location Code");
        if SpecificationNo = '' then begin
            SalesLine."CCS QC Required" := false;
            exit;
        end;

        if QCFunctionLibrary.VerifyValidQualitySpecification2(SalesLine."No.", '', QCRequired, SpecificationNo) then
            SalesLine."CCS QC Required" := QCRequired;
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Location Code', false, false)]
    local procedure SalesLine__OnAfterValidateEvent__LocationCode(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        QCFunctionLibrary: Codeunit QCFunctionLibrary_PQ;
        QCRequired: Boolean;
        QualityType: Enum ItemQualityRequirement_PQ;
        CodeunitSubscribers: Codeunit QCCodeunitSubscribers_PQ;
        SpecificationNo: Code[20];
    begin
        SpecificationNo := CodeunitSubscribers.GetSpecificationFromItemQualityRequirement(QualityType::"Sales Shipment", Rec."No.", Rec."Variant Code", Rec."Location Code");
        if SpecificationNo = '' then begin
            Rec."CCS QC Required" := false;
            exit;
        end;

        if QCFunctionLibrary.VerifyValidQualitySpecification2(Rec."No.", '', QCRequired, SpecificationNo) then
            Rec."CCS QC Required" := QCRequired;
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Variant Code', false, false)]
    local procedure SalesLine__OnAfterValidateEvent__VariantCode(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        QCFunctionLibrary: Codeunit QCFunctionLibrary_PQ;
        QCRequired: Boolean;
        QualityType: Enum ItemQualityRequirement_PQ;
        CodeunitSubscribers: Codeunit QCCodeunitSubscribers_PQ;
        SpecificationNo: Code[20];
    begin
        SpecificationNo := CodeunitSubscribers.GetSpecificationFromItemQualityRequirement(QualityType::"Sales Shipment", Rec."No.", Rec."Variant Code", Rec."Location Code");
        if SpecificationNo = '' then begin
            Rec."CCS QC Required" := false;
            exit;
        end;

        if QCFunctionLibrary.VerifyValidQualitySpecification2(Rec."No.", '', QCRequired, SpecificationNo) then
            Rec."CCS QC Required" := QCRequired;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeCallItemTracking', '', false, false)]
    local procedure SalesLineOnBeforeCallItemTracking(var SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    var
        SalesLineReserve: Codeunit "Sales Line-Reserve";
        QCFunctionLibrary: Codeunit QCFunctionLibrary_PQ;
    begin
        IsHandled := true;
        SalesLineReserve.CallItemTracking(SalesLine);
        if SalesLine.Type <> SalesLine.Type::Item then
            exit;

        QCFunctionLibrary.VerifyAndCreateQualityTestsForSales(SalesLine."Document No.", SalesLine."Line No.");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Shipment Line", 'OnAfterOpenItemTrackingLines', '', false, false)]
    local procedure WhseShipmentLineOnAfterOpenItemTrackingLines(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; var SecondSourceQtyArray: array[3] of Decimal)
    var
        QCFunctionLibrary: Codeunit QCFunctionLibrary_PQ;
    begin
        if WarehouseShipmentLine."Source Type" <> Database::"Sales Line" then
            exit;

        QCFunctionLibrary.VerifyAndCreateQualityTestsForSales(WarehouseShipmentLine."Source No.", WarehouseShipmentLine."Source Line No.");
    end;

    //[EventSubscriber(ObjectType::Table, Database::"Warehouse Activity Line", 'OnAfterModifyEvent', '', false, false)]
    local procedure WarehouseActivityLineOnAfterModifyEvent(var Rec: Record "Warehouse Activity Line"; var xRec: Record "Warehouse Activity Line"; RunTrigger: Boolean)
    var
        QCFunctionLibrary: Codeunit QCFunctionLibrary_PQ;
    begin
        if Rec."Action Type" <> Rec."Action Type"::Place then
            exit;

        if (Rec."Lot No." = Rec."CCS Latest Lot No.") and (Rec."Serial No." = Rec."CCS Latest Serial No.") then
            exit;

        // Delete associated Quality test for old lot/serial combination
        QCFunctionLibrary.VerifyAndUpdateRelatedQualityTestsForPicking(Rec, Rec."CCS Latest Lot No.", Rec."CCS Latest Serial No.");

        // Create new quality test for new lot/serial combination
        QCFunctionLibrary.VerifyAndCreateQualityTestsForSalesPicking(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Activity Line", 'OnBeforeDeleteWhseActivLine2', '', false, false)]
    local procedure WarehouseActivityLineOnBeforeDeleteWhseActivLine2(var WarehouseActivityLine2: Record "Warehouse Activity Line"; CalledFromHeader: Boolean; IsHandled: Boolean)
    var
        QCFunctionLibrary: Codeunit QCFunctionLibrary_PQ;
    begin
        if WarehouseActivityLine2."Action Type" <> WarehouseActivityLine2."Action Type"::Place then
            exit;

        QCFunctionLibrary.VerifyAndUpdateRelatedQualityTestsForPicking(WarehouseActivityLine2, WarehouseActivityLine2."Lot No.", WarehouseActivityLine2."Serial No.");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Activity Line", 'OnAfterValidateEvent', 'Lot No.', false, false)]
    local procedure WarehouseActivityLineOnAfterValidateEventLotNo(var Rec: Record "Warehouse Activity Line"; var xRec: Record "Warehouse Activity Line"; CurrFieldNo: Integer)
    begin
        if xRec."Lot No." <> Rec."Lot No." then
            Rec."CCS Latest Lot No." := xRec."Lot No.";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Activity Line", 'OnAfterValidateEvent', 'Serial No.', false, false)]
    local procedure WarehouseActivityLineOnAfterValidateEventSerialNo(var Rec: Record "Warehouse Activity Line"; var xRec: Record "Warehouse Activity Line"; CurrFieldNo: Integer)
    begin
        if xRec."Serial No." <> Rec."Serial No." then
            Rec."CCS Latest Serial No." := xRec."Serial No.";
    end;
}
