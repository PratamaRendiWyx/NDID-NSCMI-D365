codeunit 51105 "Inventory Aging Mgt."
{
    trigger OnRun()
    var
        myInt: Integer;
    begin
        MainProcess();
    end;
    //Insert log
    procedure insertLog(iAsOfDate: Date; iSeq: Integer; iDesc: Text)
    var
        logEntries: Record "Log Entries Invt. Aging";
    begin
        Clear(logEntries);
        logEntries.Reset();
        logEntries.Init();
        logEntries.GuidID := CreateGuid();
        logEntries."As Of Date" := iAsOfDate;
        logEntries.Description := iDesc;
        logEntries."Date Time" := CurrentDateTime;
        logEntries.Sequence := iSeq;
        logEntries.Insert();
        Commit();
    end;
    //Main Process
    //Main Process With Input Parameter
    procedure MainProcess()
    var
        lastdate: Date;
        InventoryAging: Record "Inventory Aging";
        Ok: Boolean;
        SessionId: Integer;
        logEntries: Record "Log Entries Invt. Aging";
    begin
        //Reset All
        InventoryAging.Reset();
        InventoryAging.DeleteAll();
        //Reset Log 
        logEntries.Reset();
        logEntries.DeleteAll();

        LastDate := getAsOfDate();

        //  CollectInvtAgingData(lastdate, 'RMB00001');
        insertLog(LastDate, 0, 'Start Initial Process Invt. Aging - Header');
        Clear(SessionId);
        Ok := StartSession(SessionId, Codeunit::"Inventory Aging CMB");
        Clear(SessionId);
        Ok := StartSession(SessionId, Codeunit::"Inventory Aging FGB-1");
        Clear(SessionId);
        Ok := StartSession(SessionId, Codeunit::"Inventory Aging FSB-1");
        Clear(SessionId);
        Ok := StartSession(SessionId, Codeunit::"Inventory Aging RMB-1");
        Clear(SessionId);
        Ok := StartSession(SessionId, Codeunit::"Inventory Aging PMB");
        Clear(SessionId);
        Ok := StartSession(SessionId, Codeunit::"Inventory Aging SCB-1");
        Clear(SessionId);
        Ok := StartSession(SessionId, Codeunit::"Inventory Aging SMB");
        insertLog(LastDate, 0, 'End Intial Process Invt. Aging - Header');
    end;

    procedure getAsOfDate(): Date
    var
        JobCategory: Record "Job Queue Category";
        asOfDate: Date;
    begin
        Clear(asOfDate);
        asOfDate := CALCDATE('CM', Today());
        JobCategory.Reset();
        JobCategory.SetRange(Code, 'INVTAGING');
        if JobCategory.Find('-') then begin
            if JobCategory.Parameters <> '' then
                asOfDate := ConvertTextToDate(JobCategory.Parameters);
        end;
        exit(asOfDate);
    end;

    local procedure ConvertTextToDate(DateText: Text): Date
    var
        DayPart, MonthPart, YearPart : Integer;
        ConvertedDate: Date;
    begin
        if StrLen(DateText) <> 8 then
            Error('Format date must DDMMYYYY, e.g: 13102025');
        Evaluate(DayPart, CopyStr(DateText, 1, 2));
        Evaluate(MonthPart, CopyStr(DateText, 3, 2));
        Evaluate(YearPart, CopyStr(DateText, 5, 4));
        ConvertedDate := DMY2Date(DayPart, MonthPart, YearPart);
        exit(ConvertedDate);
    end;

    procedure CollectInvtAgingData(iAsofDate: Date; iItemNo: Code[20])
    var
        myInt: Integer;
        ILE: Record "Item Ledger Entry";
        ILE1: Record "Item Ledger Entry";
        ApplicationEntries: Record "Item Application Entry";
        ItemAppEntry: Record "Item Application Entry";
        Items: Record Item;
        AgingInt: Integer;
        varDocReff: Code[20];
        ILE3: Record "Item Ledger Entry";
        LotInformation: Record "Lot No. Information";
    begin
        v_asofDate := iAsofDate;

        if v_asofDate = 0D then
            v_asofDate := DMY2Date(31, 12, 9999); //MAx Date

        Clear(LotInformation);
        LotInformation.Reset();
        LotInformation.SetRange("Item No.", iItemNo);
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
            Items.SetRange("No.", iItemNo);
            Items.SetFilter("Date Filter", '<=%1', v_asofDate);
            Items.SetFilter(Inventory, '<>0');
            if Items.FindSet() then begin
                //insert aging
                InsertInvtAging(Items."No.", '');
            end;
        end;
    end;

    local procedure InsertInvtAging(iItemNo: Code[20]; iLotNo: Code[50])
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
        Clear(RowID);
        Clear(InventoryAging);
        InventoryAging.Init();

        //check detail per item | lot
        Clear(ILE);
        ILE.SetFilter("Item No.", iItemNo);
        ILE.SetFilter("Posting Date", '<=%1', v_asofDate);
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
                            RowID := CreateGuid();
                            InventoryAging.GuidID := RowID;
                            if CheckPrefix(ILE1."Document No.", 'BINV') then
                                InventoryAging."Posting Date" := ILE1."Document Date"
                            else
                                InventoryAging."Posting Date" := ILE1."Posting Date";
                            InventoryAging."Document No." := ILE1."Document No.";
                            InventoryAging.ItemNo_ := ILE1."Item No.";
                            Clear(Items);
                            Items.Get(ILE1."Item No.");
                            InventoryAging.Description := Items.Description;
                            InventoryAging.Balance := itemApplicationEntry.Quantity;
                            InventoryAging."Lot No" := ILE."Lot No.";
                            InventoryAging.Type := Format(ILE1."Entry Type");

                            //Init
                            InventoryAging.Aging1 := 0;
                            InventoryAging.Aging2 := 0;
                            InventoryAging.Aging3 := 0;
                            InventoryAging.Aging4 := 0;
                            InventoryAging.Aging5 := 0;
                            Clear(InventoryAging."Date Doc. Reff");
                            Clear(InventoryAging."Document Reff No.");
                            Clear(InventoryAging."Date Doc. Reff");
                            //-end of init

                            //Check Aging 
                            Clear(AgingInt);
                            AgingInt := CalculateDaysBetweenDates(InventoryAging."Posting Date", v_asofDate);
                            if AgingInt <= 90 then
                                InventoryAging.Aging1 := itemApplicationEntry.Quantity;
                            if (AgingInt > 90) AND (AgingInt <= 180) then
                                InventoryAging.Aging2 := itemApplicationEntry.Quantity;
                            if (AgingInt > 180) AND (AgingInt <= 270) then
                                InventoryAging.Aging3 := itemApplicationEntry.Quantity;
                            if (AgingInt > 270) AND (AgingInt <= 360) then
                                InventoryAging.Aging4 := itemApplicationEntry.Quantity;
                            if AgingInt > 360 then
                                InventoryAging.Aging5 := itemApplicationEntry.Quantity;
                            InventoryAging.InventoryPostingGroup := Items."Inventory Posting Group";
                            InventoryAging."Orig Doc. No" := ILE."Document No.";
                            InventoryAging."Item Ledger Entry No." := ILE."Entry No.";
                            InventoryAging."Inbound Entry No." := ILE1."Entry No.";
                            InventoryAging.Insert();
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
                    itemApplicationEntry2.SetRange("Item Ledger Entry No.", CurrTempEntryNo);
                    itemApplicationEntry2.SetRange("Item No.", iItemNo);
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

    var
        v_asofDate: Date;
        RowID: Guid;
        CurrReportPageNoCaptionLbl: Label 'Page';
        v_itemNo: Code[20];

        glbGUID: Guid;
}
