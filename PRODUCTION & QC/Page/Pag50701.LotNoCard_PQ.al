page 50701 LotNoCard_PQ
{
    // version QC10.1 - OBSOLETE?

    // //QC7.2
    //   - Added Promoted Actions Category "Lot No.", and assigned various Actions to it
    //   - Promoted Certain Actions
    // 
    // //QC7.3
    //   - Added "Item Tracing" Action
    // 
    // QC90 
    //   - Change Action "Item &Tracking Entries" to match Action of the Same Name in "Lot No. Information Card" Page

    Caption = 'Lot No. Information Card';
    Editable = true;
    PageType = Card;
    PopulateAllFields = true;
    PromotedActionCategories = 'New,Process,Report,Lot No.';
    SourceTable = "Lot No. Information";
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Item No."; Rec."Item No.")
                {
                    Editable = false;
                    ToolTip = 'Item No. specified for this lot';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Description';
                    Editable = false;
                    ToolTip = 'Contains the description of the Item in this Lot';
                    ApplicationArea = All;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    Editable = false;
                    ToolTip = 'If this particular Lot has any variant, the code is displayed here';
                    ApplicationArea = All;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the lot number';
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'If checked, this lot no is blocked for some reason, generally due to non-compliance';
                    ApplicationArea = All;
                }
                field("Lot Test Exists"; Rec."Lot Test Exists")
                {
                    Editable = false;
                    ToolTip = 'Indicates if Tests exist for this Lot';
                    ApplicationArea = All;
                }
                field("Qty on Hand"; Rec."Qty on Hand")
                {
                    ToolTip = 'Quantity on Hand in this Lot';
                    ApplicationArea = All;
                }
                field("Expired Inventory"; Rec."Expired Inventory")
                {
                    ToolTip = '"Indicates if the inventory in the Lot is expired "';
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
                    ToolTip = 'Click to view Item Tracking Entries';
                    ApplicationArea = All;
                    Visible = false;

                    trigger OnAction();
                    var
                        ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
                    begin
                        //ItemTrackingDocMgt.ShowItemTrackingForMasterData(0, '', "Item No.", "Variant Code", '', "Lot No.", '');
                    end;
                }
                action("Item Tracing")
                {
                    Caption = 'Item Tracing';
                    Image = ItemTracing;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Item Tracing";
                    RunPageLink = "Item No." = FIELD(FILTER("Item No.")),
                                  "Lot No." = FIELD(FILTER("Lot No."));
                    ToolTip = 'Click to Trace the Lot Number';
                    ApplicationArea = All;
                }
                action("Comment")
                {
                    Caption = 'Comment';
                    Image = Note;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Item Tracking Comments";
                    RunPageLink = Type = CONST("Lot No."),
                                  "Item No." = FIELD("Item No."),
                                  "Variant Code" = FIELD("Variant Code"),
                                  "Serial/Lot No." = FIELD("Lot No.");
                    ToolTip = 'Edit Comments';
                    ApplicationArea = All;
                }
                action("QC &Specifications")
                {
                    Caption = 'Quality &Specifications';
                    Image = Design;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page QCSpecificationList_PQ;
                    RunPageLink = "Item No." = FIELD("Item No.");
                    RunPageView = SORTING("Item No.", "Customer No.", Type);
                    ToolTip = 'Click to edit the QC Specification List';
                    ApplicationArea = All;
                }
                action("&QC Testing")
                {
                    Caption = '&Quality Testing';
                    Image = Evaluate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page QCTestList_PQ;
                    RunPageLink = "Item No." = FIELD("Item No."),
                                  "Lot No./Serial No." = FIELD("Lot No.");
                    RunPageView = SORTING("Item No.", "Lot No./Serial No.");
                    ToolTip = 'Click to open the QC Test List';
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage();
    begin
        Rec.SETRANGE("Date Filter", 00000101D, WORKDATE);
    end;
}

