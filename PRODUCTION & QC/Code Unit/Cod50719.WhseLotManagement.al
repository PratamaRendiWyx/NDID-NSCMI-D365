codeunit 50719 "Whse. Lot Management"
{
    procedure MainProcess(var UpdItemLotRec: Record "Item Jnl. Update Lot"; var iDimensionSetID: Integer)
    var
        MSG_ProcessComplete: TextConst ENU = 'Create reclass entries is completed.';
        UpdItemLotRecDel: Record "Item Jnl. Update Lot";
        counterProcess: Integer;
    begin
        Clear(counterProcess);
        ClearLastError();
        Clear(GlbItemJl);
        SetDimensionSetID(iDimensionSetID);

        repeat
            if UpdItemLotRec.Quantity > 0 then begin
                UpdItemLotRec.TestField("Location Code");
                Clear(ItemJnlPostLine);
                QC_CreateReclassLine(UpdItemLotRec);
                counterProcess += 1;
                //action delete
                Clear(UpdItemLotRecDel);
                UpdItemLotRecDel.Reset();
                UpdItemLotRecDel.SetRange("GUID ID", UpdItemLotRec."GUID ID");
                if UpdItemLotRecDel.FindSet() then begin
                    UpdItemLotRecDel.Delete();
                end;
                //-
            end;
        until UpdItemLotRec.Next() = 0;

        if GetLastErrorText = '' then begin
            if counterProcess > 0 then
                Message(MSG_ProcessComplete)
            else
                Message('Nothing to handle.');
        end else
            SelectLatestVersion();
    end;

    procedure QC_CreateReclassLine(var UpdItemLotRec: Record "Item Jnl. Update Lot")
    var
        ItemJnlLine: Record "Item Journal Line";
        TrackingSpecification: Record "Tracking Specification";
    begin
        with UpdItemLotRec do begin
            CreateNewItemJournalLine(ItemJnlLine, UpdItemLotRec);
            CreateNewItemTrackingLine(TrackingSpecification, ItemJnlLine, UpdItemLotRec);
            //-- Post --//
            ItemJnlPostLine.Run(ItemJnlLine);
        end;
    end;

    local procedure GetLastLineNo(TemplateName: Code[10]; BatchName: Code[10]): Integer
    var
        ItemJnlLine: Record "Item Journal Line";
    begin
        ItemJnlLine.Reset();
        ItemJnlLine.SetRange("Journal Template Name", TemplateName);
        ItemJnlLine.SetRange("Journal Batch Name", BatchName);
        if ItemJnlLine.FindLast then
            exit(ItemJnlLine."Line No." + 10000)
        else
            exit(10000);
    end;

    local procedure GetItems(ItemNo: Code[20])
    begin
        Itemrc.Reset();
        Itemrc.Get(ItemNo);
    end;

    local procedure CreateNewItemJournalLine(var IJL: Record "Item Journal Line"; var UpdItemLotRec: Record "Item Jnl. Update Lot")
    var
        ItemJNLTemplate: Record "Item Journal Template";
        ItemJNLBatch: Record "Item Journal Batch";
        SourceCodeSetup: Record "Source Code Setup";
        InvSetup: Record "Inventory Setup";
        NoSeriesMgt: Codeunit "No. Series";
        DimSetEntry: Record "Dimension Set Entry";
        GenLedgeSetup: Record "General Ledger Setup";
    begin
        //-- Get all Setups --//
        InvSetup.Get();
        ItemJNLTemplate.Reset();
        ItemJNLTemplate.SetRange(Name, InvSetup."QC Auto Reclass Template Name");
        if ItemJNLTemplate.FindFirst() then;

        ItemJnlBatch.Get(ItemJnlTemplate.Name, InvSetup."QC Auto Reclass Batch Name");
        // ItemJNLBatch.TestField("Posting No. Series");
        //-- Create new Item Journal Line based on referenced Item Ledger Entry --//
        with IJL do begin
            Init;
            "Journal Template Name" := ItemJNLTemplate.Name;
            "Journal Batch Name" := ItemJNLBatch.Name;
            "Line No." := GetLastLineNo("Journal Template Name", "Journal Batch Name");

            "External Document No." := NoSeriesMgt.GetNextNo(ItemJNLBatch."No. Series", "Posting Date", true); //ILE."Document No.";

            Validate("Posting Date", WorkDate());
            //-- Generates DocNo from Current batch setup --//
            "Document No." := "External Document No.";
            "Entry Type" := "Entry Type"::Transfer;

            "Gen. Bus. Posting Group" := UpdItemLotRec."Gen. Bus. Posting Group";

            //  "New Lot No." := UpdItemLotRec."New Lot No.";

            Validate("Source Code", SourceCodeSetup."Item Reclass. Journal");
            Validate("Entry Type", "Entry Type"::Transfer);

            GetItems(UpdItemLotRec."Item No.");
            Validate("Item No.", Itemrc."No.");

            Validate("Location Code", UpdItemLotRec."Location Code");

            Validate(Quantity, UpdItemLotRec.Quantity);
            //-- Use this to refer to its original line --//

            "Document Line No." := "Line No.";

            //-- Validate "New Shortcut Dimensions" and "New Dimension Set ID" --//
            DimSetEntry.Reset();
            DimSetEntry.SetRange("Dimension Set ID", DimensionSetID);
            if DimSetEntry.FindFirst() then begin
                repeat

                    case DimSetEntry."Dimension Code" of
                        GenLedgeSetup."Shortcut Dimension 1 Code":
                            begin
                                Validate("New Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
                            end;

                        GenLedgeSetup."Shortcut Dimension 2 Code":
                            begin
                                Validate("New Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
                            end;

                        GenLedgeSetup."Shortcut Dimension 3 Code":
                            begin
                                ValidateNewShortcutDimCode(3, DimSetEntry."Dimension Value Code");
                            end;

                        GenLedgeSetup."Shortcut Dimension 4 Code":
                            begin
                                ValidateNewShortcutDimCode(4, DimSetEntry."Dimension Value Code");
                            end;

                    end;

                until DimSetEntry.Next() = 0;
            end;

            Insert();
            // transfer field to Temporary
            GlbItemJl.TransferFields(IJL);
            GlbItemJl.Insert();
        end;
    end;

    local procedure CreateNewItemTrackingLine(var TrackingSpec: Record "Tracking Specification"; var IJL: Record "Item Journal Line"; var UpdItemLotRec: Record "Item Jnl. Update Lot")
    var
        CU_CreateResEntry: Codeunit "Create Reserv. Entry";
        ForReservEntry: Record "Reservation Entry";
    begin
        //-- Create Reservation Entries --//
        ForReservEntry.Init();
        ForReservEntry."Serial No." := '';
        ForReservEntry."New Serial No." := '';
        ForReservEntry."Lot No." := UpdItemLotRec."Lot No.";
        ForReservEntry."New Lot No." := UpdItemLotRec."New Lot No.";
        ForReservEntry.Quantity := UpdItemLotRec.Quantity;

        CU_CreateResEntry.CreateReservEntryFor(
                DATABASE::"Item Journal Line", 4, IJL."Journal Template Name", IJL."Journal Batch Name", 0, IJL."Line No.",
                IJL."Qty. per Unit of Measure", IJL.Quantity, IJL."Quantity (Base)", ForReservEntry);
        CU_CreateResEntry.CreateEntry(IJL."Item No.", IJL."Variant Code", IJL."Location Code", IJL.Description, 0D, 0D, 0,
        ForReservEntry."Reservation Status"::Surplus);

    end;

    local procedure SetDimensionSetID(var iDimensionSetID: Integer)
    begin
        DimensionSetID := iDimensionSetID;
    end;


    var
        Itemrc: Record Item;
        DimensionSetID: Integer;
        TempILE: Record "Item Ledger Entry" temporary;

        GlbItemJl: Record "Item Journal Line" temporary;

        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";


}
