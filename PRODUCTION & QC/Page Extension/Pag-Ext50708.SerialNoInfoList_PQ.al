pageextension 50708 SerialNoInfoList_PQ extends "Serial No. Information List"
{

    layout
    {
        addafter("Item No.")
        {
            field(ItemNo1; Rec."Item No.")
            {
                ApplicationArea = All;
            }
            field(PQDescription; Rec.Description)
            {
                ApplicationArea = All;
            }
        }
        addafter("Serial No.")
        {
            field("Status"; Rec."CCS Status")
            {
                ApplicationArea = All;
            }
            field("Expiration Date"; Rec."CCS Expiration Date")
            {
                ApplicationArea = All;
            }
            field("Date Created"; DT2DATE(Rec.SystemCreatedAt))
            {
                ApplicationArea = All;
                Caption = 'Date Created';
                ToolTip = 'Date Created';
            }
            field("Date Received"; Rec."CCS Date Received")
            {
                ApplicationArea = All;
            }
            field("Date Certified"; Rec."CCS Date Certified")
            {
                ApplicationArea = All;
            }
            field("No. of Quality Tests"; Rec."No. of Quality Tests")
            {
                Editable = false;
                ApplicationArea = All;
            }
            field("Qty on Hand"; Rec."Qty on Hand")
            {
                ApplicationArea = All;
            }
        }
        modify(Description)
        {
            Visible = false;
        }
        modify("Expired Inventory")
        {
            Visible = true;
        }
        movebefore(Control16; "Expired Inventory")
        modify(Blocked)
        {
            Visible = false;
        }

    }

    actions
    {
        addafter("&Serial No.")
        {
            group("Quality")
            {
                Caption = 'Quality';
                Image = PreviewChecks;
                action("QC &Specifications")
                {
                    Caption = 'Quality &Specifications';
                    Image = Design;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page QCSpecificationList_PQ;
                    RunPageLink = "Item No." = FIELD("Item No.");
                    RunPageView = SORTING("Item No.", "Customer No.", Type);
                    ToolTip = 'Click to open Quality Specification List';
                    ApplicationArea = All;
                }
                action("&QC Testing")
                {
                    Caption = '[Under Process] Quality Tests';
                    Image = Evaluate;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page QCTestList_PQ;
                    RunPageLink = "Item No." = FIELD("Item No."),
                              "Lot No./Serial No." = FIELD("Serial No.");
                    RunPageView = SORTING("Item No.", "Lot No./Serial No.");
                    ToolTip = 'Click to open Quality Test List';
                    ApplicationArea = All;
                }
            }
        }

    }
        
}
