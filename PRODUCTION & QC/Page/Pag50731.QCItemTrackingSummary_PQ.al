page 50731 QCItemTrackingSummary_PQ
{
    // version NAVW111.00,QC11.02

    // //QC11.01
    //   - Created from QC-Modified NAV Page 6500. Unmodifed P 6500 placed back into DB
    //     - Changed Local Var. "ItemTrackingSummaryForm" in Func "AssistEditTrackingNo" in CU 14004595 to point to this Page instead of Page 6500

    Caption = 'Item Tracking Summary';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = "Entry Summary";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the lot number for which availability is presented in the Item Tracking Summary window.';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the serial number for which availability is presented in the Item Tracking Summary window.';
                }
                field("Warranty Date"; Rec."Warranty Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the warranty expiration date, if any, of the item carrying the item tracking number.';
                    Visible = false;
                }
                field("QC Option"; Rec."QC Option")
                {
                    ToolTip = '"Indicates the QC option for this Item Tracking Specification (Customer or Company) "';
                    ApplicationArea = All;
                }
                field("QC Specs Exist"; Rec."QC Specs Exist")
                {
                    Caption = 'Item Specs Exist';
                    ToolTip = 'Indicates if Item Specifications exist for the Item in this Item Tracking';
                    ApplicationArea = All;
                }
                field("QC Test Exists"; Rec."QC Test Exists")
                {
                    Caption = 'Item Test Exists';
                    ToolTip = 'Indicates if Quality Test exists for the Item in this Item Tracking Summary';
                    ApplicationArea = All;
                }
                field("Cust Specs Exist"; Rec."Cust Specs Exist")
                {
                    ToolTip = 'Indicates if Customer Specifications exist for the Item in this Item Tracking';
                    ApplicationArea = All;
                }
                field("Cust Test Exists"; Rec."Cust Test Exists")
                {
                    ToolTip = 'Indicates if Customer Test exists for the Item in this Item Tracking';
                    ApplicationArea = All;
                }
                field("Item Test Non Compliant"; Rec."Item Test Non Compliant")
                {
                    ToolTip = 'This field is flagged when the Item Test for this Item Tracking was non-compliant';
                    ApplicationArea = All;
                }
                field("Cust Test Non Compliant"; Rec."Cust Test Non Compliant")
                {
                    ToolTip = 'This field is flagged when the Customer Test for this Item Tracking was non-compliant';
                    ApplicationArea = All;
                }
                field("QC Compliance"; Rec."QC Compliance")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the expiration date, if any, of the item carrying the item tracking number.';
                    Visible = false;
                }
                field("Total Quantity"; Rec."Total Quantity")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    Editable = false;
                    ToolTip = 'Specifies the total quantity of the item in inventory.';

                    trigger OnDrillDown();
                    begin
                        DrillDownEntries(Rec.FIELDNO("Total Quantity"));
                    end;
                }
                field("Total Requested Quantity"; Rec."Total Requested Quantity")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    Editable = false;
                    ToolTip = 'Specifies the total quantity of the lot or serial number that is requested in all documents.';

                    trigger OnDrillDown();
                    begin
                        DrillDownEntries(Rec.FIELDNO("Total Requested Quantity"));
                    end;
                }
                field("Current Pending Quantity"; Rec."Current Pending Quantity")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the quantity from the item tracking line that is selected on the document but not yet committed to the database.';
                }
                field("Total Available Quantity"; Rec."Total Available Quantity")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the quantity available for the user to request, in entries of the type on the line.';
                }
                field("Current Reserved Quantity"; Rec."Current Reserved Quantity")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the quantity of items in the entry that are reserved for the line that the Reservation window is opened from.';
                    Visible = false;
                }
                field("Total Reserved Quantity"; Rec."Total Reserved Quantity")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the total quantity of the relevant item that is reserved on documents or entries of the type on the line.';
                    Visible = false;
                }
                field("Bin Content"; Rec."Bin Content")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the quantity of the item in the bin specified in the document line.';
                    Visible = BinContentVisible;

                    trigger OnDrillDown();
                    begin
                        DrillDownBinContent(Rec.FIELDNO("Bin Content"));
                    end;
                }
                field("Selected Quantity"; Rec."Selected Quantity")
                {
                    ApplicationArea = All;
                    Editable = SelectedQuantityEditable;
                    Style = Strong;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the quantity of each lot or serial number that you want to use to fulfill the demand for the transaction.';
                    Visible = SelectedQuantityVisible;

                   trigger OnValidate();
                    begin
                        SelectedQuantityOnAfterValidate();
                    end; 
                }
            }
            group(Control50)
            {
                fixed(Control1901775901)
                {
                    group(Selectable)
                    {
                        Caption = 'Selectable';
                        Visible = MaxQuantity1Visible;
                        field(MaxQuantity1; MaxQuantity)
                        {
                            ApplicationArea = All;
                            Caption = 'Selectable';
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                            ToolTip = 'Specifies the value from the Undefined field on the Item Tracking Lines window. This value indicates how much can be selected.';
                        }
                    }
                    group(Selected)
                    {
                        Caption = 'Selected';
                        Visible = Selected1Visible;
                        field(Selected1; SelectedQuantity)
                        {
                            ApplicationArea = All;
                            Caption = 'Selected';
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                            ToolTip = 'Specifies the sum of the quantity that you have selected. It Specifies a total of the quantities in the Selected Quantity fields.';
                        }
                    }
                    group(Undefined)
                    {
                        Caption = 'Undefined';
                        Visible = Undefined1Visible;
                        field(Undefined1; MaxQuantity - SelectedQuantity)
                        {
                            ApplicationArea = All;
                            BlankZero = true;
                            Caption = 'Undefined';
                            DecimalPlaces = 2 : 5;
                            Editable = false;
                            ToolTip = 'Specifies the difference between the quantity that can be selected for the document line, and the quantity selected in this window.';
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Quality ")
            {
                Caption = '"&Quality "';
                action("QCItemNoSpecs")
                {
                    Caption = 'Item No. Specs';
                    Image = Design;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = All;
                }
                action("QCLotSerialNoTests")
                {
                    Caption = 'Lot/Serial No. &Tests';
                    Image = Design;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = All;
                }
                action("QCComplianceList")
                {
                    Caption = 'Get Quality Compliance List';
                    Image = ViewWorksheet;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        UpdateIfFiltersHaveChanged;
    end; 

    trigger OnInit();
    begin
        Undefined1Visible := true;
        Selected1Visible := true;
        MaxQuantity1Visible := true;
        BinContentVisible := true;
    end;

    trigger OnOpenPage();
    begin
        UpdateSelectedQuantity;

        BinContentVisible := CurrBinCode <> '';
    end; 

    var
        CurrItemTrackingCode: Record "Item Tracking Code";
        TempReservEntry: Record "Reservation Entry" temporary;
        xFilterRec: Record "Entry Summary";
        ItemTrackingDataCollection: Codeunit "Item Tracking Data Collection";
        MaxQuantity: Decimal;
        SelectedQuantity: Decimal;
        CurrBinCode: Code[20];
        [InDataSet]
        SelectedQuantityVisible: Boolean;
        [InDataSet]
        BinContentVisible: Boolean;
        [InDataSet]
        MaxQuantity1Visible: Boolean;
        [InDataSet]
        Selected1Visible: Boolean;
        [InDataSet]
        Undefined1Visible: Boolean;
        [InDataSet]
        SelectedQuantityEditable: Boolean;

    [Scope('cloud')]
    procedure SetSources(var ReservEntry: Record "Reservation Entry"; var EntrySummary: Record "Entry Summary");
    var
        xEntrySummary: Record "Entry Summary";
    begin
        TempReservEntry.RESET;
        TempReservEntry.DELETEALL;
        if ReservEntry.FIND('-') then
            repeat
                TempReservEntry := ReservEntry;
                TempReservEntry.INSERT;
            until ReservEntry.NEXT = 0;

        xEntrySummary.SETVIEW(Rec.GETVIEW);
        xEntrySummary.RESET;
        xEntrySummary.DELETEALL;
        if EntrySummary.FINDSET then
            repeat
                if EntrySummary.HasQuantity then begin
                    Rec := EntrySummary;
                    EntrySummary.INSERT;
                end;
            until EntrySummary.NEXT = 0;
        Rec.SETVIEW(xEntrySummary.GETVIEW);
        UpdateSelectedQuantity;
    end;

    [Scope('cloud')]
    procedure SetSelectionMode(SelectionMode: Boolean);
    begin
        SelectedQuantityVisible := SelectionMode;
        SelectedQuantityEditable := SelectionMode;
        MaxQuantity1Visible := SelectionMode;
        Selected1Visible := SelectionMode;
        Undefined1Visible := SelectionMode;
    end;

    [Scope('cloud')]
    procedure SetMaxQuantity(MaxQty: Decimal);
    begin
        MaxQuantity := MaxQty;
    end;

    [Scope('cloud')]
    procedure SetCurrentBinAndItemTrkgCode(BinCode: Code[20]; ItemTrackingCode: Record "Item Tracking Code");
    begin
        ItemTrackingDataCollection.SetCurrentBinAndItemTrkgCode(BinCode, ItemTrackingCode);
        BinContentVisible := BinCode <> '';
        CurrBinCode := BinCode;
        CurrItemTrackingCode := ItemTrackingCode;
    end;

   [Scope('cloud')]
    procedure AutoSelectTrackingNo();
    var
        AvailableQty: Decimal;
        SelectedQty: Decimal;
    begin
        if MaxQuantity = 0 then
            exit;

        SelectedQty := MaxQuantity;
        if Rec.FINDSET then
            repeat
                AvailableQty := Rec."Total Available Quantity";
                if Rec."Bin Active" then
                    AvailableQty := MinValueAbs(Rec."Bin Content", Rec."Total Available Quantity");

                if AvailableQty > 0 then begin
                    Rec."Selected Quantity" := MinValueAbs(AvailableQty, SelectedQty);
                    SelectedQty -= Rec."Selected Quantity";
                    Rec.MODIFY;
                end;
            until (Rec.NEXT = 0) or (SelectedQty <= 0);
    end; 

    local procedure MinValueAbs(Value1: Decimal; Value2: Decimal): Decimal;
    begin
        if ABS(Value1) < ABS(Value2) then
            exit(Value1);

        exit(Value2);
    end;

    local procedure UpdateSelectedQuantity();
    var
        xEntrySummary: Record "Entry Summary";
    begin
        if not SelectedQuantityVisible then
            exit;
        if Rec.MODIFY then; // Ensure that changes to current rec are included in CALCSUMS
        xEntrySummary := Rec;
        Rec.CALCSUMS("Selected Quantity");
        SelectedQuantity := Rec."Selected Quantity";
        Rec := xEntrySummary;
    end; 

    [Scope('cloud')]
    procedure GetSelected(var EntrySummary: Record "Entry Summary");
    begin
        EntrySummary.RESET;
        EntrySummary.DELETEALL;
        Rec.SETFILTER("Selected Quantity", '<>%1', 0);
        if Rec.FINDSET then
            repeat
                EntrySummary := Rec;
                EntrySummary.INSERT;
            until Rec.NEXT = 0;
    end; 

    local procedure DrillDownEntries(FieldNumber: Integer);
    var
        TempReservEntry2: Record "Reservation Entry" temporary;
    begin
        TempReservEntry.RESET;
        TempReservEntry.SETCURRENTKEY(
          "Item No.", "Source Type", "Source Subtype", "Reservation Status",
          "Location Code", "Variant Code", "Shipment Date", "Expected Receipt Date", "Serial No.", "Lot No.");

        TempReservEntry.SETRANGE("Lot No.", Rec."Lot No.");
        if Rec."Serial No." <> '' then
            TempReservEntry.SETRANGE("Serial No.", Rec."Serial No.");

        case FieldNumber of
            Rec.FIELDNO("Total Quantity"):
                begin
                    // An Item Ledger Entry will in itself be represented with a surplus TempReservEntry. Order tracking
                    // and reservations against Item Ledger Entries are therefore kept out, as these quantities would
                    // otherwise be represented twice in the drill down.

                    TempReservEntry.SETRANGE(Positive, true);
                    TempReservEntry2.COPY(TempReservEntry);  // Copy key
                    if TempReservEntry.FINDSET then
                        repeat
                            TempReservEntry2 := TempReservEntry;
                            if TempReservEntry."Source Type" = DATABASE::"Item Ledger Entry" then begin
                                if TempReservEntry."Reservation Status" = TempReservEntry."Reservation Status"::Surplus then
                                    TempReservEntry2.INSERT;
                            end else
                                TempReservEntry2.INSERT;
                        until TempReservEntry.NEXT = 0;
                    TempReservEntry2.ASCENDING(false);
                    PAGE.RUNMODAL(PAGE::"Avail. - Item Tracking Lines", TempReservEntry2);
                end;
            Rec.FIELDNO("Total Requested Quantity"):
                begin
                    TempReservEntry.SETRANGE(Positive, false);
                    TempReservEntry.ASCENDING(false);
                    PAGE.RUNMODAL(PAGE::"Avail. - Item Tracking Lines", TempReservEntry);
                end;
        end;
    end;

    local procedure DrillDownBinContent(FieldNumber: Integer);
    var
        BinContent: Record "Bin Content";
    begin
        if CurrBinCode = '' then
            exit;
        TempReservEntry.RESET;
        if not TempReservEntry.FINDFIRST then
            exit;

        CurrItemTrackingCode.TESTFIELD(Code);

        BinContent.SETRANGE("Location Code", TempReservEntry."Location Code");
        BinContent.SETRANGE("Item No.", TempReservEntry."Item No.");
        BinContent.SETRANGE("Variant Code", TempReservEntry."Variant Code");
        if CurrItemTrackingCode."Lot Warehouse Tracking" then
            if Rec."Lot No." <> '' then
                BinContent.SETRANGE("Lot No. Filter", Rec."Lot No.");
        if CurrItemTrackingCode."SN Warehouse Tracking" then
            if Rec."Serial No." <> '' then
                BinContent.SETRANGE("Serial No. Filter", Rec."Serial No.");

        if FieldNumber = Rec.FIELDNO("Bin Content") then
            BinContent.SETRANGE("Bin Code", CurrBinCode);

        PAGE.RUNMODAL(PAGE::"Bin Content", BinContent);
    end;

   local procedure UpdateIfFiltersHaveChanged();
    begin
        // In order to update Selected Quantity when filters have been changed on the form.
        if Rec.GETFILTERS = xFilterRec.GETFILTERS then
            exit;

        UpdateSelectedQuantity;
        xFilterRec.COPY(Rec);
    end;

local procedure SelectedQuantityOnAfterValidate();
    begin
        UpdateSelectedQuantity;
        CurrPage.UPDATE;
    end; 
}

