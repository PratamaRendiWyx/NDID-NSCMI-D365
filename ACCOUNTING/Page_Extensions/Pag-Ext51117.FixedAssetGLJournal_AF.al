namespace ACCOUNTING.ACCOUNTING;

using Microsoft.FixedAssets.Journal;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Sales.Customer;
using Microsoft.Purchases.Vendor;
using Microsoft.FixedAssets.FixedAsset;

pageextension 51117 FixedAssetGLJournal_AF extends "Fixed Asset G/L Journal"
{
    layout
    {
        addbefore("Gen. Bus. Posting Group")
        {
            field("FA Posting Group"; Rec."FA Posting Group")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        addafter("Account No.")
        {
            field("Account Name 3"; getSourceName(Rec."Account Type", Rec."Account No."))
            {
                ApplicationArea = All;
                Caption = 'Account Name';
                Editable = false;
            }
        }

    }

    local procedure getFAPostingGroup(): Text
    var
        fixedAsset: Record "Fixed Asset";
    begin
        if Rec."Account Type" = Rec."Account Type"::"Fixed Asset" then begin
            Clear(fixedAsset);
            fixedAsset.Reset();
            fixedAsset.SetRange("No.", Rec."Account No.");
            if fixedAsset.Find('-') then
                exit(fixedAsset."FA Posting Group");
        end;
        exit('');
    end;

    local procedure getSourceName(iSourceType: Enum "Gen. Journal Account Type"; iSourceNo: Text): Text
    var
        fixedAsset: Record "Fixed Asset";
        vendor: Record Vendor;
        customer: Record Customer;
        glAccount: Record "G/L Account";
    begin
        case iSourceType of
            iSourceType::"Fixed Asset":
                begin
                    Clear(fixedAsset);
                    fixedAsset.Reset();
                    fixedAsset.SetRange("No.", iSourceNo);
                    if fixedAsset.Find('-') then
                        exit(fixedAsset.Description);
                end;
            iSourceType::Vendor:
                begin
                    Clear(vendor);
                    vendor.Reset();
                    vendor.SetRange("No.", iSourceNo);
                    if vendor.Find('-') then
                        exit(vendor.Name);
                end;
            iSourceType::Customer:
                begin
                    Clear(customer);
                    customer.Reset();
                    customer.SetRange("No.", iSourceNo);
                    if customer.Find('-') then
                        exit(customer.Name);
                end;
            iSourceType::"G/L Account":
                begin
                    Clear(glAccount);
                    glAccount.Reset();
                    glAccount.SetRange("No.", iSourceNo);
                    if glAccount.Find('-') then begin
                        exit(glAccount.Name);
                    end;
                end;
        //-
        end;
        exit('');
    end;
}
