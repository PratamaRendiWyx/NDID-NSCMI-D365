pageextension 50340 "Item Tracking Lines SP" extends "Item Tracking Lines"
{
    layout
    {
        addafter("Package No.")
        {
            field("Shipping Mark No."; Rec."Shipping Mark No.")
            {
                ApplicationArea = All;
            }
            field("Box Qty."; Rec."Box Qty.")
            {
                ApplicationArea = All;
            }
            field("USDFS Code"; Rec."USDFS Code")
            {
                ApplicationArea = All;
            }
        }
        addbefore("ItemTrackingCode.Description")
        {
            field(getLastUsedShippingMark; getLastUsedShippingMark)
            {
                ApplicationArea = ItemTracking;
                Caption = 'Last Used Shipping Mark';
                Editable = false;
                ToolTip = 'Last Used Shipping Mark.';
            }
        }
    }
    actions
    {
        addafter(Barcode)
        {
            action("AssignShippingMark.")
            {
                ApplicationArea = All;
                Caption = 'Assign Shipping Mark';
                Visible = false;
                Image = AdjustItemCost;
                ToolTip = 'Process Assign Shipping Mark No.';
                trigger OnAction()
                var
                    myInt: Integer;
                    TrackingSpesification: Record "Tracking Specification" temporary;
                    AssignShippingMark: Report "Assign Shipping Mark";
                begin
                    if InsertIsBlocked then
                        exit;

                    TrackingSpesification.Copy(Rec, true);
                    AssignShippingMark.UseRequestPage(true);
                    AssignShippingMark.setParameter(TrackingSpesification);
                    AssignShippingMark.RunModal();
                    CurrPage.Update(false);
                end;
            }

            action("AssignShippingMark2.")
            {
                ApplicationArea = All;
                Caption = 'Assign Shipping Mark';
                Visible = true;
                Image = AdjustItemCost;
                ToolTip = 'Process Assign Shipping Mark No.';
                trigger OnAction()
                var
                    myInt: Integer;
                    TrackingSpesification: Record "Tracking Specification" temporary;
                    AssignShippingMark: Report "Assign Shipping Mark";
                    WarehouseSetup: Record "Warehouse Setup";
                    NoSeries: Codeunit "No. Series";
                    QtyToCreate: Decimal;
                    DoInsertNewLine: Boolean;
                    IsHandled: Boolean;
                    Selection: Option " ","Next No.","Last No. Used";
                    Text000: Label '&Next No.,&Last No. Used';
                    DefaultNumber: Integer;
                begin
                    if InsertIsBlocked then
                        exit;
                    DefaultNumber := 1;
                    Selection := StrMenu(Text000, DefaultNumber);
                    case Selection of
                        Selection::"Next No.":
                            begin
                                optionNumber := 0;
                            end;
                        Selection::"Last No. Used":
                            begin
                                optionNumber := 1;
                            end;
                    end;
                    AssignShippingMarkNoToExistingLines();
                end;
            }
        }
    }

    local procedure AssignNewShippingMark()
    var
        warehousesetup: Record "Warehouse Setup";
        IsHandled: Boolean;
        NoSeries: Codeunit "No. Series";
    begin
        warehousesetup.Get();
        warehousesetup.TestField("Ship Mark Nos.");
        if optionNumber = 0 then
            Rec.Validate("Shipping Mark No.", NoSeries.GetNextNo(warehousesetup."Ship Mark Nos."))
        else
            Rec.Validate("Shipping Mark No.", NoSeries.GetLastNoUsed(warehousesetup."Ship Mark Nos."));
    end;

    local procedure AssignShippingMarkNoToExistingLines(): Boolean
    var
        TempSelectedTrackingSpecification: Record "Tracking Specification" temporary;
        AssignedShiipingMark: Code[50];
        CurrRecEntryNo: Integer;
    begin
        if Rec."Entry No." = 0 then
            exit(false);

        CurrRecEntryNo := Rec."Entry No.";
        GetTrackingSpec(TempSelectedTrackingSpecification);
        Rec.Get(CurrRecEntryNo);

        CurrPage.SetSelectionFilter(TempSelectedTrackingSpecification);
        TempSelectedTrackingSpecification.SetFilter("Shipping Mark No.", '%1', '');
        if TempSelectedTrackingSpecification.FindSet() then begin
            repeat
                Rec.Get(TempSelectedTrackingSpecification."Entry No.");
                SetShippingMarkNoInSingleLine(AssignedShiipingMark);
            until TempSelectedTrackingSpecification.Next() = 0;
            Rec.Get(CurrRecEntryNo);
        end;
        exit(AssignedShiipingMark <> '');
    end;

    local procedure SetShippingMarkNoInSingleLine(var AssignedShippingMarkNo: Code[50])
    begin
        if Rec."Shipping Mark No." <> '' then
            exit;

        if AssignedShippingMarkNo = '' then begin
            AssignNewShippingMark();
            AssignedShippingMarkNo := Rec."Shipping Mark No.";
        end else
            Rec.Validate("Shipping Mark No.", AssignedShippingMarkNo);
        Rec.Modify();
        UpdateTrackingData();
    end;

    local procedure getLastUsedShippingMark(): Text
    var
        NoSeries: Codeunit "No. Series";
        warehousesetup: Record "Warehouse Setup";
    begin
        warehousesetup.Get();
        if warehousesetup."Ship Mark Nos." = '' then
            exit('-')
        else
            exit(NoSeries.GetLastNoUsed(warehousesetup."Ship Mark Nos."));
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        myInt: Integer;
        CompletelyPacking: Boolean;
        trackingSpesification: Record "Tracking Specification" temporary;
        check: Boolean;
        warehouseShipmentLine: Record "Warehouse Shipment Line";
        varQty: Decimal;
    begin
        Clear(varQty);
        Clear(Rec);
        repeat
            check := true;
            if Rec."Shipping Mark No." = '' then
                check := false;
            varQty += Rec."Qty. to Handle";
        until Rec.Next() = 0;
        // trackingSpesification.Copy(Rec);
        //flagging
        if check then begin
            if (Rec."Source Type" = Database::"Sales Line") AND (Rec."Source Subtype" = Rec."Source Subtype"::"1") then begin
                //find wh shipment line
                Clear(warehouseShipmentLine);
                warehouseShipmentLine.SetRange("Source Document", warehouseShipmentLine."Source Document"::"Sales Order");
                warehouseShipmentLine.SetRange("Source No.", Rec."Source ID");
                warehouseShipmentLine.SetRange("Source Line No.", Rec."Source Ref. No.");
                warehouseShipmentLine.SetRange("Item No.", Rec."Item No.");
                warehouseShipmentLine.SetRange("Location Code", Rec."Location Code");
                if warehouseShipmentLine.FindSet() then begin
                    warehouseShipmentLine."Completely Shipping Mark" := false;
                    if varQty = warehouseShipmentLine."Qty. to Ship" then
                        warehouseShipmentLine."Completely Shipping Mark" := true;
                    warehouseShipmentLine.Modify();
                end;
            end;
        end;
    end;

    var
        optionNumber: Integer;
}
