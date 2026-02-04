pageextension 50330 PurchaseQuote_SP extends "Purchase Quote"
{
    Caption = 'Purchase Request';
    layout
    {
        addafter(Status)
        {
            field(Reason; Rec.Reason)
            {
                ApplicationArea = All;
            }
            field(Purpose; Rec.Purpose)
            {
                ApplicationArea = All;
            }

            field("Order Type"; Rec."Order Type")
            {
                ApplicationArea = All;
            }
            field("PO No."; Rec."PO No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Already Done"; Rec."Already Done")
            {
                ApplicationArea = All;
            }
            field(Service; Rec.Service)
            {
                ApplicationArea = All;
            }
            field(Notes; Rec.Notes)
            {
                Caption = 'Notes';
                ApplicationArea = All;
                MultiLine = true;
            }
            field(Application; Rec.Application)
            {
                ApplicationArea = All;
            }
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = All;
            }
        }
        modify("Shortcut Dimension 1 Code")
        {
            ShowMandatory = true;
        }
    }

    actions
    {
        addafter(Print)
        {
            action("&Print1")
            {
                ApplicationArea = Suite;
                Caption = '&Print.';
                Ellipsis = true;
                Image = Print;
                ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    CurrPage.SetSelectionFilter(PurchaseHeader);
                    REPORT.Run(REPORT::"Purchase Request", true, false, PurchaseHeader);
                end;
            }
        }
        modify("Make Order")
        {
            Enabled = not (Rec."PO No." <> '');
        }
        modify(Reopen)
        {
            Enabled = (Rec."PO No." = '');
        }
        modify(SendApprovalRequest)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                Rec.TestField("Shortcut Dimension 1 Code");
                validationCheck();
            end;
        }
        modify(Release)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                Rec.TestField("Shortcut Dimension 1 Code");
                validationCheck();
            end;
        }
    }

    local procedure validationCheck()
    var
        myInt: Integer;
        PurchLines: Record "Purchase Line";
        GeneralLedgerSetup: Record "General Ledger Setup";
        Item: Record Item;
    begin
        GeneralLedgerSetup.Get();
        PurchLines.Reset();
        PurchLines.SetRange("Document No.", Rec."No.");
        PurchLines.SetRange("Document Type", PurchLines."Document Type"::Quote);
        if PurchLines.FindSet() then begin
            repeat
                Clear(PurchMgt);
                if PurchLines.Type = PurchLines.Type::Item then begin
                    //Budget Code
                    PurchMgt.checkDimValue(PurchLines."Dimension Set ID", PurchLines."No.", PurchLines."Line No.", GeneralLedgerSetup."Shortcut Dimension 7 Code");
                end;
            until PurchLines.Next() = 0;
        end;
    end;

    var
        PurchMgt: Codeunit PurchManagement_SP;
}
