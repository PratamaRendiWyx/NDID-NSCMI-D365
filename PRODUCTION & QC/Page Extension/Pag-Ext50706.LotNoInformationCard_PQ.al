pageextension 50706 LotNoInformationCard_PQ extends "Lot No. Information Card"
{

    layout
    {
        addafter("Lot No.")
        {
            field("Lot Test Exists"; Rec."Lot Test Exists")
            {
                Editable = false;
                ToolTip = 'Indicates if Tests exist for this Lot';
                ApplicationArea = All;
                Visible = false;
            }

            field("Expiration Date"; Rec."CCS Expiration Date")
            {
                ApplicationArea = All;
                ToolTip = 'Updates the related Item ledger entries with a new Expiration date';
            }
        }
        addafter("Certificate Number")
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
        modify("Test Quality")
        {
            Visible = false;
        }
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
        addafter("&Item Tracing")
        {
            action("QC&Specifications")
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
            action("QCTesting")
            {
                Caption = '&Quality Testing';
                Image = Evaluate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page QCTestList_PQ;
                RunPageLink = "Item No." = FIELD("Item No."),
                              "Lot No./Serial No." = FIELD("Lot No.");
                RunPageView = SORTING("Item No.", "Lot No./Serial No.");
                ToolTip = 'Click to open the Quality Test List';
                ApplicationArea = All;
            }

            action("UpdateItemLot")
            {
                ApplicationArea = All;
                Caption = 'Update Lot (Reclass)';
                Image = Journal;
                ToolTip = 'Update lot Item to New Item Lot.';
                trigger OnAction()
                var
                    myInt: Integer;
                    updateitemlot: Page UpdateItemLot_PQ;
                    ItemJnlQCRecord: Record "Item Jnl. Update Lot";
                begin
                    Clear(ItemJnlQCRecord);
                    ItemJnlQCRecord.Reset();
                    ItemJnlQCRecord.SetRange("Item No.", Rec."Item No.");
                    ItemJnlQCRecord.SetRange("Lot No.", Rec."Lot No.");
                    if not ItemJnlQCRecord.FindSet() then;
                    //Reclass | Transfer list
                    updateitemlot.setParameter(Rec."Lot No.");
                    updateitemlot.SetTableView(ItemJnlQCRecord);
                    updateitemlot.RunModal();
                    CurrPage.Update();
                end;
            }

            group("AM&Report")
            {
                Caption = '&Report';
            }
        }
    }

}

