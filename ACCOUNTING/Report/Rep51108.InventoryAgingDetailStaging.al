namespace ACCOUNTING.ACCOUNTING;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Item;

report 51108 "Inventory Aging Detail Stag."
{

    DefaultLayout = RDLC;
    RDLCLayout = './ReportDesign/Inventory Aging Detail Staging.rdlc';
    AdditionalSearchTerms = 'invtaging,aging,Inventory Aging';
    ApplicationArea = Manufacturing;
    Caption = 'Inventory Aging Detail (Staging)';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(InventoryAgingTempFT; "Inventory Aging")
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
            column(Aging1; getAging(1)) { }
            column(Aging2; getAging(2)) { }
            column(Aging3; getAging(3)) { }
            column(Aging4; getAging(4)) { }
            column(Aging5; getAging(5)) { }
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

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin

                if v_asofDate = 0D then
                    v_asofDate := DMY2Date(31, 12, 9999); //MAx Date
                if v_itemNo <> '' then
                    SetFilter(ItemNo_, v_itemNo);
                SetFilter("Posting Date", '<=%1', v_asofDate);
            end;

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

    local procedure getAging(iAgingIndex: Integer): Decimal
    var
        AgingInt: Integer;
    begin
        Clear(AgingInt);
        AgingInt := CalculateDaysBetweenDates(InventoryAgingTempFT."Posting Date", v_asofDate);
        case iAgingIndex of
            1:
                begin
                    if AgingInt <= 90 then
                        exit(InventoryAgingTempFT.Balance);
                end;
            2:
                begin
                    if (AgingInt > 90) AND (AgingInt <= 180) then
                        exit(InventoryAgingTempFT.Balance);
                end;
            3:
                begin
                    if (AgingInt > 180) AND (AgingInt <= 270) then
                        exit(InventoryAgingTempFT.Balance);
                end;
            4:
                begin
                    if (AgingInt > 270) AND (AgingInt <= 360) then
                        exit(InventoryAgingTempFT.Balance);
                end;
            5:
                begin
                    if AgingInt > 360 then
                        exit(InventoryAgingTempFT.Balance);
                end;
        end;
        exit(0);
    end;

    local procedure CalculateDaysBetweenDates(StartDate: Date;
    EndDate:
        Date):
            Integer
    var
        TotalDays: Integer;
    begin
        Clear(TotalDays);
        TotalDays := EndDate - StartDate;
        exit(TotalDays);
    end;

    var
        v_asofDate: Date;
        RowID: Integer;

        CurrReportPageNoCaptionLbl: Label 'Page';
        v_itemNo: Text;
}
