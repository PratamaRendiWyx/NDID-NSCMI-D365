page 50714 QCItemList_PQ
{
    // version QC10.1

    // //QC7.2 08/20/13 Doug McIntosh, Cost Control Software
    //   - Removed several Actions
    //   - Promoted certain Actions
    // 
    // QC90  11/03/15  Doug McIntosh
    //   - Change Action "Item &Tracking Entries" to comport with Action of the Same Name in "Lot No. Information Card" Page

    Caption = 'Item List';
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Quality Spcs,Item';
    SourceTable = Item;
    SourceTableView = WHERE("Has Quality Specifications" = CONST(true));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Item Tracking Code"; Rec."Item Tracking Code")
                {
                    ApplicationArea = All;
                }
                field("Has Quality Specifications"; Rec."Has Quality Specifications")
                {
                    ApplicationArea = All;
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Item No."; Rec."Vendor Item No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Production BOM No."; Rec."Production BOM No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Item")
            {
                Caption = '&Item';
                action("Card")
                {
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page "Item Card";
                    RunPageLink = "No." = FIELD("No."),
                                  "Date Filter" = FIELD("Date Filter"),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                  "Location Filter" = FIELD("Location Filter"),
                                  "Drop Shipment Filter" = FIELD("Drop Shipment Filter");
                    ShortCutKey = 'Shift+Ctrl+C';
                    ToolTip = 'Edit Item Card';
                    ApplicationArea = All;
                }
                action("Stockkeepin&g Units")
                {
                    Caption = 'Stockkeepin&g Units';
                    Image = ItemVariant;
                    RunObject = Page "Stockkeeping Unit List";
                    RunPageLink = "Item No." = FIELD("No.");
                    RunPageView = SORTING("Item No.");
                    ToolTip = 'View SKU List';
                    ApplicationArea = All;
                }
                action("&Picture")
                {
                    Caption = '&Picture';
                    Image = Picture;
                    RunObject = Page "Item Picture";
                    RunPageLink = "No." = FIELD("No."),
                                  "Date Filter" = FIELD("Date Filter"),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                  "Location Filter" = FIELD("Location Filter"),
                                  "Drop Shipment Filter" = FIELD("Drop Shipment Filter"),
                                  "Variant Filter" = FIELD("Variant Filter");
                    ToolTip = 'Edit Item Picture';
                    ApplicationArea = All;
                }
                group("E&ntries")
                {
                    Caption = 'E&ntries';
                    Image = Entries;
                    action("Item &Tracking Entries")
                    {
                        Caption = 'Item &Tracking Entries';
                        Image = ItemTrackingLedger;
                        Promoted = true;
                        PromotedIsBig = true;
                        ShortCutKey = 'Shift+Ctrl+I';
                        ToolTip = 'View Item Tracking Entries';
                        ApplicationArea = All;
                        Visible = false;

                        trigger OnAction();
                        var
                            ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
                        begin
                            //ItemTrackingDocMgt.ShowItemTrackingForMasterData(0, '', "No.", '', '', '', '');
                        end;
                    }
                }
                group("&Item Availability by")
                {
                    Caption = '&Item Availability by';
                    Image = ItemAvailability;
                    action("Location")
                    {
                        Caption = 'Location';
                        Image = ItemAvailbyLoc;
                        Promoted = true;
                        PromotedCategory = Category5;
                        PromotedIsBig = true;
                        RunObject = Page "Item Availability by Location";
                        RunPageLink = "No." = FIELD("No."),
                                      "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                      "Location Filter" = FIELD("Location Filter"),
                                      "Drop Shipment Filter" = FIELD("Drop Shipment Filter"),
                                      "Variant Filter" = FIELD("Variant Filter");
                        ToolTip = 'View Item Availability by Location';
                        ApplicationArea = All;
                    }
                }
            }
            group("S&ales")
            {
                Caption = 'S&ales';
                action("Orders")
                {
                    Caption = 'Orders';
                    Image = Document;
                    RunObject = Page "Sales Orders";
                    RunPageLink = Type = CONST(Item),
                                  "No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", Type, "No.");
                    ToolTip = 'Open Sales Order List';
                    ApplicationArea = All;
                }
            }
            group("&Purchases")
            {
                Caption = '&Purchases';
                action("Action40")
                {
                    Caption = 'Orders';
                    Image = Document;
                    RunObject = Page "Purchase Orders";
                    RunPageLink = Type = CONST(Item),
                                  "No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", Type, "No.");
                    ToolTip = 'Open Purchase Order List';
                    ApplicationArea = All;
                }
            }
            group("&QC Specs")
            {
                Caption = '&Quality Specification';
                action("Item Specifications")
                {
                    Caption = 'Item Specifications';
                    Image = Design;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Edit Item Specifications';
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        QCSpecHeader.SETRANGE("Item No.", Rec."No.");
                        PAGE.RUN(PAGE::QCSpecificationHeader_PQ, QCSpecHeader);
                        CLEAR(QCSpecHeader);
                    end;
                }
                action("Lot No.s")
                {
                    Caption = 'Lot Nos.';
                    Image = Lot;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page LotNoList_PQ;
                    RunPageLink = "Item No." = FIELD("No.");
                    RunPageView = SORTING("Item No.", "Variant Code", "Lot No.");
                    ToolTip = 'View Lot No. List';
                    ApplicationArea = All;
                }
                action("Serial No.s")
                {
                    Caption = 'Serial Nos.';
                    Image = CodesList;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page ItemSerialNoInfoList_PQ;
                    RunPageLink = "Item No." = FIELD("No.");
                    RunPageView = SORTING("Item No.", "Variant Code", "Serial No.");
                    ToolTip = 'View Serial Number List';
                    ApplicationArea = All;
                }
                action("QC Tests")
                {
                    Caption = 'Quality Tests';
                    Image = Evaluate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page QCTestList_PQ;
                    RunPageLink = "Item No." = FIELD("No.");
                    RunPageView = SORTING("Item No.", "Lot No./Serial No.");
                    ToolTip = 'View QC Test List';
                    ApplicationArea = All;
                }
            }
            group("&Reports")
            {
                Caption = '&Reports';
            }
        }
    }

    var
        TblshtgHeader: Record "Troubleshooting Header";
        SkilledResourceList: Page "Skilled Resource List";
        CalculateStdCost: Codeunit "Calculate Standard Cost";
        QCSpecHeader: Record QCSpecificationHeader_PQ;
        "-QC7_2": Integer;
        Spec: Record QCSpecificationHeader_PQ;

    procedure GetSelectionFilter(): Code[80];
    var
        Item: Record Item;
        FirstItem: Code[30];
        LastItem: Code[30];
        SelectionFilter: Code[250];
        ItemCount: Integer;
        More: Boolean;
    begin
        CurrPage.SETSELECTIONFILTER(Item);
        ItemCount := Item.COUNT;
        if ItemCount > 0 then begin
            Item.FIND('-');
            while ItemCount > 0 do begin
                ItemCount := ItemCount - 1;
                Item.MARKEDONLY(false);
                FirstItem := Item."No.";
                LastItem := FirstItem;
                More := (ItemCount > 0);
                while More do
                    if Item.NEXT = 0 then
                        More := false
                    else
                        if not Item.MARK then
                            More := false
                        else begin
                            LastItem := Item."No.";
                            ItemCount := ItemCount - 1;
                            if ItemCount = 0 then
                                More := false;
                        end;
                if SelectionFilter <> '' then
                    SelectionFilter := SelectionFilter + '|';
                if FirstItem = LastItem then
                    SelectionFilter := SelectionFilter + FirstItem
                else
                    SelectionFilter := SelectionFilter + FirstItem + '..' + LastItem;
                if ItemCount > 0 then begin
                    Item.MARKEDONLY(true);
                    Item.NEXT;
                end;
            end;
        end;
        exit(SelectionFilter);
    end;

    procedure SetSelection(var Item: Record Item);
    begin
        CurrPage.SETSELECTIONFILTER(Item);
    end;
}

