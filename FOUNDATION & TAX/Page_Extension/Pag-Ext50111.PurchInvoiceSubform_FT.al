pageextension 50111 PurcHInvoiceSubform_FT extends "Purch. Invoice Subform"
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
                ItemCharge: Record "Item Charge";
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
                        Rec."WHT Product Posting Group" := Items."WHT Product Posting Group";
                        Rec."WHT Business Posting Group" := whtbuspostinggrp;
                    end
                end;
                //fixed asset 
                if Rec.Type = Rec.Type::"Fixed Asset" then begin
                    Clear(FixedAssets);
                    FixedAssets.Reset();
                    FixedAssets.SetRange("No.", Rec."No.");
                    if FixedAssets.Find('-') then begin
                        Rec."WHT Product Posting Group" := FixedAssets."WHT Product Posting Group";
                        Rec."WHT Business Posting Group" := whtbuspostinggrp;
                    end;
                end;
                //Item Charge 
                if Rec.Type = Rec.Type::"Charge (Item)" then begin
                    Clear(ItemCharge);
                    ItemCharge.Reset();
                    ItemCharge.SetRange("No.", Rec."No.");
                    if ItemCharge.Find('-') then begin
                        Rec."WHT Product Posting Group" := ItemCharge."WHT Prod. Posting Group";
                    end;
                end
            end;
        }
    }
    actions
    {
        addafter(GetReceiptLines)
        {
            action(CalculateWHT)
            {
                ApplicationArea = Suite;
                Caption = 'Calculate WHT';
                Ellipsis = true;
                Image = Receipt;
                ToolTip = 'Calculate WHT.';

                trigger OnAction()
                begin
                    //Add action 
                    // CurrPage.Update();
                    calculateWHT(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    local procedure updateInfoWHTLineItems(var iPurchaseLine: Record "Purchase Line")
    var
        purchaseLine: Record "Purchase Line";
        Items: Record Item;
        FixedAssets: Record "Fixed Asset";
        Vendor: Record Vendor;
        whtbuspostinggrp: Text;
        ItemCharge: Record "Item Charge";
    begin
        Clear(Vendor);
        if Vendor.get(PurchaseHeader."Buy-from Vendor No.") then
            whtbuspostinggrp := Vendor."WHT Business Posting Group";

        Clear(purchaseLine);
        purchaseLine.Reset();
        purchaseLine.Copy(iPurchaseLine);
        purchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        purchaseLine.SetRange("Document Type", purchaseLine."Document Type"::Invoice);
        purchaseLine.SetFilter(Type, '%1|%2|%3', purchaseLine.Type::Item, purchaseLine.Type::"Fixed Asset", purchaseLine.Type::"Charge (Item)");
        if purchaseLine.FindSet() then begin
            repeat
                //item 
                if purchaseLine.Type = purchaseLine.Type::Item then begin
                    Clear(Items);
                    Items.Reset();
                    Items.SetRange("No.", purchaseLine."No.");
                    if Items.Find('-') then begin
                        purchaseLine."WHT Product Posting Group" := Items."WHT Product Posting Group";
                        purchaseLine."WHT Business Posting Group" := whtbuspostinggrp;
                    end
                end;
                //fixed asset 
                if purchaseLine.Type = purchaseLine.Type::"Fixed Asset" then begin
                    Clear(FixedAssets);
                    FixedAssets.Reset();
                    FixedAssets.SetRange("No.", purchaseLine."No.");
                    if FixedAssets.Find('-') then begin
                        purchaseLine."WHT Product Posting Group" := FixedAssets."WHT Product Posting Group";
                        purchaseLine."WHT Business Posting Group" := whtbuspostinggrp;
                    end;
                end;
                //Item Charge
                if purchaseLine.Type = purchaseLine.Type::"Charge (Item)" then begin
                    Clear(ItemCharge);
                    ItemCharge.Reset();
                    ItemCharge.SetRange("No.", purchaseLine."No.");
                    if ItemCharge.Find('-') then begin
                        purchaseLine."WHT Product Posting Group" := ItemCharge."WHT Prod. Posting Group";
                        purchaseLine."WHT Business Posting Group" := whtbuspostinggrp;
                    end;
                end;
                //update 
                purchaseLine.Modify();
            until purchaseLine.Next() = 0;
        end;
    end;

    local procedure calculateWHT(var iPurchaseLine: Record "Purchase Line")
    var
        purchaseLine: Record "Purchase Line";
        vendor: Record Vendor;
        WHTPostSetup: Record WHTPostingSetup_FT;
        tempdata: Text;
        currdata: Text;
        LastLineno: Integer;
        v_glAccountNo: Text;
        PurchaseLineCalculate: Record "Purchase Line";
        PurchaseLineGL: Record "Purchase Line";
        varDocNo: Text;
    begin
        Clear(varDocNo);
        if PurchaseHeader."No." = '' then begin
            varDocNo := iPurchaseLine."Document No.";
            Clear(PurchaseHeader);
            PurchaseHeader.Reset();
            PurchaseHeader.SetRange("No.", varDocNo);
            PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Invoice);
            if not PurchaseHeader.FindSet() then;
        end;
        //update wht info 
        updateInfoWHTLineItems(iPurchaseLine);
        //if PurchaseHeader.Find('-') then begin
        Clear(purchaseLine);
        purchaseLine.Reset();
        purchaseLine.Copy(iPurchaseLine);
        if PurchaseHeader."No." <> '' then
            purchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        purchaseLine.SetRange("Document Type", purchaseLine."Document Type"::Invoice);
        purchaseLine.SetFilter(Type, '%1|%2|%3', purchaseLine.Type::Item, purchaseLine.Type::"Fixed Asset", purchaseLine.Type::"Charge (Item)");
        purchaseLine.SetCurrentKey("WHT Business Posting Group", "WHT Product Posting Group");
        purchaseLine.Ascending(true);
        if purchaseLine.FindSet() then begin
            repeat
                currdata := purchaseLine."WHT Business Posting Group" + '#' + purchaseLine."WHT Product Posting Group";
                //grouping and calculate
                if currdata <> tempdata then begin
                    Clear(PurchaseLineCalculate);
                    PurchaseLineCalculate.Reset();
                    PurchaseLineCalculate.SetRange("Document No.", PurchaseHeader."No.");
                    PurchaseLineCalculate.SetRange("Document Type", PurchaseLineCalculate."Document Type"::Invoice);
                    PurchaseLineCalculate.SetRange("WHT Business Posting Group", purchaseLine."WHT Business Posting Group");
                    PurchaseLineCalculate.SetRange("WHT Product Posting Group", purchaseLine."WHT Product Posting Group");
                    PurchaseLineCalculate.SetFilter(Type, '%1|%2|%3', purchaseLine.Type::Item, purchaseLine.Type::"Fixed Asset", purchaseLine.Type::"Charge (Item)");
                    if PurchaseLineCalculate.FindSet() then begin
                        //calculate line amount
                        PurchaseLineCalculate.CalcSums("Line Amount", Quantity, "Quantity (Base)");
                        Clear(WHTPostSetup);
                        WHTPostSetup.Reset();
                        WHTPostSetup.SetRange("WHT Business Posting Group", PurchaseLineCalculate."WHT Business Posting Group");
                        WHTPostSetup.SetRange("WHT Product Posting Group", PurchaseLineCalculate."WHT Product Posting Group");
                        if WHTPostSetup.Find('-') then begin
                            //check modfify | Insert 
                            Clear(PurchaseLineGL);
                            PurchaseLineGL.Reset();
                            PurchaseLineGL.SetRange("Document No.", PurchaseHeader."No.");
                            PurchaseLineGL.SetRange("Document Type", PurchaseLineGL."Document Type"::Invoice);
                            PurchaseLineGL.SetRange("WHT Business Posting Group", WHTPostSetup."WHT Business Posting Group");
                            PurchaseLineGL.SetRange("WHT Product Posting Group", WHTPostSetup."WHT Product Posting Group");
                            PurchaseLineGL.SetRange("No.", WHTPostSetup."PPH Purchase Account.");
                            if PurchaseLineGL.Find('-') then begin
                                PurchaseLineGL."Line Amount" := (PurchaseLineCalculate."Line Amount" * WHTPostSetup."WHT %") / 100;
                                PurchaseLineGL.Description := getInfoAccount(WHTPostSetup."PPH Purchase Account.");
                                PurchaseLineGL."Line Amount" := (PurchaseLineCalculate."Line Amount" * WHTPostSetup."WHT %") / 100;
                                PurchaseLineGL.Amount := (PurchaseLineCalculate."Line Amount" * WHTPostSetup."WHT %") / 100;
                                PurchaseLineGL."Amount Including VAT" := (PurchaseLineCalculate."Line Amount" * WHTPostSetup."WHT %") / 100;
                                PurchaseLineGL."VAT Base Amount" := (PurchaseLineCalculate."Line Amount" * WHTPostSetup."WHT %") / 100;
                                PurchaseLineGL."Outstanding Amount" := (PurchaseLineCalculate."Line Amount" * WHTPostSetup."WHT %") / 100;
                                PurchaseLineGL."Outstanding Amount (LCY)" := (PurchaseLineCalculate."Line Amount" * WHTPostSetup."WHT %") / 100;
                                PurchaseLineGL.Quantity := 1;
                                PurchaseLineGL."Quantity (Base)" := 1;
                                PurchaseLineGL."Qty. to Receive" := 1;
                                PurchaseLineGL."Qty. to Receive (Base)" := 1;
                                PurchaseLineGL."Qty. to Invoice" := 1;
                                PurchaseLineGL."Qty. to Invoice (Base)" := 1;
                                PurchaseLineGL."Direct Unit Cost" := (PurchaseLineCalculate."Line Amount" * WHTPostSetup."WHT %") / 100;
                                PurchaseLineGL.Validate("Direct Unit Cost");
                                PurchaseLineGL."WHT Business Posting Group" := WHTPostSetup."WHT Business Posting Group";
                                PurchaseLineGL."WHT Product Posting Group" := WHTPostSetup."WHT Product Posting Group";
                                PurchaseLineGL."Gen. Bus. Posting Group" := PurchaseLineCalculate."Gen. Bus. Posting Group";
                                PurchaseLineGL."Gen. Prod. Posting Group" := PurchaseLineCalculate."Gen. Prod. Posting Group";
                                PurchaseLineGL.Modify(true);
                            end else begin
                                LastLineno := getLastLinNoPurchLine(PurchaseHeader."No.");
                                PurchaseLineGL.Init();
                                PurchaseLineGL."Document No." := PurchaseHeader."No.";
                                PurchaseLineGL."Line No." := LastLineno;
                                PurchaseLineGL."Document Type" := PurchaseLineGL."Document Type"::Invoice;
                                PurchaseLineGL.Type := PurchaseLineGL.Type::"G/L Account";
                                PurchaseLineGL."No." := WHTPostSetup."PPH Purchase Account.";
                                PurchaseLineGL.Description := getInfoAccount(WHTPostSetup."PPH Purchase Account.");
                                PurchaseLineGL."Line Amount" := (PurchaseLineCalculate."Line Amount" * WHTPostSetup."WHT %") / 100;
                                PurchaseLineGL.Amount := (PurchaseLineCalculate."Line Amount" * WHTPostSetup."WHT %") / 100;
                                PurchaseLineGL."Amount Including VAT" := (PurchaseLineCalculate."Line Amount" * WHTPostSetup."WHT %") / 100;
                                PurchaseLineGL."Outstanding Amount" := (PurchaseLineCalculate."Line Amount" * WHTPostSetup."WHT %") / 100;
                                PurchaseLineGL."Outstanding Amount (LCY)" := (PurchaseLineCalculate."Line Amount" * WHTPostSetup."WHT %") / 100;
                                PurchaseLineGL."VAT Base Amount" := (PurchaseLineCalculate."Line Amount" * WHTPostSetup."WHT %") / 100;
                                PurchaseLineGL.Quantity := 1;
                                PurchaseLineGL."Quantity (Base)" := 1;
                                PurchaseLineGL."Qty. to Receive" := 1;
                                PurchaseLineGL."Qty. to Receive (Base)" := 1;
                                PurchaseLineGL."Qty. to Invoice" := 1;
                                PurchaseLineGL."Qty. to Invoice (Base)" := 1;
                                PurchaseLineGL."Direct Unit Cost" := (PurchaseLineCalculate."Line Amount" * WHTPostSetup."WHT %") / 100;
                                PurchaseLineGL.Validate("Direct Unit Cost");
                                PurchaseLineGL."WHT Business Posting Group" := WHTPostSetup."WHT Business Posting Group";
                                PurchaseLineGL."WHT Product Posting Group" := WHTPostSetup."WHT Product Posting Group";
                                PurchaseLineGL."Gen. Bus. Posting Group" := PurchaseLineCalculate."Gen. Bus. Posting Group";
                                PurchaseLineGL."Gen. Prod. Posting Group" := PurchaseLineCalculate."Gen. Prod. Posting Group";
                                PurchaseLineGL.Insert(true);
                            end;
                        end;
                    end;
                end;
                tempdata := currdata;
            until purchaseLine.Next() = 0;
        end;
        //end;
    end;

    local procedure getInfoAccount(iAccountNo: Text): Text
    var
        GLAccount: Record "G/L Account";
    begin
        Clear(GLAccount);
        GLAccount.Reset();
        GLAccount.SetRange("No.", iAccountNo);
        if GLAccount.Find('-') then
            exit(GLAccount.Name);
        exit('');
    end;

    local procedure getLastLinNoPurchLine(iDocumentNo: Text): Integer
    var
        purchaseLine: Record "Purchase Line";
        lineNo: Integer;
    begin
        Clear(lineNo);
        Clear(purchaseLine);
        purchaseLine.Reset();
        purchaseLine.SetRange("Document No.", iDocumentNo);
        if purchaseLine.FindLast() then
            lineNo := purchaseLine."Line No." + 10000;
        exit(lineNo);
    end;

    procedure setParameterforWHT(var ipurchaseHeader: Record "Purchase Header")
    begin
        PurchaseHeader := ipurchaseHeader;
        v_docNO := ipurchaseHeader."No.";
    end;

    var
        PurchaseHeader: Record "Purchase Header";
        v_docNO: Text;
}
