codeunit 50704 QCCodeunitSubscribers_PQ
{
    // version QC11.01

    // Documentation Triggers for Codeunits:
    //
    // 22 - Item Jnl.-Post Line
    // //QC   Setup of global variables (LotMasterT & ItemT.. +)
    //        Add TextConstants
    //        Code below to insert the Lot Master
    //        Code to stop post if Item Qualtity is required and Test does not exist.
    //        Added local variables to InitItemLedgEntry(VAR ItemLedgEntry : Record "Item Ledger Entry
    // //QC37.05 Added new global text message
    //           Added Code below
    //           Added Local variable on InsertTransferEntry
    //           Added Global variable
    // //QC4.30  Added code to pass the Result Type and Result
    //
    // //QC71.3 
    //   - Addressed Issue of incorrectly-re-mapped "Test Statuses" ("In-Progress" appearing instead of "Certified Final")
    //
    // QC90  11/03/15  Doug McIntosh
    //   - Updated //QC Code in CheckItemTracking Func. to reference the renamed Text Const. "SerialNoRequiredErr" (formerly "Text015")
    //   - Updated //QC Code in CheckItemTracking Func. to reference the renamed Text Const. "LotNoRequiredErr" (Formerly "Text016")
    //
    // QC11.01 
    //   - Changes to Accomodate Event-Driven Design
    //     - Moved Code Blocks in "InsertTransferEntry" into this Subscriber Codeunit Function "ItemJnlPostLineOnBeforeInsertTransferEntry"
    //     - Moved Code Blocks in "InitItemLedgEntry" into this Subscriber Codeunit Function "ItemJnlPostLineOnAfterInitItemLedgEntry"
    //     - Moved Code in Function "CheckItemTracking" into two Functions in CU 22, "QCCheckItemTrackingHandleSNs" and "QCCheckItemTrackingHandleLots"
    //
    // 6501 - Item Tracking Data Collection
    // //QC   Add check for QC specifications
    //        Add two global variables
    //        Add local variables to
    //           AssistEditLotSerialNo(VAR TrackingSpecification : TEMPORARY Record "Tracking Specification";SearchForSupply : Boolean;Curr
    // //QC37.05   Added code to allow for Serial No. as well as Lot no.
    // //QC4SP1.2  Added code for lookup from Prod. Order component table
    //             Added code to look for customer specific specs on sales lines and not to
    //                include Customer specific tests for item jnl, prod. order and transfer
    // //QC5.01  Added code to check for non-conforming list test results
    //
    // QC7.7 
    //   - Several Changes to Improve the Lot/Serial "Conformance" Decision process
    //     - Several Code Changes to the "CreateEntrySummary2" Function, which contains the main "Conformance Decision" Logic
    //     - Added New Function "FinalizeConformanceDecision", to, well, have the "last word" when it comes to "Conformance"
    //     - See Also, Table 338 and Page 6500, for additional, related changes
    //
    // QC80.1
    //   - Changes to Allow "Test Line Complete" to permit an "Actual Measure" of Zero for a "Completed" Test Line
    //   - Changed Several Places where "Test Status" was erroneously comparing to an old Option-Value of "Certified" (which got re-mapped to "In-Process")
    //     ...These are now changed to the (correct) value of "Certified Final"
    //
    // QC11.01
    //   - Changes for Event-Driven Design
    //     - Removed all Documentation Trigger Contents and placed in this Codeunit
    //     - Removed all Inserted Code-Blocks, and replaced with Subscriber Functions or One-Line Function Calls into the "QC Function Library" Codeunit
    //     - Removed All "QC"-related Global Variables, Text Contstants, and Functions
    // QC200.01 
    //   - Add new event function

    Permissions = TableData "Item Ledger Entry" = rimd;

    trigger OnRun();
    begin
    end;

#if BC19
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeCheckItemTrackingInformation', '', false, false)]
    local procedure ItemJnlPostLineOnBeforeCheckItemTrackingInformation(var ItemJnlLine2: Record "Item Journal Line"; var TrackingSpecification: Record "Tracking Specification"; var ItemTrackingSetup: Record "Item Tracking Setup"; var SignFactor: Decimal; var ItemTrackingCode: Record "Item Tracking Code"; var IsHandled: Boolean)
    var
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    begin
        if ItemTrackingCode."Create SN Info on Posting" then
            ItemTrackingMgt.CreateSerialNoInformation(TrackingSpecification);

        if ItemTrackingCode."Create Lot No. Info on posting" then
            ItemTrackingMgt.CreateLotNoInformation(TrackingSpecification);

        IsHandled := true;
    end;
#else
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeCheckLotNoInfoNotBlocked', '', false, false)]
    local procedure ItemJnlPostLineOnBeforeCheckLotNoInfoNotBlocked(var ItemJnlLine2: Record "Item Journal Line"; var IsHandled: Boolean; var ItemTrackingSetup: Record "Item Tracking Setup"; var TrackingSpecification: Record "Tracking Specification")
    begin
        if ItemJnlLine2."CCS Test No." <> '' then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnCheckItemTrackingInformationOnBeforeTestFields', '', false, false)]
    local procedure ItemJnlPostLineOnCheckItemTrackingInformationOnBeforeTestFields(ItemTrackingSetup: Record "Item Tracking Setup"; TrackingSpecification: Record "Tracking Specification"; ItemJnlLine: Record "Item Journal Line"; var IsHandled: Boolean)
    begin
        if ItemJnlLine."CCS Test No." <> '' then
            IsHandled := true;
    end;
#endif

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterApplyItemLedgEntrySetFilters', '', false, false)]
    local procedure ItemJnlPostLineOnAfterApplyItemLedgEntrySetFilters(var ItemLedgerEntry2: Record "Item Ledger Entry"; ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line")
    var
        IsMarked: Boolean;
        ItemLedgEntryType: Enum "Item Ledger Entry Type";
        LotNoInformation: Record "Lot No. Information";
        SerialNoInformation: Record "Serial No. Information";
    begin
        if not (ItemLedgerEntry."Entry Type" in [ItemLedgEntryType::Consumption, ItemLedgEntryType::"Negative Adjmt.", ItemLedgEntryType::Sale]) then
            exit;

        if ItemLedgerEntry2.FindSet() then
            repeat
                IsMarked := false;
                if (ItemLedgerEntry2."Lot No." = '') and (ItemLedgerEntry2."Serial No." = '') then
                    IsMarked := true;
                if ItemLedgerEntry2."Lot No." <> '' then
                    if LotNoInformation.Get(ItemLedgerEntry2."Item No.", ItemLedgerEntry2."Variant Code", ItemLedgerEntry2."Lot No.") then
                        IsMarked := not LotNoInformation.Blocked;
                if ItemLedgerEntry2."Serial No." <> '' then
                    if SerialNoInformation.Get(ItemLedgerEntry2."Item No.", ItemLedgerEntry2."Variant Code", ItemLedgerEntry2."Serial No.") then
                        IsMarked := not SerialNoInformation.Blocked;
                ItemLedgerEntry2.Mark(IsMarked);
            until ItemLedgerEntry2.Next() = 0;
        ItemLedgerEntry2.MarkedOnly(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, 22, 'OnBeforeInsertTransferEntry', '', false, false)]
    local procedure ItemJnlPostLineOnBeforeInsertTransferEntry(var NewItemLedgerEntry: Record "Item Ledger Entry"; var OldItemLedgerEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line");
    var
        LotMasterT: Record "Lot No. Information";
        ItemT: Record Item;
        lvItemT: Record Item;
        SerialMasterT: Record "Serial No. Information";
    begin
        //QC11.01 - Moved Code here from Codeunit 22, Function "InsertTransferEntry"

        //QC
        if ItemJournalLine."New Lot No." <> '' then
            if not LotMasterT.GET(NewItemLedgerEntry."Item No.", NewItemLedgerEntry."Variant Code", NewItemLedgerEntry."Lot No.") then begin
                LotMasterT.INIT;
                LotMasterT."Item No." := NewItemLedgerEntry."Item No.";
                LotMasterT."Variant Code" := NewItemLedgerEntry."Variant Code";
                LotMasterT."Lot No." := NewItemLedgerEntry."Lot No.";
                if ItemT.GET(NewItemLedgerEntry."Item No.") then begin
                    if (NewItemLedgerEntry.Description <> '') and (NewItemLedgerEntry.Description <> ItemT.Description) then
                        LotMasterT.Description := NewItemLedgerEntry.Description
                    else
                        LotMasterT.Description := ItemT.Description;
                end;
                if LotMasterT.INSERT then; //Suppress Error if FP has already done this
            end;
        //end QC

        //QC37.05
        if ItemJournalLine."New Serial No." <> '' then
            if lvItemT.GET(NewItemLedgerEntry."Item No.") then
                if lvItemT."CCS Auto Enter Ser No. Master" = true then begin
                    if not SerialMasterT.GET(NewItemLedgerEntry."Item No.", NewItemLedgerEntry."Variant Code",
                                              NewItemLedgerEntry."Serial No.") then begin
                        SerialMasterT.INIT;
                        SerialMasterT."Item No." := NewItemLedgerEntry."Item No.";
                        SerialMasterT."Variant Code" := NewItemLedgerEntry."Variant Code";
                        SerialMasterT."Serial No." := NewItemLedgerEntry."Serial No.";
                        if ItemT.GET(NewItemLedgerEntry."Item No.") then begin
                            if (NewItemLedgerEntry.Description <> '') and (NewItemLedgerEntry.Description <> ItemT.Description) then
                                SerialMasterT.Description := NewItemLedgerEntry.Description
                            else
                                SerialMasterT.Description := ItemT.Description;
                        end;
                        if SerialMasterT.INSERT then; //Suppress Error if FP has already done this
                    end;
                end;
        // end QC37.05
    end;

    [EventSubscriber(ObjectType::Codeunit, 22, 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure ItemJnlPostLineOnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line");
    var
        LotMasterT: Record "Lot No. Information";
        ItemT: Record Item;
        QSpecHeaderT: Record QCSpecificationHeader_PQ;
        ActiveVersionCode: Code[20];
        GetCompanySpec: Boolean;
        QSpecLineT: Record QCSpecificationLine_PQ;
        QLotTestLineT: Record QualityTestLines_PQ;
        lvItemT2: Record Item;
        QualitySpecsCopy: Codeunit QCFunctionLibrary_PQ;
        QCPostedT: Record QCPostedCompliance_PQ;
        ItemLedgEntryNo: Integer;
        SerialMasterT: Record "Serial No. Information";
        CustNo: Code[20];
    begin
        //QC11.01 Code Moved here from Codeunit 22, Function "InitItemLedgEntry"
        CustNo := '';
        if ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Sale then
            CustNo := ItemJournalLine."Source No.";

        ItemLedgEntryNo := NewItemLedgEntry."Entry No."; //QC11.01 - Get into Var. from Rec.

        //
        //QC - Start HUGE (300-ish line Insertion of Code in between two lines of NAV Std. Code
        //

        //QC
        if ItemJournalLine."Lot No." <> '' then begin
            if not LotMasterT.GET(NewItemLedgEntry."Item No.", NewItemLedgEntry."Variant Code", NewItemLedgEntry."Lot No.") then begin
                LotMasterT.INIT();
                LotMasterT."Item No." := NewItemLedgEntry."Item No.";
                LotMasterT."Variant Code" := NewItemLedgEntry."Variant Code";
                LotMasterT."Lot No." := NewItemLedgEntry."Lot No.";
                if ItemT.GET(NewItemLedgEntry."Item No.") then begin
                    if (NewItemLedgEntry.Description <> '') and (NewItemLedgEntry.Description <> ItemT.Description) then
                        LotMasterT.Description := NewItemLedgEntry.Description
                    else
                        LotMasterT.Description := ItemT.Description;
                end;
                if LotMasterT.INSERT() then; //Suppress Error if FP already did this
            end;

            //Creating entries in QC Posted Compliance table
            //QC
            //     ..Add ActiveVersionCode local variable
            //     ..Add QualtiySpecsCopy  global codeunit variable
            //     ..Add GetCompanySpec  Local
            //     ..Add QSpecLineT    Local

            GetCompanySpec := false;
            if QSpecHeaderT.GET(ItemJournalLine."Item No.",
                                ItemJournalLine."Source No.", QSpecHeaderT.GetSpecNoFromNonOutputSpecification(ItemJournalLine."Item No.", CustNo, '')) then begin
                ActiveVersionCode := QualitySpecsCopy.GetQCVersion(ItemJournalLine."Item No.",
                                                                   ItemJournalLine."Source No.", '',
                                                                   WORKDATE, 2);   //Origin = Salesline
                if ActiveVersionCode = '' then
                    if QSpecHeaderT.Status <> QSpecHeaderT.Status::Certified then
                        GetCompanySpec := true;

            end else
                GetCompanySpec := true;

            if GetCompanySpec then begin
                ActiveVersionCode := QualitySpecsCopy.GetQCVersion(ItemJournalLine."Item No.",
                                                                   '', '', WORKDATE, 2);   //Origin = SalesLine
                                                                                           //**
                QSpecLineT.SETRANGE("Item No.", ItemJournalLine."Item No.");
                QSpecLineT.SETRANGE("Customer No.", '');
                QSpecLineT.SETRANGE(Type, '');
                QSpecLineT.SETRANGE("Version Code", ActiveVersionCode);
                if QSpecLineT.FINDSET() then
                    repeat
                        QCPostedT.INIT();
                        QCPostedT."Item Entry No." := ItemLedgEntryNo;
                        QCPostedT."Lot/Serial No." := NewItemLedgEntry."Lot No.";
                        QCPostedT."Quality Measure" := QSpecLineT."Quality Measure";
                        QCPostedT."Line No." := QSpecLineT."Line No.";
                        QCPostedT."Non Compliance" := false;

                        //get test results
                        QLotTestLineT.SETRANGE("Item No.", ItemJournalLine."Item No.");
                        QLotTestLineT.SETRANGE("Lot No./Serial No.", ItemJournalLine."Lot No.");
                        QLotTestLineT.SETRANGE("Quality Measure", QSpecLineT."Quality Measure");
                        QLotTestLineT.SETRANGE("Test Status", QLotTestLineT."Test Status"::"Certified Final"); //QC71.3 - changed to "Certified Final"
                        if QLotTestLineT.FINDFIRST() then begin
                            if QLotTestLineT."Actual Measure" <> 0 then begin
                                if QSpecLineT."Lower Limit" <> 0 then
                                    if QLotTestLineT."Actual Measure" < QSpecLineT."Lower Limit" then
                                        QCPostedT."Non Compliance" := true;
                                if QSpecLineT."Upper Limit" <> 0 then
                                    if QLotTestLineT."Actual Measure" > QSpecLineT."Upper Limit" then
                                        QCPostedT."Non Compliance" := true;
                            end else begin
                                //QC4.30
                                if QLotTestLineT.Result <> '' then begin
                                    QCPostedT.Result := QLotTestLineT.Result;
                                    QCPostedT."Non Compliance" := QLotTestLineT."Non-Conformance";
                                end;
                                //end 4.30
                            end;
                        end;
                        QCPostedT."Item No." := NewItemLedgEntry."Item No.";
                        QCPostedT."Document No." := ItemJournalLine."Document No.";
                        QCPostedT."Posting Date" := ItemJournalLine."Posting Date";
                        QCPostedT."Customer No." := '';
                        QCPostedT."Version Code" := ActiveVersionCode;
                        QCPostedT."Lower Limit" := QSpecLineT."Lower Limit";
                        QCPostedT."Upper Limit" := QSpecLineT."Upper Limit";
                        QCPostedT."Nominal Value" := QSpecLineT."Nominal Value";
                        QCPostedT."Actual Value" := QLotTestLineT."Actual Measure";
                        QCPostedT."Result Type" := QLotTestLineT."Result Type";     //QC4.30
                        QCPostedT."Measure Description" := QSpecLineT."Measure Description";
                        QCPostedT.Method := QSpecLineT.Method;
                        QCPostedT."Test No." := QLotTestLineT."Test No.";
                        QCPostedT."Optional Display Prefix" := QLotTestLineT."Optional Display Prefix";
                        QCPostedT."Optional Display Value" := QLotTestLineT."Optional Display Value";
                        if QCPostedT.INSERT() then;

                    until QSpecLineT.NEXT = 0;

            end else begin     //get customer specific QC spec
                               //**
                QSpecLineT.SETRANGE("Item No.", ItemJournalLine."Item No.");
                QSpecLineT.SETRANGE("Customer No.", ItemJournalLine."Source No.");
                QSpecLineT.SETRANGE(Type, '');
                QSpecLineT.SETRANGE("Version Code", ActiveVersionCode);
                if QSpecLineT.FINDSET() then
                    repeat
                        QCPostedT.INIT();
                        QCPostedT."Item Entry No." := ItemLedgEntryNo;
                        QCPostedT."Lot/Serial No." := NewItemLedgEntry."Lot No.";
                        QCPostedT."Quality Measure" := QSpecLineT."Quality Measure";
                        QCPostedT."Line No." := QSpecLineT."Line No.";
                        QCPostedT."Non Compliance" := false;

                        //get test results
                        QLotTestLineT.SETRANGE("Item No.", ItemJournalLine."Item No.");
                        QLotTestLineT.SETRANGE("Lot No./Serial No.", ItemJournalLine."Lot No.");
                        QLotTestLineT.SETRANGE("Quality Measure", QSpecLineT."Quality Measure");
                        QLotTestLineT.SETRANGE("Test Status", QLotTestLineT."Test Status"::"Certified Final"); //QC71.3 - Changed to "Certified Final"
                        if QLotTestLineT.FINDFIRST() then begin
                            if QLotTestLineT."Actual Measure" <> 0 then begin
                                if QSpecLineT."Lower Limit" <> 0 then
                                    if QLotTestLineT."Actual Measure" < QSpecLineT."Lower Limit" then
                                        QCPostedT."Non Compliance" := true;
                                if QSpecLineT."Upper Limit" <> 0 then
                                    if QLotTestLineT."Actual Measure" > QSpecLineT."Upper Limit" then
                                        QCPostedT."Non Compliance" := true;
                            end else begin
                                //QC4.30
                                if QLotTestLineT.Result <> '' then begin
                                    QCPostedT.Result := QLotTestLineT.Result;
                                    QCPostedT."Non Compliance" := QLotTestLineT."Non-Conformance";
                                end;
                                //end 4.30
                            end;
                        end;
                        QCPostedT."Item No." := NewItemLedgEntry."Item No.";
                        QCPostedT."Document No." := ItemJournalLine."Document No.";
                        QCPostedT."Posting Date" := ItemJournalLine."Posting Date";
                        QCPostedT."Customer No." := ItemJournalLine."Source No.";
                        QCPostedT."Version Code" := ActiveVersionCode;
                        QCPostedT."Lower Limit" := QSpecLineT."Lower Limit";
                        QCPostedT."Upper Limit" := QSpecLineT."Upper Limit";
                        QCPostedT."Nominal Value" := QSpecLineT."Nominal Value";
                        QCPostedT."Actual Value" := QLotTestLineT."Actual Measure";
                        QCPostedT."Result Type" := QLotTestLineT."Result Type";     //QC4.30
                        QCPostedT."Measure Description" := QSpecLineT."Measure Description";
                        QCPostedT.Method := QSpecLineT.Method;
                        QCPostedT."Test No." := QLotTestLineT."Test No.";
                        QCPostedT."Optional Display Prefix" := QLotTestLineT."Optional Display Prefix";
                        QCPostedT."Optional Display Value" := QLotTestLineT."Optional Display Value";
                        if QCPostedT.INSERT() then;

                    until QSpecLineT.NEXT() = 0;
            end;
        end;
        //end QC

        //QC37.05
        if NewItemLedgEntry."Serial No." <> '' then begin
            if lvItemT2.GET(NewItemLedgEntry."Item No.") then begin
                if lvItemT2."CCS Auto Enter Ser No. Master" = true then begin
                    if not SerialMasterT.GET(NewItemLedgEntry."Item No.", NewItemLedgEntry."Variant Code", NewItemLedgEntry."Serial No.") then begin
                        SerialMasterT.INIT();
                        SerialMasterT."Item No." := NewItemLedgEntry."Item No.";
                        SerialMasterT."Variant Code" := NewItemLedgEntry."Variant Code";
                        SerialMasterT."Serial No." := NewItemLedgEntry."Serial No.";
                        if ItemT.GET(NewItemLedgEntry."Item No.") then begin
                            if (NewItemLedgEntry.Description <> '') and (NewItemLedgEntry.Description <> ItemT.Description) then
                                SerialMasterT.Description := NewItemLedgEntry.Description
                            else
                                SerialMasterT.Description := ItemT.Description;
                        end;
                        if SerialMasterT.INSERT() then;  //Suppress Error if FP already did this
                    end;
                end;
            end;

            //Creating entries in QC Posted Compliance table
            //QC
            //     ..Add ActiveVersionCode local variable
            //     ..Add QualtiySpecsCopy  global codeunit variable
            //     ..Add GetCompanySpec  Local
            //     ..Add QSpecLineT    Local

            GetCompanySpec := false;
            if QSpecHeaderT.GET(ItemJournalLine."Item No.",
                                ItemJournalLine."Source No.", QSpecHeaderT.GetSpecNoFromNonOutputSpecification(ItemJournalLine."Item No.", CustNo, '')) then begin
                ActiveVersionCode := QualitySpecsCopy.GetQCVersion(ItemJournalLine."Item No.",
                                                                   ItemJournalLine."Source No.", '',
                                                                   WORKDATE, 2);   //Origin = Salesline
                if ActiveVersionCode = '' then
                    if QSpecHeaderT.Status <> QSpecHeaderT.Status::Certified then
                        GetCompanySpec := true;

            end else
                GetCompanySpec := true;

            if GetCompanySpec then begin
                ActiveVersionCode := QualitySpecsCopy.GetQCVersion(ItemJournalLine."Item No.",
                                                                   '', '', WORKDATE, 2);   //Origin = SalesLine
                                                                                           //**
                QSpecLineT.SETRANGE("Item No.", ItemJournalLine."Item No.");
                QSpecLineT.SETRANGE("Customer No.", '');
                QSpecLineT.SETRANGE(Type, '');
                QSpecLineT.SETRANGE("Version Code", ActiveVersionCode);
                if QSpecLineT.FINDSET() then
                    repeat
                        QCPostedT.INIT();
                        QCPostedT."Item Entry No." := ItemLedgEntryNo;
                        QCPostedT."Lot/Serial No." := NewItemLedgEntry."Serial No.";
                        QCPostedT."Quality Measure" := QSpecLineT."Quality Measure";
                        QCPostedT."Line No." := QSpecLineT."Line No.";
                        QCPostedT."Non Compliance" := false;

                        //get test results
                        QLotTestLineT.SETRANGE("Item No.", ItemJournalLine."Item No.");
                        QLotTestLineT.SETRANGE("Lot No./Serial No.", ItemJournalLine."Serial No.");
                        QLotTestLineT.SETRANGE("Quality Measure", QSpecLineT."Quality Measure");
                        QLotTestLineT.SETRANGE("Test Status", QLotTestLineT."Test Status"::"Certified Final"); //QC71.3 - changed to "Certified Final"
                        if QLotTestLineT.FINDFIRST() then begin
                            if QLotTestLineT."Actual Measure" <> 0 then begin
                                if QSpecLineT."Lower Limit" <> 0 then
                                    if QLotTestLineT."Actual Measure" < QSpecLineT."Lower Limit" then
                                        QCPostedT."Non Compliance" := true;
                                if QSpecLineT."Upper Limit" <> 0 then
                                    if QLotTestLineT."Actual Measure" > QSpecLineT."Upper Limit" then
                                        QCPostedT."Non Compliance" := true;
                            end else begin
                                //QC4.30
                                if QLotTestLineT.Result <> '' then begin
                                    QCPostedT.Result := QLotTestLineT.Result;
                                    QCPostedT."Non Compliance" := QLotTestLineT."Non-Conformance";
                                end;
                                //end 4.30
                            end;
                        end;
                        QCPostedT."Item No." := NewItemLedgEntry."Item No.";
                        QCPostedT."Document No." := ItemJournalLine."Document No.";
                        QCPostedT."Posting Date" := ItemJournalLine."Posting Date";
                        QCPostedT."Customer No." := '';
                        QCPostedT."Version Code" := ActiveVersionCode;
                        QCPostedT."Lower Limit" := QSpecLineT."Lower Limit";
                        QCPostedT."Upper Limit" := QSpecLineT."Upper Limit";
                        QCPostedT."Nominal Value" := QSpecLineT."Nominal Value";
                        QCPostedT."Actual Value" := QLotTestLineT."Actual Measure";
                        QCPostedT."Result Type" := QLotTestLineT."Result Type";     //QC4.30
                        QCPostedT."Measure Description" := QSpecLineT."Measure Description";
                        QCPostedT.Method := QSpecLineT.Method;
                        QCPostedT."Test No." := QLotTestLineT."Test No.";
                        QCPostedT."Optional Display Prefix" := QLotTestLineT."Optional Display Prefix";
                        QCPostedT."Optional Display Value" := QLotTestLineT."Optional Display Value";
                        if QCPostedT.INSERT() then;

                    until QSpecLineT.NEXT() = 0;

            end else begin     //get customer specific QC spec
                               //**
                QSpecLineT.SETRANGE("Item No.", ItemJournalLine."Item No.");
                QSpecLineT.SETRANGE("Customer No.", ItemJournalLine."Source No.");
                QSpecLineT.SETRANGE(Type, '');
                QSpecLineT.SETRANGE("Version Code", ActiveVersionCode);
                if QSpecLineT.FINDSET() then
                    repeat
                        QCPostedT.INIT;
                        QCPostedT."Item Entry No." := ItemLedgEntryNo;
                        QCPostedT."Lot/Serial No." := NewItemLedgEntry."Serial No.";
                        QCPostedT."Quality Measure" := QSpecLineT."Quality Measure";
                        QCPostedT."Line No." := QSpecLineT."Line No.";
                        QCPostedT."Non Compliance" := false;

                        //get test results
                        QLotTestLineT.SETRANGE("Item No.", ItemJournalLine."Item No.");
                        QLotTestLineT.SETRANGE("Lot No./Serial No.", ItemJournalLine."Serial No.");
                        QLotTestLineT.SETRANGE("Quality Measure", QSpecLineT."Quality Measure");
                        QLotTestLineT.SETRANGE("Test Status", QLotTestLineT."Test Status"::"Certified Final"); //QC71.3 - changed to "Certified Final"
                        if QLotTestLineT.FINDFIRST() then begin
                            if QLotTestLineT."Actual Measure" <> 0 then begin
                                if QSpecLineT."Lower Limit" <> 0 then
                                    if QLotTestLineT."Actual Measure" < QSpecLineT."Lower Limit" then
                                        QCPostedT."Non Compliance" := true;
                                if QSpecLineT."Upper Limit" <> 0 then
                                    if QLotTestLineT."Actual Measure" > QSpecLineT."Upper Limit" then
                                        QCPostedT."Non Compliance" := true;
                            end else begin
                                //QC4.30
                                if QLotTestLineT.Result <> '' then begin
                                    QCPostedT.Result := QLotTestLineT.Result;
                                    QCPostedT."Non Compliance" := QLotTestLineT."Non-Conformance";
                                end;
                                //end 4.30
                            end;
                        end;
                        QCPostedT."Item No." := NewItemLedgEntry."Item No.";
                        QCPostedT."Document No." := ItemJournalLine."Document No.";
                        QCPostedT."Posting Date" := ItemJournalLine."Posting Date";
                        QCPostedT."Customer No." := ItemJournalLine."Source No.";
                        QCPostedT."Version Code" := ActiveVersionCode;
                        QCPostedT."Lower Limit" := QSpecLineT."Lower Limit";
                        QCPostedT."Upper Limit" := QSpecLineT."Upper Limit";
                        QCPostedT."Nominal Value" := QSpecLineT."Nominal Value";
                        QCPostedT."Actual Value" := QLotTestLineT."Actual Measure";
                        QCPostedT."Result Type" := QLotTestLineT."Result Type";     //QC4.30
                        QCPostedT."Measure Description" := QSpecLineT."Measure Description";
                        QCPostedT.Method := QSpecLineT.Method;
                        QCPostedT."Test No." := QLotTestLineT."Test No.";
                        QCPostedT."Optional Display Prefix" := QLotTestLineT."Optional Display Prefix";
                        QCPostedT."Optional Display Value" := QLotTestLineT."Optional Display Value";
                        if QCPostedT.INSERT() then;

                    until QSpecLineT.NEXT() = 0;
            end;
        end;
        // end QC37.05

        //QC4 Start - Code Insertion to always enter Lots

        if NewItemLedgEntry."Lot No." <> '' then begin
            if lvItemT2.GET(NewItemLedgEntry."Item No.") then begin
                if not LotMasterT.GET(NewItemLedgEntry."Item No.", NewItemLedgEntry."Variant Code", NewItemLedgEntry."Lot No.") then begin
                    LotMasterT.INIT();
                    LotMasterT."Item No." := NewItemLedgEntry."Item No.";
                    LotMasterT."Variant Code" := NewItemLedgEntry."Variant Code";
                    LotMasterT."Lot No." := NewItemLedgEntry."Lot No.";
                    if ItemT.GET(NewItemLedgEntry."Item No.") then begin
                        if (NewItemLedgEntry.Description <> '') and (NewItemLedgEntry.Description <> ItemT.Description) then
                            LotMasterT.Description := NewItemLedgEntry.Description
                        else
                            LotMasterT.Description := ItemT.Description;
                    end;
                    if LotMasterT.INSERT() then; //Suppress Error if FP already did this
                end;
            end;
        end;
        if NewItemLedgEntry."Serial No." <> '' then begin
            if lvItemT2.GET(NewItemLedgEntry."Item No.") then begin
                if lvItemT2."CCS Auto Enter Ser No. Master" = true then begin
                    if not SerialMasterT.GET(NewItemLedgEntry."Item No.", NewItemLedgEntry."Variant Code", NewItemLedgEntry."Serial No.") then begin
                        SerialMasterT.INIT();
                        SerialMasterT."Item No." := NewItemLedgEntry."Item No.";
                        SerialMasterT."Variant Code" := NewItemLedgEntry."Variant Code";
                        SerialMasterT."Serial No." := NewItemLedgEntry."Serial No.";
                        if ItemT.GET(NewItemLedgEntry."Item No.") then begin
                            if (NewItemLedgEntry.Description <> '') and (NewItemLedgEntry.Description <> ItemT.Description) then
                                SerialMasterT.Description := NewItemLedgEntry.Description
                            else
                                SerialMasterT.Description := ItemT.Description;
                        end;
                        if SerialMasterT.INSERT() then;  //Suppress Error if FP already did this
                    end;
                end;
            end;
        end;

        //QC4 Finish Lot Code Insersion


        //QC ...Original NAV Code resumes after here

        //
        //QC - Finish HUGE (300-ish line Insertion of Code)
        //
    end;

    //QC200.01
    [EventSubscriber(ObjectType::Codeunit, 22, 'OnAfterInsertItemLedgEntry', '', false, false)]
    local procedure ItemJnlPostLineOnAfterInsertItemLedgEntry(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer; var ValueEntryNo: Integer; var ItemApplnEntryNo: Integer);
    var
        QCFunctionLibrary: Codeunit QCFunctionLibrary_PQ;
        SourceCodeSetup: Record "Source Code Setup";
        QCSetup: Record "QCSetup_PQ";
        LotNoInfo: Record "Lot No. Information";
        SerialNoInfo: Record "Serial No. Information";
        QCSpecHeader: Record "QCSpecificationHeader_PQ";
        //QCTransactionArea: Record "CCS Transaction Area";
        QCRequired: Boolean;
        Lbl001: Label 'Lot No. %1 is restricted for sales, it cannot be shipped.';
        Lbl002: Label 'Serial No. %1 is restricted for sales, it cannot be shipped.';
        Lbl003: Label 'Please specify transaction areas for Sales, Purchases, Output and Phys. Inventory.';
        OrderNo: Code[20];
        LineNo: Integer;
        VendorNo: Code[20];
        SourceType: Enum QCSourceType_PQ;
        PurchHdr: Record "Purchase Header";
        PurchRcptHdr: Record "Purch. Rcpt. Header";
        TransferHdr: Record "Transfer Header";
        TransferRcptHdr: Record "Transfer Receipt Header";
        SalesHdr: Record "Sales Header";
        SalesShpmHdr: Record "Sales Shipment Header";
        ReturnReceipthdr: Record "Return Receipt Header";
        QualityType: Enum "ItemQualityRequirement_PQ";
        SpecificationNo: Code[20];
        TestNo: Code[20];
        Items: Record Item;
        QTCreate: Boolean;
        CheckLotCreated: Boolean;
        QtTestNoCreated: Text;
        IsNew: Boolean;
        QTHeader: Record QualityTestHeader_PQ;
        QualityTestLine: Record QualityTestLines_PQ;
        BinCode: Code[20];
    begin
        QCSetup.Get;

        SourceCodeSetup.Get;

        if ((ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::Sale) and (ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Shipment")) then begin
            if (ItemLedgerEntry."Lot No." <> '') and LotNoInfo.Get(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Lot No.") then
                if LotNoInfo."CCS Status" = LotNoInfo."CCS Status"::Restricted then
                    Error(Lbl001);
            if (ItemLedgerEntry."Serial No." <> '') and SerialNoInfo.Get(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Serial No.") then
                if SerialNoInfo."CCS Status" = SerialNoInfo."CCS Status"::Restricted then
                    Error(Lbl002);

            // Verify Specification
            /*
            QCTransactionArea.SetRange("Transaction Area", QCTransactionArea."Transaction Area"::Sales);
            if not QCTransactionArea.FindFirst() then
                error(Lbl003);
            */
            SpecificationNo := GetSpecificationFromItemQualityRequirement(QualityType::"Sales Shipment", ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Location Code");
            if SpecificationNo = '' then
                exit;

            OrderNo := ItemLedgerEntry."Document No.";

            SalesShpmHdr.Reset();
            SalesShpmHdr.SetRange("No.", ItemLedgerEntry."Document No.");
            if SalesShpmHdr.FindFirst() then begin
                SalesHdr.Reset();
                SalesHdr.SetRange("Document Type", SalesHdr."Document Type"::Order);
                SalesHdr.SetRange("No.", SalesShpmHdr."Order No.");
                if SalesHdr.FindFirst() then
                    OrderNo := SalesHdr."No.";
            end;

            if QCFunctionLibrary.VerifyValidQualitySpecification2(ItemLedgerEntry."Item No.", '', QCRequired, SpecificationNo) then
                if QCRequired then
                    QCFunctionLibrary.CreateQualityTestAndSpecifications(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Unit of Measure Code", ItemLedgerEntry."Lot No.", ItemLedgerEntry."Serial No.", SpecificationNo,
                    '', QCSourceType_PQ::"Sales Order", OrderNo, ItemLedgerEntry."Document Line No.", '', ItemLedgerEntry.Quantity, ItemLedgerEntry."Document No.", '', BinCode);
        end;

        if ((ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::Purchase) and (ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Purchase Receipt")) or (ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::Output)
           or ((ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::"Positive Adjmt.") and (ItemJournalLine."Source Code" in [SourceCodeSetup."Item Journal", SourceCodeSetup."Item Reclass. Journal", SourceCodeSetup."Whse. Item Journal", SourceCodeSetup."Phys. Inventory Journal"]))
           or ((ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::Sale) and (ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Return Receipt")
           or ((ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::Transfer) and (ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Transfer Receipt")))
        then begin

            //Handling revese
            if ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::Output then begin
                if ItemLedgerEntry."Applies-to Entry" <> 0 then
                    exit;
            end;
            //-

            //Add check by rnd 27 April 22, request by chz 
            Clear(QtTestNoCreated);
            CheckLotCreated := false;
            Clear(LotNoInfo);
            LotNoInfo.SetRange("Item No.", ItemLedgerEntry."Item No.");
            LotNoInfo.SetRange("Lot No.", ItemLedgerEntry."Lot No.");
            if LotNoInfo.Find('-') then begin
                CheckLotCreated := true;
                QtTestNoCreated := LotNoInfo."CCS Test No.";
            end;
            //-
            // Verify Lot and Serial No. Information Card
            if ItemLedgerEntry."Lot No." <> '' then
                if not QCFunctionLibrary.LotOrSerialNoInformationExists(0, ItemLedgerEntry) then begin
                    QCFunctionLibrary.CreateLotOrSerialNoInformation(0, ItemLedgerEntry);
                end
                else
                    OnModifyLotOrSerialNoInformation(LotNoInfo, ItemLedgerEntry);
            if ItemLedgerEntry."Serial No." <> '' then
                if not QCFunctionLibrary.LotOrSerialNoInformationExists(1, ItemLedgerEntry) then
                    QCFunctionLibrary.CreateLotOrSerialNoInformation(1, ItemLedgerEntry);

            // Verify Quality Specification
            if QCSetup."Autom. Create Quality Test" then begin
                // Verify transaction area

                case ItemLedgerEntry."Entry Type" of
                    ItemLedgerEntry."Entry Type"::Output:
                        QualityType := QualityType::"Item Output";
                    ItemLedgerEntry."Entry Type"::Purchase:
                        QualityType := QualityType::"Purchase Receipt";
                    ItemLedgerEntry."Entry Type"::"Positive Adjmt.":
                        begin
                            if ItemJournalLine."Source Code" = SourceCodeSetup."Item Journal" then
                                QualityType := QualityType::"Item Journal"
                            else
                                QualityType := QualityType::"Item Phys. Inventory";
                        end;
                    ItemLedgerEntry."Entry Type"::Sale:
                        QualityType := QualityType::"Sales Return Receipt";
                    ItemLedgerEntry."Entry Type"::Transfer:
                        QualityType := QualityType::"Transfer Receipt";
                end;
                /*
                if not QCTransactionArea.FindFirst() then
                    error(Lbl003);
                */
                // SpecificationNo := GetSpecificationFromItemQualityRequirement(QualityType, ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Location Code");
                // if SpecificationNo = '' then
                //     exit;

                if (ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::Purchase) and (ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Purchase Receipt") then begin
                    // 02 Jan 2026, Add info bin
                    Clear(BinCode);
                    BinCode := ItemJournalLine."Bin Code";
                    //-

                    OrderNo := ItemLedgerEntry."Document No.";
                    LineNo := ItemLedgerEntry."Document Line No.";
                    SourceType := QCSourceType_PQ::"Purchase Order";
                    VendorNo := '';

                    SpecificationNo := GetSpecificationFromItemQualityRequirement(QualityType, ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Location Code");
                    if SpecificationNo = '' then exit;

                    PurchRcptHdr.Reset();
                    PurchRcptHdr.SetRange("No.", ItemLedgerEntry."Document No.");
                    if PurchRcptHdr.FindFirst() then begin
                        PurchHdr.Reset();
                        PurchHdr.SetRange("Document Type", PurchHdr."Document Type"::Order);
                        PurchHdr.SetRange("No.", PurchRcptHdr."Order No.");
                        if PurchHdr.FindFirst() then begin
                            OrderNo := PurchHdr."No.";
                            VendorNo := PurchHdr."Buy-from Vendor No.";
                        end;
                    end;

                    //case if FP already inserted Lot/Serial
                    if LotNoInfo.Get(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Lot No.") then begin
                        LotNoInfo."CCS Date Received" := ItemLedgerEntry."Posting Date"; //work date
                        LotNoInfo.Modify();
                    end;
                    if SerialNoInfo.Get(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Serial No.") then begin
                        SerialNoInfo."CCS Date Received" := WorkDate;
                        SerialNoInfo.Modify();
                    end;

                end else
                    if ((ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::Sale) and (ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Return Receipt")) then begin
                        OrderNo := ItemLedgerEntry."Document No.";
                        LineNo := ItemLedgerEntry."Document Line No.";
                        SourceType := QCSourceType_PQ::"Sales Return Receipt";
                        VendorNo := '';

                        SpecificationNo := GetSpecificationFromItemQualityRequirement(QualityType, ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Location Code");
                        if SpecificationNo = '' then exit;

                        ReturnReceipthdr.Reset();
                        ReturnReceipthdr.SetRange("No.", ItemLedgerEntry."Document No.");
                        if ReturnReceipthdr.FindFirst() then begin
                            SalesHdr.Reset();
                            SalesHdr.SetRange("Document Type", PurchHdr."Document Type"::"Return Order");
                            SalesHdr.SetRange("No.", ReturnReceipthdr."Return Order No.");
                            if SalesHdr.FindFirst() then begin
                                OrderNo := SalesHdr."No.";
                                //VendorNo := SalesHdr."Buy-from Vendor No.";
                            end;
                        end;
                    end else
                        if ((ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::Transfer) and (ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Transfer Receipt")) then begin
                            OrderNo := ItemLedgerEntry."Document No.";
                            LineNo := ItemLedgerEntry."Document Line No.";
                            SourceType := QCSourceType_PQ::"Transfer Order";
                            VendorNo := '';

                            TransferRcptHdr.Reset();
                            TransferRcptHdr.SetRange("No.", ItemLedgerEntry."Document No.");
                            if TransferRcptHdr.FindFirst() then begin
                                TransferHdr.Reset();
                                TransferHdr.SetRange("No.", TransferRcptHdr."No.");
                                if TransferHdr.FindFirst() then begin
                                    OrderNo := TransferHdr."No.";
                                    // VendorNo := TransferHdr."Buy-from Vendor No.";
                                end;
                                SpecificationNo := GetSpecificationFromItemQualityRequirement(QualityType, ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Location Code");
                                if SpecificationNo = '' then exit;
                            end;

                            //case if FP already inserted Lot/Serial
                            if LotNoInfo.Get(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Lot No.") then begin
                                LotNoInfo."CCS Date Received" := WorkDate;
                                LotNoInfo.Modify();
                            end;
                            if SerialNoInfo.Get(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Serial No.") then begin
                                SerialNoInfo."CCS Date Received" := WorkDate;
                                SerialNoInfo.Modify();
                            end;
                        end else begin
                            OrderNo := ItemJournalLine."Document No.";
                            LineNo := 10000;
                            if ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::Output then
                                SourceType := QCSourceType_PQ::"Output Journal"
                            else
                                SourceType := QCSourceType_PQ::"Item Journal";
                            SpecificationNo := GetSpecificationFromItemQualityRequirement(QualityType, ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Location Code");
                            if SpecificationNo = '' then exit;
                        end;

                // Verify Specification
                if QCFunctionLibrary.VerifyValidQualitySpecification2(ItemLedgerEntry."Item No.", '', QCRequired, SpecificationNo) then
                    if QCRequired then begin
                        //additional check by rnd 27 April 24, request by chz
                        /*QTCreate := true;
                        if SourceType = SourceType::"Output Journal" then begin
                            Clear(Items);
                            if Items.Get(ItemLedgerEntry."Item No.") then begin
                                if Items."QualityTest Type" = items."Quality Test Type"::Singgle then begin
                                    if CheckLotCreated then begin
                                        TestNo := QtTestNoCreated;
                                        QTCreate := false
                                    end;
                                end;
                                if Items."Quality Test Type" = Items."Quality Test Type"::" " then
                                    QTCreate := false;
                            end;
                        end;
                        */
                        //- 
                        //Modify at 30 April 2024 , Handle QT Always create & Check remain qty
                        QTCreate := true;
                        if ItemJournalLine.IsRemainQty then begin
                            TestNo := '';
                            QTCreate := false;
                            QCRequired := false;
                        end;
                        //-
                        if QTCreate then
                            TestNo := QCFunctionLibrary.CreateQualityTestAndSpecifications(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Unit of Measure Code", ItemLedgerEntry."Lot No.", ItemLedgerEntry."Serial No.", SpecificationNo,
                             '', SourceType, OrderNo, LineNo, VendorNo, ItemLedgerEntry.Quantity, ItemLedgerEntry."Document No.", '', BinCode);

                        ItemLedgerEntry."CCS Quality Test" := TestNo;
                        ItemLedgerEntry.IsRemainQty := ItemJournalLine.IsRemainQty;
                        ItemLedgerEntry.Modify();
                    end;

                // Block Lot/Serial No. Information Card
                if QCRequired then
                    QCFunctionLibrary.BlockLotAndSerialNoInformation3(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Lot No.", ItemLedgerEntry."Serial No.", ItemLedgerEntry."Expiration Date", true, TestNo);
            end;
        end;

        // Update expiration date
        if ItemLedgerEntry."Lot No." <> '' then
            QCFunctionLibrary.UpdateExpirationDateOnLotOrSerialNoInformation(0, ItemLedgerEntry);
        if ItemLedgerEntry."Serial No." <> '' then
            QCFunctionLibrary.UpdateExpirationDateOnLotOrSerialNoInformation(1, ItemLedgerEntry);
    end;

    local procedure AssignSourceTestNo(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line")
    begin
        if ItemJournalLine."CCS Test No." = '' then
            exit;
        ItemLedgerEntry."CCS Create from Test No." := ItemJournalLine."CCS Test No.";
        ItemLedgerEntry.Modify();
    end;

    //QC200.01 --Disable refer to DKR
    /*
    [EventSubscriber(ObjectType::Codeunit, 99000813, 'OnAfterTransferPlanningRtngLine', '', false, false)]
    local procedure CarryOutActionOnAfterTransferPlanningRtngLine(var PlanningRtngLine: Record "Planning Routing Line"; var ProdOrderRtngLine: Record "Prod. Order Routing Line");
    var
        QCFunctionLibrary: Codeunit QCFunctionLibrary_PQ;
        RoutingLine: Record "Routing Line";
        ProdOrderLine: Record "Prod. Order Line";
        QCRequired: Boolean;
    begin
        ProdOrderLine.SetRange("Prod. Order No.", ProdOrderRtngLine."Prod. Order No.");
        if ProdOrderLine.FindFirst() then begin
            if RoutingLine.Get(ProdOrderRtngLine."Routing No.", ProdOrderLine."Routing Version Code", ProdOrderRtngLine."Operation No.") then
                ProdOrderRtngLine."CCS Spec. Type ID" := RoutingLine."CCS Spec. Type ID";

            if ProdOrderRtngLine."CCS Spec. Type ID" <> '' then
                if QCFunctionLibrary.VerifyValidQualitySpecification2(ProdOrderLine."Item No.", '', QCRequired, ProdOrderRtngLine."CCS Spec. Type ID") then
                    if QCRequired then begin
                        ProdOrderRtngLine."CCS Quality Test No." := QCFunctionLibrary.GetSpecificQualityHeader(ProdOrderLine."Item No.", ProdOrderRtngLine."CCS Spec. Type ID");
                        if ProdOrderRtngLine."CCS Quality Test No." = '' then begin
                            QCFunctionLibrary.CreateQualityTestAndSpecifications(ProdOrderLine."Item No.", ProdOrderLine."Variant Code", ProdOrderLine."Location Code", ProdOrderLine."Unit of Measure Code", '', '', ProdOrderRtngLine."CCS Spec. Type ID",
                            '', QCSourceType_PQ::"Production Order", ProdOrderLine."Prod. Order No.", ProdOrderLine."Line No.", '', '', ProdOrderLine.Quantity, ProdOrderLine."Prod. Order No.", ProdOrderRtngLine."Operation No.");
                            ProdOrderRtngLine."CCS Quality Test No." := QCFunctionLibrary.GetSpecificQualityHeader(ProdOrderLine."Item No.", ProdOrderRtngLine."CCS Spec. Type ID");
                        end;
                    end;
        end;
    end;
    */

    //QC200.01 disbale refer to DKR
    /*[EventSubscriber(ObjectType::Codeunit, 99000773, 'OnAfterTransferRoutingLine', '', false, false)]
    local procedure CalculateProdOrderOnAfterTransferRoutingLine(var ProdOrderLine: Record "Prod. Order Line"; var RoutingLine: Record "Routing Line"; var ProdOrderRoutingLine: Record "Prod. Order Routing Line");
    var
        QCFunctionLibrary: Codeunit QCFunctionLibrary_PQ;
        QCRequired: Boolean;
        ProdOrder: Record "Production Order";
    begin
        ProdOrderRoutingLine."CCS Spec. Type ID" := RoutingLine."CCS Spec. Type ID";
        if ProdOrder.Get(ProdOrder.Status::Released, ProdOrderLine."Prod. Order No.") then begin
            if ProdOrderRoutingLine."CCS Spec. Type ID" <> '' then
                if QCFunctionLibrary.VerifyValidQualitySpecification2(ProdOrderLine."Item No.", '', QCRequired, ProdOrderRoutingLine."CCS Spec. Type ID") then
                    if QCRequired then begin
                        ProdOrderRoutingLine."CCS Quality Test No." := QCFunctionLibrary.GetSpecificQualityHeader2(ProdOrderLine."Item No.", ProdOrderRoutingLine."CCS Spec. Type ID", ProdOrder."No.", ProdOrderRoutingLine."Operation No.");
                        if ProdOrderRoutingLine."CCS Quality Test No." = '' then begin
                            QCFunctionLibrary.CreateQualityTestAndSpecifications(ProdOrderLine."Item No.", ProdOrderLine."Variant Code", ProdOrderLine."Location Code", ProdOrderLine."Unit of Measure Code", '', '', ProdOrderRoutingLine."CCS Spec. Type ID", ProdOrder."No.",
                            QCSourceType_PQ::"Production Order", ProdOrderLine."Prod. Order No.", ProdOrderLine."Line No.", '', '', ProdOrderLine.Quantity, ProdOrderLine."Prod. Order No.", ProdOrderRoutingLine."Operation No.");
                            ProdOrderRoutingLine."CCS Quality Test No." := QCFunctionLibrary.GetSpecificQualityHeader2(ProdOrderLine."Item No.", ProdOrderRoutingLine."CCS Spec. Type ID", ProdOrder."No.", ProdOrderRoutingLine."Operation No.");
                        end;
                    end;
        end;
    end;
    */


    /* Disable refer to DKR
    [EventSubscriber(ObjectType::Codeunit, 5407, 'OnAfterToProdOrderRtngLineInsert', '', false, false)]
    local procedure OnAfterToProdOrderRtngLineInsert(var ToProdOrderRoutingLine: Record "Prod. Order Routing Line"; var FromProdOrderRoutingLine: Record "Prod. Order Routing Line")
    var
        QCFunctionLibrary: Codeunit QCFunctionLibrary_PQ;
        QCRequired: Boolean;
        ProdOrder: Record "Production Order";
        ProdOrderLine: Record "Prod. Order Line";
        RoutingLine: Record "Routing Line";
    begin
        if ProdOrder.Get(ProdOrder.Status::Released, ToProdOrderRoutingLine."Prod. Order No.") then begin
            ProdOrderLine.Reset();
            ProdOrderLine.SetRange(Status, ProdOrder.Status);
            ProdOrderLine.SetRange("Prod. Order No.", ProdOrder."No.");
            ProdOrderLine.SetRange("Line No.", ToProdOrderRoutingLine."Routing Reference No.");
            if ProdOrderLine.FindFirst() then begin
                RoutingLine.Reset();
                RoutingLine.SetRange("Routing No.", ToProdOrderRoutingLine."Routing No.");
                RoutingLine.SetRange("Operation No.", ToProdOrderRoutingLine."Operation No.");
                if RoutingLine.FindFirst() then begin
                    if ToProdOrderRoutingLine."CCS Spec. Type ID" = '' then
                        ToProdOrderRoutingLine."CCS Spec. Type ID" := RoutingLine."CCS Spec. Type ID";
                end;
                if ToProdOrderRoutingLine."CCS Spec. Type ID" <> '' then
                    if QCFunctionLibrary.VerifyValidQualitySpecification2(ProdOrderLine."Item No.", '', QCRequired, ToProdOrderRoutingLine."CCS Spec. Type ID") then
                        if QCRequired then begin
                            ToProdOrderRoutingLine."CCS Quality Test No." := QCFunctionLibrary.GetSpecificQualityHeader2(ProdOrderLine."Item No.", ToProdOrderRoutingLine."CCS Spec. Type ID", ProdOrder."No.", ToProdOrderRoutingLine."Operation No.");
                            if ToProdOrderRoutingLine."CCS Quality Test No." = '' then begin
                                QCFunctionLibrary.CreateQualityTestAndSpecifications(ProdOrderLine."Item No.", ProdOrderLine."Variant Code", ProdOrderLine."Location Code", ProdOrderLine."Unit of Measure Code", '', '', ToProdOrderRoutingLine."CCS Spec. Type ID", ProdOrder."No.",
                                QCSourceType_PQ::"Production Order", ProdOrderLine."Prod. Order No.", ProdOrderLine."Line No.", '', '', ProdOrderLine.Quantity, ProdOrderLine."Prod. Order No.", ToProdOrderRoutingLine."Operation No.");
                                ToProdOrderRoutingLine."CCS Quality Test No." := QCFunctionLibrary.GetSpecificQualityHeader2(ProdOrderLine."Item No.", ToProdOrderRoutingLine."CCS Spec. Type ID", ProdOrder."No.", ToProdOrderRoutingLine."Operation No.");
                            end;
                        end;
            end;
        end;
    end;*/


    /* disable refer to DKR
    [EventSubscriber(ObjectType::Table, 83, 'OnBeforePostingItemJnlFromProduction', '', false, false)]
    local procedure ItemJournalLineOnBeforePostingItemJnlFromProduction(var ItemJournalLine: Record "Item Journal Line"; Print: Boolean; var IsHandled: Boolean);
    var
        ProdOrderRtngLine: Record "Prod. Order Routing Line";
        QualityHeader: Record QualityTestHeader_PQ;
        ItemJnlLine: Record "Item Journal Line";
        Txt001: Label 'You cannot post line %1 because it has an associated un-certified Quality Test (%2).';
    begin
        ItemJnlLine.Copy(ItemJournalLine);

        ItemJnlLine.SetRange("Entry Type", ItemJnlLine."Entry Type"::Output);
        ItemJnlLine.SetFilter("Operation No.", '<>%1', '');
        ItemJnlLine.SetFilter("Output Quantity", '<>%1', 0);
        if ItemJnlLine.FindSet() then
            repeat
                if ProdOrderRtngLine.Get(ProdOrderRtngLine.Status::Released, ItemJnlLine."Order No.", ItemJnlLine."Routing Reference No.", ItemJnlLine."Routing No.", ItemJnlLine."Operation No.") then
                    if ProdOrderRtngLine."CCS Quality Test No." <> '' then
                        //if (QualityHeader."Test Status" <> QualityHeader."Test Status"::Certified) and (QualityHeader."Test Status" <> QualityHeader."Test Status"::"Certified Final") and (QualityHeader."Test Status" <> QualityHeader."Test Status"::"Certified with Waiver") then
                        //    Error(Txt001,ItemJnlLine."Line No.",ProdOrderRtngLine."CCS Quality Test No.");
                        if ProdOrderRtngLine."Routing Status" <> ProdOrderRtngLine."Routing Status"::Finished then
                            Error(Txt001, ItemJnlLine."Line No.", ProdOrderRtngLine."CCS Quality Test No.");
            until ItemJnlLine.Next = 0;
    end;
    */

    // Events for controlling picking lines creation, update "blocked" functionality in the lot no. information card, there is not enough events to handle it on runtime
    [EventSubscriber(ObjectType::Codeunit, 7312, 'OnCreateTempLineOnBeforeCheckReservation', '', false, false)]
    local procedure CreatePickOnBeforeCreateTempItemTrkgLines(SourceType: Integer; SourceNo: Code[20]; SourceLineNo: Integer; var QtyBaseMaxAvailToPick: Decimal; var isHandled: Boolean);
    var
        LotNoInfo: Record "Lot No. Information";
        SerialNoInfo: Record "Serial No. Information";
        SalesLine: Record "Sales Line";
    begin
        if SourceType <> Database::"Sales Line" then
            exit;

        if SalesLine.Get(SalesLine."Document Type"::Order, SourceNo, SourceLineNo) then begin
            LotNoInfo.Reset();
            LotNoInfo.SetRange("Item No.", SalesLine."No.");
            LotNoInfo.SetRange("Variant Code", SalesLine."Variant Code");
            LotNoInfo.SetFilter("Lot No.", '<>%1', '');
            LotNoInfo.SetRange("CCS Status", LotNoInfo."CCS Status"::Restricted);
            if LotNoInfo.FindSet() then
                repeat
                    LotNoInfo."CCS Temporary Blocked" := true;
                    LotNoInfo.Blocked := true;
                    LotNoInfo.Modify();
                until LotNoInfo.Next() = 0;

            SerialNoInfo.Reset();
            SerialNoInfo.SetRange("Item No.", SalesLine."No.");
            SerialNoInfo.SetRange("Variant Code", SalesLine."Variant Code");
            SerialNoInfo.SetFilter("Serial No.", '<>%1', '');
            SerialNoInfo.SetRange("CCS Status", SerialNoInfo."CCS Status"::Restricted);
            if SerialNoInfo.FindSet() then
                repeat
                    SerialNoInfo."CCS Temporary Blocked" := true;
                    SerialNoInfo.Blocked := true;
                    SerialNoInfo.Modify();
                until SerialNoInfo.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Pick", 'OnAfterCreateTempLine', '', false, false)]
    local procedure CreatePickOnAfterCreateTempLine(LocationCode: Code[10]; ToBinCode: Code[20]; ItemNo: Code[20]; VariantCode: Code[10]; UnitofMeasureCode: Code[10]; QtyPerUnitofMeasure: Decimal)
    var
        LotNoInfo: Record "Lot No. Information";
        SerialNoInfo: Record "Serial No. Information";
    begin
        LotNoInfo.Reset();
        LotNoInfo.SetRange("CCS Temporary Blocked", true);
        if LotNoInfo.FindSet() then
            repeat
                LotNoInfo.Blocked := false;
                LotNoInfo."CCS Temporary Blocked" := false;
                LotNoInfo.Modify();
            until LotNoInfo.Next() = 0;

        SerialNoInfo.Reset();
        SerialNoInfo.SetRange("CCS Temporary Blocked", true);
        if SerialNoInfo.FindSet() then
            repeat
                SerialNoInfo.Blocked := false;
                SerialNoInfo."CCS Temporary Blocked" := false;
                SerialNoInfo.Modify();
            until SerialNoInfo.Next() = 0;
    end;

    local procedure CreatePickOnAfterCreateWhseDocLine(var WarehouseActivityLine: Record "Warehouse Activity Line")
    var
        QCFunctionLibrary: Codeunit QCFunctionLibrary_PQ;
    begin
        if (WarehouseActivityLine."Source Type" <> Database::"Sales Line") and (WarehouseActivityLine."Source Subtype" <> WarehouseActivityLine."Source Subtype"::"1") then
            exit;

        QCFunctionLibrary.VerifyAndCreateQualityTestsForSalesPicking(WarehouseActivityLine);
    end;

    procedure GetSpecificationFromItemQualityRequirement(Type: Enum ItemQualityRequirement_PQ; ItemNo: Code[20]): Code[20]
    var
        ItemQualityRequirement: Record ItemQualityRequirement_PQ;
        VariantItem: Code[10];
    begin
        ItemQualityRequirement.Reset();
        ItemQualityRequirement.SetCurrentKey(Type, "Item No.", "Variant Code", "Starting Date");
        ItemQualityRequirement.SetRange(Type, Type);
        ItemQualityRequirement.SetRange("Item No.", ItemNo);
        ItemQualityRequirement.SetFilter("Starting Date", '<=%1', Today);
        if ItemQualityRequirement.FindFirst() then
            exit(ItemQualityRequirement."Specification No.");
        exit('');
    end;

    procedure GetSpecificationFromItemQualityRequirement(Type: Enum ItemQualityRequirement_PQ; ItemNo: Code[20]; VariantCode: Code[20]): Code[20]
    var
        ItemQualityRequirement: Record ItemQualityRequirement_PQ;
        VariantItem: Code[10];
    begin
        ItemQualityRequirement.Reset();
        ItemQualityRequirement.SetCurrentKey(Type, "Item No.", "Variant Code", "Starting Date");
        ItemQualityRequirement.SetRange(Type, Type);
        ItemQualityRequirement.SetRange("Item No.", ItemNo);
        ItemQualityRequirement.SetRange("Variant Code", VariantCode);
        ItemQualityRequirement.SetFilter("Starting Date", '<=%1', Today);
        if ItemQualityRequirement.FindFirst() then
            exit(ItemQualityRequirement."Specification No.");
        exit('');
    end;

    procedure GetSpecificationFromItemQualityRequirement(Type: Enum ItemQualityRequirement_PQ; ItemNo: Code[20]; VariantCode: Code[20]; LocationCode: Code[10]): Code[20]
    var
        ItemQualityRequirement: Record ItemQualityRequirement_PQ;
        SpecificationNo: Code[20];
    begin
        ItemQualityRequirement.Reset();
        ItemQualityRequirement.SetCurrentKey(Type, "Item No.", "Variant Code", "Location Code", "Starting Date", "Ending Date");
        ItemQualityRequirement.SetRange(Type, Type);
        ItemQualityRequirement.SetRange("Item No.", ItemNo);
        ItemQualityRequirement.SetRange("Variant Code", VariantCode);
        ItemQualityRequirement.SetRange("Location Code", LocationCode);
        SpecificationNo := ApplyDateFilter(ItemQualityRequirement);
        if SpecificationNo <> '' then
            exit(SpecificationNo);

        // Find again with Variant Code is blank
        ItemQualityRequirement.SetRange("Variant Code", '');
        ItemQualityRequirement.SetRange("Location Code", LocationCode);
        SpecificationNo := ApplyDateFilter(ItemQualityRequirement);
        if SpecificationNo <> '' then
            exit(SpecificationNo);

        // Find again with Location Code is blank
        ItemQualityRequirement.SetRange("Variant Code", VariantCode);
        ItemQualityRequirement.SetRange("Location Code", '');
        SpecificationNo := ApplyDateFilter(ItemQualityRequirement);
        if SpecificationNo <> '' then
            exit(SpecificationNo);

        // Find again with both Location / Variant Code are blank
        ItemQualityRequirement.SetRange("Variant Code", '');
        ItemQualityRequirement.SetRange("Location Code", '');
        SpecificationNo := ApplyDateFilter(ItemQualityRequirement);
        if SpecificationNo <> '' then
            exit(SpecificationNo);

        exit('');
    end;

    local procedure ApplyDateFilter(var ItemQltyReqt: Record ItemQualityRequirement_PQ): Code[20]
    begin
        ItemQltyReqt.SetFilter("Starting Date", '<=%1 & <>''''', Today);
        ItemQltyReqt.SetFilter("Ending Date", '>=%1 & <>''''', Today);
        if ItemQltyReqt.FindFirst() then
            exit(ItemQltyReqt."Specification No.");

        ItemQltyReqt.SetFilter("Starting Date", '<=%1 & <>''''', Today);
        ItemQltyReqt.SetFilter("Ending Date", '=''''');
        if ItemQltyReqt.FindFirst() then
            exit(ItemQltyReqt."Specification No.");

        ItemQltyReqt.SetFilter("Starting Date", '=''''');
        ItemQltyReqt.SetFilter("Ending Date", '>=%1 & <>''''', Today);
        if ItemQltyReqt.FindFirst() then
            exit(ItemQltyReqt."Specification No.");

        ItemQltyReqt.SetFilter("Starting Date", '=''''');
        ItemQltyReqt.SetFilter("Ending Date", '=''''');
        if ItemQltyReqt.FindFirst() then
            exit(ItemQltyReqt."Specification No.");

        exit('');
    end;

    [EventSubscriber(ObjectType::Codeunit, 99000835, 'OnCallItemTrackingOnBeforeItemTrackingLinesRunModal', '', false, false)]
    local procedure OnCallItemTrackingOnBeforeItemTrackingLinesRunModal(var ItemJnlLine: REcord "Item Journal Line"; var ItemTrackingLines: Page "Item Tracking Lines")
    var
        QualityTestHeader: Record QualityTestHeader_PQ;
    begin
        QualityTestHeader.Reset();
        QualityTestHeader.SetRange("Source No.", ItemJnlLine."Document No.");
        QualityTestHeader.SetRange("Multiple Tracking", true);
        if QualityTestHeader.FindSet() then begin
            QualityTestHeader.ModifyAll("Multiple Tracking", false, false);
            Commit();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 99000837, 'OnAfterCallItemTracking', '', false, false)]
    local procedure OnAfterCallItemTracking(var ProdOrderLine: Record "Prod. Order Line")
    var
        QCFunctionLibrary: Codeunit QCFunctionLibrary_PQ;
        TrackingSpecification: Record "Tracking Specification";
        ItemTrackingLines: Page "Item Tracking Lines";
        TempTrackingSpec: Record "Tracking Specification" temporary;

        QCTestHdr: Record QualityTestHeader_PQ;
        QCTestLn: Record QualityTestLines_PQ;
        QCTestHdr2: Record QualityTestHeader_PQ;
        QCTestLn2: Record QualityTestLines_PQ;
        QCSetup: Record QCSetup_PQ;
        IsInsert: Boolean;
        LotSeriaNo: Code[101];
        ProdRoutingLine: Record "Prod. Order Routing Line";
    begin
        IsInsert := false;
        QCSetup.Get();
        if QCSetup."Create QT per Item Tracking" then begin
            QCTestHdr.Reset();
            QCTestHdr.SetRange("Source Type", QCTestHdr."Source Type"::"Production Order");
            QCTestHdr.SetRange("Source No.", ProdOrderLine."Prod. Order No.");
            if QCTestHdr.FindSet() then
                repeat
                    TempTrackingSpec.RESET;
                    TempTrackingSpec.DELETEALL;

                    CLEAR(ItemTrackingLines);

                    TrackingSpecification.InitFromProdOrderLine(ProdOrderLine);
                    ItemTrackingLines.SETRECORD(TrackingSpecification);
                    ItemTrackingLines.SetSourceSpec(TrackingSpecification, ProdOrderLine."Due Date");
                    ItemTrackingLines.GetTempTrackingSpec(TempTrackingSpec);

                    if TempTrackingSpec.FindSet() then
                        repeat
                            LotSeriaNo := '';
                            QCTestHdr2.Init();
                            QCTestHdr2.TransferFields(QCTestHdr);
                            QCTestHdr2."Test No." := '';
                            QCTestHdr2."Test Qty" := TempTrackingSpec."Quantity (Base)";
                            if TempTrackingSpec."Lot No." <> '' then
                                QCTestHdr2."Lot No." := TempTrackingSpec."Lot No.";
                            if TempTrackingSpec."Serial No." <> '' then
                                QCTestHdr2."Serial No." := TempTrackingSpec."Serial No.";

                            if TempTrackingSpec."Lot No." <> '' then begin
                                LotSeriaNo := TempTrackingSpec."Lot No.";
                            end;

                            if (TempTrackingSpec."Lot No." <> '') and (TempTrackingSpec."Serial No." <> '') then
                                LotSeriaNo += ',';

                            if TempTrackingSpec."Serial No." <> '' then begin
                                LotSeriaNo += TempTrackingSpec."Serial No.";
                            end;

                            QCTestHdr2."Lot No./Serial No." := LotSeriaNo;

                            if not QCFunctionLibrary.QualityTestExistsForSalesLine2(QCTestHdr2."Source No.", QCTestHdr2."Source Line No.", QCTestHdr2."Item No.", QCTestHdr2."Lot No.", QCTestHdr2."Serial No.", QCTestHdr2."Routing No.") then begin
                                if QCTestHdr2.Insert(true) then begin
                                    ProdRoutingLine.Reset();
                                    ProdRoutingLine.SetRange(Status, ProdRoutingLine.Status::Released);
                                    ProdRoutingLine.SetRange("CCS Quality Test No.", QCTestHdr."Test No.");
                                    if ProdRoutingLine.FindSet() then
                                        repeat
                                            ProdRoutingLine."CCS Quality Test No." := QCTestHdr2."Test No.";
                                            ProdRoutingLine.Modify(false);
                                        until ProdRoutingLine.Next() = 0;


                                    IsInsert := true;
                                    QCTestLn.Reset();
                                    QCTestLn.SetRange("Test No.", QCTestHdr."Test No.");
                                    if QCTestLn.FindSet() then
                                        repeat
                                            QCTestLn2.TransferFields(QCTestLn);
                                            QCTestLn2."Test No." := QCTestHdr2."Test No.";
                                            QCTestLn2.Insert();
                                        until QCTestLn.Next() = 0;
                                    /*
                                    if TempTrackingSpec."Lot No." <> '' then
                                        if not QCFunctionLibrary.LotOrSerialNoInformationExists2(0, TempTrackingSpec) then
                                            QCFunctionLibrary.CreateLotOrSerialNoInformation2(0, TempTrackingSpec);
                                    if TempTrackingSpec."Serial No." <> '' then
                                        if not QCFunctionLibrary.LotOrSerialNoInformationExists2(1, TempTrackingSpec) then
                                            QCFunctionLibrary.CreateLotOrSerialNoInformation2(1, TempTrackingSpec);

                                    QCFunctionLibrary.BlockLotAndSerialNoInformation(TempTrackingSpec."Item No.", TempTrackingSpec."Variant Code", TempTrackingSpec."Lot No.", TempTrackingSpec."Serial No.", TempTrackingSpec."Expiration Date", true);
                                    */
                                end;
                            end else
                                IsInsert := false;

                        until TempTrackingSpec.Next() = 0;
                    if (IsInsert) and (QCTestHdr."Lot No." = '') and (QCTestHdr."Serial No." = '') then begin
                        QCTestHdr."Test Status" := QCTestHdr."Test Status"::Closed;
                        QCTestHdr.Delete(true);
                    end;

                until QCTestHdr.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnCheckAndUpdateOnAfterSetPostingFlags', '', false, false)]
    local procedure OnCheckAndUpdateOnAfterSetPostingFlags(var SalesHeader: Record "Sales Header"; var TempSalesLineGlobal: Record "Sales Line" temporary; var ModifyHeader: Boolean)
    var
        QualityTestHdr: Record QualityTestHeader_PQ;
        SalesLine: Record "Sales Line";
        Err001: Label 'The mandatory Quality Test %1 hasn''t been completed and certified.';
    begin
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange("CCS QC Required", true);
        SalesLine.SetFilter("Qty. to Ship", '<>%1', 0);
        if SalesLine.FindSet() then
            repeat
                QualityTestHdr.Reset();
                QualityTestHdr.SetRange("Source Type", QualityTestHdr."Source Type"::"Sales Order");
                QualityTestHdr.SetRange("Source No.", SalesLine."Document No.");
                QualityTestHdr.SetRange("Source Line No.", SalesLine."Line No.");
                QualityTestHdr.SetFilter("Test Status", '%1|%2|%3|%4|%5', QualityTestHdr."Test Status"::New, QualityTestHdr."Test Status"::"Ready for Testing", QualityTestHdr."Test Status"::"In-Process", QualityTestHdr."Test Status"::"Ready for Review", QualityTestHdr."Test Status"::Rejected);
                if QualityTestHdr.FindFirst() then
                    Error(Err001, QualityTestHdr."Test No.");
            until SalesLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, 6500, 'OnAfterCreateSNInformation', '', false, false)]
    local procedure ItemTrackingMgmtOnAfterCreateSNInformation(var SerialNoInfo: Record "Serial No. Information"; TrackingSpecification: Record "Tracking Specification")
    var
        Item: Record Item;
        ItemVariant: Record "Item Variant";
    begin
        if TrackingSpecification."Variant Code" = '' then begin
            if Item.Get(TrackingSpecification."Item No.") then begin
                SerialNoInfo.Validate(Description, Item.Description);
                SerialNoInfo.Modify();
            end;
        end
        else
            if ItemVariant.Get(TrackingSpecification."Item No.", TrackingSpecification."Variant Code") then begin
                SerialNoInfo.Validate(Description, ItemVariant.Description);
                SerialNoInfo.Modify();
            end;
    end;
    // BC20 END----------------------------------

#if BC19
#else
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Transfer", 'OnAfterCreateItemJnlLine', '', false, false)]
    local procedure TransferOrderPostTransferOnAfterCreateItemJnlLine(var ItemJnlLine: Record "Item Journal Line"; TransLine: Record "Transfer Line"; DirectTransHeader: Record "Direct Trans. Header"; DirectTransLine: Record "Direct Trans. Line")
    begin
        ItemJnlLine."CCS Test No." := TransLine."CCS Test No.";
    end;
#endif

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnBeforePostItemJournalLine', '', false, false)]
    local procedure TransferOrderPostReceiptOnBeforePostItemJournalLine(var ItemJournalLine: Record "Item Journal Line"; TransferLine: Record "Transfer Line"; TransferReceiptHeader: Record "Transfer Receipt Header"; TransferReceiptLine: Record "Transfer Receipt Line"; CommitIsSuppressed: Boolean; TransLine: Record "Transfer Line"; PostedWhseRcptHeader: Record "Posted Whse. Receipt Header")
    begin
        ItemJournalLine."CCS Test No." := TransferLine."CCS Test No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnAfterCreateItemJnlLine', '', false, false)]
    local procedure TransferOrderPostShipmentOnAfterCreateItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; TransferLine: Record "Transfer Line"; TransferShipmentHeader: Record "Transfer Shipment Header"; TransferShipmentLine: Record "Transfer Shipment Line")
    begin
        ItemJournalLine."CCS Test No." := TransferLine."CCS Test No.";
    end;

    [IntegrationEvent(false, false)]
    local procedure OnModifyLotOrSerialNoInformation(var LotInformation: Record "Lot No. Information"; var ItemLedgEntry: Record "Item Ledger Entry")
    begin
    end;
}
