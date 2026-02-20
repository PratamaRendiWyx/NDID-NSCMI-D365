namespace ACCOUNTING.ACCOUNTING;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Tracking;
using Microsoft.Inventory.Item;

report 51104 "Inventory Aging Detail"
{

    DefaultLayout = RDLC;
    RDLCLayout = './ReportDesign/Inventory Aging DetailV3.rdlc';
    AdditionalSearchTerms = 'invtaging,aging,Inventory Aging';
    ApplicationArea = Manufacturing;
    Caption = 'Inventory Aging Detail';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(InventoryAgingTempFT; "Inventory Aging Temp FT")
        {
            DataItemTableView = sorting(ItemNo_, "Posting Date", "Document No.");
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(RowID; RowID) { }
            column(Posting_Date; Format("Posting Date", 0, '<Day,2> <Month Text,3> <Year4>')) { }
            column(AsOfDate; Format(v_asofDate, 0, '<Day,2> <Month Text,3> <Year4>')) { }
            column(Document_No_; "Document No.") { }
            column(ItemNo_; ItemNo_) { }
            column(Description; Description) { }
            column(Balance; Balance) { }
            column(Type; Type) { }
            column(Aging1; Aging1) { }
            column(Aging2; Aging2) { }
            column(Aging3; Aging3) { }
            column(Aging4; Aging4) { }
            column(Aging5; Aging5) { }
            column(InventoryPostingGroup; InventoryPostingGroup) { }
            column(Lot_No; "Lot No") { }
            column(CompanyName; COMPANYPROPERTY.DisplayName())
            {
            }
            column(Document_Reff_No_; "Document Reff No.") { }
            column(Date_Doc__Reff; Format("Date Doc. Reff")) { }
            column(Orig_Doc__No; "Orig Doc. No") { }
            column(Item_Ledger_Entry_No_; "Item Ledger Entry No.") { }
            column(Inbound_Entry_No_; "Inbound Entry No.") { }
            column(Is_Tracking; "Is Tracking Code (?)")
            {

            }
        }
    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(v_asofDate; v_asofDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'As of Date';
                    }
                    field(v_itemNo; v_itemNo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Item No.';
                        // TableRelation = Item."No.";
                        trigger OnLookup(Var Text: Text): Boolean
                        var
                            Item: Record Item;
                            ItemList: page "Item List";
                            XData: Record Item;
                        begin
                            Clear(ItemList);
                            Clear(Item);
                            ItemList.SetRecord(XData);
                            ItemList.SetTableView(XData);
                            ItemList.LookupMode := true;
                            if ItemList.RunModal() = Action::LookupOK then begin
                                ItemList.SetSelectionFilter(Item);
                                if Item.FindSet() then begin
                                    v_itemNo := Item."No.";
                                end;
                            end;
                        end;
                    }
                }
            }
        }

        actions
        {
            area(Processing)
            {
            }
        }
    }

    trigger OnInitReport()
    var
        myInt: Integer;
    begin
        v_asofDate := 0D;
    end;

    trigger OnPreReport()
    var
        myInt: Integer;
        ILE: Record "Item Ledger Entry";
        ILE1: Record "Item Ledger Entry";
        ApplicationEntries: Record "Item Application Entry";
        TempData: Text;
        CurrData: Text;
        ItemAppEntry: Record "Item Application Entry";
        Items: Record Item;
        AgingInt: Integer;
        itemApplicationEntry: Record "Item Application Entry";
        itemApplicationEntry2: Record "Item Application Entry"; // for data correction, check inbound from outbound entry
        varDocReff: Code[20];
        ILE3: Record "Item Ledger Entry";
        InboundOrig: Integer;
        CurrDat: Text;
        TempDat: Text;
        ILESum: Record "Item Ledger Entry";
        LotInformation: Record "Lot No. Information";
    begin
        Clear(RowID);
        InventoryAgingTempFT.Reset();
        InventoryAgingTempFT.DeleteAll();
        InventoryAgingTempFT.Init();

        Clear(CurrData);
        Clear(TempData);

        if v_asofDate = 0D then
            v_asofDate := DMY2Date(31, 12, 9999); //MAx Date

        RowID := RowID + 1;

        LotInformation.Reset();
        if v_itemNo <> '' then
            LotInformation.SetFilter("Item No.", v_itemNo);
        LotInformation.SetFilter("Date Filter", '<=%1', v_asofDate);
        LotInformation.SETFILTER("Lot No.", '<>''''');
        LotInformation.SetFilter(Inventory1, '<>0');
        if LotInformation.FindSet() then begin
            repeat
                //insert aging
                InsertInvtAging(LotInformation."Item No.", LotInformation."Lot No.");
            until LotInformation.Next() = 0;
        end else begin // lot does not exists
            Clear(Items);
            Items.Reset();
            Items.SetRange("No.", v_itemNo);
            Items.SetFilter("Date Filter", '<=%1', v_asofDate);
            Items.SetFilter(Inventory, '<>0');
            if Items.FindSet() then begin
                //insert aging
                insertinvtagingNonTracking(Items."No.", '');
            end;
        end;
    end;

    local procedure insertinvtaging(iItemNo: Code[20]; iLotNo: Code[50])
    var
        ILE: Record "Item Ledger Entry";
        ILE1: Record "Item Ledger Entry";
        itemApplicationEntry: Record "Item Application Entry";
        itemApplicationEntry2: Record "Item Application Entry"; // for data correction, check inbound from outbound entry
        InboundOrig: Integer;
        InventoryAging: Record "Inventory Aging";
        Items: Record Item;
        AgingInt: Integer;
    begin
        //check detail per item | lot
        Clear(ILE);
        ILE.Reset();
        ILE.SetFilter("Posting Date", '<=%1', v_asofDate);
        ILE.SetRange("Item No.", iItemNo);
        if iLotNo <> '' then
            ILE.SetRange("Lot No.", iLotNo);
        ILE.SetCurrentKey("Item No.", "Posting Date", "Entry Type", "Document No.", "Lot No.", "Document Type", Quantity, "Entry No.");
        if ILE.FindSet() then begin
            repeat
                //check inbound or date receive 
                Clear(itemApplicationEntry);
                itemApplicationEntry.Reset();
                itemApplicationEntry.SetRange("Item Ledger Entry No.", ILE."Entry No.");
                if itemApplicationEntry.FindSet() then begin
                    repeat
                        Clear(InboundOrig);
                        InboundOrig := findInbonOrig(ILE."Item No.", ILE."Lot No.");
                        Clear(ILE1);
                        ILE1.Reset();
                        ILE1.SetRange("Entry No.", InboundOrig);
                        ILE1.SetCurrentKey("Posting Date");
                        if ILE1.FindSet() then begin
                            RowID := RowID + 1;
                            InventoryAgingTempFT.RowID := RowID;
                            if CheckPrefix(ILE1."Document No.", 'BINV') then
                                InventoryAgingTempFT."Posting Date" := ILE1."Document Date"
                            else
                                InventoryAgingTempFT."Posting Date" := ILE1."Posting Date";
                            InventoryAgingTempFT."Document No." := ILE1."Document No.";
                            InventoryAgingTempFT.ItemNo_ := ILE1."Item No.";
                            Clear(Items);
                            Items.Get(ILE1."Item No.");
                            InventoryAgingTempFT.Description := Items.Description;
                            InventoryAgingTempFT.Balance := itemApplicationEntry.Quantity;
                            InventoryAgingTempFT."Lot No" := ILE."Lot No.";
                            InventoryAgingTempFT.Type := Format(ILE1."Entry Type");

                            //Init
                            InventoryAgingTempFT.Aging1 := 0;
                            InventoryAgingTempFT.Aging2 := 0;
                            InventoryAgingTempFT.Aging3 := 0;
                            InventoryAgingTempFT.Aging4 := 0;
                            InventoryAgingTempFT.Aging5 := 0;
                            Clear(InventoryAgingTempFT."Date Doc. Reff");
                            Clear(InventoryAgingTempFT."Document Reff No.");
                            Clear(InventoryAgingTempFT."Date Doc. Reff");
                            //-end of init

                            //Check Aging 
                            Clear(AgingInt);
                            AgingInt := CalculateDaysBetweenDates(InventoryAgingTempFT."Posting Date", v_asofDate);
                            if AgingInt <= 90 then
                                InventoryAgingTempFT.Aging1 := itemApplicationEntry.Quantity;
                            if (AgingInt > 90) AND (AgingInt <= 180) then
                                InventoryAgingTempFT.Aging2 := itemApplicationEntry.Quantity;
                            if (AgingInt > 180) AND (AgingInt <= 270) then
                                InventoryAgingTempFT.Aging3 := itemApplicationEntry.Quantity;
                            if (AgingInt > 270) AND (AgingInt <= 360) then
                                InventoryAgingTempFT.Aging4 := itemApplicationEntry.Quantity;
                            if AgingInt > 360 then
                                InventoryAgingTempFT.Aging5 := itemApplicationEntry.Quantity;
                            InventoryAgingTempFT.InventoryPostingGroup := Items."Inventory Posting Group";
                            InventoryAgingTempFT."Orig Doc. No" := ILE."Document No.";
                            InventoryAgingTempFT."Item Ledger Entry No." := ILE."Entry No.";
                            InventoryAgingTempFT."Inbound Entry No." := ILE1."Entry No.";
                            InventoryAgingTempFT."Is Tracking Code (?)" := true;
                            InventoryAgingTempFT.Insert();
                        end;
                    until itemApplicationEntry.Next() = 0;
                end;
            until ILE.Next() = 0;
        end;
    end;


    local procedure insertinvtagingNonTracking(iItemNo: Code[20]; iLotNo: Code[50])
    var
        ILE: Record "Item Ledger Entry";
        ILE1: Record "Item Ledger Entry";
        itemApplicationEntry: Record "Item Application Entry";
        itemApplicationEntry2: Record "Item Application Entry"; // for data correction, check inbound from outbound entry
        InboundOrig: Integer;
        InventoryAging: Record "Inventory Aging";
        Items: Record Item;
        AgingInt: Integer;
    begin
        //check detail per item | lot
        Clear(ILE);
        ILE.Reset();
        ILE.SetFilter("Posting Date", '<=%1', v_asofDate);
        ILE.SetRange("Item No.", iItemNo);
        if iLotNo <> '' then
            ILE.SetRange("Lot No.", iLotNo);
        ILE.SetCurrentKey("Item No.", "Posting Date", "Entry Type", "Document No.", "Lot No.", "Document Type", Quantity, "Entry No.");
        if ILE.FindSet() then begin
            repeat
                //check inbound or date receive 
                Clear(itemApplicationEntry);
                itemApplicationEntry.Reset();
                itemApplicationEntry.SetRange("Item Ledger Entry No.", ILE."Entry No.");
                if itemApplicationEntry.FindSet() then begin
                    repeat
                        Clear(InboundOrig);
                        InboundOrig := itemApplicationEntry."Inbound Item Entry No."; //findInbonOrig(ILE."Item No.", ILE."Lot No.");
                        Clear(ILE1);
                        ILE1.Reset();
                        ILE1.SetRange("Entry No.", InboundOrig);
                        //ILE1.SetFilter("Entry Type", '%1|%2', ILE1."Entry Type"::"Positive Adjmt.", ILE1."Entry Type"::Purchase);
                        ILE1.SetCurrentKey("Posting Date");
                        if ILE1.FindSet() then begin
                            RowID := RowID + 1;
                            InventoryAgingTempFT.RowID := RowID;
                            if CheckPrefix(ILE1."Document No.", 'BINV') then
                                InventoryAgingTempFT."Posting Date" := ILE1."Document Date"
                            else
                                InventoryAgingTempFT."Posting Date" := ILE1."Posting Date";
                            InventoryAgingTempFT."Document No." := ILE1."Document No.";
                            InventoryAgingTempFT.ItemNo_ := ILE1."Item No.";
                            Clear(Items);
                            Items.Get(ILE1."Item No.");
                            InventoryAgingTempFT.Description := Items.Description;
                            InventoryAgingTempFT.Balance := itemApplicationEntry.Quantity;
                            InventoryAgingTempFT."Lot No" := ILE."Lot No.";
                            InventoryAgingTempFT.Type := Format(ILE1."Entry Type");

                            //Init
                            InventoryAgingTempFT.Aging1 := 0;
                            InventoryAgingTempFT.Aging2 := 0;
                            InventoryAgingTempFT.Aging3 := 0;
                            InventoryAgingTempFT.Aging4 := 0;
                            InventoryAgingTempFT.Aging5 := 0;
                            Clear(InventoryAgingTempFT."Date Doc. Reff");
                            Clear(InventoryAgingTempFT."Document Reff No.");
                            Clear(InventoryAgingTempFT."Date Doc. Reff");
                            //-end of init

                            //Check Aging 
                            Clear(AgingInt);
                            AgingInt := CalculateDaysBetweenDates(InventoryAgingTempFT."Posting Date", v_asofDate);
                            if AgingInt <= 90 then
                                InventoryAgingTempFT.Aging1 := itemApplicationEntry.Quantity;
                            if (AgingInt > 90) AND (AgingInt <= 180) then
                                InventoryAgingTempFT.Aging2 := itemApplicationEntry.Quantity;
                            if (AgingInt > 180) AND (AgingInt <= 270) then
                                InventoryAgingTempFT.Aging3 := itemApplicationEntry.Quantity;
                            if (AgingInt > 270) AND (AgingInt <= 360) then
                                InventoryAgingTempFT.Aging4 := itemApplicationEntry.Quantity;
                            if AgingInt > 360 then
                                InventoryAgingTempFT.Aging5 := itemApplicationEntry.Quantity;
                            InventoryAgingTempFT.InventoryPostingGroup := Items."Inventory Posting Group";
                            InventoryAgingTempFT."Orig Doc. No" := ILE."Document No.";
                            InventoryAgingTempFT."Item Ledger Entry No." := ILE."Entry No.";
                            InventoryAgingTempFT."Inbound Entry No." := ILE1."Entry No.";
                            InventoryAgingTempFT."Is Tracking Code (?)" := false;
                            InventoryAgingTempFT.Insert();
                        end;
                    until itemApplicationEntry.Next() = 0;
                end;
            until ILE.Next() = 0;
        end;
    end;


    procedure CheckPrefix(myString: Text; prefix: Text): Boolean
    begin
        if myString.StartsWith(prefix) then
            exit(true)
        else
            exit(false);
    end;

    local procedure findInbonOrig(iItemNo: Text; iLotNo: Text) OInboundEntryNo: Integer
    var
        itemApplicationEntry: Record "Item Application Entry";
        itemApplicationEntry2: Record "Item Application Entry";
        itemApplicationEntry3: Record "Item Application Entry";
        CurrTempEntryNo: Integer;
        CurrTempLot: Text;
        Check: Boolean;
    begin
        OInboundEntryNo := -1;
        Clear(itemApplicationEntry);
        itemApplicationEntry.Reset();
        itemApplicationEntry.SetRange("Item No.", iItemNo);
        itemApplicationEntry.SetRange("Lot No", iLotNo);
        itemApplicationEntry.SetCurrentKey("Item Ledger Entry No.");
        itemApplicationEntry.SetAutoCalcFields("Item No.", "Lot No");
        if itemApplicationEntry.FindFirst() then begin
            if itemApplicationEntry."Outbound Item Entry No." = 0 then begin
                // OInboundEntryNo := itemApplicationEntry."Item Ledger Entry No.";
                Clear(itemApplicationEntry3);
                itemApplicationEntry3.Reset();
                itemApplicationEntry3.SetRange("Item No.", iItemNo);
                itemApplicationEntry3.SetRange("Lot No", iLotNo);
                itemApplicationEntry3.SetRange("Outbound Item Entry No.", 0);
                itemApplicationEntry3.SetCurrentKey("Item Ledger Entry No.");
                // itemApplicationEntry3.SetAscending("Item Ledger Entry No.", false);
                itemApplicationEntry3.SetAutoCalcFields("Item No.", "Lot No");
                if itemApplicationEntry3.FindFirst() then
                    OInboundEntryNo := itemApplicationEntry3."Item Ledger Entry No.";
            end
            else begin
                Clear(CurrTempEntryNo);
                CurrTempEntryNo := itemApplicationEntry."Transferred-from Entry No.";
                Check := true;
                while Check do begin
                    Clear(itemApplicationEntry2);
                    itemApplicationEntry2.Reset();
                    itemApplicationEntry2.SetRange("Item No.", iItemNo);
                    itemApplicationEntry2.SetRange("Item Ledger Entry No.", CurrTempEntryNo);
                    itemApplicationEntry2.SetCurrentKey("Item Ledger Entry No.");
                    itemApplicationEntry2.SetAutoCalcFields("Item No.");
                    if itemApplicationEntry2.FindFirst() then begin
                        if itemApplicationEntry2."Outbound Item Entry No." <> 0 then
                            CurrTempEntryNo := itemApplicationEntry2."Transferred-from Entry No."
                        else begin
                            Check := false;
                            CurrTempEntryNo := itemApplicationEntry2."Item Ledger Entry No.";
                            OInboundEntryNo := CurrTempEntryNo;
                        end;
                    end
                end;
            end;
        end;
    end;


    local procedure CalculateDaysBetweenDates(StartDate: Date; EndDate: Date): Integer
    var
        TotalDays: Integer;
    begin
        Clear(TotalDays);
        TotalDays := EndDate - StartDate;
        exit(TotalDays);
    end;

    local procedure getInfoInbound(var iItemLedgerEntry: Record "Item Ledger Entry"; iItemLedgerEntryNo: Integer)
    var
        itemApplicationEntry: Record "Item Application Entry";
        ILE: Record "Item Ledger Entry";
    begin

    end;

    var
        v_asofDate: Date;
        RowID: Integer;

        CurrReportPageNoCaptionLbl: Label 'Page';
        v_itemNo: Code[20];
}
