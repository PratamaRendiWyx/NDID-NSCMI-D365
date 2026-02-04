codeunit 50703 QCPageSubscribers_PQ
{
    // version QC11.02

    // Documentation Triggers for Pages:
    // 
    // Page 21 Customer Card
    //   //QC3.7   Added 'Has Quality Specifications' field to Shipping tab
    // 
    // Page 30 Item Card
    //   //QC Added 'Has Quality Specification' field to 'Item Tracking' tab.
    //   //QC37.05  Added the new field "Auto enter Serial No. Master" on Item Tracking Tab and tool tip
    //   //QC5.01   Allow the field "Has Quality Specifications" to be editable
    // 
    // Page 54 Purchase Order Subform
    //   //QC Added QC Required boolean field to form
    // 
    // Page 119 User Setup
    //   //QC71 Added "Quality Manager" Field
    // 
    // Page 130 Posted Sales Shipment
    //   //QC  Replaced Print Command button with Print Menu button.
    //       Added Menu choice to print the Certificate of Analysis
    // 
    //   //QC7.2 Added Image to CoA Print Button and Promote to Ribbon
    //       Added "Quality" Promoted Action Category
    // 
    // Page 6500 Item Tracking Summary
    //    //QC   Add QC fields to Page
    //           Add code on AssistEdit of 'QC Compliance' field
    //    //QC37.05   Make Serial No. visiable too.
    //    //QC7.7
    //           - Rework and Expansion of QC Compliance Logic
    //           - See Also, Table 338 and Codeunit 6501 for other changes related to this
    //           - Added Fields "Cust Specs Exist", "Cust Test Exists", "Item Test Non Conformance" and "Cust Test Non Conformance"
    //           - Changed Caption of "QC Specs Exist" and "QC Test Exists" to "Item Specs Exist" and "Item Test Exists"
    //           - Added Image to the "Tests" Action, and added new "Specs" Action, and Promoted Both
    //           - MADE PAGE NON-EDITABLE
    // 
    //   //QC11.01 04/02/18
    //           - Created Action "Get QC Compliance List" to Replace OnAssistEdit Code on "QC Compliance" Field
    //           - Removed All Globals
    //           - Removed Property to Make Page Non-Editable
    //           - Removed StyleExpr Property on "QC Compliance" Field
    // 
    // Page 6501 Item Tracking Entries
    //           //QC   Expanded the header for better viewing
    //           Added new lookup to QC Lot No. Card from the Item Tracking Entry Menu Button
    // 
    // Page 6505 Lot No. Information Card
    //           //QC    Added reports under Related Information
    // //QC11.01
    //   - Changes for Extension-Readiness
    //     - Moved Field "Lot Test Exists" from (obsoleted) P14004591 Lot No. Card
    //     - Moved Actions "QC Specifications" and "QC Testing" from P14004591
    // 
    // Page 6508 Lot No. Information List
    //           //QC    Added reports under Related Information
    // //QC11.01
    //   - Changes for Extension-Readiness
    //     - Moved Fields "Lot Test Exists" and "Non-Conformance" from (obsoleted) P14004593 Lot No. List
    //     - Moved Actions "QC Specifications", "QC Testing" and Report "Test Results by Lot" from P14004593
    //     - Added a second "Item No." Field, because Original one is HIDDEN
    //     - Changed Style Property of "Non-Conformance" Field to "Strong", and Removed the "StyleExpr" Property
    // 
    // Page 6509  Serial No. Information List
    // //QC11.01
    //   - Changes for Extension-Readiness
    //     - Moved Fields "Date Filter", "Location Filter", "Bin Filter" from (obsoleted) P14004614 Item Serial No. List
    //     - Added a second "Item No." Field, because Original one is HIDDEN
    // 
    // Page 6510 Item Tracking Lines
    // //QC11.02
    //   - Changes for Extension-Readiness
    //     - Created new "Lot No." and "Serial No." Fields. Changed Visibility on original Lot No. and Serial No. Fields to FALSE
    //     - Changed Locals and Assist-Edit Code on new Fields To Call new Collect Item Tracking Summary Codeunit 14004595 (replaces call to CU 6501)
    // 
    // Page 6511 Posted Item Tracking Lines
    //           //QC  Added ActionItems Container and Actions thereunder
    //           Add one global variable (Cannot find)
    // 
    // Page 9012 Shop Supervisor Role Center
    //           //QC6  Added QC Activities ActionGroup and Actions thereunder
    //           //QC7.2
    //           - Added "Tracked Items" and "Purchase Orders" Activity Buttons
    //           - Hooked up P 14004614 to Serial No. List Activity Button
    //           //QC7.3
    //           - Added Action to "Quality Control" to launch "Quality Test Lines" Page


    trigger OnRun();
    begin
    end;

    var
        QCText000: Label 'Quality tests were not found for this Lot No.';
        QCText001: Label 'Quality tests were not found for this Serial No.';
        QCText002: Label 'Quality Specifications were not found for this Item No.';

    [EventSubscriber(ObjectType::Page, 130, 'OnAfterActionEvent', 'PrintCertificateofSupply', false, false)]
    local procedure PostedSalesShipmentOnAfterActionPrintCertofSupply(var Rec: Record "Sales Shipment Header");
    var
        CertificateOfSupply: Record "Certificate of Supply";
    begin
        CertificateOfSupply.SETRANGE("Document Type", CertificateOfSupply."Document Type"::"Sales Shipment");
        CertificateOfSupply.SETRANGE("Document No.", Rec."No.");
        CertificateOfSupply.Print;
    end;

    [EventSubscriber(ObjectType::Page, 50731, 'OnAfterActionEvent', 'QCItemNoSpecs', false, false)]
    local procedure ItemTrackingSummaryOnAfterActionItemNoSpecs(var Rec: Record "Entry Summary");
    var
        QualitySpecHeaderT: Record QCSpecificationHeader_PQ;
    begin
        QualitySpecHeaderT.SETFILTER("Customer No.", '%1|%2', '', Rec."Customer No."); //Only "Item" Specs, and Specs for THIS Customer!

        QualitySpecHeaderT.SETCURRENTKEY("Item No.");
        QualitySpecHeaderT.SETRANGE("Item No.", Rec."Item No.");
        QualitySpecHeaderT.SETRANGE(Type, '');
        if QualitySpecHeaderT.FIND('-') then
            PAGE.RUN(PAGE::QCSpecificationList_PQ, QualitySpecHeaderT)
        else
            ERROR(QCText001);
    end;

    [EventSubscriber(ObjectType::Page, 50731, 'OnAfterActionEvent', 'QCLotSerialNoTests', false, false)]
    local procedure ItemTrackingSummaryOnAfterActionLotSerialNoTests(var Rec: Record "Entry Summary");
    var
        QualityTestHeaderT: Record QualityTestHeader_PQ;
    begin
        if Rec."Lot No." <> '' then begin
            QualityTestHeaderT.SETCURRENTKEY("Item No.", "Lot No./Serial No.");
            QualityTestHeaderT.SETRANGE("Item No.", Rec."Item No.");
            QualityTestHeaderT.SETRANGE("Lot No./Serial No.", Rec."Lot No.");
            if QualityTestHeaderT.FIND('-') then
                PAGE.RUN(PAGE::QCTestList_PQ, QualityTestHeaderT)
            else
                ERROR(QCText000);
        end else begin
            //QualityTestHeaderT.SETCURRENTKEY("Item No.","Lot No./Serial No.");
            QualityTestHeaderT.SETRANGE("Item No.", Rec."Item No.");
            QualityTestHeaderT.SETRANGE("Lot No./Serial No.", Rec."Serial No.");
            if QualityTestHeaderT.FIND('-') then
                PAGE.RUN(PAGE::QCTestList_PQ, QualityTestHeaderT)
            else
                ERROR(QCText001);
        end;
    end;

    [EventSubscriber(ObjectType::Page, 50731, 'OnAfterActionEvent', 'QCComplianceList', false, false)]
    local procedure ItemTrackingSummaryOnAfterActionQCComplianceList(var Rec: Record "Entry Summary");
    var
        QualityCodeUnit: Codeunit QCFunctionLibrary_PQ;
    begin
        QualityCodeUnit.GetTempCompliance(Rec);
    end;

    [EventSubscriber(ObjectType::Page, 1174, 'OnBeforeDrillDown', '', false, false)]
    local procedure OnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        QualityTestHdr: Record QualityTestHeader_PQ;
        QualitySpecHdr: Record QCSpecificationHeader_PQ;
    begin
        if DocumentAttachment."Table ID" = Database::QualityTestHeader_PQ then begin
            RecRef.Open(DATABASE::QualityTestHeader_PQ);
            if QualityTestHdr.Get(DocumentAttachment."No.") then
                RecRef.GetTable(QualityTestHdr);
        end;

        if DocumentAttachment."Table ID" = Database::QCSpecificationHeader_PQ then begin
            RecRef.Open(DATABASE::QCSpecificationHeader_PQ);
            QualitySpecHdr.Reset();
            QualitySpecHdr.SetRange(Type, DocumentAttachment."No.");
            if QualitySpecHdr.FindFirst() then
                RecRef.GetTable(QualitySpecHdr);
        end;
    end;

    [EventSubscriber(ObjectType::Page, 1173, 'OnAfterOpenForRecRef', '', false, false)]
    local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef; var FlowFieldsEditable: Boolean)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            DATABASE::QualityTestHeader_PQ:
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;

            DATABASE::QCSpecificationHeader_PQ:
                begin
                    FieldRef := RecRef.Field(4);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;
    end;

}

