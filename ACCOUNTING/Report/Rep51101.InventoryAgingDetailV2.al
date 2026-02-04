namespace ACCOUNTING.ACCOUNTING;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Item;

report 51101 "Inventory Aging Detail V2"
{

    DefaultLayout = RDLC;
    RDLCLayout = './ReportDesign/Inventory Aging DetailV2.rdlc';
    AdditionalSearchTerms = 'invtaging,aging,Inventory Aging';
    ApplicationArea = Manufacturing;
    Caption = 'Inventory Aging Detail V2';
    // UsageCategory = ReportsAndAnalysis;
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
                        TableRelation = Item."No.";
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

        Clear(ILE);
        // ILE.SetRange("Posting Date", 0D, v_asofDate);
        ILE.SetFilter("Posting Date", '<=%1', v_asofDate);
        // ILE.SetFilter("Entry Type", '<>%1', ILE."Entry Type"::Transfer);
        if v_itemNo <> '' then
            ILE.SetFilter("Item No.", v_itemNo);
        ILE.SetCurrentKey("Item No.", "Posting Date", "Entry Type", "Document No.", "Lot No.", "Document Type", Quantity, "Entry No.");
        ILE.Ascending;
        if ILE.FindSet() then begin
            repeat
                //check inbound or date receive 
                Clear(itemApplicationEntry);
                itemApplicationEntry.SetRange("Item Ledger Entry No.", ILE."Entry No.");
                if itemApplicationEntry.FindSet() then begin
                    repeat
                        //Check condition, Correction or Not 
                        if Not ILE.Correction then begin
                            //-start
                            Clear(ILE1);
                            ILE1.SetRange("Entry No.", itemApplicationEntry."Inbound Item Entry No.");
                            ILE1.SetCurrentKey("Posting Date");
                            ILE1.Ascending;
                            if ILE1.FindSet() then begin
                                RowID := RowID + 1;
                                InventoryAgingTempFT.RowID := RowID;
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
                                Clear(InventoryAgingTempFT.Type);
                                //-end of init

                                //Check Aging 
                                Clear(AgingInt);
                                AgingInt := CalculateDaysBetweenDates(ILE1."Posting Date", v_asofDate);
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
                                InventoryAgingTempFT.Insert();
                            end;
                            //-end
                        end else begin
                            //Correction 
                            //-start
                            Clear(ILE1);
                            ILE1.SetRange("Entry No.", itemApplicationEntry."Inbound Item Entry No.");
                            ILE1.SetCurrentKey("Posting Date");
                            ILE1.Ascending;
                            if ILE1.FindSet() then begin
                                RowID := RowID + 1;
                                InventoryAgingTempFT.RowID := RowID;
                                InventoryAgingTempFT."Posting Date" := ILE1."Posting Date";
                                InventoryAgingTempFT."Document No." := ILE1."Document No.";
                                InventoryAgingTempFT.ItemNo_ := ILE1."Item No.";
                                Clear(Items);
                                Items.Get(ILE1."Item No.");
                                InventoryAgingTempFT.Description := Items.Description;
                                InventoryAgingTempFT.Balance := itemApplicationEntry.Quantity;
                                InventoryAgingTempFT."Lot No" := ILE."Lot No.";

                                //Init
                                InventoryAgingTempFT.Aging1 := 0;
                                InventoryAgingTempFT.Aging2 := 0;
                                InventoryAgingTempFT.Aging3 := 0;
                                InventoryAgingTempFT.Aging4 := 0;
                                InventoryAgingTempFT.Aging5 := 0;
                                Clear(InventoryAgingTempFT."Date Doc. Reff");
                                Clear(InventoryAgingTempFT."Document Reff No.");
                                Clear(InventoryAgingTempFT.Type);
                                //-end of init

                                //get document refference
                                Clear(itemApplicationEntry2);
                                itemApplicationEntry2.Reset();
                                itemApplicationEntry2.SetRange("Item Ledger Entry No.", itemApplicationEntry."Outbound Item Entry No.");
                                if itemApplicationEntry2.FindSet() then begin
                                    Clear(ILE3);
                                    ILE3.SetRange("Entry No.", itemApplicationEntry2."Inbound Item Entry No.");
                                    if ILE3.FindSet() then begin
                                        InventoryAgingTempFT."Date Doc. Reff" := ILE3."Posting Date";
                                        InventoryAgingTempFT."Document Reff No." := ILE3."Document No.";
                                        InventoryAgingTempFT.Type := Format(ILE3."Entry Type");
                                        //Check Aging 
                                        Clear(AgingInt);
                                        AgingInt := CalculateDaysBetweenDates(ILE3."Posting Date", v_asofDate);
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
                                    end;
                                end;
                                //-
                                InventoryAgingTempFT.InventoryPostingGroup := Items."Inventory Posting Group";
                                InventoryAgingTempFT."Orig Doc. No" := ILE."Document No.";
                                InventoryAgingTempFT."Item Ledger Entry No." := ILE."Entry No.";
                                InventoryAgingTempFT."Inbound Entry No." := ILE1."Entry No.";
                                InventoryAgingTempFT.Insert();
                            end;
                            //-end
                        end;
                    until itemApplicationEntry.Next() = 0;
                end;
            until ILE.Next() = 0;
        end;
    end;

    local procedure checkApplyCorrection(iEntryNo: Integer): Boolean
    var
        ItemLedger: Record "Item Ledger Entry";
    begin
        Clear(ItemLedger);
        ItemLedger.SetRange(Correction, true);
        ItemLedger.SetRange("Applies-to Entry", iEntryNo);
        if ItemLedger.Find('-') then begin
            exit(true);
        end;
        exit(false);
    end;

    /*
    Sales Shipment
    Purchase Return Shipment
    Transfer Shipment
    */
    local procedure CheckUndoProcessBaseOnOutboundEntry(iEntryNo: Integer): Boolean
    var
        ApplicationEntry: Record "Item Application Entry";
    begin
        Clear(ApplicationEntry);
        ApplicationEntry.SetRange("Outbound Item Entry No.", iEntryNo);
        if ApplicationEntry.Count() > 1 then
            exit(true);
        exit(false);
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
