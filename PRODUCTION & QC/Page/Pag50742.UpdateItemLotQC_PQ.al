page 50742 UpdateItemLotQC_PQ
{
    ApplicationArea = All;
    Caption = 'Update Item Lot';
    PageType = List;
    SourceTable = "Item Jnl. Update Lot QC";
    layout
    {

        area(Content)
        {
            group(Control1)
            {
                ShowCaption = false;
                fixed(Control1903651101)
                {
                    ShowCaption = false;
                    group(Source)
                    {
                        Caption = 'Source';
                        field("SourceQuantity"; SourceQuantity)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Quantity';
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                        }
                    }
                }
            }
            repeater(General)
            {
                ShowCaption = false;
                field("Test No"; Rec."Test No")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
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
                        QcLotMgnt: Codeunit "Whse. QC Management";
                        UpdateLotRec: Record "Item Jnl. Update Lot QC";
                        UpdateLotRecCp: Record "Item Jnl. Update Lot QC";
                        label: Label 'Do you want to post the journal lines?';
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
                            getSourceQtyFromILE(UpdateLotRecCp);
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

    local procedure getSourceQtyFromILE(var iUpdateRec: Record "Item Jnl. Update Lot QC")
    var
        itemLedgerEntry: Record "Item Ledger Entry";
    begin
        Clear(itemLedgerEntry);
        itemLedgerEntry.Reset();
        itemLedgerEntry.SetRange("Item No.", iUpdateRec."Item No.");
        itemLedgerEntry.SetRange("Location Code", iUpdateRec."Location Code");
        itemLedgerEntry.SetRange("Lot No.", iUpdateRec."Lot No.");
        if itemLedgerEntry.FindSet() then begin
            itemLedgerEntry.CalcSums("Remaining Quantity");
            updateSourceQty(itemLedgerEntry."Remaining Quantity");
        end;
    end;

    trigger OnInit()
    var
        myInt: Integer;
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin

    end;

    procedure setParameter(iQty: Decimal; iDimensionSetID: Integer)
    begin
        SourceQuantity := iQty;
        DimensetID := iDimensionSetID;
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

    var
        SourceQuantity: Decimal;
        TotalQuantityReclass: Decimal;
        DimensetID: Integer;

}
