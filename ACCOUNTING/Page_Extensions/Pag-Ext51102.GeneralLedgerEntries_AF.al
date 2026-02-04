pageextension 51102 GeneralLedgerEntries_AF extends "General Ledger Entries"
{
    layout
    {
        addbefore(Description)
        {
            field(ItemNo; ItemNo)
            {
                Editable = false;
                Caption = 'Item No.';
                ApplicationArea = All;
            }
            field(ItemDesc; ItemDesc)
            {
                Editable = false;
                Caption = 'Item Description';
                ApplicationArea = All;
            }
        }
        modify("Source Currency Amount")
        {
            Visible = true;
        }
        modify("Source Currency Code")
        {
            Visible = true;
        }
        addafter("Source Currency Amount")
        {
            field("Currency Factor"; Rec."Currency Factor")
            {
                ApplicationArea = All;
            }
        }
        addafter("Source No.")
        {
            field(SourceName; getSourceName(Rec."Source Type", Rec."Source No."))
            {
                ApplicationArea = All;
                Caption = 'Source Name';
            }
            field("PIB/PEB No"; Rec."PIB/PEB No")
            {
                ApplicationArea = All;
                Editable = true;
            }
            field("Tax No."; getInfoTaxNo(Rec."Document No."))
            {
                ApplicationArea = All;
            }
            field("Tax Date"; Rec."Tax Date")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addfirst(reporting)
        {

        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        ValueEntry: Record "Value Entry";
        GlEntryRelation: Record "G/L - Item Ledger Relation";
        ItemLedgerEntry: Record "Item Ledger Entry";
        Item: Record Item;
        //show source name
        v_sourceName: Text;
    begin
        Clear(ItemNo);
        Clear(ItemDesc);
        Clear(GlEntryRelation);
        GlEntryRelation.Reset();
        GlEntryRelation.SetRange("G/L Entry No.", Rec."Entry No.");
        if GlEntryRelation.Find('-') then begin
            Clear(ValueEntry);
            ValueEntry.Reset();
            ValueEntry.SetRange("Entry No.", GlEntryRelation."Value Entry No.");
            if ValueEntry.Find('-') then begin
                Clear(Item);
                Item.Reset();
                Item.SetRange("No.", ValueEntry."Item No.");
                if Item.Find('-') then begin
                    ItemNo := Item."No.";
                    ItemDesc := Item.Description;
                end;
            end;
        end;
        //handling source name not showing
        // v_sourceName := getSourceName(Rec."Source Type", Rec."Source No.");
        // Rec.CalcFields("O4N Source Name");
        // if (Rec."O4N Source Name" = '') Or (Rec."O4N Source Name" <> v_sourceName) then
        //     Rec."O4N Source Name" := v_sourceName;
        //-
    end;

    local procedure getSourceName(iSourceType: Enum "Gen. Journal Source Type"; iSourceNo: Text): Text
    var
        fixedAsset: Record "Fixed Asset";
        vendor: Record Vendor;
        customer: Record Customer;
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
            // New add by rnd, 19 Feb 24, request by arief-san
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
        //-
        end;
        exit('');
    end;

    local procedure getInfoTaxNo(iDocumentNo: Text): Text
    var
        puscashaseInv: Record "Purch. Inv. Header";
    begin
        Clear(puscashaseInv);
        puscashaseInv.Reset();
        puscashaseInv.SetRange("No.", iDocumentNo);
        if puscashaseInv.Find('-') then begin
            exit(puscashaseInv."Tax Number_FT");
        end;
        exit('');
    end;

    var
        ItemNo: Code[100];
        ItemDesc: Text;
        TaxNo: Text;

    var
        GLEntryRec: Record "G/L Entry";
}