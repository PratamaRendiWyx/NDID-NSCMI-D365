namespace ACCOUNTING.ACCOUNTING;

using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Purchases.Vendor;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.FixedAssets.FixedAsset;
using Microsoft.Bank.BankAccount;
using Microsoft.HumanResources.Employee;
using Microsoft.Sales.Customer;
using System.Environment.Configuration;
using Microsoft.Finance.GeneralLedger.Ledger;

pageextension 51109 PostedGeneralJournal_AF extends "Posted General Journal"
{
    layout
    {
        addafter(Description)
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

        addafter("Account No.")
        {
            field(getAccountName; getAccountName)
            {
                Caption = 'Account Name';
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
    actions
    {
        addafter(CopyRegister)
        {
            action("Report Cash Voucher (Posted)")
            {
                Caption = 'Cash Voucher (Posted) Type 1';
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    PostedGenJournal.SetFilter("Document No.", Rec."Document No.");
                    REPORT.Run(REPORT::"Cash Voucher (Posted)", true, false, PostedGenJournal);
                end;
            }
            action("Report Cash Voucher (Posted) Type1")
            {
                Caption = 'Cash Voucher (Posted) Type 2';
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    PostedGenJournal.SetFilter("Document No.", Rec."Document No.");
                    REPORT.Run(REPORT::"Cash Voucher (Posted) Type 2", true, false, PostedGenJournal);
                end;
            }
            action("Report Journal Voucher (Posted)")
            {
                Caption = 'Journal Voucher (Posted)';
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    PostedGenJournal.SetFilter("Document No.", Rec."Document No.");
                    REPORT.Run(REPORT::"Journal Voucher (Posted)", true, false, PostedGenJournal);
                end;
            }
            action("Payment Request")
            {
                Caption = 'Payment Request (Posted)';
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    PostedGenJournal.SetFilter("Document No.", Rec."Document No.");
                    REPORT.Run(REPORT::"Payment Request (Posted)", true, false, PostedGenJournal);
                end;
            }
            action("ReadNote")
            {
                Caption = 'Read Notes';
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ApplicationArea = All;
                Image = View;
                trigger OnAction()
                var
                    Links: Record "Record Link";
                    NoteManagement: Codeunit "Entry Event";
                    MyRecordRef: RecordRef;
                    TempNotes: Text;
                    Notes: Text;
                    PostedGenJournal3: Record "Posted Gen. Journal Line";
                begin
                    Clear(Notes);
                    Clear(PostedGenJournal3);
                    PostedGenJournal3.Reset;
                    PostedGenJournal3.SetCurrentKey("Document No.");
                    PostedGenJournal3.SetRange("Document No.", Rec."Document No.");
                    if PostedGenJournal3.FindSet() then begin
                        repeat
                            Clear(MyRecordRef);
                            Clear(NoteManagement);
                            MyRecordRef.GetTable(PostedGenJournal3);
                            //- Collect Note
                            Clear(TempNotes);
                            TempNotes := NoteManagement.GetNotesForRecordRef(MyRecordRef);
                            if TempNotes <> '' then begin
                                if Notes = '' then
                                    Notes := TempNotes
                                else
                                    Notes := ' ' + TempNotes;
                            end;
                        //-
                        until PostedGenJournal3.Next() = 0;
                        if Notes <> '' then
                            Message(Notes);
                    end;
                end;
            }
            //update documet 
            action(UpdateDocument)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update Document';
                Image = Document;
                ToolTip = 'Update Document';
                trigger OnAction()
                var
                    PostedGenJournal: Report "Update Data Posted Journal";
                    PostedGenJoural: Record "Posted Gen. Journal Line";
                begin
                    CurrPage.SetSelectionFilter(PostedGenJoural);
                    if PostedGenJoural.Find('-') then begin
                        PostedGenJournal.UseRequestPage(true);
                        PostedGenJournal.setParam(PostedGenJoural);
                        PostedGenJournal.RunModal();
                    end;
                    CurrPage.Update(false);
                end;
            }
        }
    }

    local procedure getAccountName(): Text
    var
        vendor: Record Vendor;
        customer: Record Customer;
        employee: Record Employee;
        glAccount: Record "G/L Account";
        BankAccount: Record "Bank Account";
        fixedAsset: Record "Fixed Asset";
    begin
        case
            Rec."Account Type" of
            Rec."Account Type"::"G/L Account":
                begin
                    Clear(glAccount);
                    glAccount.SetRange("No.", Rec."Account No.");
                    if glAccount.Find('-') then
                        exit(glAccount.Name);
                end;
            Rec."Account Type"::Vendor:
                begin
                    Clear(vendor);
                    vendor.SetRange("No.", Rec."Account No.");
                    if vendor.Find('-') then
                        exit(vendor.Name);
                end;
            Rec."Account Type"::Employee:
                begin
                    Clear(employee);
                    employee.SetRange("No.", Rec."Account No.");
                    if employee.Find('-') then
                        exit(employee.FullName());
                end;
            Rec."Account Type"::Customer:
                begin
                    Clear(customer);
                    customer.SetRange("No.", Rec."Account No.");
                    if customer.Find('-') then
                        exit(customer.Name);
                end;
            Rec."Account Type"::"Fixed Asset":
                begin
                    Clear(fixedAsset);
                    fixedAsset.SetRange("No.", Rec."Account No.");
                    if fixedAsset.Find('-') then
                        exit(fixedAsset.Description);
                end;
            Rec."Account Type"::"Bank Account":
                begin
                    Clear(BankAccount);
                    BankAccount.SetRange("No.", Rec."Account No.");
                    if BankAccount.Find('-') then
                        exit(BankAccount.Name);
                end;
        end;
    end;

    var
        GLEntryRec: Record "G/L Entry";
        PostedGenJournal: Record "Posted Gen. Journal Line";
}
