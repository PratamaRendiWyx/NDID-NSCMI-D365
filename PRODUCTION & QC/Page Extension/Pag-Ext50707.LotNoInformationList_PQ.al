pageextension 50707 LotNoInformationList_PQ extends "Lot No. Information List"
{

    layout
    {
        addafter("Item No.")
        {
            field(AMItemNo1; Rec."Item No.")
            {
                ApplicationArea = All;
            }
            field(AMRelocDescription; Rec.Description)
            {
                ApplicationArea = All;
            }
        }
        addafter("Lot No.")
        {
            field("Status"; Rec."CCS Status")
            {
                ApplicationArea = All;
            }
            field("Lot Test Exists"; Rec."Lot Test Exists")
            {
                Editable = false;
                ApplicationArea = All;
                Visible = false;
            }
            field("Non-Conformance"; Rec."Non-Conformance")
            {
                Style = Strong;
                StyleExpr = TRUE;
                ApplicationArea = All;
                Visible = false;
            }
        }
        addafter("Certificate Number")
        {
            field("Expiration Date"; Rec."CCS Expiration Date")
            {
                ApplicationArea = All;
                ToolTip = 'Updates the related Item ledger entries with a new Expiration date';
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
                ApplicationArea = All;
            }
            field("QtPOy on Hand"; Rec."Qty on Hand")
            {
                ApplicationArea = All;
            }
        }
        modify("Test Quality")
        {
            Visible = false;
        }
        modify(Description)
        {
            Visible = false;
        }
        modify("Expired Inventory")
        {
            Visible = true;
        }
        movebefore(CommentField; "Expired Inventory")
        modify(Blocked)
        {
            Visible = false;
        }
        modify("Certificate Number")
        {
            Visible = false;
        }
    }
    actions
    {
        addafter("&Lot No.")
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
                action("QC Testing")
                {
                    Caption = '[Under Process] Quality Tests';
                    Image = Evaluate;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page QCTestList_PQ;
                    RunPageLink = "Item No." = FIELD("Item No."),
                              "Lot No./Serial No." = FIELD("Lot No.");
                    RunPageView = SORTING("Item No.", "Lot No./Serial No.");
                    ToolTip = 'Click to open Quality Test List';
                    ApplicationArea = All;
                }
            }
        }

    }
}
