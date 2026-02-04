codeunit 50705 QCItemTrackingColl_PQ
{
    // version QC11.02

    // //QC11.02 
    //   - Created from NAV CU 6501
    //   - Called from OnAssistEdit Triggers of "AM QC Lot No. and "AM QC Serial No." Fields on Page 6510
    //   - The only Reason this CU Exists is because you can't Change Codeunits with Extensions
    //   - NAV CU 6501 will no longer be modified by QC
    //   - Changed Local Var in Func. "AssistEditTrackingNo" to point to "AM QC Item Tracking Summary" Page

    Permissions = TableData "Item Entry Relation" = rd,
                  TableData "Value Entry Relation" = rd;

    trigger OnRun();
    begin
    end;

    var
        Text004: Label 'Counting records...';
        TempGlobalReservEntry: Record "Reservation Entry" temporary;
        TempGlobalAdjustEntry: Record "Reservation Entry" temporary;
        TempGlobalEntrySummary: Record "Entry Summary" temporary;
        TempGlobalChangedEntrySummary: Record "Entry Summary" temporary;
        CurrItemTrackingCode: Record "Item Tracking Code";
        TempGlobalTrackingSpec: Record "Tracking Specification" temporary;
        CurrBinCode: Code[20];
        LastSummaryEntryNo: Integer;
        LastReservEntryNo: Integer;
        FullGlobalDataSetExists: Boolean;
        AvailabilityWarningsMsg: Label 'The data used for availability calculation has been updated.\There are availability warnings on one or more lines.';
        NoAvailabilityWarningsMsg: Label 'The data used for availability calculation has been updated.\There are no availability warnings.';
        Text009: Label '%1 List';
        Text010: Label '%1 %2 - Availability';
        Text011: Label 'Item Tracking - Select Entries';
        PartialGlobalDataSetExists: Boolean;
        SkipLot: Boolean;
        Text013: Label 'Neutralize consumption/output';
        //LotNoBySNNotFoundErr: TextConst Comment = '%1 - serial number.', enu = 'A lot number could not be found for serial number %1.', ESM = 'No se encontró un número de lote para el número de serie %1.', FRC = 'Un numéro de lot est introuvable pour le numéro de série %1.', ENC = 'A lot number could not be found for serial number %1.';

        LotNoBySNNotFoundErr: Label 'A lot number could not be found for serial number %1.';

    [Scope('cloud')]
    procedure AssistEditTrackingNo(var TempTrackingSpecification: Record "Tracking Specification" temporary; SearchForSupply: Boolean; CurrentSignFactor: Integer; LookupMode: Option "Serial No.","Lot No."; MaxQuantity: Decimal);
    var
        ItemTrackingSummaryForm: Page QCItemTrackingSummary_PQ;
        Window: Dialog;
        AvailableQty: Decimal;
        AdjustmentQty: Decimal;
        QtyOnLine: Decimal;
        QtyHandledOnLine: Decimal;
        NewQtyOnLine: Decimal;
    begin
        //QC11.02 Changed Local Var. "ItemTrackingSummaryForm" to point to Page "AM QC Item Tracking Summary" instead of Page 6500

        OnBeforeAssistEditTrackingNo(TempTrackingSpecification, SearchForSupply, CurrentSignFactor, LookupMode, MaxQuantity);

        Window.OPEN(Text004);

        if not FullGlobalDataSetExists then
            RetrieveLookupData(TempTrackingSpecification, true);

        TempGlobalReservEntry.RESET;
        TempGlobalEntrySummary.RESET;

        // Select the proper key on form
        TempGlobalEntrySummary.SETCURRENTKEY("Expiration Date");
        TempGlobalEntrySummary.SETFILTER("Expiration Date", '<>%1', 0D);
        if TempGlobalEntrySummary.ISEMPTY then
            TempGlobalEntrySummary.SETCURRENTKEY("Lot No.", "Serial No.");
        TempGlobalEntrySummary.SETRANGE("Expiration Date");
        ItemTrackingSummaryForm.SETTABLEVIEW(TempGlobalEntrySummary);

        TempGlobalEntrySummary.SETCURRENTKEY("Lot No.", "Serial No.");
        case LookupMode of
            LookupMode::"Serial No.":
                begin
                    if TempTrackingSpecification."Lot No." <> '' then
                        TempGlobalEntrySummary.SETRANGE("Lot No.", TempTrackingSpecification."Lot No.");
                    TempGlobalEntrySummary.SETRANGE("Serial No.", TempTrackingSpecification."Serial No.");
                    if TempGlobalEntrySummary.FINDFIRST then
                        ItemTrackingSummaryForm.SETRECORD(TempGlobalEntrySummary);
                    TempGlobalEntrySummary.SETFILTER("Serial No.", '<>%1', '');
                    TempGlobalEntrySummary.SETFILTER("Table ID", '<>%1', 0);
                    ItemTrackingSummaryForm.CAPTION := STRSUBSTNO(Text009, TempGlobalReservEntry.FIELDCAPTION("Serial No."));
                end;
            LookupMode::"Lot No.":
                begin
                    if TempTrackingSpecification."Serial No." <> '' then
                        TempGlobalEntrySummary.SETRANGE("Serial No.", TempTrackingSpecification."Serial No.")
                    else
                        TempGlobalEntrySummary.SETRANGE("Serial No.", '');
                    TempGlobalEntrySummary.SETRANGE("Lot No.", TempTrackingSpecification."Lot No.");
                    if TempGlobalEntrySummary.FINDFIRST then
                        ItemTrackingSummaryForm.SETRECORD(TempGlobalEntrySummary);
                    TempGlobalEntrySummary.SETFILTER("Lot No.", '<>%1', '');
                    ItemTrackingSummaryForm.CAPTION := STRSUBSTNO(Text009, TempGlobalEntrySummary.FIELDCAPTION("Lot No."));
                end;
        end;

        ItemTrackingSummaryForm.SetCurrentBinAndItemTrkgCode(CurrBinCode, CurrItemTrackingCode);
        ItemTrackingSummaryForm.SetSources(TempGlobalReservEntry, TempGlobalEntrySummary);
        ItemTrackingSummaryForm.LOOKUPMODE(SearchForSupply);
        ItemTrackingSummaryForm.SetSelectionMode(false);

        Window.CLOSE;
        if ItemTrackingSummaryForm.RUNMODAL = ACTION::LookupOK then begin
            ItemTrackingSummaryForm.GETRECORD(TempGlobalEntrySummary);

            if TempGlobalEntrySummary."Bin Active" then
                AvailableQty := MinValueAbs(TempGlobalEntrySummary."Bin Content", TempGlobalEntrySummary."Total Available Quantity")
            else
                AvailableQty := TempGlobalEntrySummary."Total Available Quantity";
            QtyHandledOnLine := TempTrackingSpecification."Quantity Handled (Base)";
            QtyOnLine := TempTrackingSpecification."Quantity (Base)" - QtyHandledOnLine;

            if CurrentSignFactor > 0 then begin
                AvailableQty := -AvailableQty;
                QtyHandledOnLine := -QtyHandledOnLine;
                QtyOnLine := -QtyOnLine;
            end;

            if MaxQuantity < 0 then begin
                AdjustmentQty := MaxQuantity;
                if AvailableQty < 0 then
                    if AdjustmentQty > AvailableQty then
                        AdjustmentQty := AvailableQty;
                if QtyOnLine + AdjustmentQty < 0 then
                    AdjustmentQty := -QtyOnLine;
            end else begin
                AdjustmentQty := AvailableQty;
                if AvailableQty < 0 then begin
                    if QtyOnLine + AdjustmentQty < 0 then
                        AdjustmentQty := -QtyOnLine;
                end else
                    AdjustmentQty := MinValueAbs(MaxQuantity, AvailableQty);
            end;
            if LookupMode = LookupMode::"Serial No." then
                TempTrackingSpecification.VALIDATE("Serial No.", TempGlobalEntrySummary."Serial No.");
            TempTrackingSpecification.VALIDATE("Lot No.", TempGlobalEntrySummary."Lot No.");

            TransferExpDateFromSummary(TempTrackingSpecification, TempGlobalEntrySummary);
            if TempTrackingSpecification.IsReclass then begin
                TempTrackingSpecification."New Serial No." := TempTrackingSpecification."Serial No.";
                TempTrackingSpecification."New Lot No." := TempTrackingSpecification."Lot No.";
            end;

            NewQtyOnLine := QtyOnLine + AdjustmentQty + QtyHandledOnLine;
            if TempTrackingSpecification."Serial No." <> '' then
                if ABS(NewQtyOnLine) > 1 then
                    NewQtyOnLine := NewQtyOnLine / ABS(NewQtyOnLine); // Set to a signed value of 1.

            TempTrackingSpecification.VALIDATE("Quantity (Base)", NewQtyOnLine);

            OnAfterAssistEditTrackingNo(TempTrackingSpecification, TempGlobalEntrySummary);
        end;
    end;

    [Scope('cloud')]
    procedure SelectMultipleTrackingNo(var TempTrackingSpecification: Record "Tracking Specification" temporary; MaxQuantity: Decimal; CurrentSignFactor: Integer);
    var
        TempEntrySummary: Record "Entry Summary" temporary;
        ItemTrackingSummaryForm: Page "Item Tracking Summary";
        Window: Dialog;
        LookupMode: Option "Serial No.","Lot No.",All;
    begin
        CLEAR(ItemTrackingSummaryForm);
        Window.OPEN(Text004);
        LookupMode := LookupMode::All;
        if not FullGlobalDataSetExists then
            RetrieveLookupData(TempTrackingSpecification, true);

        TempGlobalReservEntry.RESET;
        TempGlobalEntrySummary.RESET;

        // Swap sign if negative supply lines
        if CurrentSignFactor > 0 then
            MaxQuantity := -MaxQuantity;

        // Select the proper key
        TempGlobalEntrySummary.SETCURRENTKEY("Expiration Date");
        TempGlobalEntrySummary.SETFILTER("Expiration Date", '<>%1', 0D);
        if TempGlobalEntrySummary.ISEMPTY then
            TempGlobalEntrySummary.SETCURRENTKEY("Lot No.", "Serial No.");
        TempGlobalEntrySummary.SETRANGE("Expiration Date");

        // Initialize form
        ItemTrackingSummaryForm.CAPTION := Text011;
        ItemTrackingSummaryForm.SETTABLEVIEW(TempGlobalEntrySummary);
        TempGlobalEntrySummary.SETFILTER("Table ID", '<>%1', 0); // Filter out summations
        ItemTrackingSummaryForm.SetSources(TempGlobalReservEntry, TempGlobalEntrySummary);
        ItemTrackingSummaryForm.SetSelectionMode(MaxQuantity <> 0);
        ItemTrackingSummaryForm.LOOKUPMODE(true);
        ItemTrackingSummaryForm.SetMaxQuantity(MaxQuantity);
        ItemTrackingSummaryForm.SetCurrentBinAndItemTrkgCode(CurrBinCode, CurrItemTrackingCode);

        // Run preselection on form
        ItemTrackingSummaryForm.AutoSelectTrackingNo;

        Window.CLOSE;

        if not (ItemTrackingSummaryForm.RUNMODAL = ACTION::LookupOK) then
            exit;
        ItemTrackingSummaryForm.GetSelected(TempEntrySummary);
        if TempEntrySummary.ISEMPTY then
            exit;

        // Swap sign on the selected entries if parent is a negative supply line
        if CurrentSignFactor > 0 then // Negative supply lines
            if TempEntrySummary.FIND('-') then
                repeat
                    TempEntrySummary."Selected Quantity" := -TempEntrySummary."Selected Quantity";
                    TempEntrySummary.MODIFY;
                until TempEntrySummary.NEXT = 0;

        // Modify the item tracking lines with the selected quantities
        AddSelectedTrackingToDataSet(TempEntrySummary, TempTrackingSpecification, CurrentSignFactor);
    end;

    [Scope('cloud')]
    procedure LookupTrackingAvailability(var TempTrackingSpecification: Record "Tracking Specification" temporary; LookupMode: Option "Serial No.","Lot No.");
    var
        ItemTrackingSummaryForm: Page "Item Tracking Summary";
        Window: Dialog;
    begin
        case LookupMode of
            LookupMode::"Serial No.":
                if TempTrackingSpecification."Serial No." = '' then
                    exit;
            LookupMode::"Lot No.":
                if TempTrackingSpecification."Lot No." = '' then
                    exit;
        end;

        CLEAR(ItemTrackingSummaryForm);
        Window.OPEN(Text004);
        TempGlobalChangedEntrySummary.RESET;

        if not (PartialGlobalDataSetExists or FullGlobalDataSetExists) then
            RetrieveLookupData(TempTrackingSpecification, true);

        TempGlobalEntrySummary.RESET;
        TempGlobalEntrySummary.SETCURRENTKEY("Lot No.", "Serial No.");

        TempGlobalReservEntry.RESET;

        case LookupMode of
            LookupMode::"Serial No.":
                begin
                    TempGlobalEntrySummary.SETRANGE("Serial No.", TempTrackingSpecification."Serial No.");
                    TempGlobalEntrySummary.SETFILTER("Table ID", '<>%1', 0); // Filter out summations
                    TempGlobalReservEntry.SETRANGE("Serial No.", TempTrackingSpecification."Serial No.");
                    ItemTrackingSummaryForm.CAPTION := STRSUBSTNO(
                        Text010, TempTrackingSpecification.FIELDCAPTION("Serial No."), TempTrackingSpecification."Serial No.");
                end;
            LookupMode::"Lot No.":
                begin
                    TempGlobalEntrySummary.SETRANGE("Serial No.", '');
                    TempGlobalEntrySummary.SETRANGE("Lot No.", TempTrackingSpecification."Lot No.");
                    TempGlobalReservEntry.SETRANGE("Lot No.", TempTrackingSpecification."Lot No.");
                    ItemTrackingSummaryForm.CAPTION := STRSUBSTNO(
                        Text010, TempTrackingSpecification.FIELDCAPTION("Lot No."), TempTrackingSpecification."Lot No.");
                end;
        end;

        ItemTrackingSummaryForm.SetSources(TempGlobalReservEntry, TempGlobalEntrySummary);
        ItemTrackingSummaryForm.SetCurrentBinAndItemTrkgCode(CurrBinCode, CurrItemTrackingCode);
        ItemTrackingSummaryForm.LOOKUPMODE(false);
        ItemTrackingSummaryForm.SetSelectionMode(false);
        Window.CLOSE;
        ItemTrackingSummaryForm.RUNMODAL;
    end;

    [Scope('cloud')]
    procedure RetrieveLookupData(var TrackingSpecification: Record "Tracking Specification" temporary; FullDataSet: Boolean);
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        ReservEntry: Record "Reservation Entry";
        TempReservEntry: Record "Reservation Entry" temporary;
        xTrackingSpecification: Record "Tracking Specification" temporary;
    begin
        LastSummaryEntryNo := 0;
        LastReservEntryNo := 0;
        xTrackingSpecification := TrackingSpecification;
        TempGlobalReservEntry.RESET;
        TempGlobalReservEntry.DELETEALL;
        TempGlobalEntrySummary.RESET;
        TempGlobalEntrySummary.DELETEALL;

        ReservEntry.RESET;
        if ReservEntry.FINDLAST then
            LastReservEntryNo := ReservEntry."Entry No.";
        ReservEntry.SETCURRENTKEY(
          "Item No.", "Variant Code", "Location Code", "Item Tracking", "Reservation Status", "Lot No.", "Serial No.");
        ReservEntry.SETRANGE("Item No.", TrackingSpecification."Item No.");
        ReservEntry.SETRANGE("Variant Code", TrackingSpecification."Variant Code");
        ReservEntry.SETRANGE("Location Code", TrackingSpecification."Location Code");
        ReservEntry.SETFILTER("Item Tracking", '<>%1', ReservEntry."Item Tracking"::None);

        if ReservEntry.FINDSET then
            repeat
                TempReservEntry := ReservEntry;
                if CanIncludeReservEntryToTrackingSpec(TempReservEntry) then
                    TempReservEntry.INSERT;
            until ReservEntry.NEXT = 0;

        ItemLedgEntry.RESET;
        ItemLedgEntry.SETCURRENTKEY("Item No.", Open, "Variant Code", "Location Code", "Item Tracking",
          "Lot No.", "Serial No.");
        ItemLedgEntry.SETRANGE("Item No.", TrackingSpecification."Item No.");
        ItemLedgEntry.SETRANGE("Variant Code", TrackingSpecification."Variant Code");
        ItemLedgEntry.SETRANGE(Open, true);
        ItemLedgEntry.SETRANGE("Location Code", TrackingSpecification."Location Code");

        if FullDataSet then begin
            TransferReservEntryToTempRec(TempReservEntry, TrackingSpecification);
            TransferItemLedgToTempRec(ItemLedgEntry, TrackingSpecification);
        end else begin
            if TrackingSpecification.FIND('-') then
                repeat
                    ItemLedgEntry.SetTrackingFilterFromSpec(TrackingSpecification);
                    ReservEntry.SetTrackingFilterFromSpec(TrackingSpecification);
                    TransferReservEntryToTempRec(TempReservEntry, TrackingSpecification);
                    TransferItemLedgToTempRec(ItemLedgEntry, TrackingSpecification);
                until TrackingSpecification.NEXT = 0;
        end;

        TempGlobalEntrySummary.RESET;
        UpdateCurrentPendingQty;
        TrackingSpecification := xTrackingSpecification;

        PartialGlobalDataSetExists := true;
        FullGlobalDataSetExists := FullDataSet;
        AdjustForDoubleEntries;
    end;

    local procedure TransferItemLedgToTempRec(var ItemLedgEntry: Record "Item Ledger Entry"; var TrackingSpecification: Record "Tracking Specification" temporary);
    begin
        if ItemLedgEntry.FINDSET then
            repeat
                if ItemLedgEntry.TrackingExists then begin
                    TempGlobalReservEntry.INIT;
                    TempGlobalReservEntry."Entry No." := -ItemLedgEntry."Entry No.";
                    TempGlobalReservEntry."Reservation Status" := TempGlobalReservEntry."Reservation Status"::Surplus;
                    TempGlobalReservEntry.Positive := ItemLedgEntry.Positive;
                    TempGlobalReservEntry."Item No." := ItemLedgEntry."Item No.";
                    TempGlobalReservEntry."Location Code" := ItemLedgEntry."Location Code";
                    TempGlobalReservEntry."Quantity (Base)" := ItemLedgEntry."Remaining Quantity";
                    TempGlobalReservEntry."Source Type" := DATABASE::"Item Ledger Entry";
                    TempGlobalReservEntry."Source Ref. No." := ItemLedgEntry."Entry No.";
                    TempGlobalReservEntry."Serial No." := ItemLedgEntry."Serial No.";
                    TempGlobalReservEntry."Lot No." := ItemLedgEntry."Lot No.";
                    TempGlobalReservEntry."Variant Code" := ItemLedgEntry."Variant Code";

                    if TempGlobalReservEntry.Positive then begin
                        TempGlobalReservEntry."Warranty Date" := ItemLedgEntry."Warranty Date";
                        TempGlobalReservEntry."Expiration Date" := ItemLedgEntry."Expiration Date";
                        TempGlobalReservEntry."Expected Receipt Date" := 0D
                    end else
                        TempGlobalReservEntry."Shipment Date" := DMY2DATE(31, 12, 9999);

                    if TempGlobalReservEntry.INSERT then
                        CreateEntrySummary(TrackingSpecification, TempGlobalReservEntry);
                end;
            until ItemLedgEntry.NEXT = 0;
    end;

    local procedure TransferReservEntryToTempRec(var TempReservEntry: Record "Reservation Entry" temporary; var TrackingSpecification: Record "Tracking Specification" temporary);
    begin
        if TempReservEntry.FINDSET then
            repeat
                TempGlobalReservEntry := TempReservEntry;
                TempGlobalReservEntry."Transferred from Entry No." := 0;
                if TempGlobalReservEntry.INSERT then
                    CreateEntrySummary(TrackingSpecification, TempGlobalReservEntry);
            until TempReservEntry.NEXT = 0;
    end;

    local procedure CreateEntrySummary(TrackingSpecification: Record "Tracking Specification" temporary; TempReservEntry: Record "Reservation Entry" temporary);
    var
        LookupMode: Option "Serial No.","Lot No.";
    begin
        CreateEntrySummary2(TrackingSpecification, LookupMode::"Serial No.", TempReservEntry);
        CreateEntrySummary2(TrackingSpecification, LookupMode::"Lot No.", TempReservEntry);
    end;

    local procedure CreateEntrySummary2(TrackingSpecification: Record "Tracking Specification" temporary; LookupMode: Option "Serial No.","Lot No."; TempReservEntry: Record "Reservation Entry" temporary);
    var
        DoInsert: Boolean;
        JobT: Record Job;
        TransferLineT: Record "Transfer Line";
        ProdOrderCompLineT: Record "Prod. Order Component";
        "-QC11.01---": Integer;
        QCFuncs: Codeunit QCFunctionLibrary_PQ;
    begin
        //QC11.01 - Created Local Var and Added Function Call to Replace many Local Vars and huge Code-Block Insertion

        TempGlobalEntrySummary.RESET;
        TempGlobalEntrySummary.SETCURRENTKEY("Lot No.", "Serial No.");

        // Set filters
        case LookupMode of
            LookupMode::"Serial No.":
                begin
                    if TempReservEntry."Serial No." = '' then
                        exit;
                    TempGlobalEntrySummary.SetTrackingFilterFromReservEntry(TempReservEntry);
                end;
            LookupMode::"Lot No.":
                begin
                    //TempGlobalEntrySummary.SetTrackingFilter('', TempReservEntry."Lot No.");
                    if TempReservEntry."Serial No." <> '' then
                        TempGlobalEntrySummary.SETRANGE("Table ID", 0)
                    else
                        TempGlobalEntrySummary.SETFILTER("Table ID", '<>%1', 0);
                end;
        end;

        // If no summary exists, create new record
        if not TempGlobalEntrySummary.FINDFIRST then begin
            TempGlobalEntrySummary.INIT;
            TempGlobalEntrySummary."Entry No." := LastSummaryEntryNo + 1;
            LastSummaryEntryNo := TempGlobalEntrySummary."Entry No.";

            if (LookupMode = LookupMode::"Lot No.") and (TempReservEntry."Serial No." <> '') then
                TempGlobalEntrySummary."Table ID" := 0 // Mark as summation
            else
                TempGlobalEntrySummary."Table ID" := TempReservEntry."Source Type";
            if LookupMode = LookupMode::"Serial No." then
                TempGlobalEntrySummary."Serial No." := TempReservEntry."Serial No."
            else
                TempGlobalEntrySummary."Serial No." := '';
            TempGlobalEntrySummary."Lot No." := TempReservEntry."Lot No.";
            TempGlobalEntrySummary."Bin Active" := CurrBinCode <> '';
            UpdateBinContent(TempGlobalEntrySummary);

            // If consumption/output fill in double entry value here:
            TempGlobalEntrySummary."Double-entry Adjustment" :=
              MaxDoubleEntryAdjustQty(TrackingSpecification, TempGlobalEntrySummary);

            DoInsert := true;
        end;

        // Sum up values
        if TempReservEntry.Positive then begin
            TempGlobalEntrySummary."Warranty Date" := TempReservEntry."Warranty Date";
            TempGlobalEntrySummary."Expiration Date" := TempReservEntry."Expiration Date";

            //QC11.01 Start - Substitute the Call below for the huge Code Block Insertion that used to go right here
            QCFuncs.ItemTrackingDataCollectionCreateEntrySummary2(TrackingSpecification, LookupMode, TempReservEntry, TempGlobalEntrySummary);
            //QC11.01 Finish

            // //QC Start - Begin HUGE Code Insersion that comes between 2 lines of Original NAV Code
            //
            //  //QC
            //  GetCompanySpec := FALSE;
            //  TempGlobalEntrySummary."QC Non Compliance" := FALSE;
            //  TempGlobalEntrySummary."QC Compliance" := '';
            //
            //  IF TrackingSpecification."Source Type" = DATABASE::"Sales Line" THEN // Handle Sales-Line Source
            //    IF SalesLineT.GET(TrackingSpecification."Source Subtype",TrackingSpecification."Source ID",
            //                      TrackingSpecification."Source Ref. No.")
            //                      //Source Subtype = Document Type
            //                      //Source ID      = Document No.
            //                      //Source Ref. No.= Line No.
            //    THEN BEGIN
            //      IF ItemT.GET(TrackingSpecification."Item No.") THEN BEGIN
            //        ItemT.CALCFIELDS("Has Quality Specifications");
            //        TempGlobalEntrySummary."QC Specs Exist" := ItemT."Has Quality Specifications"; //Set "QC Specs Exist"
            //      END;
            //
            //      //- Customer or Company Spec??
            //      IF QSpecHeaderT.GET(TrackingSpecification."Item No.",
            //                          SalesLineT."Sell-to Customer No.",'') THEN BEGIN
            //        ActiveVersionCode := QualitySpecsCopy.GetQCVersion(TrackingSpecification."Item No.",
            //                                                           SalesLineT."Sell-to Customer No.",'',
            //                                                           WORKDATE,2);   //Origin = Salesline
            //        IF ActiveVersionCode = '' THEN
            //          IF QSpecHeaderT.Status <> QSpecHeaderT.Status::Certified THEN
            //          //QC7.7 Start
            //          BEGIN
            //            GetCompanySpec := TRUE; //original line
            //            TempGlobalEntrySummary."Cust Specs Exist" := TRUE; //QC7.7 Added
            //          END;
            //          //QC7.7 Finish
            //      END ELSE
            //        GetCompanySpec := TRUE;
            //
            // //QC7.7 Note - GetCompanySpec is part of the original QC-Related Logic in this Function. It relates to the (original) Cooked-Down "Compliance" Determination...
            // // ...It is less-Relevant (but not completely so) with the addition of Function "FinalizeConformanceDecision" having the Final Say-So as to what ends up as...
            // // ...the Cooked-Down "QC Non Compliance" Boolean and "QC Compliance" Text 'Results'
            //
            //      //end- Customer or Company Spec??
            //
            // //QC7.7 Start - Not "Obeying" "GetCompanySpec" anymore. Need to look at BOTH Company (Item) AND Customer Specs and Tests!
            //
            //      //IF GetCompanySpec THEN BEGIN
            //      BEGIN
            // //QC7.7 Finish
            //        ActiveVersionCode := QualitySpecsCopy.GetQCVersion(TrackingSpecification."Item No.",
            //                                                           '','',WORKDATE,2);   //Origin = SalesLine
            //
            //        QSpecLineT.SETRANGE("Item No.",TrackingSpecification."Item No.");
            //        QSpecLineT.SETRANGE("Customer No.",'');
            //        QSpecLineT.SETRANGE(Type,'');
            //        QSpecLineT.SETRANGE("Version Code",ActiveVersionCode);
            //        IF QSpecLineT.FINDSET THEN //Found Item Spec
            //          REPEAT
            //            QLotTestLineT.SETRANGE("Item No.",TrackingSpecification."Item No.");
            //            //QC37.05
            //            IF LookupMode = LookupMode::"Lot No." THEN
            //              QLotTestLineT.SETRANGE("Lot No./Serial No.",TempReservEntry."Lot No.");
            //            IF LookupMode = LookupMode::"Serial No." THEN
            //              QLotTestLineT.SETRANGE("Lot No./Serial No.",TempReservEntry."Serial No.");
            //                   //
            //            QLotTestLineT.SETRANGE("Quality Measure",QSpecLineT."Quality Measure");
            //            QLotTestLineT.SETRANGE("Test Status",QLotTestLineT."Test Status"::"Certified Final"); //QC80.1 Corrected "Test Status" value
            //            //QC4SP1.2
            //            QLotTestLineT.SETFILTER("Customer No.",'%1','');
            //              //
            //
            //            IF QLotTestLineT.FINDLAST THEN BEGIN
            //              TempGlobalEntrySummary."QC Test Exists" := TRUE;  //Set "QC Test Exists"
            //              //QC80.1 - Added "Test Line Complete" term to line below
            //              IF ((QLotTestLineT."Actual Measure" <> 0) OR (QLotTestLineT."Test Line Complete" = TRUE)) THEN BEGIN // Handle Numeric Test Line
            //                IF QLotTestLineT."Non-Conformance" THEN BEGIN
            //                  TempGlobalEntrySummary."QC Non Compliance" := TRUE;
            //                  //QC7.7 Start
            //                  TempGlobalEntrySummary."Item Test Non Compliant" := TRUE; //Set new Field
            //                  //TempGlobalEntrySummary."QC Compliance" := 'NO';
            //                  //QC7.7 Finish
            //                END;
            //              END ELSE BEGIN  // Handle 'Result List' Test Line
            //                //QC5.01 begin
            //                IF QLotTestLineT.Result <> '' THEN BEGIN
            //                  IF QLotTestLineT."Non-Conformance" THEN BEGIN
            //                    TempGlobalEntrySummary."QC Non Compliance" := TRUE;
            //                    //QC7.7 Start
            //                    TempGlobalEntrySummary."Item Test Non Compliant" := TRUE; //Set new Field
            //                    //TempGlobalEntrySummary."QC Compliance" := 'NO';
            //                    //QC7.7 Finish
            //                  END;
            //                END;
            //              END;
            //                //QC5.01 end
            //            END;
            //          UNTIL QSpecLineT.NEXT = 0;
            //
            //          // new fields on Entry Summary table
            //          TempGlobalEntrySummary."QC Option" := TempGlobalEntrySummary."QC Option"::Company;
            //          TempGlobalEntrySummary."Item No." := TrackingSpecification."Item No.";
            //          TempGlobalEntrySummary."Customer No." := '';
            //          TempGlobalEntrySummary."Version Code" := ActiveVersionCode;
            //
            // //End Sales Line Without Sell-To Customer (???) Processing (Just to set proper flags?)
            // //Now, Process Sales-Line "Call" WITH a Sell-To Customer No. (Normal?)
            //
            // //QC7.7 Start - REMoved the "ELSE", so that we process BOTH Company AND Customer-Specific Specs and Tests
            //      //END ELSE BEGIN     //get customer specific QC spec (GetCompanySpec = FALSE got us here...)
            //      END;
            //      BEGIN //If NOT "Use Company Spec" ...
            // //QC7.7 Finish
            //
            //        //**
            //        QSpecLineT.SETRANGE("Item No.",TrackingSpecification."Item No.");
            //        QSpecLineT.SETRANGE("Customer No.",SalesLineT."Sell-to Customer No.");
            //        QSpecLineT.SETRANGE(Type,'');
            //        QSpecLineT.SETRANGE("Version Code",ActiveVersionCode);
            //        IF QSpecLineT.FINDSET THEN
            //          BEGIN //QC7.7 Start (BEGIN added too)
            //            TempGlobalEntrySummary."Cust Specs Exist" := TRUE; //CUSTOMER (Sell-To Cust.) Spec Exists for this Item
            //            //QC7.7 Finish
            //            REPEAT
            //              QLotTestLineT.SETRANGE("Item No.",TrackingSpecification."Item No.");
            //              //QC37.05
            //              IF LookupMode = LookupMode::"Lot No." THEN
            //                QLotTestLineT.SETRANGE("Lot No./Serial No.",TempReservEntry."Lot No.");
            //              IF LookupMode = LookupMode::"Serial No." THEN
            //                QLotTestLineT.SETRANGE("Lot No./Serial No.",TempReservEntry."Serial No.");
            //                     //
            //              QLotTestLineT.SETRANGE("Quality Measure",QSpecLineT."Quality Measure");
            //              QLotTestLineT.SETRANGE("Test Status",QLotTestLineT."Test Status"::"Certified Final"); //QC80.1 Corrected "Test Status" value
            //              //QC4SP1.2
            //              QLotTestLineT.SETRANGE("Customer No.",SalesLineT."Sell-to Customer No.");
            //                //
            //              IF QLotTestLineT.FINDLAST THEN BEGIN //There IS a Customer-Specific Certified Test!
            //                //QC7.7 Start
            //                //TempGlobalEntrySummary."QC Test Exists" := TRUE;
            //                TempGlobalEntrySummary."Cust Test Exists" := TRUE; //Added "Cust Test Exists" Field, so use it!
            //                //QC7.7 Finish
            //                //QC80.1 - Added "Test Line Complete" term to line below
            //                IF ((QLotTestLineT."Actual Measure" <> 0) OR (QLotTestLineT."Test Line Complete" = TRUE)) THEN BEGIN // Handle Numeric Test Line
            //                  IF QLotTestLineT."Non-Conformance" = TRUE THEN BEGIN
            //                    TempGlobalEntrySummary."QC Non Compliance" := TRUE;
            //                    //QC7.7 Start
            //                    TempGlobalEntrySummary."Cust Test Non Compliant" := TRUE; //Added "Cust Test Passed" Field
            //                    //TempGlobalEntrySummary."QC Compliance" := 'NO';
            //                    //QC7.7 Finish
            //                  END;
            //                END ELSE BEGIN //Handle Result List Type
            //                  //QC5.01 begin
            //                  IF QLotTestLineT.Result <> '' THEN BEGIN
            //                    IF QLotTestLineT."Non-Conformance" = TRUE THEN BEGIN
            //                      TempGlobalEntrySummary."QC Non Compliance" := TRUE;
            //                      //QC7.7 Start
            //                      TempGlobalEntrySummary."Cust Test Non Compliant" := TRUE; //Added "Cust Test Passed" Field
            //                      //TempGlobalEntrySummary."QC Compliance" := 'NO';
            //                      //QC7.7 Finish
            //                    END;
            //                  END;
            //                END;
            //                  //QC5.01 end
            //
            // //QC7.7 Start - REMoved the "ELSE" (left the BEGIN to make Code easier to Manage later), because we want to ALWAYS know if there was a "Company" (Item) Test!
            //              //END ELSE BEGIN
            //              END;
            //              BEGIN
            // //QC7.7 Finish
            //
            //            //Attempt to find a test for this Item, but without a customer no. (Company a/k/a "Item" Test
            //
            //                QLotTestLineT.RESET;
            //                QLotTestLineT.SETRANGE("Item No.",TrackingSpecification."Item No.");
            //                //QC37.05
            //                IF LookupMode = LookupMode::"Lot No." THEN
            //                  QLotTestLineT.SETRANGE("Lot No./Serial No.",TempReservEntry."Lot No.");
            //                IF LookupMode = LookupMode::"Serial No." THEN
            //                  QLotTestLineT.SETRANGE("Lot No./Serial No.",TempReservEntry."Serial No.");
            //                       //
            //                QLotTestLineT.SETRANGE("Quality Measure",QSpecLineT."Quality Measure");
            //                QLotTestLineT.SETRANGE("Test Status",QLotTestLineT."Test Status"::"Certified Final"); //QC80.1 Corrected "Test Status" value
            //                //QC4SP1.2
            //                QLotTestLineT.SETFILTER("Customer No.",'%1',''); //Specifially look for ITEM Tests (rather than Item + Customer)
            //                      //
            //                IF QLotTestLineT.FINDLAST THEN BEGIN
            //                  TempGlobalEntrySummary."QC Test Exists" := TRUE;
            //                  //QC80.1 - Added "Test Line Complete" term to line below
            //                  IF ((QLotTestLineT."Actual Measure" <> 0) OR (QLotTestLineT."Test Line Complete" = TRUE)) THEN BEGIN // Handle Numeric Test Line
            //                    //QC4SP1.2
            //                    IF (QLotTestLineT."Actual Measure" < QSpecLineT."Lower Limit") AND
            //                       (QLotTestLineT."Actual Measure" > QSpecLineT."Upper Limit") THEN BEGIN
            //                      TempGlobalEntrySummary."QC Non Compliance" := TRUE;
            //                      //QC7.7 Start
            //                      TempGlobalEntrySummary."Item Test Non Compliant" := TRUE; // New Field Added
            //                      //TempGlobalEntrySummary."QC Compliance" := 'NO';
            //                      //QC7.7 Finish
            //                    END;
            //
            // //QC7.7 Start - Add in apparently missing "Result List" Type
            // //                END;
            //
            //                  END ELSE BEGIN //Handle Result List Type
            //                    IF QLotTestLineT.Result <> '' THEN BEGIN
            //                      IF QLotTestLineT."Non-Conformance" = TRUE THEN BEGIN
            //                        TempGlobalEntrySummary."QC Non Compliance" := TRUE;
            //                        //QC7.7 Start
            //                        TempGlobalEntrySummary."Item Test Non Compliant" := TRUE; //Added Field
            //                        //TempGlobalEntrySummary."QC Compliance" := 'NO';
            //                        //QC7.7 Finish
            //                      END;
            //                    END;
            //                  END;
            //
            // //QC7.7 FInish
            //
            //                END ELSE BEGIN
            //                  //QC4SP1.2 - test line not found
            //                  TempGlobalEntrySummary."QC Test Exists" := FALSE;
            //                  TempGlobalEntrySummary."QC Non Compliance" := TRUE;
            //                  //QC7.7 Start
            //                  TempGlobalEntrySummary."Cust Test Exists" := FALSE;
            //                  TempGlobalEntrySummary."Cust Test Non Compliant" := FALSE;
            //                  //TempGlobalEntrySummary."QC Compliance" := 'NO';
            //                  //QC7.7 Finish
            //                END;   //end
            //              END;
            //            UNTIL QSpecLineT.NEXT = 0;
            //          END;
            //
            //          // new fields on Entry Summary table
            //          TempGlobalEntrySummary."QC Option" := TempGlobalEntrySummary."QC Option"::Customer;
            //          TempGlobalEntrySummary."Item No." := TrackingSpecification."Item No.";
            //          TempGlobalEntrySummary."Customer No." := SalesLineT."Sell-to Customer No.";
            //          TempGlobalEntrySummary."Version Code" := ActiveVersionCode;
            //
            //      END;
            //    END;
            //
            // // -- END SALESLINE "CALL" ---
            //
            // //Process Item Journal Line "Call"
            //
            //   IF (TrackingSpecification."Source Type" = DATABASE::"Item Journal Line") THEN
            //     IF ItemJnlLineT.GET(TrackingSpecification."Source ID",TrackingSpecification."Source Batch Name",
            //                         TrackingSpecification."Source Ref. No.")
            //                       //Source Subtype = ??
            //                       //Source ID      = Journal Template Name
            //                       //Source Batch   = Journal Batch Name
            //                       //Source Ref. No.= Line No.
            //
            //     THEN BEGIN
            //       IF ItemT.GET(TrackingSpecification."Item No.") THEN BEGIN
            //         ItemT.CALCFIELDS("Has Quality Specifications");
            //         TempGlobalEntrySummary."QC Specs Exist" := ItemT."Has Quality Specifications";  //Set "QC Specs Exist"
            //       END;
            //
            //       GetCompanySpec := TRUE;    //Default for item jnl line.. assume no customer so get companys specs
            //
            //       IF GetCompanySpec = TRUE THEN BEGIN
            //         ActiveVersionCode := QualitySpecsCopy.GetQCVersion(TrackingSpecification."Item No.",
            //                                                            '','',WORKDATE,2);   //Origin = SalesLine
            //
            //         QSpecLineT.SETRANGE("Item No.",TrackingSpecification."Item No.");
            //         QSpecLineT.SETRANGE("Customer No.",'');
            //         QSpecLineT.SETRANGE(Type,'');
            //         QSpecLineT.SETRANGE("Version Code",ActiveVersionCode);
            //         IF QSpecLineT.FINDSET THEN
            //           REPEAT
            //             QLotTestLineT.SETRANGE("Item No.",TrackingSpecification."Item No.");
            //             //QC37.05
            //             IF LookupMode = LookupMode::"Lot No." THEN
            //               QLotTestLineT.SETRANGE("Lot No./Serial No.",TempReservEntry."Lot No.");
            //             IF LookupMode = LookupMode::"Serial No." THEN
            //               QLotTestLineT.SETRANGE("Lot No./Serial No.",TempReservEntry."Serial No.");
            //                    //
            //             QLotTestLineT.SETRANGE("Quality Measure",QSpecLineT."Quality Measure");
            //             QLotTestLineT.SETRANGE("Test Status",QLotTestLineT."Test Status"::"Certified Final"); //QC80.1 Corrected "Test Status" value
            //             //QC4SP1.2
            //             QLotTestLineT.SETFILTER("Customer No.",'%1','');
            //               //
            //             IF QLotTestLineT.FINDLAST THEN BEGIN
            //               TempGlobalEntrySummary."QC Test Exists" := TRUE; //Set "QC Test Exists"
            //                //QC80.1 - Added "Test Line Complete" term to line below
            //                IF ((QLotTestLineT."Actual Measure" <> 0) OR (QLotTestLineT."Test Line Complete" = TRUE)) THEN BEGIN // Handle Numeric Test Line
            //                 IF QLotTestLineT."Non-Conformance" = TRUE THEN BEGIN
            //                   TempGlobalEntrySummary."QC Non Compliance" := TRUE;
            //                   //QC7.7 Start
            //                   TempGlobalEntrySummary."Item Test Non Compliant" := TRUE; // New Field Added
            //                   //TempGlobalEntrySummary."QC Compliance" := 'NO';
            //                   //QC7.7 Finish
            //                 END;
            //               END ELSE BEGIN  //Else, it must be a Result List Test Line
            //                 //QC5.01 begin
            //                 IF QLotTestLineT.Result <> '' THEN BEGIN
            //                   IF QLotTestLineT."Non-Conformance" = TRUE THEN BEGIN
            //                     TempGlobalEntrySummary."QC Non Compliance" := TRUE;
            //                   //QC7.7 Start
            //                   TempGlobalEntrySummary."Item Test Non Compliant" := TRUE; // New Field Added
            //                   //TempGlobalEntrySummary."QC Compliance" := 'NO';
            //                   //QC7.7 Finish
            //                   END;
            //                 END;
            //               END;
            //                 //QC5.01 end
            //             END;
            //           UNTIL QSpecLineT.NEXT = 0;
            //
            //           // new fields on Entry Summary table
            //           TempGlobalEntrySummary."QC Option" := TempGlobalEntrySummary."QC Option"::Company;
            //           TempGlobalEntrySummary."Item No." := TrackingSpecification."Item No.";
            //           TempGlobalEntrySummary."Customer No." := '';
            //           TempGlobalEntrySummary."Version Code" := ActiveVersionCode;
            //
            //       END;
            //     END;
            //
            // //Handle "Production Order Component" "Call"...
            //
            //     //QC4SP
            //     IF TrackingSpecification."Source Type" = DATABASE::"Prod. Order Component"
            //       {IF ProdOrderCompLineT.GET(TrackingSpecification."Source ID",
            //                                 TrackingSpecification."Source Ref. No.") }
            //                         //Source Subtype =
            //                         //Source ID      = Document No.
            //                         //Source Batch   =
            //                         //Source Ref. No.= Line No.
            //
            //       THEN BEGIN
            //       IF ItemT.GET(TrackingSpecification."Item No.") THEN BEGIN
            //         ItemT.CALCFIELDS("Has Quality Specifications");
            //         TempGlobalEntrySummary."QC Specs Exist" := ItemT."Has Quality Specifications"; //Set "QC Specs Exist"
            //       END;
            //
            //       GetCompanySpec := TRUE;    //Default for Prod. Order.. assume no customer so get companys specs
            //
            //       IF GetCompanySpec = TRUE THEN BEGIN
            //         ActiveVersionCode := QualitySpecsCopy.GetQCVersion(TrackingSpecification."Item No.",
            //                                                            '','',WORKDATE,2);   //Origin = SalesLine
            //
            //         QSpecLineT.SETRANGE("Item No.",TrackingSpecification."Item No.");
            //         QSpecLineT.SETRANGE("Customer No.",'');
            //         QSpecLineT.SETRANGE(Type,'');
            //         QSpecLineT.SETRANGE("Version Code",ActiveVersionCode);
            //         IF QSpecLineT.FINDSET THEN
            //           REPEAT
            //             QLotTestLineT.SETRANGE("Item No.",TrackingSpecification."Item No.");
            //             //QC37.05
            //             IF LookupMode = LookupMode::"Lot No." THEN
            //               QLotTestLineT.SETRANGE("Lot No./Serial No.",TempReservEntry."Lot No.");
            //             IF LookupMode = LookupMode::"Serial No." THEN
            //               QLotTestLineT.SETRANGE("Lot No./Serial No.",TempReservEntry."Serial No.");
            //                    //
            //             QLotTestLineT.SETRANGE("Quality Measure",QSpecLineT."Quality Measure");
            //             QLotTestLineT.SETRANGE("Test Status",QLotTestLineT."Test Status"::"Certified Final"); //QC80.1 Corrected "Test Status" value
            //             //QC4SP1.2
            //             QLotTestLineT.SETFILTER("Customer No.",'%1','');
            //               //
            //             IF QLotTestLineT.FINDLAST THEN BEGIN
            //               TempGlobalEntrySummary."QC Test Exists" := TRUE; //Set "QC Test Exists"
            //                //QC80.1 - Added "Test Line Complete" term to line below
            //                IF ((QLotTestLineT."Actual Measure" <> 0) OR (QLotTestLineT."Test Line Complete" = TRUE)) THEN BEGIN // Handle Numeric Test Line
            //                 IF QLotTestLineT."Non-Conformance" = TRUE THEN BEGIN
            //                   TempGlobalEntrySummary."QC Non Compliance" := TRUE;
            //                   //QC7.7 Start
            //                   TempGlobalEntrySummary."Item Test Non Compliant" := TRUE; //Set new Field
            //                   //TempGlobalEntrySummary."QC Compliance" := 'NO';
            //                   //QC7.7 Finish
            //                 END;
            //               END ELSE BEGIN  //Else, Handle Result List Test Line
            //                 //QC5.01 begin
            //                 IF QLotTestLineT.Result <> '' THEN BEGIN
            //                   IF QLotTestLineT."Non-Conformance" = TRUE THEN BEGIN
            //                     TempGlobalEntrySummary."QC Non Compliance" := TRUE;
            //                    //QC7.7 Start
            //                    TempGlobalEntrySummary."Item Test Non Compliant" := TRUE; //Set new Field
            //                    //TempGlobalEntrySummary."QC Compliance" := 'NO';
            //                    //QC7.7 Finish
            //                   END;
            //                 END;
            //               END;
            //                 //QC5.01 end
            //             END;
            //           UNTIL QSpecLineT.NEXT = 0;
            //
            //           // new fields on Entry Summary table
            //           TempGlobalEntrySummary."QC Option" := TempGlobalEntrySummary."QC Option"::Company;
            //           TempGlobalEntrySummary."Item No." := TrackingSpecification."Item No.";
            //           TempGlobalEntrySummary."Customer No." := '';
            //           TempGlobalEntrySummary."Version Code" := ActiveVersionCode;
            //
            //
            //       END;
            //     END;
            //
            // //Handle "Transfer Line" "Call"...
            //
            //     IF TrackingSpecification."Source Type" = DATABASE::"Transfer Line" THEN
            //       IF TransferLineT.GET(TrackingSpecification."Source ID",
            //                            TrackingSpecification."Source Ref. No.")
            //                         //Source Subtype =
            //                         //Source ID      = Document No.
            //                         //Source Batch   =
            //                         //Source Ref. No.= Line No.
            //
            //       THEN BEGIN
            //         IF ItemT.GET(TrackingSpecification."Item No.") THEN BEGIN
            //           ItemT.CALCFIELDS("Has Quality Specifications");
            //           TempGlobalEntrySummary."QC Specs Exist" := ItemT."Has Quality Specifications"; //Set "QC Specs Exist"
            //         END;
            //
            //         GetCompanySpec := TRUE;    //Default for transfer line.. assume no customer so get companys specs
            //
            //         IF GetCompanySpec = TRUE THEN BEGIN
            //           ActiveVersionCode := QualitySpecsCopy.GetQCVersion(TrackingSpecification."Item No.",
            //                                                              '','',WORKDATE,2);   //Origin = SalesLine
            //
            //           QSpecLineT.SETRANGE("Item No.",TrackingSpecification."Item No.");
            //           QSpecLineT.SETRANGE("Customer No.",'');
            //           QSpecLineT.SETRANGE(Type,'');
            //           QSpecLineT.SETRANGE("Version Code",ActiveVersionCode);
            //           IF QSpecLineT.FINDSET THEN
            //             REPEAT
            //               QLotTestLineT.SETRANGE("Item No.",TrackingSpecification."Item No.");
            //               //QC37.05
            //               IF LookupMode = LookupMode::"Lot No." THEN
            //                 QLotTestLineT.SETRANGE("Lot No./Serial No.",TempReservEntry."Lot No.");
            //               IF LookupMode = LookupMode::"Serial No." THEN
            //                 QLotTestLineT.SETRANGE("Lot No./Serial No.",TempReservEntry."Serial No.");
            //                    //
            //               QLotTestLineT.SETRANGE("Quality Measure",QSpecLineT."Quality Measure");
            //               QLotTestLineT.SETRANGE("Test Status",QLotTestLineT."Test Status"::"Certified Final"); //QC80.1 Corrected "Test Status" value
            //               //QC4SP1.2
            //               QLotTestLineT.SETFILTER("Customer No.",'%1','');
            //                 //
            //               IF QLotTestLineT.FINDLAST THEN BEGIN
            //                 TempGlobalEntrySummary."QC Test Exists" := TRUE; //Set "QC Test Exists"
            //                 //QC80.1 - Added "Test Line Complete" term to line below
            //                 IF ((QLotTestLineT."Actual Measure" <> 0) OR (QLotTestLineT."Test Line Complete" = TRUE)) THEN BEGIN // Handle Numeric Test Line
            //                   IF QLotTestLineT."Non-Conformance" = TRUE THEN BEGIN
            //                     TempGlobalEntrySummary."QC Non Compliance" := TRUE;
            //                     //QC7.7 Start
            //                     TempGlobalEntrySummary."Item Test Non Compliant" := TRUE; //Set new Field
            //                     //TempGlobalEntrySummary."QC Compliance" := 'NO';
            //                     //QC7.7 Finish
            //                   END;
            //                 END ELSE BEGIN //Else, this is a Result List Test Line
            //                   //QC5.01 begin
            //                   IF QLotTestLineT.Result <> '' THEN BEGIN
            //                     IF QLotTestLineT."Non-Conformance" = TRUE THEN BEGIN
            //                       TempGlobalEntrySummary."QC Non Compliance" := TRUE;
            //                       //QC7.7 Start
            //                       TempGlobalEntrySummary."Item Test Non Compliant" := TRUE; //Set new Field
            //                       //TempGlobalEntrySummary."QC Compliance" := 'NO';
            //                       //QC7.7 Finish
            //                     END;
            //                   END;
            //                 END;
            //                   //QC5.01 end
            //               END;
            //             UNTIL QSpecLineT.NEXT = 0;
            //
            //             // new fields on Entry Summary table
            //             TempGlobalEntrySummary."QC Option" := TempGlobalEntrySummary."QC Option"::Company;
            //             TempGlobalEntrySummary."Item No." := TrackingSpecification."Item No.";
            //             TempGlobalEntrySummary."Customer No." := '';
            //             TempGlobalEntrySummary."Version Code" := ActiveVersionCode;
            //         END;
            //       END;
            //
            // // End All "Call" Types - Now, Refine the "Boiled-Down" Decision...
            //
            // //QC7.7 Start - Now Apply the QC "Rules" to come up with a "Boiled-Down" "QC Compliance" Decision
            //     FinalizeConformanceDecision(TempGlobalEntrySummary); //Modify TempGlobalEntrySummary to comport with QC Rules
            // //QC7.7 Finish  -- This is also the end of all QC7.7 Changes to this Function
            //
            //     //end QC
            //
            //  //end QC
            //
            // //QC Finish - Huge Code Insertion
            // Original Code Resumes Here

            if TempReservEntry."Entry No." < 0 then // The record represents an Item ledger entry
                TempGlobalEntrySummary."Total Quantity" += TempReservEntry."Quantity (Base)";
            if TempReservEntry."Reservation Status" = TempReservEntry."Reservation Status"::Reservation then
                TempGlobalEntrySummary."Total Reserved Quantity" += TempReservEntry."Quantity (Base)";
        end else begin
            TempGlobalEntrySummary."Total Requested Quantity" -= TempReservEntry."Quantity (Base)";
            if TempReservEntry.HasSamePointerWithSpec(TrackingSpecification) then begin
                if TempReservEntry."Reservation Status" = TempReservEntry."Reservation Status"::Reservation then
                    TempGlobalEntrySummary."Current Reserved Quantity" -= TempReservEntry."Quantity (Base)";
                if TempReservEntry."Entry No." > 0 then // The record represents a reservation entry
                    TempGlobalEntrySummary."Current Requested Quantity" -= TempReservEntry."Quantity (Base)";
            end;
        end;

        // Update available quantity on the record
        TempGlobalEntrySummary.UpdateAvailable;
        if DoInsert then
            TempGlobalEntrySummary.INSERT
        else
            TempGlobalEntrySummary.MODIFY;
    end;

    local procedure MinValueAbs(Value1: Decimal; Value2: Decimal): Decimal;
    begin
        if ABS(Value1) < ABS(Value2) then
            exit(Value1);

        exit(Value2);
    end;

    local procedure AddSelectedTrackingToDataSet(var TempEntrySummary: Record "Entry Summary" temporary; var TempTrackingSpecification: Record "Tracking Specification" temporary; CurrentSignFactor: Integer);
    var
        TrackingSpecification2: Record "Tracking Specification";
        LastEntryNo: Integer;
        ChangeType: Option Insert,Modify,Delete;
    begin
        TempEntrySummary.RESET;
        TempEntrySummary.SETFILTER("Selected Quantity", '<>%1', 0);
        if TempEntrySummary.ISEMPTY then
            exit;

        // To save general and pointer information
        TrackingSpecification2.INIT;
        TrackingSpecification2."Item No." := TempTrackingSpecification."Item No.";
        TrackingSpecification2."Location Code" := TempTrackingSpecification."Location Code";
        TrackingSpecification2."Source Type" := TempTrackingSpecification."Source Type";
        TrackingSpecification2."Source Subtype" := TempTrackingSpecification."Source Subtype";
        TrackingSpecification2."Source ID" := TempTrackingSpecification."Source ID";
        TrackingSpecification2."Source Batch Name" := TempTrackingSpecification."Source Batch Name";
        TrackingSpecification2."Source Prod. Order Line" := TempTrackingSpecification."Source Prod. Order Line";
        TrackingSpecification2."Source Ref. No." := TempTrackingSpecification."Source Ref. No.";
        TrackingSpecification2.Positive := TempTrackingSpecification.Positive;
        TrackingSpecification2."Qty. per Unit of Measure" := TempTrackingSpecification."Qty. per Unit of Measure";
        TrackingSpecification2."Variant Code" := TempTrackingSpecification."Variant Code";

        TempTrackingSpecification.RESET;
        if TempTrackingSpecification.FINDLAST then
            LastEntryNo := TempTrackingSpecification."Entry No.";

        TempEntrySummary.FINDFIRST;
        repeat
            TempTrackingSpecification.SetTrackingFilterFromEntrySummary(TempEntrySummary);
            if TempTrackingSpecification.FINDFIRST then begin
                TempTrackingSpecification.VALIDATE("Quantity (Base)",
                  TempTrackingSpecification."Quantity (Base)" + TempEntrySummary."Selected Quantity");
                TempTrackingSpecification."Buffer Status" := TempTrackingSpecification."Buffer Status"::MODIFY;
                TransferExpDateFromSummary(TempTrackingSpecification, TempEntrySummary);
                TempTrackingSpecification.MODIFY;
                UpdateTrackingDataSetWithChange(TempTrackingSpecification, true, CurrentSignFactor, ChangeType::Modify);
            end else begin
                TempTrackingSpecification := TrackingSpecification2;
                TempTrackingSpecification."Entry No." := LastEntryNo + 1;
                LastEntryNo := TempTrackingSpecification."Entry No.";
                TempTrackingSpecification."Serial No." := TempEntrySummary."Serial No.";
                TempTrackingSpecification."Lot No." := TempEntrySummary."Lot No.";
                TempTrackingSpecification."Buffer Status" := TempTrackingSpecification."Buffer Status"::INSERT;
                TransferExpDateFromSummary(TempTrackingSpecification, TempEntrySummary);
                if TempTrackingSpecification.IsReclass then begin
                    TempTrackingSpecification."New Serial No." := TempTrackingSpecification."Serial No.";
                    TempTrackingSpecification."New Lot No." := TempTrackingSpecification."Lot No.";
                end;
                TempTrackingSpecification.VALIDATE("Quantity (Base)", TempEntrySummary."Selected Quantity");
                TempTrackingSpecification.INSERT;
                UpdateTrackingDataSetWithChange(TempTrackingSpecification, true, CurrentSignFactor, ChangeType::Insert);
            end;
        until TempEntrySummary.NEXT = 0;

        TempTrackingSpecification.RESET;
    end;

    [Scope('cloud')]
    procedure TrackingAvailable(TempTrackingSpecification: Record "Tracking Specification" temporary; LookupMode: Option "Serial No.","Lot No."): Boolean;
    begin
        CurrItemTrackingCode.TESTFIELD(Code);
        case LookupMode of
            LookupMode::"Serial No.":
                if (TempTrackingSpecification."Serial No." = '') or (not CurrItemTrackingCode."SN Specific Tracking") then
                    exit(true);
            LookupMode::"Lot No.":
                if (TempTrackingSpecification."Lot No." = '') or (not CurrItemTrackingCode."Lot Specific Tracking") then
                    exit(true);
        end;

        if not (PartialGlobalDataSetExists or FullGlobalDataSetExists) then
            RetrieveLookupData(TempTrackingSpecification, true);

        TempGlobalEntrySummary.RESET;
        TempGlobalEntrySummary.SETCURRENTKEY("Lot No.", "Serial No.");

        case LookupMode of
            LookupMode::"Serial No.":
                begin
                    TempGlobalEntrySummary.SETRANGE("Serial No.", TempTrackingSpecification."Serial No.");
                    TempGlobalEntrySummary.SETFILTER("Total Available Quantity", '< %1', 0);
                    if CheckJobInPurchLine(TempTrackingSpecification) then
                        exit(TempGlobalEntrySummary.FINDFIRST);
                    exit(TempGlobalEntrySummary.ISEMPTY);
                end;
            LookupMode::"Lot No.":
                begin
                    //TempGlobalEntrySummary.SetTrackingFilter('', TempTrackingSpecification."Lot No.");
                    TempGlobalEntrySummary.CALCSUMS("Total Available Quantity");
                    if CheckJobInPurchLine(TempTrackingSpecification) then
                        exit(TempGlobalEntrySummary.FINDFIRST);
                    exit(TempGlobalEntrySummary."Total Available Quantity" >= 0);
                end;
        end;
    end;

    [Scope('cloud')]
    procedure UpdateTrackingDataSetWithChange(var TempTrackingSpecificationChanged: Record "Tracking Specification" temporary; LineIsDemand: Boolean; CurrentSignFactor: Integer; ChangeType: Option Insert,Modify,Delete);
    var
        LastEntryNo: Integer;
    begin
        if not TempTrackingSpecificationChanged.TrackingExists then
            exit;

        LastEntryNo := UpdateTrackingGlobalChangeRec(TempTrackingSpecificationChanged, LineIsDemand, CurrentSignFactor, ChangeType);
        TempGlobalChangedEntrySummary.GET(LastEntryNo);
        UpdateTempSummaryWithChange(TempGlobalChangedEntrySummary);
    end;

    local procedure UpdateTrackingGlobalChangeRec(var TempTrackingSpecificationChanged: Record "Tracking Specification" temporary; LineIsDemand: Boolean; CurrentSignFactor: Integer; ChangeType: Option Insert,Modify,Delete): Integer;
    var
        NewQuantity: Decimal;
        LastEntryNo: Integer;
    begin
        if (ChangeType = ChangeType::Delete) or not LineIsDemand then
            NewQuantity := 0
        else
            NewQuantity := TempTrackingSpecificationChanged."Quantity (Base)" - TempTrackingSpecificationChanged."Quantity Handled (Base)";

        if CurrentSignFactor > 0 then // Negative supply lines
            NewQuantity := -NewQuantity;

        TempGlobalChangedEntrySummary.RESET;
        TempGlobalChangedEntrySummary.SETCURRENTKEY("Lot No.", "Serial No.");
        TempGlobalChangedEntrySummary.SetTrackingFilterFromSpec(TempTrackingSpecificationChanged);
        if not TempGlobalChangedEntrySummary.FINDFIRST then begin
            TempGlobalChangedEntrySummary.RESET;
            if TempGlobalChangedEntrySummary.FINDLAST then
                LastEntryNo := TempGlobalChangedEntrySummary."Entry No.";
            TempGlobalChangedEntrySummary.INIT;
            TempGlobalChangedEntrySummary."Entry No." := LastEntryNo + 1;
            TempGlobalChangedEntrySummary."Lot No." := TempTrackingSpecificationChanged."Lot No.";
            TempGlobalChangedEntrySummary."Serial No." := TempTrackingSpecificationChanged."Serial No.";
            TempGlobalChangedEntrySummary."Current Pending Quantity" := NewQuantity;
            if TempTrackingSpecificationChanged."Serial No." <> '' then
                TempGlobalChangedEntrySummary."Table ID" := DATABASE::"Tracking Specification"; // Not a summary line
            TempGlobalChangedEntrySummary.INSERT;
            PartialGlobalDataSetExists := false; // The partial data set does not cover the new line
        end else
            if LineIsDemand then begin
                TempGlobalChangedEntrySummary."Current Pending Quantity" := NewQuantity;
                TempGlobalChangedEntrySummary.MODIFY;
            end;
        exit(TempGlobalChangedEntrySummary."Entry No.");
    end;

    local procedure UpdateCurrentPendingQty();
    var
        TempLastGlobalEntrySummary: Record "Entry Summary" temporary;
    begin
        TempGlobalChangedEntrySummary.RESET;
        TempGlobalChangedEntrySummary.SETCURRENTKEY("Lot No.", "Serial No.");
        if TempGlobalChangedEntrySummary.FINDSET then
            repeat
                if TempGlobalChangedEntrySummary."Lot No." <> '' then begin
                    // only last record with Lot Number updates Summary
                    if TempGlobalChangedEntrySummary."Lot No." <> TempLastGlobalEntrySummary."Lot No." then
                        FindLastGlobalEntrySummary(TempGlobalChangedEntrySummary, TempLastGlobalEntrySummary);
                    SkipLot := not (TempGlobalChangedEntrySummary."Entry No." = TempLastGlobalEntrySummary."Entry No.");
                end;
                UpdateTempSummaryWithChange(TempGlobalChangedEntrySummary);
            until TempGlobalChangedEntrySummary.NEXT = 0;
    end;

    local procedure UpdateTempSummaryWithChange(var ChangedEntrySummary: Record "Entry Summary" temporary);
    var
        LastEntryNo: Integer;
        SumOfSNPendingQuantity: Decimal;
        SumOfSNRequestedQuantity: Decimal;
    begin
        TempGlobalEntrySummary.RESET;
        if TempGlobalEntrySummary.FINDLAST then
            LastEntryNo := TempGlobalEntrySummary."Entry No.";

        TempGlobalEntrySummary.SETCURRENTKEY("Lot No.", "Serial No.");
        if ChangedEntrySummary."Serial No." <> '' then begin
            TempGlobalEntrySummary.SetTrackingFilterFromEntrySummary(ChangedEntrySummary);
            if TempGlobalEntrySummary.FINDFIRST then begin
                TempGlobalEntrySummary."Current Pending Quantity" := ChangedEntrySummary."Current Pending Quantity" -
                  TempGlobalEntrySummary."Current Requested Quantity";
                TempGlobalEntrySummary.UpdateAvailable;
                TempGlobalEntrySummary.MODIFY;
            end else begin
                TempGlobalEntrySummary := ChangedEntrySummary;
                TempGlobalEntrySummary."Entry No." := LastEntryNo + 1;
                LastEntryNo := TempGlobalEntrySummary."Entry No.";
                TempGlobalEntrySummary."Bin Active" := CurrBinCode <> '';
                UpdateBinContent(TempGlobalEntrySummary);
                TempGlobalEntrySummary.UpdateAvailable;
                TempGlobalEntrySummary.INSERT;
            end;

            if (ChangedEntrySummary."Lot No." <> '') and not SkipLot then begin
                TempGlobalEntrySummary.SETFILTER("Serial No.", '<>%1', '');
                TempGlobalEntrySummary.SETRANGE("Lot No.", ChangedEntrySummary."Lot No.");
                TempGlobalEntrySummary.CALCSUMS("Current Pending Quantity", "Current Requested Quantity");
                SumOfSNPendingQuantity := TempGlobalEntrySummary."Current Pending Quantity";
                SumOfSNRequestedQuantity := TempGlobalEntrySummary."Current Requested Quantity";
            end;
        end;

        if (ChangedEntrySummary."Lot No." <> '') and not SkipLot then begin
            //TempGlobalEntrySummary.SetTrackingFilter('', ChangedEntrySummary."Lot No.");

            if ChangedEntrySummary."Serial No." <> '' then
                TempGlobalEntrySummary.SETRANGE("Table ID", 0)
            else
                TempGlobalEntrySummary.SETFILTER("Table ID", '<>%1', 0);

            if TempGlobalEntrySummary.FINDFIRST then begin
                if ChangedEntrySummary."Serial No." <> '' then begin
                    TempGlobalEntrySummary."Current Pending Quantity" := SumOfSNPendingQuantity;
                    TempGlobalEntrySummary."Current Requested Quantity" := SumOfSNRequestedQuantity;
                end else
                    TempGlobalEntrySummary."Current Pending Quantity" := ChangedEntrySummary."Current Pending Quantity" -
                      TempGlobalEntrySummary."Current Requested Quantity";

                TempGlobalEntrySummary.UpdateAvailable;
                TempGlobalEntrySummary.MODIFY;
            end else begin
                TempGlobalEntrySummary := ChangedEntrySummary;
                TempGlobalEntrySummary."Entry No." := LastEntryNo + 1;
                TempGlobalEntrySummary."Serial No." := '';
                if ChangedEntrySummary."Serial No." <> '' then // Mark as summation
                    TempGlobalEntrySummary."Table ID" := 0
                else
                    TempGlobalEntrySummary."Table ID" := DATABASE::"Tracking Specification";
                TempGlobalEntrySummary."Bin Active" := CurrBinCode <> '';
                UpdateBinContent(TempGlobalEntrySummary);
                TempGlobalEntrySummary.UpdateAvailable;
                TempGlobalEntrySummary.INSERT;
            end;
        end;
    end;

    [Scope('cloud')]
    procedure RefreshTrackingAvailability(var TempTrackingSpecification: Record "Tracking Specification" temporary; ShowMessage: Boolean) AvailabilityOK: Boolean;
    var
        TrackingSpecification2: Record "Tracking Specification";
        LookupMode: Option "Serial No.","Lot No.";
        PreviousLotNo: Code[50];
    begin
        AvailabilityOK := true;
        if TempTrackingSpecification.Positive then
            exit;

        TrackingSpecification2.COPY(TempTrackingSpecification);
        TempTrackingSpecification.RESET;
        if TempTrackingSpecification.ISEMPTY then begin
            TempTrackingSpecification.COPY(TrackingSpecification2);
            exit;
        end;

        FullGlobalDataSetExists := false;
        PartialGlobalDataSetExists := false;
        RetrieveLookupData(TempTrackingSpecification, false);

        TempTrackingSpecification.SETCURRENTKEY("Lot No.", "Serial No.");
        TempTrackingSpecification.FIND('-');
        LookupMode := LookupMode::"Serial No.";
        repeat
            if TempTrackingSpecification."Lot No." <> PreviousLotNo then begin
                PreviousLotNo := TempTrackingSpecification."Lot No.";
                LookupMode := LookupMode::"Lot No.";

                if not TrackingAvailable(TempTrackingSpecification, LookupMode) then
                    AvailabilityOK := false;

                LookupMode := LookupMode::"Serial No.";
            end;

            if not TrackingAvailable(TempTrackingSpecification, LookupMode) then
                AvailabilityOK := false;
        until TempTrackingSpecification.NEXT = 0;

        if ShowMessage then
            if AvailabilityOK then
                MESSAGE(NoAvailabilityWarningsMsg)
            else
                MESSAGE(AvailabilityWarningsMsg);

        TempTrackingSpecification.COPY(TrackingSpecification2);
    end;

    [Scope('cloud')]
    procedure SetCurrentBinAndItemTrkgCode(BinCode: Code[20]; ItemTrackingCode: Record "Item Tracking Code");
    var
        xBinCode: Code[20];
    begin
        xBinCode := CurrBinCode;
        CurrBinCode := BinCode;
        CurrItemTrackingCode := ItemTrackingCode;

        if xBinCode <> BinCode then
            if PartialGlobalDataSetExists then
                RefreshBinContent(TempGlobalEntrySummary);
    end;

    local procedure UpdateBinContent(var TempEntrySummary: Record "Entry Summary" temporary);
    var
        WarehouseEntry: Record "Warehouse Entry";
    begin
        if CurrBinCode = '' then
            exit;
        CurrItemTrackingCode.TESTFIELD(Code);
        WarehouseEntry.RESET;
        WarehouseEntry.SETCURRENTKEY(
          "Item No.", "Bin Code", "Location Code", "Variant Code",
          "Unit of Measure Code", "Lot No.", "Serial No.");
        WarehouseEntry.SETRANGE("Item No.", TempGlobalReservEntry."Item No.");
        WarehouseEntry.SETRANGE("Bin Code", CurrBinCode);
        WarehouseEntry.SETRANGE("Location Code", TempGlobalReservEntry."Location Code");
        WarehouseEntry.SETRANGE("Variant Code", TempGlobalReservEntry."Variant Code");
        if CurrItemTrackingCode."SN Warehouse Tracking" then
            if TempEntrySummary."Serial No." <> '' then
                WarehouseEntry.SETRANGE("Serial No.", TempEntrySummary."Serial No.");
        if CurrItemTrackingCode."Lot Warehouse Tracking" then
            if TempEntrySummary."Lot No." <> '' then
                WarehouseEntry.SETRANGE("Lot No.", TempEntrySummary."Lot No.");
        WarehouseEntry.CALCSUMS("Qty. (Base)");

        TempEntrySummary."Bin Content" := WarehouseEntry."Qty. (Base)";
    end;

    local procedure RefreshBinContent(var TempEntrySummary: Record "Entry Summary" temporary);
    begin
        TempEntrySummary.RESET;
        if TempEntrySummary.FINDSET then
            repeat
                if CurrBinCode <> '' then
                    UpdateBinContent(TempEntrySummary)
                else
                    TempEntrySummary."Bin Content" := 0;
                TempEntrySummary.MODIFY;
            until TempEntrySummary.NEXT = 0;
    end;

    local procedure TransferExpDateFromSummary(var TrackingSpecification: Record "Tracking Specification" temporary; var TempEntrySummary: Record "Entry Summary" temporary);
    begin
        // Handle Expiration Date
        if TempEntrySummary."Total Quantity" <> 0 then begin
            TrackingSpecification."Buffer Status2" := TrackingSpecification."Buffer Status2"::"ExpDate blocked";
            TrackingSpecification."Expiration Date" := TempEntrySummary."Expiration Date";
            if TrackingSpecification.IsReclass then
                TrackingSpecification."New Expiration Date" := TrackingSpecification."Expiration Date"
            else
                TrackingSpecification."New Expiration Date" := 0D;
        end else begin
            TrackingSpecification."Buffer Status2" := 0;
            TrackingSpecification."Expiration Date" := 0D;
            TrackingSpecification."New Expiration Date" := 0D;
        end;
    end;

    local procedure AdjustForDoubleEntries();
    begin
        TempGlobalAdjustEntry.RESET;
        TempGlobalAdjustEntry.DELETEALL;

        TempGlobalTrackingSpec.RESET;
        TempGlobalTrackingSpec.DELETEALL;

        // Check if there is any need to investigate:
        TempGlobalReservEntry.RESET;
        TempGlobalReservEntry.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name");
        TempGlobalReservEntry.SETRANGE("Reservation Status", TempGlobalReservEntry."Reservation Status"::Prospect);
        TempGlobalReservEntry.SETRANGE("Source Type", DATABASE::"Item Journal Line");
        TempGlobalReservEntry.SETRANGE("Source Subtype", 5, 6); // Consumption, Output
        if TempGlobalReservEntry.ISEMPTY then  // No journal lines with consumption or output exist
            exit;

        TempGlobalReservEntry.RESET;
        TempGlobalReservEntry.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name");
        TempGlobalReservEntry.SETRANGE("Source Type", DATABASE::"Prod. Order Line");
        TempGlobalReservEntry.SETRANGE("Source Subtype", 3); // Released order
        if TempGlobalReservEntry.FINDSET then
            repeat
                // Sum up per prod. order line per lot/sn
                SumUpTempTrkgSpec(TempGlobalTrackingSpec, TempGlobalReservEntry);
            until TempGlobalReservEntry.NEXT = 0;

        TempGlobalReservEntry.RESET;
        TempGlobalReservEntry.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name");
        TempGlobalReservEntry.SETRANGE("Source Type", DATABASE::"Prod. Order Component");
        TempGlobalReservEntry.SETRANGE("Source Subtype", 3); // Released order
        if TempGlobalReservEntry.FINDSET then
            repeat
                // Sum up per prod. order component per lot/sn
                SumUpTempTrkgSpec(TempGlobalTrackingSpec, TempGlobalReservEntry);
            until TempGlobalReservEntry.NEXT = 0;

        TempGlobalReservEntry.RESET;
        TempGlobalReservEntry.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name");
        TempGlobalReservEntry.SETRANGE("Reservation Status", TempGlobalReservEntry."Reservation Status"::Prospect);
        TempGlobalReservEntry.SETRANGE("Source Type", DATABASE::"Item Journal Line");
        TempGlobalReservEntry.SETRANGE("Source Subtype", 5, 6); // Consumption, Output

        if TempGlobalReservEntry.FINDSET then
            repeat
                // Sum up per Component line per lot/sn
                RelateJnlLineToTempTrkgSpec(TempGlobalReservEntry, TempGlobalTrackingSpec);
            until TempGlobalReservEntry.NEXT = 0;

        InsertAdjustmentEntries;
    end;

    local procedure SumUpTempTrkgSpec(var TempTrackingSpecification: Record "Tracking Specification" temporary; ReservEntry: Record "Reservation Entry");
    var
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    begin
        TempTrackingSpecification.SetSourceFilter(
          ReservEntry."Source Type", ReservEntry."Source Subtype", ReservEntry."Source ID", ReservEntry."Source Ref. No.", false);
        TempTrackingSpecification.SetSourceFilter(ReservEntry."Source Batch Name", ReservEntry."Source Prod. Order Line");
        TempTrackingSpecification.SetTrackingFilterFromReservEntry(ReservEntry);
        if TempTrackingSpecification.FINDFIRST then begin
            TempTrackingSpecification."Quantity (Base)" += ReservEntry."Quantity (Base)";
            TempTrackingSpecification.MODIFY;
        end else begin
            ItemTrackingMgt.CreateTrackingSpecification(ReservEntry, TempTrackingSpecification);
            if not ReservEntry.Positive then               // To avoid inserting existing entry when both sides of the reservation
                TempTrackingSpecification."Entry No." *= -1; // are handled.
            TempTrackingSpecification.INSERT;
        end;
    end;

    local procedure RelateJnlLineToTempTrkgSpec(var ReservEntry: Record "Reservation Entry"; var TempTrackingSpecification: Record "Tracking Specification" temporary);
    var
        ItemJnlLine: Record "Item Journal Line";
        RemainingQty: Decimal;
        AdjustQty: Decimal;
        QtyOnJnlLine: Decimal;
    begin
        // Pre-check
        ReservEntry.TESTFIELD("Reservation Status", ReservEntry."Reservation Status"::Prospect);
        ReservEntry.TESTFIELD("Source Type", DATABASE::"Item Journal Line");
        if not (ReservEntry."Source Subtype" in [5, 6]) then
            ReservEntry.FIELDERROR("Source Subtype");

        if not ItemJnlLine.GET(ReservEntry."Source ID",
             ReservEntry."Source Batch Name", ReservEntry."Source Ref. No.")
        then
            exit;

        if (ItemJnlLine."Order Type" <> ItemJnlLine."Order Type"::Production) or
           (ItemJnlLine."Order No." = '') or
           (ItemJnlLine."Order Line No." = 0)
        then
            exit;

        // Buffer fields are used as follows:
        // "Buffer Value1" : Summed up quantity on journal line(s)
        // "Buffer Value2" : Adjustment needed to neutralize double entries

        if FindRelatedParentTrkgSpec(ItemJnlLine, TempTrackingSpecification,
             ReservEntry."Serial No.", ReservEntry."Lot No.")
        then begin
            RemainingQty := TempTrackingSpecification."Quantity (Base)" + TempTrackingSpecification."Buffer Value2";
            QtyOnJnlLine := ReservEntry."Quantity (Base)";
            ReservEntry."Transferred from Entry No." := ABS(TempTrackingSpecification."Entry No.");
            ReservEntry.MODIFY;

            if (RemainingQty <> 0) and (RemainingQty * QtyOnJnlLine > 0) then begin
                if ABS(QtyOnJnlLine) <= ABS(RemainingQty) then
                    AdjustQty := -QtyOnJnlLine
                else
                    AdjustQty := -RemainingQty;
            end;

            TempTrackingSpecification."Buffer Value1" += QtyOnJnlLine;
            TempTrackingSpecification."Buffer Value2" += AdjustQty;
            TempTrackingSpecification.MODIFY;
            AddToAdjustmentEntryDataSet(ReservEntry, AdjustQty);
        end;
    end;

    local procedure FindRelatedParentTrkgSpec(ItemJnlLine: Record "Item Journal Line"; var TempTrackingSpecification: Record "Tracking Specification" temporary; SerialNo: Code[50]; LotNo: Code[50]): Boolean;
    begin
        ItemJnlLine.TESTFIELD("Order Type", ItemJnlLine."Order Type"::Production);
        TempTrackingSpecification.RESET;
        case ItemJnlLine."Entry Type" of
            ItemJnlLine."Entry Type"::Consumption:
                begin
                    if ItemJnlLine."Prod. Order Comp. Line No." = 0 then
                        exit;
                    TempTrackingSpecification.SetSourceFilter(
                      DATABASE::"Prod. Order Component", 3, ItemJnlLine."Order No.", ItemJnlLine."Prod. Order Comp. Line No.", false);
                    TempTrackingSpecification.SetSourceFilter('', ItemJnlLine."Order Line No.");
                end;
            ItemJnlLine."Entry Type"::Output:
                begin
                    TempTrackingSpecification.SetSourceFilter(DATABASE::"Prod. Order Line", 3, ItemJnlLine."Order No.", -1, false);
                    TempTrackingSpecification.SetSourceFilter('', ItemJnlLine."Order Line No.");
                end;
        end;
        //TempTrackingSpecification.SetTrackingFilter(SerialNo, LotNo);
        exit(TempTrackingSpecification.FINDFIRST);
    end;

    local procedure AddToAdjustmentEntryDataSet(var ReservEntry: Record "Reservation Entry"; AdjustQty: Decimal);
    begin
        if AdjustQty = 0 then
            exit;

        TempGlobalAdjustEntry := ReservEntry;
        TempGlobalAdjustEntry."Source Type" := -ReservEntry."Source Type";
        TempGlobalAdjustEntry.Description := COPYSTR(Text013, 1, MAXSTRLEN(TempGlobalAdjustEntry.Description));
        TempGlobalAdjustEntry."Quantity (Base)" := AdjustQty;
        TempGlobalAdjustEntry."Entry No." += LastReservEntryNo; // Use last entry no as offset to avoid inserting existing entry
        TempGlobalAdjustEntry.INSERT;
    end;

    local procedure InsertAdjustmentEntries();
    var
        TempTrackingSpecification: Record "Tracking Specification" temporary;
    begin
        TempGlobalAdjustEntry.RESET;
        if not TempGlobalAdjustEntry.FINDSET then
            exit;

        TempTrackingSpecification.INIT;
        TempTrackingSpecification.INSERT;
        repeat
            CreateEntrySummary(TempTrackingSpecification, TempGlobalAdjustEntry); // TrackingSpecification is a dummy record
            TempGlobalReservEntry := TempGlobalAdjustEntry;
            TempGlobalReservEntry.INSERT;
        until TempGlobalAdjustEntry.NEXT = 0;
    end;

    local procedure MaxDoubleEntryAdjustQty(var TempItemTrackLineChanged: Record "Tracking Specification" temporary; var ChangedEntrySummary: Record "Entry Summary" temporary): Decimal;
    var
        ItemJnlLine: Record "Item Journal Line";
    begin
        if not (TempItemTrackLineChanged."Source Type" = DATABASE::"Item Journal Line") then
            exit;

        if not (TempItemTrackLineChanged."Source Subtype" in [5, 6]) then
            exit;

        if not ItemJnlLine.GET(TempItemTrackLineChanged."Source ID",
             TempItemTrackLineChanged."Source Batch Name", TempItemTrackLineChanged."Source Ref. No.")
        then
            exit;

        TempGlobalTrackingSpec.RESET;

        if FindRelatedParentTrkgSpec(ItemJnlLine, TempGlobalTrackingSpec,
             ChangedEntrySummary."Serial No.", ChangedEntrySummary."Lot No.")
        then
            exit(-TempGlobalTrackingSpec."Quantity (Base)" - TempGlobalTrackingSpec."Buffer Value2");
    end;

    [Scope('cloud')]
    procedure CurrentDataSetMatches(ItemNo: Code[20]; VariantCode: Code[20]; LocationCode: Code[10]): Boolean;
    begin
        exit(
          (TempGlobalReservEntry."Item No." = ItemNo) and
          (TempGlobalReservEntry."Variant Code" = VariantCode) and
          (TempGlobalReservEntry."Location Code" = LocationCode));
    end;

    local procedure CheckJobInPurchLine(TrackingSpecification: Record "Tracking Specification"): Boolean;
    var
        PurchLine: Record "Purchase Line";
    begin

        if (TrackingSpecification."Source Type" = DATABASE::"Purchase Line") and (TrackingSpecification."Source Subtype" = TrackingSpecification."Source Subtype"::"3") then begin
            PurchLine.RESET;
            PurchLine.SETRANGE("Document Type", TrackingSpecification."Source Subtype");
            PurchLine.SETRANGE("Document No.", TrackingSpecification."Source ID");
            PurchLine.SETRANGE("Line No.", TrackingSpecification."Source Ref. No.");
            if PurchLine.FINDFIRST then
                exit(PurchLine."Job No." <> '');
        end;

    end;

    [Scope('cloud')]
    procedure FindLotNoBySN(TrackingSpecification: Record "Tracking Specification"): Code[20];
    var
        LotNo: Code[50];
    begin
        if FindLotNoBySNSilent(LotNo, TrackingSpecification) then
            exit(LotNo);

        ERROR(LotNoBySNNotFoundErr, TrackingSpecification."Serial No.");
    end;

    [Scope('cloud')]
    procedure FindLotNoBySNSilent(var LotNo: Code[50]; TrackingSpecification: Record "Tracking Specification"): Boolean;
    begin
        if not (PartialGlobalDataSetExists or FullGlobalDataSetExists) then
            RetrieveLookupData(TrackingSpecification, true);

        TempGlobalEntrySummary.RESET;
        TempGlobalEntrySummary.SETCURRENTKEY("Lot No.", "Serial No.");
        TempGlobalEntrySummary.SETRANGE("Serial No.", TrackingSpecification."Serial No.");
        if not TempGlobalEntrySummary.FINDFIRST then
            exit(false);

        LotNo := TempGlobalEntrySummary."Lot No.";
        exit(true);
    end;

    [Scope('cloud')]
    procedure SetSkipLot(SkipLot2: Boolean);
    begin
        // only last record with Lot Number updates Summary.
        SkipLot := SkipLot2;
    end;

    local procedure FindLastGlobalEntrySummary(var GlobalChangedEntrySummary: Record "Entry Summary"; var LastGlobalEntrySummary: Record "Entry Summary");
    var
        TempGlobalChangedEntrySummary2: Record "Entry Summary" temporary;
    begin
        TempGlobalChangedEntrySummary2 := GlobalChangedEntrySummary;
        GlobalChangedEntrySummary.SETRANGE("Lot No.", GlobalChangedEntrySummary."Lot No.");
        if GlobalChangedEntrySummary.FINDLAST then
            LastGlobalEntrySummary := GlobalChangedEntrySummary;
        GlobalChangedEntrySummary.COPY(TempGlobalChangedEntrySummary2);
    end;

    local procedure CanIncludeReservEntryToTrackingSpec(TempReservEntry: Record "Reservation Entry" temporary): Boolean;
    var
        SalesLine: Record "Sales Line";
    begin
        if (TempReservEntry."Reservation Status" = TempReservEntry."Reservation Status"::Prospect) and
           (TempReservEntry."Source Type" = DATABASE::"Sales Line") and
           (TempReservEntry."Source Subtype" = 2)
        then begin
            SalesLine.GET(TempReservEntry."Source Subtype", TempReservEntry."Source ID", TempReservEntry."Source Ref. No.");
            if SalesLine."Shipment No." <> '' then
                exit(false);
        end;

        exit(true);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAssistEditTrackingNo(var TempTrackingSpecification: Record "Tracking Specification" temporary; var SearchForSupply: Boolean; CurrentSignFactor: Integer; LookupMode: Option "Serial No.","Lot No."; MaxQuantity: Decimal);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAssistEditTrackingNo(var TrackingSpecification: Record "Tracking Specification"; var TempGlobalEntrySummary: Record "Entry Summary" temporary);
    begin
    end;
}

