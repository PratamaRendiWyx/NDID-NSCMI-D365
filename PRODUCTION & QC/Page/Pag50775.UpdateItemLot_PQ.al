page 50775 UpdateItemLot_PQ
{
    ApplicationArea = All;
    Caption = 'Update Item Lot';
    PageType = List;
    SourceTable = "Item Jnl. Update Lot";
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                ShowCaption = false;
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("New Lot No."; Rec."New Lot No.")
                {
                    ApplicationArea = Basic, Suite;
                    ShowMandatory = true;
                }
                field(CurrQty; getQtyFromILE())
                {
                    Caption = 'Curr. Quantity';
                    ApplicationArea = Basic, Suite;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    //Action
    actions
    {
        area(processing)
        {
            group("P&osting")
            {
                action(UpdateLot)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post';
                    Ellipsis = true;
                    Image = PostApplication;
                    ShortCutKey = 'F9';
                    ToolTip = 'Post - update item lot to new lot';
                    trigger OnAction()
                    var
                        myInt: Integer;
                        QcLotMgnt: Codeunit "Whse. Lot Management";
                        UpdateLotRec: Record "Item Jnl. Update Lot";
                        UpdateLotRecCp: Record "Item Jnl. Update Lot";
                        label: Label 'Do you want to post the journal lines ?';
                    begin
                        // do update lot
                        CurrPage.SetSelectionFilter(UpdateLotRec);
                        if UpdateLotRec.FindSet() then begin
                            UpdateLotRecCp.Copy(UpdateLotRec);
                            Clear(QcLotMgnt);
                            if Confirm(label) then begin
                                QcLotMgnt.MainProcess(UpdateLotRec, DimensetID);
                            end;
                            //update source qty 
                            CurrPage.Update();
                        end;
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(UpdateLot_Promoted; UpdateLot)
                {
                }
            }
        }
    }

    local procedure getQtyFromILE(): Decimal
    var
        itemLedgerEntry: Record "Item Ledger Entry";
    begin
        Clear(itemLedgerEntry);
        itemLedgerEntry.Reset();
        itemLedgerEntry.SetRange("Item No.", Rec."Item No.");
        itemLedgerEntry.SetRange("Location Code", Rec."Location Code");
        itemLedgerEntry.SetRange("Lot No.", Rec."Lot No.");
        if itemLedgerEntry.FindSet() then begin
            itemLedgerEntry.CalcSums("Remaining Quantity");
            exit(itemLedgerEntry."Remaining Quantity");
        end;
        exit(0);
    end;

    trigger OnInit()
    var
        myInt: Integer;
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin

    end;

    var
        glbLotNo: Code[50];

    procedure setParameter(iLotNo: Code[50])
    begin
        glbLotNo := iLotNo;
    end;

    local procedure updateSourceQty(iqty: Decimal)
    begin
        SourceQuantity := iqty;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        myInt: Integer;
    begin
        Rec."GUID ID" := CreateGuid();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        myInt: Integer;
        InventorySetup: Record "Inventory Setup";
    begin
        Clear(InventorySetup);
        InventorySetup.Get();
        Rec."Location Code" := InventorySetup."Default Location QC";
    end;

    var
        SourceQuantity: Decimal;
        TotalQuantityReclass: Decimal;
        DimensetID: Integer;

}
