page 50780 QCLotTestHeaderArch_PQ
{
    // version QC13.01

    // //QC4SP1.2   Added Customer No. to the header
    //              Added a new choice on the Functions button to get the Customer Specs.
    // //QC5.1   Added glue to Transfer Button
    //
    // //QC7.2
    //   - Created Promoted Action Categories "Test" and "Functions"
    //   - Promoted and Assigned to new Categories several Actions
    //   - Made Visible, Fields "Test Date" and "Test Time"
    //
    // QC7.3
    //   - Changed "Test Worksheet" to launch R14004591 (Testing Worksheet)
    //   - Added "Item Tracing" Action
    //   - Removed "Get Current Specs" and "Get Customer Specs" Actions and Replaced with "Get Specification" Action
    //     - Moved Action Code to 3 new Functions (see commments in code)
    //   - Removed OnValidate Code from "Lot No/Serial No." Field on this Page (there is still some in the Table)
    //
    // QC71.1
    //   - Resurrected Actions for "Get Specifications" and "Get Customer Specifications", and modified Code for same
    //   - Deprecated "GetSpecification" Function
    //   - Added Globals "UserIsQCMgr" and "QualityFunctions", and Call to QualityFunctions.TestQCMgr
    //   - Added Global "CoA Available" for Printing CoAs
    //   - Updated Print CoA Action to check for Status
    //   - Changed "Get Specification" Action to NOT present a "Pick-List", but rather to use Item No. & Customer No. to get the right Spec.
    //
    // QC80
    //   - Enhanced the Functionality of the "WarnAlert" 'Badge'
    //   - RB added "Tested By" to header
    //
    // QC80.1
    //   - Added a "GET" in the "GetSpecification" Function, to avoid a "Must Re-Read from Database" Error
    //
    //
    // QC80.3
    //   - Changes to Improve Workflow of "Transfer" Function (Action)
    //     - Code Changes (and Local Vars Created) on Action "Transfer"
    //     - Moved Global "TransHeaderT" to Local under "Transfer" Action
    //     - Moved Global Text Constants Text000 and Text001 to Local under "Transfer" Action, and Renamed to "Text100" and "Text101"
    //     - Also, Removed Code in OnInsert Trigger of Table 5740 (Transfer Header), for better Compatibility with other Add-Ons
    //
    // QC80.4
    //   - Removed "Tested By" Field, per RB
    //   - Removed "Spec Version Used" Field
    //   - Added Code in Funcs. "GetCurrSpecs" and "GetCustSpecs" to Raise Confirm for Mandatory Specs UNLESS "QCMgr Non Mand" (QC Setup) is TRUE
    //
    // QC11.01
    //   - Added Item Picture
    //
    // QC200.01
    //   - Remove confirmation messages for Get Specification functionality

    Caption = 'Quality Test (Archived)';
    PageType = ListPlus;
    // PromotedActionCategories = 'New,Process,Report,Process,Navigate,Print';
    RefreshOnActivate = true;
    SourceTable = QualityTestHeaderArch_PQ;
    Editable = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Test No."; Rec."Test No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    ToolTip = 'Displays the number of the test';
                    trigger OnAssistEdit();
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.UPDATE;
                    end;
                }
                field("Item No."; Rec."Item No.")
                {
                    Editable = true;
                    ApplicationArea = All;
                    ToolTip = 'Indicates what Item number this test is run on';
                    trigger OnValidate();
                    var
                        ItemT: Record Item;
                    begin
                        if QCHeader.GET(Rec."Item No.", Rec."Customer No.") then begin
                            QCHeaderDesc := QCHeader."Test Description";
                            Rec."Unit of Measure" := QCHeader."Unit of Measure Code";
                            ItemT.GET(Rec."Item No.");
                            Rec."Test Description" := ItemT.Description;
                        end;
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        SpecListPage: Page QCSpecificationList_PQ;
                        LookupSpec: Record QCSpecificationHeader_PQ;
                        ItemT: Record Item;
                    begin
                        //QC13.0
                        CLEAR(SpecListPage);
                        LookupSpec.SETFILTER("Customer No.", '%1', Rec."Customer No.");
                        LookupSpec.SETRANGE(Status, LookupSpec.Status::Certified);
                        SpecListPage.LookupMode(true);
                        SpecListPage.SETTABLEVIEW(LookupSpec);
                        if SpecListPage.RUNMODAL = ACTION::LookupOK then begin
                            SpecListPage.GETRECORD(LookupSpec);
                            Rec."Item No." := LookupSpec."Item No.";
                            Rec."Specification Type" := LookupSpec.Type;
                            ItemT.GET(Rec."Item No.");
                            Rec."Test Description" := ItemT.Description;
                        end;
                    end;
                }
                field("Item Description"; Rec."Item Description")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Displays a description of the item';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Variant Code field.';
                }
                field("Test Description"; Rec."Test Description")
                {
                    ToolTip = 'Displays the Test Description for this Quality Test';
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Editable = true;
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Displays the Customer No. that the test is for, if it is customer specific';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Displays the Customer Name';
                }
                field(QCHeaderDesc; QCHeaderDesc)
                {
                    Caption = 'Test Description';
                    Description = '<Lookup Flow Field>>';
                    Editable = false;
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Test Description field.';
                }
                field("Category Code"; Rec."Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Category Code field.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field("Lot No./Serial No."; Rec."Lot No./Serial No.")
                {
                    ToolTip = '"Lookup tied to Item Card.  Enter Serial no.s series or Lot No.s series on Item Card. "';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = All;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    Editable = true;
                }

                field(vReceiptDate; vReceiptDate)
                {
                    ApplicationArea = All;
                    Caption = 'Receipt Date';
                    Editable = false;
                }
                field(PostingDate; getInfoPostingDateOuput())
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date (Output)';
                    Editable = false;
                }
                field("Test Status"; Rec."Test Status")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                    ToolTip = 'Displays the test stsatus for this item';
                    trigger OnValidate();
                    begin
                        CoAAvailable := Rec.CheckCoAAvailable; //QC71.1 Added
                        RestrictEditTest1();

                        CurrPage.UPDATE(false); //QC71.1 - Force Page Update if Status Change ABORTED
                    end;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Creation Date field.';
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = All;
                    ToolTip = '"Displays the USERID of the last person to modify this test "';
                }
                field("Test Start Date"; Rec."Test Start Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the test start date.';
                }
                field("Test Start Time"; Rec."Test Start Time")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the test start time.';
                }
                field("Status Transfer"; Rec."Status Transfer")
                {
                    ApplicationArea = All;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = All;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = All;
                }
                field("Production Line"; Rec."Production Line")
                {
                    ApplicationArea = All;
                    Enabled = false;
                }
                field(Cycle; Rec.Cycle)
                {
                    ApplicationArea = All;
                    Enabled = false;
                }
                field(IsPrimary; Rec.IsPrimary)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                        QualityTestLine: Record QualityTestLines_PQ;
                    begin
                        if Not Rec.IsPrimary then begin
                            if Confirm('Are you sure want to update ?') then begin
                                Clear(QualityTestLine);
                                QualityTestLine.Reset();
                                QualityTestLine.SetRange("Test No.", Rec."Test No.");
                                QualityTestLine.SetFilter(Method, '<>%1', 'VISUAL');
                                QualityTestLine.DeleteAll();
                            end;
                        end
                    end;
                }
            }
            group(Activity)
            {
                Caption = 'Activity';
                group("Test Quantity Group")
                {
                    ShowCaption = false;
                    field("Test Qty"; Rec."Test Qty")
                    {
                        ApplicationArea = All;
                        Editable = IsTestQtyEditable Or glbrestrictEdit;
                        ToolTip = 'Displays the Quantity of the item for this test';
                    }
                    field("Qty. to Certify"; Rec.QuantityToCertify())
                    {
                        ApplicationArea = All;
                        Caption = 'Qty. to Certify';
                        Editable = glbrestrictEdit;
                        ToolTip = 'Specifies the value of the Certify Quantity field.';
                    }
                    field("Qty. Actual Test"; Rec."Qty. Actual Test")
                    {
                        ApplicationArea = All;
                        StyleExpr = QCActvsFinish;
                        Visible = glb_visible;
                        Editable = glbrestrictEdit;
                        trigger OnValidate()
                        var
                            myInt: Integer;
                            ProdOrderLine: Record "Prod. Order Line";
                            ILE: Record "Item Ledger Entry";
                            QtyCalsum: Decimal;
                        begin
                            if Rec."Source Type" = Rec."Source Type"::"Output Journal" then begin
                                Clear(ProdOrderLine);
                                ProdOrderLine.SetRange("Prod. Order No.", Rec."Source No.");
                                if ProdOrderLine.FindFirst() then begin
                                    Clear(ILE);
                                    Clear(QtyCalsum);
                                    ILE.SetRange("Document No.", ProdOrderLine."Prod. Order No.");
                                    ILE.SetRange("Item No.", Rec."Item No.");
                                    ILE.SetRange("Lot No.", Rec."Lot No.");
                                    ILE.SetRange("Entry Type", ILE."Entry Type"::Output);
                                    if ILE.FindSet() then begin
                                        ILE.CalcSums(Quantity);
                                        QtyCalsum := ILE.Quantity;
                                        if QtyCalsum <> Rec."Qty. Actual Test" then
                                            Message('Actual test Qty (%1) <> Output Qty. (%2), Please Check / Reconcile.', Rec."Qty. Actual Test", QtyCalsum);
                                    end;
                                    // if Rec."Qty. Actual Test" <> ProdOrderLine."Finished Quantity" then
                                    //     Message('Actual test Qty (%1) <> Output Qty. (%2), Please Check / Reconcile.', Rec."Qty. Actual Test", ProdOrderLine."Finished Quantity");
                                end;
                            end;
                        end;

                    }
                    field("Qty. Hold"; Rec."Qty. Hold")
                    {
                        ApplicationArea = All;
                        Visible = glb_visible;
                        Editable = glbrestrictEdit;
                    }
                    field("Qty. Test Shift 1"; Rec."Qty. Test Shift 1")
                    {
                        ApplicationArea = All;
                        Visible = glb_visible;
                        Editable = glbrestrictEdit;
                    }
                    field("Qty. Test Shift 2"; Rec."Qty. Test Shift 2")
                    {
                        ApplicationArea = All;
                        Visible = glb_visible;
                        Editable = glbrestrictEdit;
                    }
                    field("Sample Scrap Status"; Rec."Sample Scrap Status")
                    {
                        ApplicationArea = All;
                        Visible = glb_visible;
                        Editable = glbrestrictEdit;
                    }
                    field("Qty. Sample"; Rec."Qty. Sample")
                    {
                        ApplicationArea = All;
                        Visible = glb_visible;
                        Editable = glbrestrictEdit;
                    }
                    field("Qty. to Scraps"; Rec."Qty. Sample" + Rec."Qty. NG")
                    {
                        ApplicationArea = All;
                        Visible = glb_visible;
                        Editable = glbrestrictEdit;
                    }
                    field("Qty. NG"; Rec."Qty. NG")
                    {
                        ApplicationArea = All;
                        Visible = glb_visible;
                        Enabled = false;
                        Editable = glbrestrictEdit;
                    }
                    field("NG Scrap Status"; Rec."NG Scrap Status")
                    {
                        ApplicationArea = All;
                        Visible = glb_visible;
                        Editable = glbrestrictEdit;
                    }
                    field("Qty. Repair"; Rec."Qty. Repair")
                    {
                        ApplicationArea = All;
                        Visible = glb_visible;
                        Editable = glbrestrictEdit;
                    }
                }
                group("Quantity to Create")
                {
                    ShowCaption = false;

                    field("Qty. to Transfer"; Rec."Qty. to Transfer")
                    {
                        ApplicationArea = All;
                        Editable = glbrestrictEdit;

                        trigger OnValidate()
                        begin
                            UpdateButtonAvailability();
                        end;
                    }
                    field("Qty. to Return"; Rec."Qty. to Return")
                    {
                        ApplicationArea = All;
                        Editable = glbrestrictEdit;

                        trigger OnValidate()
                        begin
                            UpdateButtonAvailability();
                        end;
                    }
                    field("Qty. to Scrap"; Rec."Qty. to Scrap")
                    {
                        ApplicationArea = All;
                        Editable = glbrestrictEdit;

                        trigger OnValidate()
                        begin
                            UpdateButtonAvailability();
                        end;
                    }
                }
                group("Other Quantity Group")
                {
                    ShowCaption = false;

                    field("Qty. on Transf. Order"; Rec."Qty. on Transf. Order")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Enabled = IsTransferOrder;
                        ToolTip = 'Specifies the value of the Qty. on Transf. Order field.';

                        // trigger OnDrillDown()
                        // var
                        //     TransferHeader: Record "Transfer Header";
                        // begin
                        //     TransferHeader.SetRange("No.", Rec."Transfer No.");
                        //     Page.Run(Page::"Transfer Orders", TransferHeader);
                        // end;
                    }
                    field("Qty. on Return Order"; Rec."Qty. on Return Order")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Enabled = IsPurchaseReturnOrder;
                        ToolTip = 'Specifies the value of the Qty. on Return Order field.';

                        // trigger OnDrillDown()
                        // var
                        //     PurchaseHeader: Record "Purchase Header";
                        // begin
                        //     PurchaseHeader.SetRange("Document Type", Rec."Purchase Document Type");
                        //     PurchaseHeader.SetRange("No.", Rec."Purchase Document No.");
                        //     Page.Run(Page::"Purchase Return Order List", PurchaseHeader);
                        // end;
                    }
                    field("Qty. on Scrap Line"; Rec."Qty. on Scrap Line")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Enabled = IsItemJournal;
                        ToolTip = 'Specifies the value of the Qty. on Scrap Line field.';

                        // trigger OnDrillDown()
                        // var
                        //     ItemJournalLine: Record "Item Journal Line";
                        // begin
                        //     ItemJournalLine.SetRange("Journal Template Name", Rec."Item Journal Template Name");
                        //     ItemJournalLine.SetRange("Journal Batch Name", Rec."Item Journal Batch Name");
                        //     Page.Run(Page::"Item Journal Lines", ItemJournalLine);
                        // end;
                    }
                }
            }
            part(QCLine; QCLotTestLinesArch_PQ)
            {
                SubPageLink = "Test No." = FIELD("Test No.");
                SubPageView = SORTING("Test No.");
                Caption = 'Lines';
                ApplicationArea = All;
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
            systempart(RecordLinks; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
#if not BC19
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';
                actionref("Get Specification_Promoted"; "Get Specification") { }
                actionref("Item Tracking Lines_Promoted"; "Item Tracking Lines") { }
                actionref("Get Current Specifications_Promoted"; "Get Current Specifications") { }
                actionref("Get Customer Specifications_Promoted"; "Get Customer Specifications") { }
                actionref("Transfer_Promoted"; "Transfer") { }
                actionref("Item Tracing_Promoted"; "Item Tracing") { }
                actionref("Co&mments_Promoted"; "Co&mments") { }
            }
            group(Category_Category4)
            {
                Caption = 'Prepare';
                actionref(CreateReturnOrder_Promoted; CreateReturnOrder) { }
                actionref(CreateTransferOrder_Promoted; CreateTransferOrder) { }
                actionref(CreateScrapLine_Promoted; CreateScrapLine) { }
            }
            group(Category_Category5)
            {
                Caption = 'Print';

                actionref("Certificate Of Analysis_Promoted"; "Certificate of Analysis") { }
            }
        }
#endif
        area(navigation)
        {
            group("&Test")
            {
                Caption = '&Test';
                action("Co&mments")
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    InFooterBar = true;
                    RunObject = Page QCTestHeaderCommentsArch_PQ;
                    RunPageLink = "Test No." = FIELD("Test No.");
                    RunPageView = SORTING("Test No.", "Line No.");
                    ToolTip = 'Edit Comments';

                    trigger OnAction();
                    begin
                        CurrPage.UPDATE(true);
                    end;
                }
                action("Item Tracking Lines")
                {
                    ApplicationArea = All;
                    Caption = 'Item Tracking Lines';
                    Image = ItemTrackingLines;
                    ToolTip = 'View serial and lot numbers for the quality test.';
                    trigger OnAction()
                    begin
                        OpenItemTrackingLines();
                    end;
                }
                action("Item Tracing")
                {
                    ApplicationArea = All;
                    Caption = 'Item Tracing';
                    Image = ItemTracing;
                    ToolTip = 'Open Item Tracing Page';

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

                action("QT NG Input")
                {
                    ApplicationArea = All;
                    Caption = 'NG Detail (QT)';
                    Image = ItemTracing;
                    ToolTip = 'Input NG Detaiils for QT (Quality Test)';
                    RunObject = page "Detail NG QT";
                    RunPageLink = "QT No." = FIELD("Test No.");
                    Enabled = Rec."Source Type" = Rec."Source Type"::"Output Journal";
                }

                action("UpdateItemLot")
                {
                    ApplicationArea = All;
                    Caption = 'Update Lot Hold/NG Stock';
                    Image = Journal;
                    ToolTip = 'Update lot Item to New Item Lot.';
                    trigger OnAction()
                    var
                        myInt: Integer;
                        updateitemlotQC: Page UpdateItemLotQC_PQ;
                        ItemJnlQCRecord: Record "Item Jnl. Update Lot QC";
                        ItemLedgerEntry: Record "Item Ledger Entry";
                        ItemQualityReq: Record ItemQualityRequirement_PQ;
                    begin
                        Clear(ItemQualityReq);
                        ItemQualityReq.SetRange("Item No.", Rec."Item No.");
                        ItemQualityReq.SetCurrentKey(Type, "Item No.", "Variant Code", "Starting Date");
                        ItemQualityReq.SetFilter("Starting Date", '<=%1', Today);
                        ItemQualityReq.SetRange(Type, ItemQualityReq.Type::"Item Output");
                        if ItemQualityReq.FindFirst() then begin
                            Clear(ItemJnlQCRecord);
                            ItemJnlQCRecord.Reset();
                            ItemJnlQCRecord.SetRange("Test No", Rec."Test No.");
                            ItemJnlQCRecord.SetRange("Item No.", Rec."Item No.");
                            ItemJnlQCRecord.SetRange("Location Code", ItemQualityReq."Location Code");
                            ItemJnlQCRecord.SetRange("Lot No.", Rec."Lot No./Serial No.");
                            if not ItemJnlQCRecord.FindSet() then;
                            //base qty source
                            Clear(ItemLedgerEntry);
                            ItemLedgerEntry.Reset();
                            ItemLedgerEntry.SetRange("Item No.", Rec."Item No.");
                            ItemLedgerEntry.SetRange("Location Code", ItemQualityReq."Location Code");
                            ItemLedgerEntry.SetRange("Lot No.", Rec."Lot No./Serial No.");
                            if ItemLedgerEntry.FindSet() then begin
                                ItemLedgerEntry.CalcSums("Remaining Quantity");
                                updateitemlotQC.setParameter(ItemLedgerEntry."Remaining Quantity", ItemLedgerEntry."Dimension Set ID");
                                updateitemlotQC.SetTableView(ItemJnlQCRecord);
                                updateitemlotQC.RunModal();
                            end;
                            //ItemLedgerEntry.CalcSums("Remaining Quantity");
                            //if ItemLedgerEntry."Remaining Quantity" > 0 then begin
                            //updateitemlotQC.setParameter(ItemLedgerEntry."Remaining Quantity", ItemLedgerEntry."Dimension Set ID");
                            //updateitemlotQC.SetTableView(ItemJnlQCRecord);
                            //updateitemlotQC.RunModal();
                            //end;
                            //end;
                            //-
                            CurrPage.Update();
                        end;
                    end;
                }
                action("UpdateTypeNG")
                {
                    ApplicationArea = All;
                    Caption = 'Update Type NG';
                    Image = Item;
                    Visible = false;
                    trigger OnAction()
                    var
                        myInt: Integer;
                        updateitemlotQC: Page UpdateItemLotQC_PQ;
                        ItemJnlQCRecord: Record "Item Jnl. Update Lot QC";
                        ItemLedgerEntry: Record "Item Ledger Entry";
                        ItemQualityReq: Record ItemQualityRequirement_PQ;
                    begin
                        Clear(ItemQualityReq);
                        ItemQualityReq.SetRange("Item No.", Rec."Item No.");
                        ItemQualityReq.SetCurrentKey(Type, "Item No.", "Variant Code", "Starting Date");
                        ItemQualityReq.SetFilter("Starting Date", '<=%1', Today);
                        ItemQualityReq.SetRange(Type, ItemQualityReq.Type::"Item Output");
                        if ItemQualityReq.FindFirst() then begin
                            ItemQualityReq.Reset();
                            Clear(ItemJnlQCRecord);
                            ItemJnlQCRecord.Reset();
                            ItemJnlQCRecord.SetRange("Test No", Rec."Test No.");
                            ItemJnlQCRecord.SetRange("Item No.", Rec."Item No.");
                            ItemJnlQCRecord.SetRange("Location Code", ItemQualityReq."Location Code");
                            ItemJnlQCRecord.SetRange("Lot No.", Rec."Lot No./Serial No.");
                            if not ItemJnlQCRecord.FindSet() then;
                            //base qty source
                            Clear(ItemLedgerEntry);
                            ItemLedgerEntry.Reset();
                            ItemLedgerEntry.SetRange("Item No.", Rec."Item No.");
                            ItemLedgerEntry.SetRange("Location Code", ItemQualityReq."Location Code");
                            ItemLedgerEntry.SetRange("Lot No.", Rec."Lot No./Serial No.");
                            if ItemLedgerEntry.FindSet() then begin
                                updateitemlotQC.SetTableView(ItemJnlQCRecord);
                                updateitemlotQC.RunModal();
                            end;
                            CurrPage.Update();
                        end;
                    end;
                }
            }
            group(History)
            {
                Caption = 'History';
                action("Item Ledger Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Item Ledger Entries';
                    Image = ItemLedger;

                    trigger OnAction()
                    var
                        ItemLedgerEntry: Record "Item Ledger Entry";
                    begin
                        ItemLedgerEntry.SetRange("CCS Create from Test No.", Rec."Test No.");
                        Page.RunModal(Page::"Item Ledger Entries", ItemLedgerEntry);
                    end;
                }
            }
        }

        area(processing)
        {
            group("Item")
            {
                Caption = 'Item';
                Image = Item;

                action(CreateReturnOrder)
                {
                    ApplicationArea = All;
                    Caption = 'Create Return Order';
                    Image = CreateDocuments;
                    Enabled = IsEnableCreateReturnOrder;
                    ToolTip = 'Executes the Create Return Order action.';

                    trigger OnAction()
                    var
                        TempItemLedgerEntry: Record "Item Ledger Entry" temporary;
                        ItemLedgerEntry: Record "Item Ledger Entry";
                        PurchaseHeader: Record "Purchase Header";
                        PurchaseLine: Record "Purchase Line";
                        PurchRcptHeader: Record "Purch. Rcpt. Header";
                        PurchRcptLine: Record "Purch. Rcpt. Line";
                        SrcPurchHeader: Record "Purchase Header";
                        SrcPurchLine: Record "Purchase Line";
                        Text001: Label 'The Purchase Return Order was successfully created.';
                        Text002: Label 'The source document must be of type Purchase.';
                        Currency: Record Currency;
                    begin
                        PurchaseLine.SetRange("Document Type", Rec."Purchase Document Type");
                        PurchaseLine.SetRange("Document No.", Rec."Purchase Document No.");
                        if PurchaseLine.FindSet() then begin
                            if ConfirmManagement.GetResponseOrDefault(QCText007, true) then
                                Page.Run(Page::"Purchase Lines", PurchaseLine);
                            exit;
                        end;
                        ItemLedgerEntry.SetRange("CCS Quality Test", Rec."Test No.");
                        if not ItemLedgerEntry.FindFirst() then
                            exit;
                        if ItemLedgerEntry."Entry Type" <> ItemLedgerEntry."Entry Type"::Purchase then begin
                            Message(Text002);
                            exit;
                        end;

                        PurchRcptHeader.Get(ItemLedgerEntry."Document No.");
                        PurchRcptLine.Get(ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.");

                        if SrcPurchLine.Get(SrcPurchLine."Document Type"::Order, PurchRcptLine."Order No.", PurchRcptLine."Order Line No.") then begin
#if BC19
                            SrcPurchLine.GetPurchHeader(SrcPurchHeader, Currency);
#else
                            SrcPurchHeader := SrcPurchLine.GetPurchHeader();
#endif
                            PurchaseHeader.TransferFields(SrcPurchHeader);
                            PurchaseHeader.Status := PurchaseHeader.Status::Open;

                            PurchaseLine.TransferFields(SrcPurchLine);
                        end else begin
                            PurchaseHeader.TransferFields(PurchRcptHeader);
                            PurchaseLine.TransferFields(PurchRcptLine);
                        end;

                        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::"Return Order";
                        PurchaseHeader."No." := '';
                        PurchaseHeader."Pmt. Discount Date" := 0D;
                        PurchaseHeader.Insert(true);

                        PurchaseLine."Document Type" := PurchaseHeader."Document Type";
                        PurchaseLine."Document No." := PurchaseHeader."No.";
                        PurchaseLine."Quantity Received" := 0;
                        PurchaseLine."Qty. Received (Base)" := 0;
                        PurchaseLine."Qty. Rcd. Not Invoiced" := 0;
                        PurchaseLine."Qty. Rcd. Not Invoiced (Base)" := 0;
                        PurchaseLine."Quantity Invoiced" := 0;
                        PurchaseLine."Qty. Invoiced (Base)" := 0;
                        PurchaseLine."Test No." := Rec."Test No.";
                        PurchaseLine.Validate(Quantity, Rec."Qty. to Return");
                        PurchaseLine.Insert(true);

                        Rec."Purchase Document Type" := PurchaseHeader."Document Type";
                        Rec."Purchase Document No." := PurchaseHeader."No.";
                        Rec.Modify(false);

                        GetItemTrackingLines(TempItemLedgerEntry, Rec."Source No. Tracing", Rec."Source Line No.");
                        CreateReservationEntryForPurchaseLine(TempItemLedgerEntry, PurchaseLine);

                        Message(Text001);
                    end;
                }
                action(CreateTransferOrder)
                {
                    ApplicationArea = All;
                    Caption = 'Create Transfer Order';
                    Image = CreateDocuments;
                    Enabled = IsEnableCreateTransferOrder;
                    ToolTip = 'Executes the Create Transfer Order action.';

                    trigger OnAction()
                    var
                        QualityControlSetup: Record QCSetup_PQ;
                        TempItemLedgerEntry: Record "Item Ledger Entry" temporary;
                        ItemLedgerEntry: Record "Item Ledger Entry";
                        TransferHeader: Record "Transfer Header";
                        TransferLine: Record "Transfer Line";
                        Text001: Label 'The Transfer Order was successfully created.';
                    begin
                        TransferLine.SetRange("Document No.", Rec."Transfer No.");
                        if TransferLine.FindSet() then begin
                            if ConfirmManagement.GetResponseOrDefault(QCText007, true) then
                                Page.Run(Page::"Transfer Lines", TransferLine);
                            exit;
                        end;
                        if not QualityControlSetup.Get() then
                            exit;
                        ItemLedgerEntry.SetRange("CCS Quality Test", Rec."Test No.");
                        if not ItemLedgerEntry.FindFirst() then
                            exit;
                        ItemLedgerEntry.TestField("Location Code");

                        TransferHeader.Init();
                        TransferHeader.Validate("Transfer-from Code", ItemLedgerEntry."Location Code");
                        TransferHeader.Validate("Transfer-to Code", QualityControlSetup."Transfer-to Code");
                        TransferHeader.Insert(true);

                        TransferLine.Init();
                        TransferLine.Validate("Document No.", TransferHeader."No.");
                        TransferLine.Validate("Line No.", 10000);
                        TransferLine.Validate("Item No.", ItemLedgerEntry."Item No.");
                        TransferLine.Validate("Variant Code", ItemLedgerEntry."Variant Code");
                        TransferLine.Validate(Quantity, Rec."Qty. to Transfer");
                        TransferLine.Validate("CCS Test No.", Rec."Test No.");
                        TransferLine.Insert(true);

                        Rec."Transfer No." := TransferHeader."No.";
                        Rec.Modify(false);

                        GetItemTrackingLines(TempItemLedgerEntry, Rec."Source No. Tracing", Rec."Source Line No.");
                        CreateReservationEntryForTransferLine(TempItemLedgerEntry, TransferLine);

                        Message(Text001);
                    end;
                }
                action(CreateScrapLine)
                {
                    ApplicationArea = All;
                    Caption = 'Create Scrap Line';
                    Image = CreateDocuments;
                    Enabled = IsEnableCreateScrapLine;
                    ToolTip = 'Executes the Create Scrap Line action.';

                    trigger OnAction()
                    var
                        QualityControlSetup: Record QCSetup_PQ;
                        TempItemLedgerEntry: Record "Item Ledger Entry" temporary;
                        ItemLedgerEntry: Record "Item Ledger Entry";
                        ItemJournalLine: Record "Item Journal Line";
                        LineNo: Integer;
                        Text001: Label 'The Item Journal Lines was successfully created.';
                    begin
                        ItemJournalLine.SetRange("Journal Template Name", Rec."Item Journal Template Name");
                        ItemJournalLine.SetRange("Journal Batch Name", rec."Item Journal Batch Name");
                        ItemJournalLine.SetRange("Line No.", Rec."Item Journal Line No.");
                        if ItemJournalLine.FindSet() then begin
                            if ConfirmManagement.GetResponseOrDefault(QCText007, true) then
                                Page.Run(Page::"Item Journal Lines", ItemJournalLine);
                            exit;
                        end;
                        if not QualityControlSetup.Get() then
                            exit;
                        QualityControlSetup.TestField("Item Jnl Template for Scrap");
                        QualityControlSetup.TestField("Item Jnl Batch for Scrap");

                        ItemLedgerEntry.SetRange("CCS Quality Test", Rec."Test No.");
                        ItemLedgerEntry.SetRange("Item No.", Rec."Item No.");
                        if not ItemLedgerEntry.FindFirst() then
                            exit;

                        LineNo := 10000;
                        if ItemJournalLine.FindLast() then
                            LineNo := ItemJournalLine."Line No." + 10000;

                        Clear(ItemJournalLine);
                        ItemJournalLine.Init();
                        ItemJournalLine.Validate("Journal Template Name", QualityControlSetup."Item Jnl Template for Scrap");
                        ItemJournalLine.Validate("Journal Batch Name", QualityControlSetup."Item Jnl Batch for Scrap");
                        ItemJournalLine.Validate("Line No.", LineNo);
                        ItemJournalLine.Validate("Posting Date", WorkDate());
                        ItemJournalLine.Validate("Entry Type", ItemJournalLine."Entry Type"::"Negative Adjmt.");
                        // ItemJournalLine.Validate("Document No.", 'START-MANF');
                        ItemJournalLine.Validate("Item No.", ItemLedgerEntry."Item No.");
                        ItemJournalLine.Validate("Variant Code", ItemLedgerEntry."Variant Code");
                        ItemJournalLine.Validate("Location Code", ItemLedgerEntry."Location Code");
                        ItemJournalLine.Validate(Quantity, Rec."Qty. to Scrap");
                        ItemJournalLine.Validate("CCS Test No.", Rec."Test No.");
                        ItemJournalLine.Insert(true);

                        Rec."Item Journal Template Name" := QualityControlSetup."Item Jnl Template for Scrap";
                        Rec."Item Journal Batch Name" := QualityControlSetup."Item Jnl Batch for Scrap";
                        Rec."Item Journal Line No." := ItemJournalLine."Line No.";
                        Rec.Modify(false);

                        GetItemTrackingLines(TempItemLedgerEntry, Rec."Source No. Tracing", Rec."Source Line No.");
                        CreateReservationEntryForItemJnlLine(TempItemLedgerEntry, ItemJournalLine);

                        Message(Text001);
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Get Specification")
                {
                    ApplicationArea = All;
                    Caption = 'Get Specification';
                    Image = GetEntries;
                    ToolTip = 'Click to get specifications for this test';

                    trigger OnAction();
                    begin
                        // QualitySpecsCopy.GetSpecification(Rec); //QC7.3 Added
                    end;
                }
                action("Get Current Specifications")
                {
                    Caption = 'Get Current Specifications';
                    Image = GetEntries;
                    ToolTip = 'Click to get current specifications';
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction();
                    var
                        TestLines: Record QualityTestLines_PQ;
                    begin
                        //NP1 Start
                        TestLines.SETRANGE("Test No.", Rec."Test No.");
                        if TestLines.FINDFIRST then begin //Are there any Lines?
                            if UserIsQCMgr then begin
                                if CONFIRM(NPText003 + NPText004 + NPText005 + NPText006 + NPText007 + NPText008 + NPText009 + NPText001, false) then
                                    ;// QualitySpecsCopy.GetCurrSpecs(Rec); //Get if Permission is Given...
                            end else
                                MESSAGE(NPText003 + NPText010); //Tell Non-Manager that they cannot do this if Lines Exist
                        end else
                            ;// QualitySpecsCopy.GetCurrSpecs(Rec); //...or Get if No Test Lines
                             //NP1 Finish

                        //TESTFIELD("Item No.");
                        //VersionCode := QualitySpecsCopy.GetQCVersion("Item No.",'','',WORKDATE,0);  //Origin=0 QCTestCopy
                        //QualitySpecsCopy.TestGetSpecs(Rec,VersionCode);
                    end;
                }
                action("Get Customer Specifications")
                {
                    Caption = 'Get Customer Specifications';
                    Image = GetLines;
                    ToolTip = 'Click to get Customer specific specifications';
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        //NP1 Start
                        TestLines.SETRANGE("Test No.", Rec."Test No.");
                        if TestLines.FINDFIRST then begin //Are there any Lines?
                            if UserIsQCMgr then begin
                                if CONFIRM(NPText003 + NPText004 + NPText005 + NPText006 + NPText007 + NPText008 + NPText009 + NPText001, false) then
                                    ;// QualitySpecsCopy.GetCustSpecs(Rec); //Get if Permission is Given...
                            end else
                                MESSAGE(NPText003 + NPText010); //Tell Non-Manager that they cannot do this if Lines Exist
                        end else
                            ;// QualitySpecsCopy.GetCustSpecs(Rec); //...or Get if No Test Lines
                             //NP1 Finish

                        ////QC4SP1.2
                        //TESTFIELD("Item No.");
                        //TESTFIELD("Customer No.");
                        //VersionCode := QualitySpecsCopy.GetQCVersion("Item No.","Customer No.",'',WORKDATE,2);
                        //QualitySpecsCopy.TestGetCustSpecs(Rec,VersionCode);
                    end;
                }
                action("Transfer")
                {
                    Caption = 'Transfer';
                    Image = TransferReceipt;
                    ToolTip = 'Open Transfer Window';
                    ApplicationArea = All;
                    Visible = false;

                    trigger OnAction();
                    var
                        TransHeaderT: Record "Transfer Header";
                        TransferHeader: Record "Transfer Header";
                        TransferOrderPage: Page "Transfer Order";
                        QCText100: Label 'No Transfer Orders were found for the %1 Location. \';
                        QCText101: Label 'Do you wish to create one now?';
                    begin
                        //QC80.3 Start

                        CLEAR(TransferOrderPage);

                        QCSetupT.GET;

                        TransHeaderT.SETRANGE("Transfer-from Code", QCSetupT."Default QC Location");
                        if TransHeaderT.FINDFIRST then begin
                            TransferOrderPage.SETRECORD(TransHeaderT);
                            TransferOrderPage.RUN;
                        end else
                            if CONFIRM(QCText100 + QCText101, true, QCSetupT."Default QC Location") then begin
                                //Create Transfer Header
                                TransferHeader.INIT;
                                TransferHeader."No." := '';
                                TransferHeader.INSERT(true);
                                TransferHeader.VALIDATE("Transfer-from Code", QCSetupT."Default QC Location");
                                TransferHeader.MODIFY;
                                TransferOrderPage.SETRECORD(TransferHeader);
                                TransferOrderPage.RUN;
                            end;

                        //QC80.3 Finish
                    end;
                }
            }
        }

        area(Reporting)
        {
            action("Certificate of Analysis")
            {
                ApplicationArea = All;
                Caption = 'Certificate of Analysis';
                Image = Print;
                Enabled = CoAAvailable;
                ToolTip = 'Print the Certificate of Analysis';

                trigger OnAction();
                var
                    TestHeader: Record QualityTestHeader_PQ;
                    DoReport: Boolean;
                    TestLines: Record QualityTestLines_PQ;
                begin
                    //QC71.1 Start
                    //IF "Test Status" <> "Test Status"::"Certified Final" THEN BEGIN
                    //  TestHeader.SETRANGE("Item No.","Item No.");
                    //  TestHeader.SETRANGE("Customer No.","Customer No.");
                    //  TestHeader.SETRANGE("Test Status",TestHeader."Test Status"::"Certified Final");
                    //  IF TestHeader.FINDFIRST THEN BEGIN
                    //    IF NOT CONFIRM(NPText011 + NPText012,TRUE,TestHeader."Test No.") THEN
                    //      TestHeader := Rec; //Set up to print THIS Test as CoA
                    //  END;
                    //END;
                    // TestHeader := Rec;

                    CoAAvailable := Rec.CheckCoAAvailable;

                    DoReport := CoAAvailable;

                    QCStatusRuleResult := QCStatusRules.CheckCoAAvail(TestHeader);

                    if QCStatusRuleResult = 'Confirm' then begin
                        TestLines.SETRANGE("Test No.", TestHeader."Test No.");
                        TestLines.SETRANGE("Test Line Complete", false);
                        if TestLines.FINDFIRST then
                            DoReport := CONFIRM(QCText003 + NPText012);
                    end;

                    if DoReport then begin
                        TestHeader.SETRANGE("Test No.", TestHeader."Test No.");
                        //REPORT.RUN(REPORT::"Certificate of Analysis 1", true, true, TestHeader);
                    end;
                    //SETRANGE("Test No.");
                    //QC71.1 Finish
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    var
        ProdOrderLine: Record "Prod. Order Line";
        ILE: Record "Item Ledger Entry";
        QtyCalsum: Decimal;
    begin
        UserIsQCMgr := QualityFunctions.TestQCMgr;
        CoAAvailable := Rec.CheckCoAAvailable;

        ////RP-040924
        getInfoReceiptDate();

        QCHeaderDesc := '';
        //add new by rnd, 25 Apr 2025
        RestrictEditTest1();
        //-

        if Rec."Source Type" = Rec."Source Type"::"Output Journal" then begin
            Clear(ProdOrderLine);
            ProdOrderLine.SetRange("Prod. Order No.", Rec."Source No.");
            if ProdOrderLine.FindFirst() then begin
                Clear(ILE);
                Clear(QtyCalsum);
                ILE.SetRange("Document No.", ProdOrderLine."Prod. Order No.");
                ILE.SetRange("Item No.", Rec."Item No.");
                ILE.SetRange("Lot No.", Rec."Lot No.");
                ILE.SetRange("Entry Type", ILE."Entry Type"::Output);
                if ILE.FindSet() then begin
                    ILE.CalcSums(Quantity);
                    QtyCalsum := ILE.Quantity;
                    if Rec."Qty. Actual Test" <> QtyCalsum then
                        QCActvsFinish := 'Unfavorable'
                    else
                        QCActvsFinish := 'Favorable';
                end;
            end;

            if QCHeader.GET(Rec."Item No.") then begin
                QCHeaderDesc := QCHeader."Test Description";
                Rec."Unit of Measure" := QCHeader."Unit of Measure Code";
            end;

            Rec.CALCFIELDS(Failed);
            if Rec.Failed then begin
                WarnAlert := QCText002; //Warning!!!
                QCWarnVis := 'Unfavorable';
            end else begin
                if (Rec."Test Status" = Rec."Test Status"::Certified) and (not Rec.Failed) then begin
                    WarnAlert := 'PASSED';
                    QCWarnVis := 'Favorable';
                end else begin
                    WarnAlert := FORMAT(Rec."Test Status");
                    QCWarnVis := 'Strong';
                end;
            end;
            UpdateButtonAvailability();
            UpdateFieldEditable();
            CurrPage.UPDATE(false);
        end;
    end;

    trigger OnInit();
    begin
        QCHeaderDesc := '';
    end;

    trigger OnOpenPage()
    begin

        if not DefaultFilter then begin
            Rec.SetFilter("Test No.", Rec."Test No.");
            Rec.SetFilter("Test Status", '');
        end;

        RestrictEditTest();
        UpdateButtonAvailability();
        UpdateFieldEditable();
        HideInfoQty();
        // Rec.CalculateCertifiedQuantity();
    end;

    var
        QCHeader: Record QCSpecificationHeader_PQ;
        QualitySpecsCopy: Codeunit QCFunctionLibrary_PQ;
        VersionMgt: Codeunit VersionManagement;
        ActiveVersionCode: Code[20];
        QCVersion: Record QCSpecificationVersions_PQ;
        VersionCode: Code[10];
        QCHeaderDesc: Text[50];
        QCSetupT: Record QCSetup_PQ;
        WarnAlert: Text;
        TestLines: Record QualityTestLines_PQ;
        QCText002: Label 'NON-CONFORMANCE';
        "--QC71.1--": Integer;
        [InDataSet]
        UserIsQCMgr: Boolean;
        NPText001: Label 'Do you wish to continue?';
        NPText002: Label 'Click ''Yes'' to Get ALL Specifications,\\Click ''No'' to Get ''Mandatory'' Spec. Lines ONLY';
        QualityFunctions: Codeunit QCFunctionLibrary_PQ;
        NPText003: Label 'Test Lines Already Exist!\\';
        NPText004: Label 'If you choose to do this now, the following will happen:\\';
        NPText005: Label '1.   Any Tests in the Spec. that were Deleted here will be RESTORED.\\';
        NPText006: Label '2.  With the Exception of "Actual Measures"/"Results", any "Edits" to\';
        NPText007: Label '"     Tests here will be ""Refreshed"" with values from the Spec.\\"';
        NPText008: Label '3.  All Comments in this Test will be permanently Lost.\\';
        NPText009: Label '4.  All "Custom" Tests will be Retained without Change.\\';
        NPText010: Label 'Therefore, you must be a Quality Manager to Perform this Function.';
        NPText011: Label '%1 is the Certified Final Test for this Item/Customer Specification.\\';
        NPText012: Label 'Would you like to Print that Certificate of Analysis?';
        QCText003: Label 'Some Test Lines are Incomplete.\\';
        [InDataSet]
        CoAAvailable: Boolean;
        QCStatusRules: Record QCStatusRules_PQ;
        QCStatusRuleResult: Text;
        [InDataSet]
        QCWarnVis: Text[20];
        QCActvsFinish: Text[20];
        QCText004: Label 'Test Status is not set to "New"\\';
        QCText005: Label 'Selecting ''''Yes'''' will replace the existing Test!\\';
        QCText006: Label 'Do you wish to proceed?';
        QCText007: Label 'The document has already been created, do you want to open it?';
        DefaultFilter: Boolean;
        IsPurchaseReturnOrder: Boolean;
        IsTransferOrder: Boolean;
        IsItemJournal: Boolean;
        IsEnableCreateReturnOrder: Boolean;
        IsEnableCreateTransferOrder: Boolean;
        IsEnableCreateScrapLine: Boolean;
        IsTestQtyEditable: Boolean;
        NoSeriesMgt: Codeunit "No. Series";
        CertifiedQuantity: Decimal;
        ConfirmManagement: Codeunit "Confirm Management";
        CopyDocumentMgt: Codeunit "Copy Document Mgt.";
        vReceiptDate: Date;

    local procedure LotNoSerialNoOnAfterValidate();
    begin
        //QC71.1 - This Code is largely Unused for this version; instead "Get Specifications" and "Get Customer Specifications" Actions have been Resurrected
        //...and Enhanced

        Rec.TESTFIELD("Item No.");
    end;

    procedure DisableDefaultFilter(NewDefaultFilter: Boolean)
    begin
        DefaultFilter := NewDefaultFilter;
    end;

    local procedure RestrictEditTest()
    begin
        if Rec."Test Status" in [Rec."Test Status"::Closed] then
            CurrPage.Editable := false;
    end;

    local procedure RestrictEditTest1()
    begin
        glbrestrictEdit := true;
        if Rec."Test Status" in [Rec."Test Status"::Closed, Rec."Test Status"::Certified, Rec."Test Status"::Rejected, Rec."Test Status"::Hold, Rec."Test Status"::"Ready for Review"] then begin
            CurrPage.QCLine.Page.Editable := false;
            CurrPage.QCLine.Page.ForceLineEdit(false);
            glbrestrictEdit := false;
        end else begin
            CurrPage.QCLine.Page.Editable := true;
            CurrPage.QCLine.Page.ForceLineEdit(true);
            glbrestrictEdit := true;
        end;
    end;

    local procedure HideInfoQty()
    begin
        if Rec."Source Type" <> Rec."Source Type"::"Purchase Order" then
            glb_visible := true;
    end;

    var
        glb_visible: Boolean;
        glbrestrictEdit: Boolean;

    local procedure OpenItemTrackingLines()
    var
        QTHdr: Record QualityTestHeader_PQ;
        TrackingSpecification: Record "Tracking Specification";
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

    local procedure UpdateButtonAvailability()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        IsPurchaseReturnOrder := false;
        IsTransferOrder := true;    // There are no rules for the Transfer Quantity field yet
        IsItemJournal := true;      // There are no rules for the Scrap Quantity field yet

        ItemLedgerEntry.SetRange("CCS Quality Test", Rec."Test No.");
        if ItemLedgerEntry.FindFirst() then
            if ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::Purchase then
                IsPurchaseReturnOrder := true;

        IsEnableCreateReturnOrder := false;
        if IsPurchaseReturnOrder and (Rec."Qty. to Return" <> 0) then
            IsEnableCreateReturnOrder := true;
        IsEnableCreateTransferOrder := Rec."Qty. to Transfer" <> 0;
        IsEnableCreateScrapLine := Rec."Qty. to Scrap" <> 0;
    end;

    local procedure UpdateFieldEditable()
    begin
        QCSetupT.GetRecordOnce();
        IsTestQtyEditable := QCSetupT."Qty. to Test Editable";
    end;

    local procedure IsIncomingTransactions(): Boolean
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        ItemLedgerEntry.SetRange("CCS Quality Test", Rec."Test No.");
        if not ItemLedgerEntry.FindFirst() then
            exit(false);
        if ItemLedgerEntry.Quantity < 0 then
            exit(false);
        exit(true);
    end;

    local procedure GetItemTrackingLines(var TempItemLedgerEntry: Record "Item Ledger Entry" temporary; SourceDocumentNo: Code[20]; SourceDocumentLineNo: Integer)
    var
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
        RowID: Text[250];
    begin
        case Rec."Source Type" of
            QCSourceType_PQ::"Purchase Order":
                ItemTrackingDocMgt.RetrieveEntriesFromShptRcpt(TempItemLedgerEntry, Database::"Purch. Rcpt. Line", 0, SourceDocumentNo, '', 0, SourceDocumentLineNo);
            QCSourceType_PQ::"Purchase Return Order":
                begin
                    RowID := ItemTrackingMgt.ComposeRowID(Database::"Purch. Cr. Memo Line", 0, SourceDocumentNo, '', 0, SourceDocumentLineNo);
                    ItemTrackingDocMgt.RetrieveEntriesFromPostedInvoice(TempItemLedgerEntry, RowID);
                end;
            QCSourceType_PQ::"Sales Order":
                ItemTrackingDocMgt.RetrieveEntriesFromShptRcpt(TempItemLedgerEntry, Database::"Sales Shipment Line", 0, SourceDocumentNo, '', 0, SourceDocumentLineNo);
            QCSourceType_PQ::"Sales Return Receipt":
                begin
                    RowID := ItemTrackingMgt.ComposeRowID(Database::"Sales Cr.Memo Line", 0, SourceDocumentNo, '', 0, SourceDocumentLineNo);
                    ItemTrackingDocMgt.RetrieveEntriesFromPostedInvoice(TempItemLedgerEntry, RowID);
                end;
            QCSourceType_PQ::"Transfer Order":
                ItemTrackingDocMgt.RetrieveEntriesFromShptRcpt(TempItemLedgerEntry, Database::"Transfer Receipt Line", 0, SourceDocumentNo, '', 0, SourceDocumentLineNo);
        end;
    end;

    local procedure CreateReservationEntryForPurchaseLine(var TempItemLedgerEntry: Record "Item Ledger Entry" temporary; PurchaseLine: Record "Purchase Line")
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        if not TempItemLedgerEntry.FindSet() then
            exit;
        repeat
            ReservationEntry.Init();
            ReservationEntry."Entry No." := NextEntryNo;
            ReservationEntry."Item No." := PurchaseLine."No.";
            ReservationEntry.Description := PurchaseLine.Description;
            ReservationEntry."Location Code" := PurchaseLine."Location Code";
            ReservationEntry."Variant Code" := PurchaseLine."Variant Code";
            ReservationEntry.Validate("Quantity (Base)", -TempItemLedgerEntry.Quantity);
            ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Surplus;
            ReservationEntry."Source Type" := Database::"Purchase Line";
            ReservationEntry."Source Subtype" := PurchaseLine."Document Type"::"Return Order".AsInteger();
            ReservationEntry."Source ID" := PurchaseLine."Document No.";
            ReservationEntry."Source Ref. No." := PurchaseLine."Line No.";
            ReservationEntry."Expected Receipt Date" := PurchaseLine."Expected Receipt Date";
            ReservationEntry."Qty. per Unit of Measure" := TempItemLedgerEntry."Qty. per Unit of Measure";
            ReservationEntry.Validate("Lot No.", TempItemLedgerEntry."Lot No.");
            ReservationEntry.Validate("Serial No.", TempItemLedgerEntry."Serial No.");
            ReservationEntry."Item Tracking" := TempItemLedgerEntry."Item Tracking";
            ReservationEntry."Created By" := UserId;
            ReservationEntry.Positive := false;
            ReservationEntry."Creation Date" := WorkDate();
            ReservationEntry.Insert();
        until TempItemLedgerEntry.Next() = 0;
    end;

    local procedure CreateReservationEntryForTransferLine(var TempItemLedgerEntry: Record "Item Ledger Entry" temporary; TransferLine: Record "Transfer Line")
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        if not TempItemLedgerEntry.FindSet() then
            exit;
        repeat
            // Outbound
            ReservationEntry.Init();
            ReservationEntry."Entry No." := NextEntryNo;
            ReservationEntry."Item No." := TransferLine."Item No.";
            ReservationEntry.Description := TransferLine.Description;
            ReservationEntry."Location Code" := TransferLine."Transfer-from Code";
            ReservationEntry."Variant Code" := TransferLine."Variant Code";
            ReservationEntry.Validate("Quantity (Base)", -TempItemLedgerEntry.Quantity);
            ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Surplus;
            ReservationEntry."Source Type" := Database::"Transfer Line";
            ReservationEntry."Source Subtype" := Enum::"Transfer Direction"::Outbound.AsInteger();
            ReservationEntry."Source ID" := TransferLine."Document No.";
            ReservationEntry."Source Ref. No." := TransferLine."Line No.";
            ReservationEntry."Shipment Date" := TransferLine."Shipment Date";
            ReservationEntry."Qty. per Unit of Measure" := TempItemLedgerEntry."Qty. per Unit of Measure";
            ReservationEntry.Validate("Lot No.", TempItemLedgerEntry."Lot No.");
            ReservationEntry.Validate("Serial No.", TempItemLedgerEntry."Serial No.");
            ReservationEntry."Item Tracking" := TempItemLedgerEntry."Item Tracking";
            ReservationEntry."Created By" := UserId;
            ReservationEntry.Positive := false;
            ReservationEntry."Creation Date" := WorkDate();
            ReservationEntry.Insert();

            // Inbound
            ReservationEntry.Init();
            ReservationEntry."Entry No." := NextEntryNo;
            ReservationEntry."Item No." := TransferLine."Item No.";
            ReservationEntry.Description := TransferLine.Description;
            ReservationEntry."Location Code" := TransferLine."Transfer-to Code";
            ReservationEntry."Variant Code" := TransferLine."Variant Code";
            ReservationEntry.Validate("Quantity (Base)", TempItemLedgerEntry.Quantity);
            ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Surplus;
            ReservationEntry."Source Type" := Database::"Transfer Line";
            ReservationEntry."Source Subtype" := Enum::"Transfer Direction"::Inbound.AsInteger();
            ReservationEntry."Source ID" := TransferLine."Document No.";
            ReservationEntry."Source Ref. No." := TransferLine."Line No.";
            ReservationEntry."Expected Receipt Date" := TransferLine."Receipt Date";
            ReservationEntry."Qty. per Unit of Measure" := TempItemLedgerEntry."Qty. per Unit of Measure";
            ReservationEntry.Validate("Lot No.", TempItemLedgerEntry."Lot No.");
            ReservationEntry.Validate("Serial No.", TempItemLedgerEntry."Serial No.");
            ReservationEntry."Item Tracking" := TempItemLedgerEntry."Item Tracking";
            ReservationEntry."Created By" := UserId;
            ReservationEntry.Positive := true;
            ReservationEntry."Creation Date" := WorkDate();
            ReservationEntry.Insert();
        until TempItemLedgerEntry.Next() = 0;
    end;

    local procedure CreateReservationEntryForItemJnlLine(var TempItemLedgerEntry: Record "Item Ledger Entry" temporary; ItemJnlLine: Record "Item Journal Line")
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        if not TempItemLedgerEntry.FindSet() then
            exit;
        repeat
            ReservationEntry.Init();
            ReservationEntry."Entry No." := NextEntryNo;
            ReservationEntry."Item No." := ItemJnlLine."Item No.";
            ReservationEntry.Description := ItemJnlLine.Description;
            ReservationEntry."Location Code" := ItemJnlLine."Location Code";
            ReservationEntry."Variant Code" := ItemJnlLine."Variant Code";
            ReservationEntry.Validate("Quantity (Base)", -TempItemLedgerEntry.Quantity);
            ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Prospect;
            ReservationEntry."Source Type" := Database::"Item Journal Line";
            ReservationEntry."Source Subtype" := ItemJnlLine."Entry Type"::"Negative Adjmt.".AsInteger();
            ReservationEntry."Source ID" := ItemJnlLine."Journal Template Name";
            ReservationEntry."Source Batch Name" := ItemJnlLine."Journal Batch Name";
            ReservationEntry."Source Ref. No." := ItemJnlLine."Line No.";
            ReservationEntry."Shipment Date" := ItemJnlLine."Posting Date";
            ReservationEntry."Qty. per Unit of Measure" := TempItemLedgerEntry."Qty. per Unit of Measure";
            ReservationEntry.Validate("Lot No.", TempItemLedgerEntry."Lot No.");
            ReservationEntry.Validate("Serial No.", TempItemLedgerEntry."Serial No.");
            ReservationEntry."Item Tracking" := TempItemLedgerEntry."Item Tracking";
            ReservationEntry."Created By" := UserId;
            ReservationEntry.Positive := false;
            ReservationEntry."Creation Date" := WorkDate();
            ReservationEntry.Insert();
        until TempItemLedgerEntry.Next() = 0;
    end;

    local procedure RetrieveEntriesFromProdOrderComp(var TempItemLedgEntry: Record "Item Ledger Entry" temporary; Type: Integer; ID: Code[20]; ProdOrderLine: Integer; RefNo: Integer)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        CountingRecordsMsg: Label 'Counting records...';
        Window: Dialog;
    begin
        Window.Open(CountingRecordsMsg);
        ItemLedgEntry.SetCurrentKey("Order Type", "Order No.", "Order Line No.",
          "Entry Type", "Prod. Order Comp. Line No.");
        ItemLedgEntry.SetRange("Order Type", ItemLedgEntry."Order Type"::Production);
        ItemLedgEntry.SetRange("Order No.", ID);
        ItemLedgEntry.SetRange("Order Line No.", ProdOrderLine);
        case Type of
            Database::"Prod. Order Line":
                begin
                    ItemLedgEntry.SetRange("Entry Type", ItemLedgEntry."Entry Type"::Output);
                    ItemLedgEntry.SetRange("Prod. Order Comp. Line No.", 0);
                end;
            Database::"Prod. Order Component":
                begin
                    ItemLedgEntry.SetRange("Entry Type", ItemLedgEntry."Entry Type"::Consumption);
                    ItemLedgEntry.SetRange("Prod. Order Comp. Line No.", RefNo);
                end;
        end;
        if ItemLedgEntry.FindSet() then
            repeat
                if ItemLedgEntry.TrackingExists() then begin
                    TempItemLedgEntry := ItemLedgEntry;
                    TempItemLedgEntry.Insert();
                end
            until ItemLedgEntry.Next() = 0;
        Window.Close();
    end;

    local procedure NextEntryNo(): Integer
    var
        ReserveEntry: Record "Reservation Entry";
        LastEntryNo: Integer;
    begin
        ReserveEntry.Reset();
        if ReserveEntry.FindLast() then
            LastEntryNo := ReserveEntry."Entry No.";
        LastEntryNo += 1;
        exit(LastEntryNo);
    end;

    //RP-040924
    local procedure getInfoReceiptDate()
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
            vReceiptDate := ILE."Posting Date"
        else
            vReceiptDate := 0D;
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
}
