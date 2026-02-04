namespace ACCOUNTING.ACCOUNTING;

using Microsoft.Finance.GeneralLedger.Journal;

pageextension 51108 PaymentJournal_AF extends "Payment Journal"
{
    layout
    {
        addafter("External Document No.")
        {
            field("PIB/PEB No"; Rec."PIB/PEB No")
            {
                ApplicationArea = All;
            }
            field(Payee; Rec.Payee)
            {
                ApplicationArea = All;
            }
            field("Payee Name"; Rec."Payee Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    actions
    {
        addafter(Preview)
        {
            group("Report")
            {
                Caption = 'Report';

                action("Report Cash Voucher (Preview)")
                {
                    Caption = 'Cash Voucher (Preview) Type 1';
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        PostingPreviewEventHandler: Codeunit "Posting Preview Handler";
                        VoucherType: Enum "Voucher Type";
                    begin
                        PostingPreviewEventHandler.PreviewVoucherReport(Format(Rec."Document No."), VoucherType::"Cash Receipt", 1);
                    end;
                }
                action("Report Cash Voucher (Preview) Type1")
                {
                    Caption = 'Cash Voucher (Preview) Type 2';
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        PostingPreviewEventHandler: Codeunit "Posting Preview Handler";
                        VoucherType: Enum "Voucher Type";
                    begin
                        PostingPreviewEventHandler.PreviewVoucherReport(Format(Rec."Document No."), VoucherType::"Cash Receipt", 2);
                    end;
                }

                action("Payment Voucher")
                {
                    Caption = 'Payment Request (Preview)';
                    Image = PrintVoucher;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        PostingPreviewEventHandler: Codeunit "Posting Preview Handler";
                        VoucherType: Enum "Voucher Type";
                    begin
                        PostingPreviewEventHandler.PreviewVoucherReport(Format(Rec."Document No."), VoucherType::Payment, 0);
                    end;
                }
            }

        }
    }
}
