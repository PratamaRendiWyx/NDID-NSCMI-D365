page 50702 LotNoList_PQ
{
    // version QC13.02

    //   //QC7.2 
    //   - Added Promoted Actions Category "Lot No.", and assigned various Actions to it
    //   - Promoted Certain Actions
    //   - Added "Non-Conformance" Field
    //   - Added Variable and Logic to Style certain fields based on "Non-Conformance"
    // 
    // //QC7.3 
    //   - Added "Item Tracing" Action
    // 
    // QC90  
    //   - Change Action "Item &Tracking Entries" to comport with Action of the Same Name in "Lot No. Information Card" Page
    // QC13.02 
    //      - Added "UsageCategory" and "ApplicationArea" to make Page Searchable
    //      - Changed Caption to start with "Quality" (rather than "AM") to make Search Consistent with Quality Item Specs

    Caption = 'Quality Lot No. List';
    CardPageID = LotNoCard_PQ;
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Lot No.';
    SourceTable = "Lot No. Information";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Item No."; Rec."Item No.")
                {
                    Editable = false;
                    Style = Unfavorable;
                    StyleExpr = WarnAlert;
                    ApplicationArea = All;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    Editable = false;
                    Visible = true;
                    ApplicationArea = All;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    Editable = false;
                    Style = Unfavorable;
                    StyleExpr = WarnAlert;
                    ApplicationArea = All;
                }
                field("Lot Test Exists"; Rec."Lot Test Exists")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Non-Conformance"; Rec."Non-Conformance")
                {
                    Style = Unfavorable;
                    StyleExpr = WarnAlert;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Inventory; Rec.Inventory)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
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
            group("Lot &No.")
            {
                Caption = 'Lot &No.';
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
                        //ItemTrackingDocMgt.ShowItemTrackingForMasterData(0, '', "Item No.", "Variant Code", '', "Lot No.", '');
                    end;
                }
                action("AMQCComment")
                {
                    Caption = 'Comment';
                    Image = Note;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Item Tracking Comments";
                    RunPageLink = Type = CONST("Lot No."),
                                  "Item No." = FIELD("Item No."),
                                  "Variant Code" = FIELD("Variant Code"),
                                  "Serial/Lot No." = FIELD("Lot No.");
                    ToolTip = 'Edit Comments';
                    ApplicationArea = All;
                }
                action("Item Tracing")
                {
                    Caption = 'Item Tracing';
                    Image = ItemTracing;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Item Tracing";
                    ToolTip = 'Click to open Item Tracing Page';
                    ApplicationArea = All;
                }
                action("QC &Specifications")
                {
                    Caption = 'Quality &Specifications';
                    Image = Design;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page QCSpecificationList_PQ;
                    RunPageLink = "Item No." = FIELD("Item No.");
                    RunPageView = SORTING("Item No.", "Customer No.", Type);
                    ToolTip = 'Click to open Quality Specification List';
                    ApplicationArea = All;
                }
                action("&QC Testing")
                {
                    Caption = '&Quality Tests';
                    Image = Evaluate;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page QCTestList_PQ;
                    RunPageLink = "Item No." = FIELD("Item No."),
                                  "Lot No./Serial No." = FIELD("Lot No.");
                    RunPageView = SORTING("Item No.", "Lot No./Serial No.");
                    ToolTip = 'Click to open Quality Control Test List';
                    ApplicationArea = All;
                }
            }
        }
        area(reporting)
        {
        }
    }

    trigger OnAfterGetRecord();
    begin
        //QC7.2 Start
        WarnAlert := false;
        //CALCFIELDS(Rec."Non-Conformance");
        WarnAlert := Rec."Non-Conformance";
        //QC7.2 Finish
    end;

    var
        [InDataSet]
        WarnAlert: Boolean;
}

