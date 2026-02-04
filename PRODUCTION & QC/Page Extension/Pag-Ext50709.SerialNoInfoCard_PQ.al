pageextension 50709 SerialNoInfoCard_PQ extends "Serial No. Information Card"
{

    layout
    {
        addafter("Serial No.")
        {
            field("Expiration Date"; Rec."CCS Expiration Date")
            {
                ApplicationArea = All;
                ToolTip = 'Updates the related Item ledger entries with a new Expiration date';
            }
        }
        addafter(Description)
        {
            field("Lot Status"; Rec."CCS Status")
            {
                ApplicationArea = All;
            }
            field("No. of Quality Tests"; Rec."No. of Quality Tests")
            {
                Editable = false;
                ToolTip = 'Indicates how much Tests exist for this Lot';
                ApplicationArea = All;
            }
        }
        modify(Blocked)
        {
            Visible = false;
        }
    }
    actions
    {
        addafter("&Item Tracing")
        {
            action("AMQC &Specifications")
            {
                Caption = 'Quality &Specifications';
                Image = Design;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page QCSpecificationList_PQ;
                RunPageLink = "Item No." = FIELD("Item No.");
                RunPageView = SORTING("Item No.", "Customer No.", Type);
                ToolTip = 'Click to edit the Quality Specification List';
                ApplicationArea = All;
            }
            action("QC Testing")
            {
                Caption = '&Quality Testing';
                Image = Evaluate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page QCTestList_PQ;
                RunPageLink = "Item No." = FIELD("Item No."),
                              "Lot No./Serial No." = FIELD("Serial No.");
                RunPageView = SORTING("Item No.", "Lot No./Serial No.");
                ToolTip = 'Click to open the Quality Test List';
                ApplicationArea = All;
            }
        }
    }
}

