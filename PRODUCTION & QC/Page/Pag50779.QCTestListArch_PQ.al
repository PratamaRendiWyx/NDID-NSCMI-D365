page 50779 QCTestListArch_PQ
{
    // version QC13.02

    // //QC37.05  Changed the object name
    // 
    // //QC7.2
    //   - Added Action to Launch Report 14004594
    //   - Added Logic to Style certain Fields depending on a "Failed" Test
    //   - Added Customer No. Field and "Failed" Field
    // 
    // QC7.3
    //   - Changed "Test Worksheet" to launch (Testing Worksheet)
    //   - Added "Item Tracing" Action
    //   - Added "All Quality Test Lines" Action
    // 
    // QC7.4
    //   - Added "Item Description" and "Customer Name" Fields
    // 
    // QC71.1
    //   - Made "Test Qty" HIDDEN/DISABLED (Test Qty. ALWAYS = 1)
    //   - Added Global "CoA Available" for Printing CoAs
    //   - Updated Print CoA Action to check for Status
    // 
    // QC7.2 
    //   - Added "Testing Worksheet" Action
    // 
    // QC80 
    //   - Removed "Test Card" Action (Redundant)
    //
    // QC13.02
    //      - Added "UsageCategory" and "ApplicationArea" to make Page Searchable
    //      - Changed Caption to start with "Quality" (rather than "QC") to make Search Consistent with Quality Item Specs

    Caption = 'Quality Tests (Archived)';
    CardPageID = QCLotTestHeaderArch_PQ;
    Editable = false;
    PageType = List;
    SourceTable = QualityTestHeaderArch_PQ;
    PromotedActionCategories = 'New,Process,Report,Navigate,Report';
    UsageCategory = History;
    RefreshOnActivate = true;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Test No."; Rec."Test No.")
                {
                    Style = Attention;
                    StyleExpr = FailedTest;
                    ToolTip = 'Displays the number of the test';
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Indicates what Item number this test is run on';
                    ApplicationArea = All;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    Caption = 'Variant Code';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ToolTip = 'Displays a description of the item';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Test Description"; Rec."Test Description")
                {
                    ToolTip = 'Displays the Test Description for this Quality Test';
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Displays the Customer No. that the test is for, if it is customer specific';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Displays the Customer Name';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Receipt Date"; getInfoReceiptDate())
                {
                    Caption = 'Receipt Date';
                    ApplicationArea = All;
                }
                field(PostingDate; getInfoPostingDateOuput())
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date (Output)';
                    Editable = false;
                }
                field("Category Code"; Rec."Category Code")
                {
                    ApplicationArea = All;
                }
                field("Lot No./Serial No."; Rec."Lot No.")
                {
                    ToolTip = 'Displays the lot and serial number of the item being tested';
                    ApplicationArea = All;
                    Visible = false;
                    Caption = 'Lot No./Serial No.';
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = All;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ToolTip = 'Displays the Source Type for this test';
                    ApplicationArea = All;
                }
                field("Source No."; Rec."Source No.")
                {
                    ToolTip = 'Displays the Source No for this test';
                    ApplicationArea = All;
                }
                field("Source Line No."; Rec."Source Line No.")
                {
                    ToolTip = 'Displays the Source Line No for this test';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Test Status"; Rec."Test Status")
                {
                    //Style = Strong;
                    //StyleExpr = TRUE;
                    ToolTip = 'Displays the test stsatus for this item';
                    ApplicationArea = All;
                }
                field(Failed; Rec.Failed)
                {
                    Caption = 'Non-Conformance';
                    Style = Unfavorable;
                    StyleExpr = FailedTest;
                    ToolTip = 'Indicates if this test has passed or failed';
                    ApplicationArea = All;
                }
                field("Test Qty"; Rec."Test Qty")
                {
                    ToolTip = 'Displays the Quantity of the item for this test';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ToolTip = 'Displays the Unit of Measure for the item';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ToolTip = '"Displays the USERID of the last person to modify this test "';
                    ApplicationArea = All;
                }
                field("Tested By"; Rec."Tested By")
                {
                    ToolTip = 'Displays the USERID of the  individual who performed the QC test';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Free form field for any comments related to this test';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Status Transfer"; Rec."Status Transfer")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "QT Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Test No." = field("Test No.");
                SubPageView = order(descending);
            }
            part(AMQTSummaryStatsFB; QTSummaryStatsFactbox_PQ)
            {
                ApplicationArea = All;
                Caption = 'Quality Test Details';
                SubPageLink = "Test No." = FIELD("Test No.");
            }
            part(ItemPicture; "Item Picture")
            {
                Caption = 'Picture';
                Editable = false;
                SubPageLink = "No." = FIELD("Item No.");
                ApplicationArea = All;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
            systempart(RecordLinks; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Quality")
            {
                Caption = '&Quality';
                Visible = false;
                action("Item Tracing")
                {
                    Caption = 'Item Tracing';
                    Image = ItemTracing;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    //RunObject = Page "Item Tracing";
                    ToolTip = 'Open Item Tracing';
                    ApplicationArea = All;
                    Visible = false;

                    trigger OnAction()
                    var
                        ItemTracing: Page "Item Tracing";
                        TraceMethod2: Option "Origin->Usage","Usage->Origin";
                        ShowComponents2: Option No,"Item-tracked Only",All;
                    begin
                        ItemTracing.SetItemFilters(TraceMethod2::"Usage->Origin", ShowComponents2::"Item-tracked Only", '', '', Rec."Item No.", '');
                        ItemTracing.FindRecords;
                        ItemTracing.Run();
                    end;
                }
                action("Quality Test Lines")
                {
                    Caption = 'Quality Test Lines';
                    Image = AnalysisView;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page QualityTestOverview_PQ;
                    RunPageLink = "Item No." = FIELD("Item No."),
                                  "Customer No." = FIELD("Customer No.");
                    ToolTip = 'View Quality Test Lines';
                    ApplicationArea = All;
                    Visible = false;
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    InFooterBar = true;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page QCTestHeaderCommentsArch_PQ;
                    RunPageLink = "Test No." = FIELD("Test No.");
                    RunPageView = SORTING("Test No.", "Line No.");
                    ToolTip = 'Edit Comments';
                    ApplicationArea = All;
                    Visible = false;

                    trigger OnAction();
                    begin
                        CurrPage.UPDATE(true);
                    end;
                }
            }
            action("Item Tra&cing")
            {
                Caption = 'Item Tracing';
                Image = ItemTracing;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                //RunObject = Page "Item Tracing";
                ToolTip = 'Open Item Tracing';
                ApplicationArea = All;

                trigger OnAction()
                var
                    ItemTracing: Page "Item Tracing";
                    TraceMethod2: Option "Origin->Usage","Usage->Origin";
                    ShowComponents2: Option No,"Item-tracked Only",All;
                begin
                    ItemTracing.SetItemFilters(TraceMethod2::"Usage->Origin", ShowComponents2::"Item-tracked Only", '', '', Rec."Item No.", '');
                    ItemTracing.FindRecords;
                    ItemTracing.Run();
                end;
            }
            action("Quality Te&st Lines")
            {
                Caption = 'Quality Test Lines';
                Image = AnalysisView;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page QualityTestOverview_PQ;
                RunPageLink = "Item No." = FIELD("Item No."),
                                "Customer No." = FIELD("Customer No.");
                ToolTip = 'View Quality Test Lines';
                ApplicationArea = All;
            }
            action("Co&mm&ents")
            {
                Caption = 'Co&mments';
                Image = ViewComments;
                InFooterBar = true;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page QCTestHeaderComments_PQ;
                RunPageLink = "Test No." = FIELD("Test No.");
                RunPageView = SORTING("Test No.", "Line No.");
                ToolTip = 'Edit Comments';
                ApplicationArea = All;

                trigger OnAction();
                begin
                    CurrPage.UPDATE(true);
                end;
            }
            group("&Reports")
            {
                //Caption = '&Reports';
            }
        }

        area(processing)
        {
            action("Item Tracking Lines")
            {
                ApplicationArea = ItemTracking;
                Caption = 'Item &Tracking Lines';
                Image = ItemTrackingLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                //ShortCutKey = 'Shift+Ctrl+I';
                //Enabled = Type = Type::Item;
                ToolTip = 'View serial and lot numbers for the quality test.';

                trigger OnAction()
                var
                    QTHdr: Record QualityTestHeader_PQ;
                    TrackingSpecification: Record "Tracking Specification";
                    //ItemTrackingLines: Page "Item Tracking Lines";
                    PurchLine: Record "Purchase Line";
                    PurchinvHdr: Record "Purch. Inv. Header";
                    PurchInvLine: Record "Purch. Inv. Line";
                    SalesLine: Record "Sales Line";
                    SalesInvHdr: Record "Sales Invoice Header";
                    SalesInvLine: Record "Sales Invoice Line";
                    ProdOrderLine: Record "Prod. Order Line";
                    TempItemLedgEntry: Record "Item Ledger Entry" temporary;
                    ItemTrackingMgt: Codeunit "Item Tracking Management";
                    RowID1: Text[250];
                    ItemTrackingDocMg: Codeunit "Item Tracking Doc. Management";
                    ItemTrackingLines2: Page ItemTrackingLines_PQ;
                begin
                    if QTHdr.Get(Rec."Test No.") then begin
                        case QTHdr."Source Type" of
                            QTHdr."Source Type"::"Purchase Order":
                                begin
                                    PurchLine.Reset();
                                    PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
                                    PurchLine.SetRange("Document No.", QTHdr."Source No.");
                                    PurchLine.SetRange("Line No.", QTHdr."Source Line No.");
                                    if PurchLine.FindFirst() then begin
                                        TrackingSpecification.InitFromPurchLine(PurchLine);
                                        ItemTrackingLines2.SetSourceSpec(TrackingSpecification, PurchLine."Expected Receipt Date");
                                        ItemTrackingLines2.SetInbound(PurchLine.IsInbound);
                                        ItemTrackingLines2.Editable(false);
                                        if not QTHdr."Multiple Tracking" then begin
                                            ItemTrackingLines2.AMGetLotSerialNo(Rec."Lot No.", Rec."Serial No.", true);
                                        end;
                                        ItemTrackingLines2.RunModal();
                                    end else begin
                                        PurchinvHdr.Reset();
                                        PurchinvHdr.SetRange("Order No.", QTHdr."Source No.");
                                        if PurchinvHdr.FindFirst() then begin
                                            PurchInvLine.Reset();
                                            PurchInvLine.SetRange("Document No.", PurchinvHdr."No.");
                                            PurchInvLine.SetRange("Line No.", QTHdr."Source Line No.");
                                            if PurchInvLine.FindFirst() then begin
                                                RowID1 := ItemTrackingMgt.ComposeRowID(DATABASE::"Purch. Inv. Line", 0, PurchInvLine."Document No.", '', 0, PurchInvLine."Line No.");
                                                ItemTrackingDocMg.RetrieveEntriesFromPostedInvoice(TempItemLedgEntry, RowID1);
                                                if not TempItemLedgEntry.IsEmpty() then begin
                                                    if not QTHdr."Multiple Tracking" then begin
                                                        if TempItemLedgEntry."Lot No." <> '' then
                                                            TempItemLedgEntry.SetRange("Lot No.", Rec."Lot No.");
                                                        if TempItemLedgEntry."Serial No." <> '' then
                                                            TempItemLedgEntry.SetRange("Serial No.", Rec."Serial No.");
                                                    end;
                                                    PAGE.RunModal(PAGE::"Posted Item Tracking Lines", TempItemLedgEntry);
                                                end;
                                            end;
                                        end else begin
                                            ItemTrackingLines2.AMGetIsEmpty(true);
                                            ItemTrackingLines2.RunModal();
                                        end;

                                    end
                                end;
                            QTHdr."Source Type"::"Sales Order",
                            QTHdr."Source Type"::"Sales Return Receipt":
                                begin
                                    SalesLine.Reset();

                                    if QTHdr."Source Type" = QTHdr."Source Type"::"Sales Order" then
                                        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                                    if QTHdr."Source Type" = QTHdr."Source Type"::"Sales Return Receipt" then
                                        SalesLine.SetRange("Document Type", SalesLine."Document Type"::"Return Order");

                                    SalesLine.SetRange("Document No.", QTHdr."Source No.");
                                    SalesLine.SetRange("Line No.", QTHdr."Source Line No.");
                                    if SalesLine.FindFirst() then begin
                                        TrackingSpecification.InitFromSalesLine(SalesLine);
                                        ItemTrackingLines2.SetSourceSpec(TrackingSpecification, SalesLine."Shipment Date");
                                        ItemTrackingLines2.SetInbound(SalesLine.IsInbound);
                                        ItemTrackingLines2.Editable(false);
                                        if not QTHdr."Multiple Tracking" then begin
                                            ItemTrackingLines2.AMGetLotSerialNo(Rec."Lot No.", Rec."Serial No.", true);
                                        end;
                                        ItemTrackingLines2.RunModal();
                                    end else begin
                                        SalesInvHdr.Reset();
                                        SalesInvHdr.SetRange("Order No.", QTHdr."Source No.");
                                        if SalesInvHdr.FindFirst() then begin
                                            SalesInvLine.Reset();
                                            SalesInvLine.SetRange("Document No.", SalesInvHdr."No.");
                                            SalesInvLine.SetRange("Line No.", QTHdr."Source Line No.");
                                            if SalesInvLine.FindFirst() then begin
                                                RowID1 := ItemTrackingMgt.ComposeRowID(DATABASE::"Sales Invoice Line", 0, SalesInvLine."Document No.", '', 0, SalesInvLine."Line No.");
                                                ItemTrackingDocMg.RetrieveEntriesFromPostedInvoice(TempItemLedgEntry, RowID1);
                                                if not TempItemLedgEntry.IsEmpty() then begin
                                                    if not QTHdr."Multiple Tracking" then begin
                                                        if TempItemLedgEntry."Lot No." <> '' then
                                                            TempItemLedgEntry.SetRange("Lot No.", Rec."Lot No.");
                                                        if TempItemLedgEntry."Serial No." <> '' then
                                                            TempItemLedgEntry.SetRange("Serial No.", Rec."Serial No.");
                                                    end;
                                                    PAGE.RunModal(PAGE::"Posted Item Tracking Lines", TempItemLedgEntry);
                                                end;
                                            end;
                                        end else begin
                                            ItemTrackingLines2.AMGetIsEmpty(true);
                                            ItemTrackingLines2.RunModal();
                                        end;

                                    end
                                end;
                            QTHdr."Source Type"::"Output Journal",
                            QTHdr."Source Type"::"Production Order":
                                begin
                                    ProdOrderLine.Reset();
                                    ProdOrderLine.SetRange(Status, ProdOrderLine.Status::Released);
                                    ProdOrderLine.SetRange("Prod. Order No.", QTHdr."Source No.");
                                    //ProdOrderLine.SetRange("Line No.", QTHdr."Source Line No.");
                                    if ProdOrderLine.FindFirst() then begin
                                        TrackingSpecification.InitFromProdOrderLine(ProdOrderLine);
                                        ItemTrackingLines2.SetSourceSpec(TrackingSpecification, ProdOrderLine."Due Date");
                                        ItemTrackingLines2.SetInbound(ProdOrderLine.IsInbound);
                                        ItemTrackingLines2.Editable(false);
                                        if not QTHdr."Multiple Tracking" then begin
                                            ItemTrackingLines2.AMGetLotSerialNo(Rec."Lot No.", Rec."Serial No.", true);
                                        end;
                                        ItemTrackingLines2.RunModal();
                                    end else begin
                                        ItemTrackingLines2.AMGetIsEmpty(true);
                                        ItemTrackingLines2.RunModal();
                                    end;

                                end;
                            else begin
                                ItemTrackingLines2.AMGetIsEmpty(true);
                                ItemTrackingLines2.RunModal();
                            end;
                        end
                    end;
                end;
            }
        }

        area(Reporting)
        {
        }
    }

    trigger OnAfterGetRecord();
    begin
        FailedTest := Rec.Failed; //QC7.2

        UserIsQCMgr := QualityFunctions.TestQCMgr; //NP1
        CoAAvailable := (Rec."Test Status" = Rec."Test Status"::Certified); //or (Rec."Test Status" = Rec."Test Status"::"Certified Final"); //NP1
    end;

    local procedure getInfoReceiptDate(): Date
    var
        ILE: Record "Item Ledger Entry";
    begin
        Clear(ILE);
        ILE.Reset();
        ILE.SetRange("Lot No.", Rec."Lot No.");
        ILE.SetRange("Item No.", Rec."Item No.");
        ILE.SetRange("Document Type", ILE."Document Type"::"Purchase Receipt");
        ILE.SetRange("Document No.", Rec."Source No. Tracing");
        ILE.SetCurrentKey("Posting Date");
        if ILE.Find('-') then
            exit(ILE."Posting Date")
        else
            exit(0D);
    end;

    local procedure getInfoPostingDateOuput(): Date
    var
        ILE: Record "Item Ledger Entry";
    begin
        Clear(ILE);
        ILE.Reset();
        ILE.SetRange("Lot No.", Rec."Lot No.");
        ILE.SetRange("Item No.", Rec."Item No.");
        ILE.SetRange("Document No.", Rec."Source No.");
        ILE.SetRange("Entry Type", ILE."Entry Type"::Output);
        ILE.SetCurrentKey("Posting Date");
        if ILE.Find('-') then
            exit(ILE."Posting Date")
        else
            exit(0D);
    end;

    var
        [InDataSet]
        FailedTest: Boolean;
        "--QC71.1-": Integer;
        [InDataSet]
        UserIsQCMgr: Boolean;
        QualityFunctions: Codeunit QCFunctionLibrary_PQ;
        [InDataSet]
        CoAAvailable: Boolean;
        "-QC71.1---": Integer;
        NPText011: Label '%1 is the Certified Final Test for this Item/Customer Specification.\\';
        QCStatusRules: Record QCStatusRules_PQ;
        QCStatusRuleResult: Text;
        NPText012: Label 'Would you like to Print that Certificate of Analysis?';
        QCText003: Label 'Some Test Lines are Incomplete.\\';
}

