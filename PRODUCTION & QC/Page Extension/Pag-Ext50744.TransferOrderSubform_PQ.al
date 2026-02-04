pageextension 50744 TransferOrderSubform_PQ extends "Transfer Order Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("Unit of Measure Code")
        {
            field("Transfer UOM"; Rec."Transfer UOM")
            {
                ApplicationArea = All;

                trigger OnValidate()
                begin
                    RemainingQty := Rec.Quantity mod Rec."Qty. per Transfer UOM";
                    calculateRemainQty();
                end;
            }
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
            }
            field("Planning Qty."; Rec."Planning Qty.")
            {
                ApplicationArea = All;
                Editable = false;
            }

            field("Qty. per Transfer UOM"; Rec."Qty. per Transfer UOM")
            {
                ApplicationArea = All;
                DecimalPlaces = 0;

            }

            field("Qty. Transfer"; Rec."Qty. Transfer")
            {
                ApplicationArea = All;
                Editable = false;
            }

            field("Remaining Qty."; Rec."Remaining Qty.")
            {
                ApplicationArea = All;
                Caption = 'Qty.Sisa';
                DecimalPlaces = 0;
                Editable = false;
            }
        }

        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                RemainingQty := Rec.Quantity mod Rec."Qty. per Transfer UOM";
                calculateRemainQty();
            end;
        }


    }

    actions
    {
        // Add changes to page actions here
        addafter("Item &Tracking Lines")
        {
            action(CheckRepack)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Check Qty. Transfer';
                Ellipsis = true;
                Image = CheckList;
                ToolTip = 'Check Quantity To Transfer.';
                trigger OnAction()
                begin
                    checkTransferQty(Rec."Document No.");
                    CurrPage.Update(false);
                end;
            }
        }
    }

    local procedure checkTransferQty(iDocumentNo: Text)
    var
        transferline: Record "Transfer Line";
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        Newqty: Decimal;
        OldQty: Decimal;
        RemainQty: Decimal;
        DefaultTransfer: Code[10];
    begin
        Clear(transferline);
        transferline.Reset();
        transferline.SetRange("Document No.", iDocumentNo);
        if transferline.FindSet() then begin
            repeat
                Clear(DefaultTransfer);
                Clear(ItemUnitOfMeasure);
                ItemUnitOfMeasure.SetRange("Item No.", transferline."Item No.");
                ItemUnitOfMeasure.SetRange("Default Transfer UOM", true);
                if ItemUnitOfMeasure.Find('-') then begin
                    DefaultTransfer := ItemUnitOfMeasure.Code;
                end;
                //initiate value
                OldQty := transferline.Quantity;
                Newqty := transferline.Quantity;
                //-
                if transferline."Transfer UOM" = '' then begin
                    //assign default Transfer UOM 
                    transferline."Transfer UOM" := DefaultTransfer;
                    //-
                end;
                if transferline."Transfer UOM" <> '' then begin
                    transferline.Validate("Transfer UOM");
                    // Rec."Remaining Qty." := Rec.Quantity mod Rec."Qty. per Transfer UOM";
                    if transferline."Qty. per Transfer UOM" <> 0 then begin
                        RemainQty := transferline.Quantity mod transferline."Qty. per Transfer UOM";
                        if RemainQty <> 0 then begin
                            Newqty := (transferline."Qty. Transfer" + 1) * transferline."Qty. per Transfer UOM";
                            transferline.Quantity := Newqty;
                            transferline.Validate(Quantity);
                            transferline."Planning Qty." := OldQty;
                            //transferline."Transfer UOM" := ItemUnitOfMeasure.Code;
                            transferline.Validate("Transfer UOM");
                            transferline."Remaining Qty." := 0;
                        end;
                    end;
                    if Newqty <> OldQty then
                        transferline.Modify();
                end;
            until transferline.Next() = 0;
        end;
    end;

    trigger OnModifyRecord(): Boolean
    var
        myInt: Integer;
    begin
        calculateRemainQty();
    end;

    local procedure calculateRemainQty()
    begin
        if (Rec.Quantity <> xRec.Quantity) OR
                   (Rec."Qty. per Transfer UOM" <> xRec."Qty. per Transfer UOM") OR
                   (Rec."Transfer UOM" <> xRec."Transfer UOM") then begin
            Rec.Validate("Transfer UOM");
            if Rec."Qty. per Transfer UOM" <> 0 then
                Rec."Remaining Qty." := Rec.Quantity mod Rec."Qty. per Transfer UOM";
        end;
    end;

    var
        RemainingQty: Decimal;
}