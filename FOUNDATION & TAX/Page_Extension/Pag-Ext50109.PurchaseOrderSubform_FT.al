pageextension 50109 PurchaseOrderSubform_FT extends "Purchase Order Subform"
{

    layout
    {
        addbefore("Line Amount")
        {
            field("WHT Business Posting Group"; Rec."WHT Business Posting Group")
            {
                Editable = false;
                ApplicationArea = Basic, Suite;
            }

            field("WHT Product Posting Group"; Rec."WHT Product Posting Group")
            {
                Editable = false;
                ApplicationArea = Basic, Suite;
            }
        }
        modify("No.")
        {
            trigger OnBeforeValidate()
            var
                myInt: Integer;
                Items: Record Item;
                FixedAssets: Record "Fixed Asset";
                Vendor: Record Vendor;
                whtbuspostinggrp: Text;
            begin
                Clear(Vendor);
                if Vendor.get(PurchaseHeader."Buy-from Vendor No.") then
                    whtbuspostinggrp := Vendor."WHT Business Posting Group";
                //item 
                if Rec.Type = Rec.Type::Item then begin
                    Clear(Items);
                    Items.Reset();
                    Items.SetRange("No.", Rec."No.");
                    if Items.Find('-') then begin
                        Rec."WHT Business Posting Group" := whtbuspostinggrp;
                        Rec."WHT Product Posting Group" := Items."WHT Product Posting Group";
                    end
                end;
                //fixed asset 
                if Rec.Type = Rec.Type::"Fixed Asset" then begin
                    Clear(FixedAssets);
                    FixedAssets.Reset();
                    FixedAssets.SetRange("No.", Rec."No.");
                    if FixedAssets.Find('-') then begin
                        Rec."WHT Business Posting Group" := whtbuspostinggrp;
                        Rec."WHT Product Posting Group" := FixedAssets."WHT Product Posting Group";
                    end;
                end;
            end;
        }
    }

    trigger OnModifyRecord(): Boolean
    var
        purchHeader: Record "Purchase Header";
        Items: Record Item;
        FixedAssets: Record "Fixed Asset";
        Vendor: Record Vendor;
        whtbuspostinggrp: Text;
    begin
        if (Rec.Amount <> xRec.Amount) AND ((Rec.Type = Rec.Type::Item) OR (Rec.Type = Rec.Type::"Fixed Asset")) then begin
            //update info WHT 
            if (Rec."WHT Business Posting Group" = '') OR (Rec."WHT Product Posting Group" = '') then begin
                Clear(Vendor);
                if Vendor.get(PurchaseHeader."Buy-from Vendor No.") then
                    whtbuspostinggrp := Vendor."WHT Business Posting Group";
                //item 
                if Rec.Type = Rec.Type::Item then begin
                    Clear(Items);
                    Items.Reset();
                    Items.SetRange("No.", Rec."No.");
                    if Items.Find('-') then begin
                        Rec."WHT Business Posting Group" := whtbuspostinggrp;
                        Rec."WHT Product Posting Group" := Items."WHT Product Posting Group";
                    end
                end;
                //fixed asset 
                if Rec.Type = Rec.Type::"Fixed Asset" then begin
                    Clear(FixedAssets);
                    FixedAssets.Reset();
                    FixedAssets.SetRange("No.", Rec."No.");
                    if FixedAssets.Find('-') then begin
                        Rec."WHT Business Posting Group" := whtbuspostinggrp;
                        Rec."WHT Product Posting Group" := FixedAssets."WHT Product Posting Group";
                    end;
                end;
            end;
            //update WHT Amount
            Rec."WHT Amount PO" := getWHTAmountPO(Rec);
        end;
    end;


    local procedure getWHTAmountPO(var iPurchaseLine: Record "Purchase Line"): Decimal
    var
        whtPostingSetup: Record WHTPostingSetup_FT;
        o_result: Decimal;
    begin
        o_result := 0;
        Clear(whtPostingSetup);
        whtPostingSetup.Reset();
        whtPostingSetup.SetRange("WHT Business Posting Group", iPurchaseLine."WHT Business Posting Group");
        whtPostingSetup.SetRange("WHT Product Posting Group", iPurchaseLine."WHT Product Posting Group");
        if whtPostingSetup.Find('-') then
            o_result := (iPurchaseLine."Line Amount" * whtPostingSetup."WHT %") / 100;
        exit(o_result);
    end;

    local procedure setWHT()
    var
        purchHeader: Record "Purchase Header";
        vendor: record Vendor;
        item: Record Item;
        FixedAsset: Record "Fixed Asset";
    begin
        purchHeader.get(rec."Document Type", Rec."Document No.");
        vendor.get(purchHeader."Buy-from Vendor No.");
   
        //CurrPage.Update();
        if (rec.Type = rec.Type::"Fixed Asset") then begin
            FixedAsset.Get(REc."No.");
            Rec."WHT Product Posting Group" := FixedAsset."WHT Product Posting Group";
        end
        else
            if (rec.Type = Rec.Type::Item) then begin
                item.get(Rec."No.");
                rec."WHT Product Posting Group" := item."WHT Product Posting Group";
            end;
        if (purchHeader."WHT Business Posting Group" <> '') then
            rec."WHT Business Posting Group" := purchHeader."WHT Business Posting Group"
        else
            if (vendor."WHT Business Posting Group" <> '') then rec."WHT Business Posting Group" := vendor."WHT Business Posting Group";
    end;

    procedure setParameterforWHT(var ipurchaseHeader: Record "Purchase Header")
    begin
        PurchaseHeader := ipurchaseHeader;
    end;

    var
        PurchaseHeader: Record "Purchase Header";

}
