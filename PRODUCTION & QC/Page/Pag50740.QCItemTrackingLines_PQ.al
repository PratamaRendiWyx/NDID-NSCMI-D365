page 50740 QCItemTrackingLines_PQ
{
    // version NAVW111.00,QC11.02

    // //QC11.02
    //   - Created from NAV Page 6510
    //   - Created AM QC Lot No. and AM QC Serial No. Fields, and Hid the original Fields
    //     - Changed the OnAssistEdit Code for the two new Fields to Run CU 50705 instead of CU 6501

    Caption = 'Item Tracking Lines';
    DataCaptionFields = "Item No.", "Variant Code", Description;
    DelayedInsert = true;
    PageType = Worksheet;
    PopulateAllFields = true;
    SourceTable = "Tracking Specification";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(Control59)
            {
                fixed(Control1903651101)
                {
                    group(Source)
                    {
                        Caption = 'Source';
                        field(CurrentSourceCaption; CurrentSourceCaption)
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field("SourceQuantityArray[1]"; SourceQuantityArray[1])
                        {
                            ApplicationArea = All;
                            Caption = 'Quantity';
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                            ToolTip = 'Specifies the quantity of the item that corresponds to the document line, which is indicated by 0 in the Undefined fields.';
                        }
                        field(Handle1; SourceQuantityArray[2])
                        {
                            ApplicationArea = All;
                            Caption = 'Qty. to Handle';
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                            ToolTip = 'Specifies the item-tracked quantity to be handled. The quantities must correspond to those of the document line.';
                            Visible = Handle1Visible;
                        }
                        field(Invoice1; SourceQuantityArray[3])
                        {
                            ApplicationArea = All;
                            Caption = 'Qty. to Invoice';
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                            ToolTip = 'Specifies the item-tracked quantity to be invoiced.';
                            Visible = Invoice1Visible;
                        }
                    }
                    group("Item Tracking")
                    {
                        Caption = 'Item Tracking';
                        field(Text020; Text020)
                        {
                            ApplicationArea = All;
                            Visible = false;
                        }
                        field(Quantity_ItemTracking; TotalItemTrackingLine."Quantity (Base)")
                        {
                            ApplicationArea = All;
                            Caption = 'Quantity';
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                            ToolTip = 'Specifies the item-tracked quantity of the item that corresponds to the document line, which is indicated by 0 in the Undefined fields.';
                        }
                        field(Handle2; TotalItemTrackingLine."Qty. to Handle (Base)")
                        {
                            ApplicationArea = All;
                            Caption = 'Qty. to Handle';
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                            ToolTip = 'Specifies the item-tracked quantity to be handled. The quantities must correspond to those of the document line.';
                            Visible = Handle2Visible;
                        }
                        field(Invoice2; TotalItemTrackingLine."Qty. to Invoice (Base)")
                        {
                            ApplicationArea = All;
                            Caption = 'Qty. to Invoice';
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                            ToolTip = 'Specifies the item-tracked quantity to be invoiced.';
                            Visible = Invoice2Visible;
                        }
                    }
                    group(Undefined)
                    {
                        Caption = 'Undefined';
                        field(Control88; Text020)
                        {
                            ApplicationArea = All;
                            Visible = false;
                        }
                        field(Quantity3; UndefinedQtyArray[1])
                        {
                            ApplicationArea = All;
                            BlankZero = true;
                            Caption = 'Undefined Quantity';
                            DecimalPlaces = 2 : 5;
                            Editable = false;
                            ToolTip = 'Specifies the item-tracked quantity that remains to be assigned, according to the document quantity.';
                        }
                        field(Handle3; UndefinedQtyArray[2])
                        {
                            ApplicationArea = All;
                            BlankZero = true;
                            Caption = 'Undefined Quantity to Handle';
                            DecimalPlaces = 2 : 5;
                            Editable = false;
                            ToolTip = 'Specifies the difference between the quantity that can be selected for the document line (which is shown in the Selectable field) and the quantity that you have selected in this window (shown in the Selected field). If you have specified more item tracking quantity than is required on the document line, this field shows the overflow quantity as a negative number in red.';
                            Visible = Handle3Visible;
                        }
                        field(Invoice3; UndefinedQtyArray[3])
                        {
                            ApplicationArea = All;
                            BlankZero = true;
                            Caption = 'Undefined Quantity to Invoice';
                            DecimalPlaces = 2 : 5;
                            Editable = false;
                            ToolTip = 'Specifies the difference between the quantity that can be selected for the document line (which is shown in the Selectable field) and the quantity that you have selected in this window (shown in the Selected field). If you have specified more item tracking quantity than is required on the document line, this field shows the overflow quantity as a negative number in red.';
                            Visible = Invoice3Visible;
                        }
                    }
                }
            }
            group(Control82)
            {
                field("ItemTrackingCode.Code"; ItemTrackingCode.Code)
                {
                    ApplicationArea = All;
                    Caption = 'Item Tracking Code';
                    Editable = false;
                    Lookup = true;
                    ToolTip = 'Specifies the transferred item tracking lines.';

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        PAGE.RUNMODAL(0, ItemTrackingCode);
                    end;
                }
                field("ItemTrackingCode.Description"; ItemTrackingCode.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    Editable = false;
                    ToolTip = 'Specifies the description of what is being tracked.';
                }
            }
            repeater(Control1)
            {
                field(AvailabilitySerialNo; TrackingAvailable(Rec, 0))
                {
                    ApplicationArea = All;
                    Caption = 'Availability, Serial No.';
                    Editable = false;
                    ToolTip = 'Specifies a warning icon if the sum of the quantities of the item in outbound documents is greater than the serial number quantity in inventory.';

                    trigger OnDrillDown();
                    begin
                        LookupAvailable(0);
                    end;
                }
                field("AM QC Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    Caption = 'Serial No.';
                    Editable = SerialNoEditable;
                    ToolTip = 'Specifies the serial number associated with the entry.';

                    trigger OnAssistEdit();
                    var
                        MaxQuantity: Decimal;
                        QCItemTrackingCollection: Codeunit QCItemTrackingColl_PQ;
                    begin
                        MaxQuantity := UndefinedQtyArray[1];

                        Rec."Bin Code" := ForBinCode;
                        QCItemTrackingCollection.AssistEditTrackingNo(Rec,
                          (CurrentSignFactor * SourceQuantityArray[1] < 0) and not
                          InsertIsBlocked, CurrentSignFactor, 0, MaxQuantity);
                        Rec."Bin Code" := '';
                        CurrPage.UPDATE;
                    end;

                    trigger OnValidate();
                    begin
                        SerialNoOnAfterValidate;
                    end;
                }
                field("New Serial No."; Rec."New Serial No.")
                {
                    ApplicationArea = All;
                    Editable = NewSerialNoEditable;
                    ToolTip = 'Specifies a new serial number that will take the place of the serial number in the Serial No. field.';
                    Visible = NewSerialNoVisible;
                }
                field(AvailabilityLotNo; TrackingAvailable(Rec, 1))
                {
                    ApplicationArea = All;
                    Caption = 'Availability, Lot No.';
                    Editable = false;
                    ToolTip = 'Specifies a warning icon if the sum of the quantities of the item in outbound documents is greater than the lot number quantity in inventory.';

                    trigger OnDrillDown();
                    begin
                        LookupAvailable(1);
                    end;
                }
                field("AM QC Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    Caption = 'Lot No.';
                    Editable = LotNoEditable;
                    ToolTip = 'Specifies the lot number of the item being handled for the associated document line.';

                    trigger OnAssistEdit();
                    var
                        MaxQuantity: Decimal;
                        QCItemTrackingCollection: Codeunit QCItemTrackingColl_PQ;
                    begin
                        MaxQuantity := UndefinedQtyArray[1];

                        Rec."Bin Code" := ForBinCode;
                        QCItemTrackingCollection.AssistEditTrackingNo(Rec,
                          (CurrentSignFactor * SourceQuantityArray[1] < 0) and not
                          InsertIsBlocked, CurrentSignFactor, 1, MaxQuantity);
                        Rec."Bin Code" := '';
                        CurrPage.UPDATE;
                    end;

                    trigger OnValidate();
                    begin
                        LotNoOnAfterValidate;
                    end;
                }
                field("New Lot No."; Rec."New Lot No.")
                {
                    ApplicationArea = All;
                    Editable = NewLotNoEditable;
                    ToolTip = 'Specifies a new lot number that will take the place of the lot number in the Lot No. field.';
                    Visible = NewLotNoVisible;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = All;
                    Editable = ExpirationDateEditable;
                    ToolTip = 'Specifies the expiration date, if any, of the item carrying the item tracking number.';
                    Visible = false;
                }
                field("New Expiration Date"; Rec."New Expiration Date")
                {
                    ApplicationArea = All;
                    Editable = NewExpirationDateEditable;
                    ToolTip = 'Specifies a new expiration date.';
                    Visible = NewExpirationDateVisible;
                }
                field("Warranty Date"; Rec."Warranty Date")
                {
                    ApplicationArea = All;
                    Editable = WarrantyDateEditable;
                    ToolTip = 'Specifies that a warranty date must be entered manually.';
                    Visible = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = ItemNoEditable;
                    ToolTip = 'Specifies the number of the item associated with the entry.';
                    Visible = false;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    Editable = VariantCodeEditable;
                    ToolTip = 'Specifies the variant of the item on the line.';
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = DescriptionEditable;
                    ToolTip = 'Specifies the description of the entry.';
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Editable = LocationCodeEditable;
                    ToolTip = 'Specifies the location code for the entry.';
                    Visible = false;
                }
                field("Quantity (Base)"; Rec."Quantity (Base)")
                {
                    ApplicationArea = All;
                    Editable = QuantityBaseEditable;
                    ToolTip = 'Specifies the quantity on the line expressed in base units of measure.';

                    trigger OnValidate();
                    begin
                        QuantityBaseOnValidate;
                        QuantityBaseOnAfterValidate;
                    end;
                }
                field("Qty. to Handle (Base)"; Rec."Qty. to Handle (Base)")
                {
                    ApplicationArea = All;
                    Editable = QtyToHandleBaseEditable;
                    ToolTip = 'Specifies the quantity that you want to handle in the base unit of measure.';
                    Visible = QtyToHandleBaseVisible;

                    trigger OnValidate();
                    begin
                        QtytoHandleBaseOnAfterValidate;
                    end;
                }
                field("Qty. to Invoice (Base)"; Rec."Qty. to Invoice (Base)")
                {
                    ApplicationArea = All;
                    Editable = QtyToInvoiceBaseEditable;
                    ToolTip = 'Specifies how many of the items, in base units of measure, are scheduled for invoicing.';
                    Visible = QtyToInvoiceBaseVisible;

                    trigger OnValidate();
                    begin
                        QtytoInvoiceBaseOnAfterValidat;
                    end;
                }
                field("Quantity Handled (Base)"; Rec."Quantity Handled (Base)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity of serial/lot numbers shipped or received for the associated document line, expressed in base units of measure.';
                    Visible = false;
                }
                field("Quantity Invoiced (Base)"; Rec."Quantity Invoiced (Base)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity of serial/lot numbers that are invoiced with the associated document line, expressed in base units of measure.';
                    Visible = false;
                }
                field("Appl.-to Item Entry"; Rec."Appl.-to Item Entry")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the item ledger entry that the document or journal line is applied -to.';
                    Visible = ApplToItemEntryVisible;
                }
                field("Appl.-from Item Entry"; Rec."Appl.-from Item Entry")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the item ledger entry that the document or journal line is applied from.';
                    Visible = ApplFromItemEntryVisible;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(ButtonLineReclass)
            {
                Caption = '&Line';
                Image = Line;
                Visible = ButtonLineReclassVisible;
                action("Reclass_SerialNoInfoCard")
                {
                    ApplicationArea = All;
                    Caption = 'Serial No. Information Card';
                    Image = SNInfo;
                    RunObject = Page "Serial No. Information List";
                    RunPageLink = "Item No." = FIELD("Item No."),
                                  "Variant Code" = FIELD("Variant Code"),
                                  "Serial No." = FIELD("Serial No.");
                    ToolTip = 'View or edit detailed information about the serial number.';

                    trigger OnAction();
                    begin
                        Rec.TESTFIELD(Rec."Serial No.");
                    end;
                }
                action("Reclass_LotNoInfoCard")
                {
                    ApplicationArea = All;
                    Caption = 'Lot No. Information Card';
                    Image = LotInfo;
                    RunObject = Page "Lot No. Information List";
                    RunPageLink = "Item No." = FIELD("Item No."),
                                  "Variant Code" = FIELD("Variant Code"),
                                  "Lot No." = FIELD("Lot No.");
                    ToolTip = 'View or edit detailed information about the lot number.';

                    trigger OnAction();
                    begin
                        Rec.TESTFIELD(Rec."Lot No.");
                    end;
                }
                separator(Separator69)
                {
                }
                action("NewSerialNoInformation")
                {
                    ApplicationArea = All;
                    Caption = 'New S&erial No. Information';
                    Image = NewSerialNoProperties;
                    ToolTip = 'Create a record with detailed information about the serial number.';

                    trigger OnAction();
                    var
                        SerialNoInfoNew: Record "Serial No. Information";
                        SerialNoInfoForm: Page "Serial No. Information Card";
                    begin
                        Rec.TESTFIELD(Rec."New Serial No.");

                        CLEAR(SerialNoInfoForm);
                        SerialNoInfoForm.Init(Rec);

                        SerialNoInfoNew.SETRANGE("Item No.", Rec."Item No.");
                        SerialNoInfoNew.SETRANGE("Variant Code", Rec."Variant Code");
                        SerialNoInfoNew.SETRANGE("Serial No.", Rec."New Serial No.");

                        SerialNoInfoForm.SETTABLEVIEW(SerialNoInfoNew);
                        SerialNoInfoForm.RUN;
                    end;
                }
                action("NewLotNoInformation")
                {
                    ApplicationArea = All;
                    Caption = 'New L&ot No. Information';
                    Image = NewLotProperties;
                    RunPageOnRec = false;
                    ToolTip = 'Create a record with detailed information about the lot number.';

                    trigger OnAction();
                    var
                        LotNoInfoNew: Record "Lot No. Information";
                        LotNoInfoForm: Page "Lot No. Information Card";
                    begin
                        Rec.TESTFIELD(Rec."New Lot No.");

                        CLEAR(LotNoInfoForm);
                        LotNoInfoForm.Init(Rec);

                        LotNoInfoNew.SETRANGE("Item No.", Rec."Item No.");
                        LotNoInfoNew.SETRANGE("Variant Code", Rec."Variant Code");
                        LotNoInfoNew.SETRANGE("Lot No.", Rec."New Lot No.");

                        LotNoInfoForm.SETTABLEVIEW(LotNoInfoNew);
                        LotNoInfoForm.RUN;
                    end;
                }
            }
            group(ButtonLine)
            {
                Caption = '&Line';
                Image = Line;
                Visible = ButtonLineVisible;
                action("Line_SerialNoInfoCard")
                {
                    ApplicationArea = All;
                    Caption = 'Serial No. Information Card';
                    Image = SNInfo;
                    RunObject = Page "Serial No. Information List";
                    RunPageLink = "Item No." = FIELD("Item No."),
                                  "Variant Code" = FIELD("Variant Code"),
                                  "Serial No." = FIELD("Serial No.");
                    ToolTip = 'View or edit detailed information about the serial number.';

                    trigger OnAction();
                    begin
                        Rec.TESTFIELD(Rec."Serial No.");
                    end;
                }
                action("Line_LotNoInfoCard")
                {
                    ApplicationArea = All;
                    Caption = 'Lot No. Information Card';
                    Image = LotInfo;
                    RunObject = Page "Lot No. Information List";
                    RunPageLink = "Item No." = FIELD("Item No."),
                                  "Variant Code" = FIELD("Variant Code"),
                                  "Lot No." = FIELD("Lot No.");
                    ToolTip = 'View or edit detailed information about the lot number.';

                    trigger OnAction();
                    begin
                        Rec.TESTFIELD(Rec."Lot No.");
                    end;
                }
            }
        }
        area(processing)
        {
            group(FunctionsSupply)
            {
                Caption = 'F&unctions';
                Image = "Action";
                Visible = FunctionsSupplyVisible;
                action("Assign Serial No.")
                {
                    ApplicationArea = All;
                    Caption = 'Assign &Serial No.';
                    Image = SerialNo;
                    ToolTip = 'Automatically assign the required serial numbers from predefined number series.';

                    trigger OnAction();
                    begin
                        if InsertIsBlocked then
                            exit;
                        AssignSerialNo;
                    end;
                }
                action("Assign Lot No.")
                {
                    ApplicationArea = All;
                    Caption = 'Assign &Lot No.';
                    Image = Lot;
                    ToolTip = 'Automatically assign the required lot numbers from predefined number series.';

                    trigger OnAction();
                    begin
                        if InsertIsBlocked then
                            exit;
                        AssignLotNo;
                    end;
                }
                action("Refresh Availability")
                {
                    ApplicationArea = All;
                    Caption = 'Refresh Availability';
                    Image = Refresh;
                    ToolTip = 'Update the availability information according to changes made by other users since you opened the window. ';

                    trigger OnAction();
                    begin
                        ItemTrackingDataCollection.RefreshTrackingAvailability(Rec, true);
                    end;
                }
            }
            group(FunctionsDemand)
            {
                Caption = 'F&unctions';
                Image = "Action";
                Visible = FunctionsDemandVisible;
                action("Assign &Serial No.")
                {
                    ApplicationArea = All;
                    Caption = 'Assign &Serial No.';
                    Image = SerialNo;
                    ToolTip = 'Automatically assign the required serial numbers from predefined number series.';

                    trigger OnAction();
                    begin
                        if InsertIsBlocked then
                            exit;
                        AssignSerialNo;
                    end;
                }
                action("Assign &Lot No.")
                {
                    ApplicationArea = All;
                    Caption = 'Assign &Lot No.';
                    Image = Lot;
                    ToolTip = 'Automatically assign the required lot numbers from predefined number series.';

                    trigger OnAction();
                    begin
                        if InsertIsBlocked then
                            exit;
                        AssignLotNo;
                    end;
                }
                action("AMQCCreateCustomizedSN")
                {
                    ApplicationArea = All;
                    Caption = 'Create Customized SN';
                    Image = CreateSerialNo;
                    ToolTip = 'Automatically assign the required serial numbers based on a number series that you define.';

                    trigger OnAction();
                    begin
                        if InsertIsBlocked then
                            exit;
                        CreateCustomizedSN;
                    end;
                }
                action("Select Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Select &Entries';
                    Image = SelectEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Select from existing, available serial or lot numbers.';

                    trigger OnAction();
                    begin
                        if InsertIsBlocked then
                            exit;

                        SelectEntries;
                    end;
                }
                action("Action64")
                {
                    ApplicationArea = All;
                    Caption = 'Refresh Availability';
                    Image = Refresh;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Update the availability information according to changes made by other users since you opened the window. ';

                    trigger OnAction();
                    begin
                        ItemTrackingDataCollection.RefreshTrackingAvailability(Rec, true);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        UpdateExpDateEditable;
    end;

    trigger OnAfterGetRecord();
    begin
        ExpirationDateOnFormat;
    end;

    trigger OnClosePage();
    begin
        if UpdateUndefinedQty then
            WriteToDatabase;
        if FormRunMode = FormRunMode::"Drop Shipment" then
            case CurrentSourceType of
                DATABASE::"Sales Line":
                    SynchronizeLinkedSources(STRSUBSTNO(Text015, Text016));
                DATABASE::"Purchase Line":
                    SynchronizeLinkedSources(STRSUBSTNO(Text015, Text017));
            end;
        if FormRunMode = FormRunMode::Transfer then
            SynchronizeLinkedSources('');
        SynchronizeWarehouseItemTracking;
    end;

    trigger OnDeleteRecord(): Boolean;
    var
        TrackingSpec: Record "Tracking Specification";
        WMSManagement: Codeunit "WMS Management";
        AlreadyDeleted: Boolean;
    begin
        TrackingSpec."Item No." := Rec."Item No.";
        TrackingSpec."Location Code" := Rec."Location Code";
        TrackingSpec."Source Type" := Rec."Source Type";
        TrackingSpec."Source Subtype" := Rec."Source Subtype";
        WMSManagement.CheckItemTrackingChange(TrackingSpec, Rec);

        if not DeleteIsBlocked then begin
            AlreadyDeleted := TempItemTrackLineDelete.GET(Rec."Entry No.");
            TempItemTrackLineDelete.TRANSFERFIELDS(Rec);
            Rec.DELETE(true);

            if not AlreadyDeleted then
                TempItemTrackLineDelete.INSERT;
            ItemTrackingDataCollection.UpdateTrackingDataSetWithChange(
              TempItemTrackLineDelete, CurrentSignFactor * SourceQuantityArray[1] < 0, CurrentSignFactor, 2);
            if TempItemTrackLineInsert.GET(Rec."Entry No.") then
                TempItemTrackLineInsert.DELETE;
            if TempItemTrackLineModify.GET(Rec."Entry No.") then
                TempItemTrackLineModify.DELETE;
        end;
        CalculateSums;

        exit(false);
    end;

    trigger OnInit();
    begin
        WarrantyDateEditable := true;
        ExpirationDateEditable := true;
        NewExpirationDateEditable := true;
        NewLotNoEditable := true;
        NewSerialNoEditable := true;
        DescriptionEditable := true;
        LotNoEditable := true;
        SerialNoEditable := true;
        QuantityBaseEditable := true;
        QtyToInvoiceBaseEditable := true;
        QtyToHandleBaseEditable := true;
        FunctionsDemandVisible := true;
        FunctionsSupplyVisible := true;
        ButtonLineVisible := true;
        QtyToInvoiceBaseVisible := true;
        Invoice3Visible := true;
        Invoice2Visible := true;
        Invoice1Visible := true;
        QtyToHandleBaseVisible := true;
        Handle3Visible := true;
        Handle2Visible := true;
        Handle1Visible := true;
        LocationCodeEditable := true;
        VariantCodeEditable := true;
        ItemNoEditable := true;
        InboundIsSet := false;
        ApplFromItemEntryVisible := false;
        ApplToItemEntryVisible := false;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        if Rec."Entry No." <> 0 then
            exit(false);
        Rec."Entry No." := NextEntryNo;
        if (not InsertIsBlocked) and (not ZeroLineExists) then
            if not TestTempSpecificationExists then begin
                TempItemTrackLineInsert.TRANSFERFIELDS(Rec);
                TempItemTrackLineInsert.INSERT;
                Rec.INSERT;
                ItemTrackingDataCollection.UpdateTrackingDataSetWithChange(
                  TempItemTrackLineInsert, CurrentSignFactor * SourceQuantityArray[1] < 0, CurrentSignFactor, 0);
            end;
        CalculateSums;

        exit(false);
    end;

    trigger OnModifyRecord(): Boolean;
    var
        xTempTrackingSpec: Record "Tracking Specification" temporary;
    begin
        if InsertIsBlocked then
            if (xRec."Lot No." <> Rec."Lot No.") or
               (xRec."Serial No." <> Rec."Serial No.") or
               (xRec."Quantity (Base)" <> Rec."Quantity (Base)")
            then
                exit(false);

        if not TestTempSpecificationExists then begin
            Rec.MODIFY;

            if (xRec."Lot No." <> Rec."Lot No.") or (xRec."Serial No." <> Rec."Serial No.") then begin
                xTempTrackingSpec := xRec;
                ItemTrackingDataCollection.UpdateTrackingDataSetWithChange(
                  xTempTrackingSpec, CurrentSignFactor * SourceQuantityArray[1] < 0, CurrentSignFactor, 2);
            end;

            if TempItemTrackLineModify.GET(Rec."Entry No.") then
                TempItemTrackLineModify.DELETE;
            if TempItemTrackLineInsert.GET(Rec."Entry No.") then begin
                TempItemTrackLineInsert.TRANSFERFIELDS(Rec);
                TempItemTrackLineInsert.MODIFY;
                ItemTrackingDataCollection.UpdateTrackingDataSetWithChange(
                  TempItemTrackLineInsert, CurrentSignFactor * SourceQuantityArray[1] < 0, CurrentSignFactor, 1);
            end else begin
                TempItemTrackLineModify.TRANSFERFIELDS(Rec);
                TempItemTrackLineModify.INSERT;
                ItemTrackingDataCollection.UpdateTrackingDataSetWithChange(
                  TempItemTrackLineModify, CurrentSignFactor * SourceQuantityArray[1] < 0, CurrentSignFactor, 1);
            end;
        end;
        CalculateSums;

        exit(false);
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        Rec."Qty. per Unit of Measure" := QtyPerUOM;
    end;

    trigger OnOpenPage();
    begin
        ItemNoEditable := false;
        VariantCodeEditable := false;
        LocationCodeEditable := false;
        if InboundIsSet then begin
            ApplFromItemEntryVisible := Inbound;
            ApplToItemEntryVisible := not Inbound;
        end;

        UpdateUndefinedQtyArray;

        CurrentFormIsOpen := true;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    begin
        if not UpdateUndefinedQty then
            exit(CONFIRM(Text006));

        if not ItemTrackingDataCollection.RefreshTrackingAvailability(Rec, false) then begin
            CurrPage.UPDATE;
            exit(CONFIRM(Text019, true));
        end;
    end;

    var
        xTempItemTrackingLine: Record "Tracking Specification" temporary;
        TotalItemTrackingLine: Record "Tracking Specification";
        TempItemTrackLineInsert: Record "Tracking Specification" temporary;
        TempItemTrackLineModify: Record "Tracking Specification" temporary;
        TempItemTrackLineDelete: Record "Tracking Specification" temporary;
        TempItemTrackLineReserv: Record "Tracking Specification" temporary;
        Item: Record Item;
        ItemTrackingCode: Record "Item Tracking Code";
        TempReservEntry: Record "Reservation Entry" temporary;
        NoSeriesMgt: Codeunit "No. Series";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        ItemTrackingDataCollection: Codeunit "Item Tracking Data Collection";
        UndefinedQtyArray: array[3] of Decimal;
        SourceQuantityArray: array[5] of Decimal;
        QtyPerUOM: Decimal;
        QtyToAddAsBlank: Decimal;
        CurrentSignFactor: Integer;
        Text002: label 'Quantity must be %1.';
        Text003: label 'negative';
        Text004: label 'positive';
        LastEntryNo: Integer;
        CurrentSourceType: Integer;
        SecondSourceID: Integer;
        IsAssembleToOrder: Boolean;
        ExpectedReceiptDate: Date;
        ShipmentDate: Date;
        Text005: label 'Error when writing to database.';
        Text006: Label 'The corrections cannot be saved as excess quantity has been defined.\Close the form anyway?';
        Text007: Label 'Another user has modified the item tracking data since it was retrieved from the database.\Start again.';
        CurrentEntryStatus: Enum "Reservation Status";
        FormRunMode: Option Reclass,"Combined Ship/Rcpt","Drop Shipment",Transfer;
        InsertIsBlocked: Boolean;
        Text008: Label 'The quantity to create must be an integer.';
        Text009: Label 'The quantity to create must be positive.';
        Text011: Label 'Tracking specification with Serial No. %1 and Lot No. %2 already exists.';
        Text012: Label 'Tracking specification with Serial No. %1 already exists.';
        DeleteIsBlocked: Boolean;
        Text014: Label 'The total item tracking quantity %1 exceeds the %2 quantity %3.\The changes cannot be saved to the database.';
        Text015: Label 'Do you want to synchronize item tracking on the line with item tracking on the related drop shipment %1?';
        BlockCommit: Boolean;
        IsCorrection: Boolean;
        CurrentFormIsOpen: Boolean;
        CalledFromSynchWhseItemTrkg: Boolean;
        Inbound: Boolean;
        CurrentSourceCaption: Text[255];
        CurrentSourceRowID: Text[250];
        SecondSourceRowID: Text[250];
        Text016: Label 'purchase order line';
        Text017: Label 'sales order line';
        Text018: Label 'Saving item tracking line changes';
        ForBinCode: Code[20];
        Text019: Label 'There are availability warnings on one or more lines.\Close the form anyway?';
        Text020: Label 'Placeholder';
        [InDataSet]
        ApplFromItemEntryVisible: Boolean;
        [InDataSet]
        ApplToItemEntryVisible: Boolean;
        [InDataSet]
        ItemNoEditable: Boolean;
        [InDataSet]
        VariantCodeEditable: Boolean;
        [InDataSet]
        LocationCodeEditable: Boolean;
        [InDataSet]
        Handle1Visible: Boolean;
        [InDataSet]
        Handle2Visible: Boolean;
        [InDataSet]
        Handle3Visible: Boolean;
        [InDataSet]
        QtyToHandleBaseVisible: Boolean;
        [InDataSet]
        Invoice1Visible: Boolean;
        [InDataSet]
        Invoice2Visible: Boolean;
        [InDataSet]
        Invoice3Visible: Boolean;
        [InDataSet]
        QtyToInvoiceBaseVisible: Boolean;
        [InDataSet]
        NewSerialNoVisible: Boolean;
        [InDataSet]
        NewLotNoVisible: Boolean;
        [InDataSet]
        NewExpirationDateVisible: Boolean;
        [InDataSet]
        ButtonLineReclassVisible: Boolean;
        [InDataSet]
        ButtonLineVisible: Boolean;
        [InDataSet]
        FunctionsSupplyVisible: Boolean;
        [InDataSet]
        FunctionsDemandVisible: Boolean;
        InboundIsSet: Boolean;
        [InDataSet]
        QtyToHandleBaseEditable: Boolean;
        [InDataSet]
        QtyToInvoiceBaseEditable: Boolean;
        [InDataSet]
        QuantityBaseEditable: Boolean;
        [InDataSet]
        SerialNoEditable: Boolean;
        [InDataSet]
        LotNoEditable: Boolean;
        [InDataSet]
        DescriptionEditable: Boolean;
        [InDataSet]
        NewSerialNoEditable: Boolean;
        [InDataSet]
        NewLotNoEditable: Boolean;
        [InDataSet]
        NewExpirationDateEditable: Boolean;
        [InDataSet]
        ExpirationDateEditable: Boolean;
        [InDataSet]
        WarrantyDateEditable: Boolean;
        ExcludePostedEntries: Boolean;
        ProdOrderLineHandling: Boolean;

    [Scope('Cloud')]
    procedure SetFormRunMode(Mode: Option Reclass,"Combined Ship/Rcpt","Drop Shipment");
    begin
        FormRunMode := Mode;
    end;

    [Scope('Cloud')]
    procedure SetSourceSpec(TrackingSpecification: Record "Tracking Specification"; AvailabilityDate: Date);
    var
        ReservEntry: Record "Reservation Entry";
        TempTrackingSpecification: Record "Tracking Specification" temporary;
        TempTrackingSpecification2: Record "Tracking Specification" temporary;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        Controls: Option Handle,Invoice,Quantity,Reclass,Tracking;
    begin
        GetItem(TrackingSpecification."Item No.");
        ForBinCode := TrackingSpecification."Bin Code";
        SetFilters(TrackingSpecification);
        TempTrackingSpecification.DELETEALL;
        TempItemTrackLineInsert.DELETEALL;
        TempItemTrackLineModify.DELETEALL;
        TempItemTrackLineDelete.DELETEALL;

        TempReservEntry.DELETEALL;
        LastEntryNo := 0;
        if ItemTrackingMgt.IsOrderNetworkEntity(TrackingSpecification."Source Type",
             TrackingSpecification."Source Subtype") and not (FormRunMode = FormRunMode::"Drop Shipment")
        then
            CurrentEntryStatus := CurrentEntryStatus::Surplus
        else
            CurrentEntryStatus := CurrentEntryStatus::Prospect;

        // Set controls for Qty to handle:
        SetControls(Controls::Handle, GetHandleSource(TrackingSpecification));
        // Set controls for Qty to Invoice:
        SetControls(Controls::Invoice, GetInvoiceSource(TrackingSpecification));

        SetControls(Controls::Reclass, FormRunMode = FormRunMode::Reclass);

        if FormRunMode = FormRunMode::"Combined Ship/Rcpt" then
            SetControls(Controls::Tracking, false);
        if ItemTrackingMgt.ItemTrkgIsManagedByWhse(
             TrackingSpecification."Source Type",
             TrackingSpecification."Source Subtype",
             TrackingSpecification."Source ID",
             TrackingSpecification."Source Prod. Order Line",
             TrackingSpecification."Source Ref. No.",
             TrackingSpecification."Location Code",
             TrackingSpecification."Item No.")
        then begin
            SetControls(Controls::Quantity, false);
            QtyToHandleBaseEditable := true;
            DeleteIsBlocked := true;
        end;

        ReservEntry."Source Type" := TrackingSpecification."Source Type";
        ReservEntry."Source Subtype" := TrackingSpecification."Source Subtype";
        CurrentSignFactor := CreateReservEntry.SignFactor(ReservEntry);
        CurrentSourceCaption := ReservEntry.TextCaption;
        CurrentSourceType := ReservEntry."Source Type";

        if CurrentSignFactor < 0 then begin
            ExpectedReceiptDate := 0D;
            ShipmentDate := AvailabilityDate;
        end else begin
            ExpectedReceiptDate := AvailabilityDate;
            ShipmentDate := 0D;
        end;

        SourceQuantityArray[1] := TrackingSpecification."Quantity (Base)";
        SourceQuantityArray[2] := TrackingSpecification."Qty. to Handle (Base)";
        SourceQuantityArray[3] := TrackingSpecification."Qty. to Invoice (Base)";
        SourceQuantityArray[4] := TrackingSpecification."Quantity Handled (Base)";
        SourceQuantityArray[5] := TrackingSpecification."Quantity Invoiced (Base)";
        QtyPerUOM := TrackingSpecification."Qty. per Unit of Measure";

        ReservEntry.SETCURRENTKEY(
          "Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
          "Source Batch Name", "Source Prod. Order Line", "Reservation Status");

        ReservEntry.SETRANGE("Source ID", TrackingSpecification."Source ID");
        ReservEntry.SETRANGE("Source Ref. No.", TrackingSpecification."Source Ref. No.");
        ReservEntry.SETRANGE("Source Type", TrackingSpecification."Source Type");
        ReservEntry.SETRANGE("Source Subtype", TrackingSpecification."Source Subtype");
        ReservEntry.SETRANGE("Source Batch Name", TrackingSpecification."Source Batch Name");
        ReservEntry.SETRANGE("Source Prod. Order Line", TrackingSpecification."Source Prod. Order Line");

        // Transfer Receipt gets special treatment:
        if (TrackingSpecification."Source Type" = DATABASE::"Transfer Line") and
           (FormRunMode <> FormRunMode::Transfer) and
           (TrackingSpecification."Source Subtype" = 1)
        then begin
            ReservEntry.SETRANGE("Source Subtype", 0);
            AddReservEntriesToTempRecSet(ReservEntry, TempTrackingSpecification2, true, 8421504);
            ReservEntry.SETRANGE("Source Subtype", 1);
            ReservEntry.SETRANGE("Source Prod. Order Line", TrackingSpecification."Source Ref. No.");
            ReservEntry.SETRANGE("Source Ref. No.");
            DeleteIsBlocked := true;
            SetControls(Controls::Quantity, false);
        end;

        AddReservEntriesToTempRecSet(ReservEntry, TempTrackingSpecification, false, 0);

        TempReservEntry.COPYFILTERS(ReservEntry);

        TrackingSpecification.SETCURRENTKEY(
          "Source ID", "Source Type", "Source Subtype",
          "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.");

        TrackingSpecification.SETRANGE("Source ID", TrackingSpecification."Source ID");
        TrackingSpecification.SETRANGE("Source Type", TrackingSpecification."Source Type");
        TrackingSpecification.SETRANGE("Source Subtype", TrackingSpecification."Source Subtype");
        TrackingSpecification.SETRANGE("Source Batch Name", TrackingSpecification."Source Batch Name");
        TrackingSpecification.SETRANGE("Source Prod. Order Line", TrackingSpecification."Source Prod. Order Line");
        TrackingSpecification.SETRANGE("Source Ref. No.", TrackingSpecification."Source Ref. No.");

        if TrackingSpecification.FINDSET then
            repeat
                TempTrackingSpecification := TrackingSpecification;
                TempTrackingSpecification.INSERT;
            until TrackingSpecification.NEXT = 0;

        // Data regarding posted quantities on transfers is collected from Item Ledger Entries:
        if TrackingSpecification."Source Type" = DATABASE::"Transfer Line" then
            CollectPostedTransferEntries(TrackingSpecification, TempTrackingSpecification);

        // Data regarding posted quantities on assembly orders is collected from Item Ledger Entries:
        if not ExcludePostedEntries then
            if (TrackingSpecification."Source Type" = DATABASE::"Assembly Line") or
               (TrackingSpecification."Source Type" = DATABASE::"Assembly Header")
            then
                CollectPostedAssemblyEntries(TrackingSpecification, TempTrackingSpecification);

        // Data regarding posted output quantities on prod.orders is collected from Item Ledger Entries:
        if TrackingSpecification."Source Type" = DATABASE::"Prod. Order Line" then
            if TrackingSpecification."Source Subtype" = 3 then
                CollectPostedOutputEntries(TrackingSpecification, TempTrackingSpecification);

        // If run for Drop Shipment a RowID is prepared for synchronisation:
        if FormRunMode = FormRunMode::"Drop Shipment" then
            CurrentSourceRowID := ItemTrackingMgt.ComposeRowID(TrackingSpecification."Source Type",
                TrackingSpecification."Source Subtype", TrackingSpecification."Source ID",
                TrackingSpecification."Source Batch Name", TrackingSpecification."Source Prod. Order Line",
                TrackingSpecification."Source Ref. No.");

        // Synchronization of outbound transfer order:
        if (TrackingSpecification."Source Type" = DATABASE::"Transfer Line") and
           (TrackingSpecification."Source Subtype" = 0)
        then begin
            BlockCommit := true;
            CurrentSourceRowID := ItemTrackingMgt.ComposeRowID(TrackingSpecification."Source Type",
                TrackingSpecification."Source Subtype", TrackingSpecification."Source ID",
                TrackingSpecification."Source Batch Name", TrackingSpecification."Source Prod. Order Line",
                TrackingSpecification."Source Ref. No.");
            SecondSourceRowID := ItemTrackingMgt.ComposeRowID(TrackingSpecification."Source Type",
                1, TrackingSpecification."Source ID",
                TrackingSpecification."Source Batch Name", TrackingSpecification."Source Prod. Order Line",
                TrackingSpecification."Source Ref. No.");
            FormRunMode := FormRunMode::Transfer;
        end;

        AddToGlobalRecordSet(TempTrackingSpecification);
        AddToGlobalRecordSet(TempTrackingSpecification2);
        CalculateSums;

        ItemTrackingDataCollection.SetCurrentBinAndItemTrkgCode(ForBinCode, ItemTrackingCode);
        ItemTrackingDataCollection.RetrieveLookupData(Rec, false);

        FunctionsDemandVisible := CurrentSignFactor * SourceQuantityArray[1] < 0;
        FunctionsSupplyVisible := not FunctionsDemandVisible;
    end;

    [Scope('Cloud')]
    procedure SetSecondSourceQuantity(SecondSourceQuantityArray: array[3] of Decimal);
    var
        Controls: Option Handle,Invoice;
    begin
        case SecondSourceQuantityArray[1] of
            DATABASE::"Warehouse Receipt Line", DATABASE::"Warehouse Shipment Line":
                begin
                    SourceQuantityArray[2] := SecondSourceQuantityArray[2]; // "Qty. to Handle (Base)"
                    SourceQuantityArray[3] := SecondSourceQuantityArray[3]; // "Qty. to Invoice (Base)"
                    SetControls(Controls::Invoice, false);
                end;
            else
                exit;
        end;
        CalculateSums;
    end;

    [Scope('Cloud')]
    procedure SetSecondSourceRowID(RowID: Text[250]);
    begin
        SecondSourceRowID := RowID;
    end;

    local procedure AddReservEntriesToTempRecSet(var ReservEntry: Record "Reservation Entry"; var TempTrackingSpecification: Record "Tracking Specification" temporary; SwapSign: Boolean; Color: Integer);
    var
        FromReservEntry: Record "Reservation Entry";
        AddTracking: Boolean;
    begin
        if ReservEntry.FINDSET then
            repeat
                if Color = 0 then begin
                    TempReservEntry := ReservEntry;
                    TempReservEntry.INSERT;
                end;
                if ReservEntry.TrackingExists then begin
                    AddTracking := true;
                    if SecondSourceID = DATABASE::"Warehouse Shipment Line" then
                        if FromReservEntry.GET(ReservEntry."Entry No.", not ReservEntry.Positive) then
                            AddTracking := (FromReservEntry."Source Type" = DATABASE::"Assembly Header") = IsAssembleToOrder
                        else
                            AddTracking := not IsAssembleToOrder;

                    if AddTracking then begin
                        TempTrackingSpecification.TRANSFERFIELDS(ReservEntry);
                        // Ensure uniqueness of Entry No. by making it negative:
                        TempTrackingSpecification."Entry No." *= -1;
                        if SwapSign then
                            TempTrackingSpecification."Quantity (Base)" *= -1;
                        if Color <> 0 then begin
                            TempTrackingSpecification."Quantity Handled (Base)" :=
                              TempTrackingSpecification."Quantity (Base)";
                            TempTrackingSpecification."Quantity Invoiced (Base)" :=
                              TempTrackingSpecification."Quantity (Base)";
                            TempTrackingSpecification."Qty. to Handle (Base)" := 0;
                            TempTrackingSpecification."Qty. to Invoice (Base)" := 0;
                        end;
                        TempTrackingSpecification."Buffer Status" := Color;
                        TempTrackingSpecification.INSERT;
                    end;
                end;
            until ReservEntry.NEXT = 0;
    end;

    local procedure AddToGlobalRecordSet(var TempTrackingSpecification: Record "Tracking Specification" temporary);
    var
        ExpDate: Date;
        EntriesExist: Boolean;
    begin
        TempTrackingSpecification.SETCURRENTKEY("Lot No.", "Serial No.");
        if TempTrackingSpecification.FIND('-') then
            repeat
                TempTrackingSpecification.SetTrackingFilterFromSpec(TempTrackingSpecification);
                TempTrackingSpecification.CALCSUMS("Quantity (Base)", "Qty. to Handle (Base)",
                  "Qty. to Invoice (Base)", "Quantity Handled (Base)", "Quantity Invoiced (Base)");
                if TempTrackingSpecification."Quantity (Base)" <> 0 then begin
                    Rec := TempTrackingSpecification;
                    Rec."Quantity (Base)" *= CurrentSignFactor;
                    Rec."Qty. to Handle (Base)" *= CurrentSignFactor;
                    Rec."Qty. to Invoice (Base)" *= CurrentSignFactor;
                    Rec."Quantity Handled (Base)" *= CurrentSignFactor;
                    Rec."Quantity Invoiced (Base)" *= CurrentSignFactor;
                    Rec."Qty. to Handle" :=
                      Rec.CalcQty(Rec."Qty. to Handle (Base)");
                    Rec."Qty. to Invoice" :=
                      Rec.CalcQty(Rec."Qty. to Invoice (Base)");
                    Rec."Entry No." := NextEntryNo;
                    /*
                    ExpDate := ItemTrackingMgt.ExistingExpirationDate(
                        Rec."Item No.", Rec."Variant Code",
                        Rec."Lot No.", Rec."Serial No.", false, EntriesExist);
                    */

                    if ExpDate <> 0D then begin
                        Rec."Expiration Date" := ExpDate;
                        Rec."Buffer Status2" := Rec."Buffer Status2"::"ExpDate blocked";
                    end;

                    Rec.INSERT;

                    if Rec."Buffer Status" = 0 then begin
                        xTempItemTrackingLine := Rec;
                        xTempItemTrackingLine.INSERT;
                    end;
                end;

                TempTrackingSpecification.FIND('+');
                TempTrackingSpecification.ClearTrackingFilter;
            until TempTrackingSpecification.NEXT = 0;
    end;

    local procedure SetControls(Controls: Option Handle,Invoice,Quantity,Reclass,Tracking; SetAccess: Boolean);
    begin
        case Controls of
            Controls::Handle:
                begin
                    Handle1Visible := SetAccess;
                    Handle2Visible := SetAccess;
                    Handle3Visible := SetAccess;
                    QtyToHandleBaseVisible := SetAccess;
                    QtyToHandleBaseEditable := SetAccess;
                end;
            Controls::Invoice:
                begin
                    Invoice1Visible := SetAccess;
                    Invoice2Visible := SetAccess;
                    Invoice3Visible := SetAccess;
                    QtyToInvoiceBaseVisible := SetAccess;
                    QtyToInvoiceBaseEditable := SetAccess;
                end;
            Controls::Quantity:
                begin
                    QuantityBaseEditable := SetAccess;
                    SerialNoEditable := SetAccess;
                    LotNoEditable := SetAccess;
                    DescriptionEditable := SetAccess;
                    InsertIsBlocked := true;
                end;
            Controls::Reclass:
                begin
                    NewSerialNoVisible := SetAccess;
                    NewSerialNoEditable := SetAccess;
                    NewLotNoVisible := SetAccess;
                    NewLotNoEditable := SetAccess;
                    NewExpirationDateVisible := SetAccess;
                    NewExpirationDateEditable := SetAccess;
                    ButtonLineReclassVisible := SetAccess;
                    ButtonLineVisible := not SetAccess;
                end;
            Controls::Tracking:
                begin
                    SerialNoEditable := SetAccess;
                    LotNoEditable := SetAccess;
                    ExpirationDateEditable := SetAccess;
                    WarrantyDateEditable := SetAccess;
                    InsertIsBlocked := SetAccess;
                end;
        end;
    end;

    local procedure GetItem(ItemNo: Code[20]);
    begin
        if Item."No." <> ItemNo then begin
            Item.GET(ItemNo);
            Item.TESTFIELD(Item."Item Tracking Code");
            if ItemTrackingCode.Code <> Item."Item Tracking Code" then
                ItemTrackingCode.GET(Item."Item Tracking Code");
        end;
    end;

    local procedure SetFilters(TrackingSpecification: Record "Tracking Specification");
    begin
        Rec.FILTERGROUP := 2;
        Rec.SETCURRENTKEY(Rec."Source ID", Rec."Source Type", Rec."Source Subtype", Rec."Source Batch Name", Rec."Source Prod. Order Line", Rec."Source Ref. No.");
        Rec.SETRANGE(Rec."Source ID", TrackingSpecification."Source ID");
        Rec.SETRANGE(Rec."Source Type", TrackingSpecification."Source Type");
        Rec.SETRANGE(Rec."Source Subtype", TrackingSpecification."Source Subtype");
        Rec.SETRANGE(Rec."Source Batch Name", TrackingSpecification."Source Batch Name");
        if (TrackingSpecification."Source Type" = DATABASE::"Transfer Line") and
           (TrackingSpecification."Source Subtype" = 1)
        then begin
            Rec.SETFILTER(Rec."Source Prod. Order Line", '0 | ' + FORMAT(TrackingSpecification."Source Ref. No."));
            Rec.SETRANGE(Rec."Source Ref. No.");
        end else begin
            Rec.SETRANGE(Rec."Source Prod. Order Line", TrackingSpecification."Source Prod. Order Line");
            Rec.SETRANGE(Rec."Source Ref. No.", TrackingSpecification."Source Ref. No.");
        end;
        Rec.SETRANGE(Rec."Item No.", TrackingSpecification."Item No.");
        Rec.SETRANGE(Rec."Location Code", TrackingSpecification."Location Code");
        Rec.SETRANGE(Rec."Variant Code", TrackingSpecification."Variant Code");
        Rec.FILTERGROUP := 0;
    end;

    local procedure CheckLine(TrackingLine: Record "Tracking Specification");
    begin
        if TrackingLine."Quantity (Base)" * SourceQuantityArray[1] < 0 then
            if SourceQuantityArray[1] < 0 then
                ERROR(Text002, Text003)
            else
                ERROR(Text002, Text004);
    end;

    local procedure CalculateSums();
    var
        xTrackingSpec: Record "Tracking Specification";
    begin
        xTrackingSpec.COPY(Rec);
        Rec.RESET;
        Rec.CALCSUMS(Rec."Quantity (Base)",
          Rec."Qty. to Handle (Base)",
          Rec."Qty. to Invoice (Base)");
        TotalItemTrackingLine := Rec;
        Rec.COPY(xTrackingSpec);

        UpdateUndefinedQtyArray;
    end;

    local procedure UpdateUndefinedQty(): Boolean;
    begin
        UpdateUndefinedQtyArray;
        if ProdOrderLineHandling then // Avoid check for prod.journal lines
            exit(true);
        exit(ABS(SourceQuantityArray[1]) >= ABS(TotalItemTrackingLine."Quantity (Base)"));
    end;

    local procedure UpdateUndefinedQtyArray();
    begin
        UndefinedQtyArray[1] := SourceQuantityArray[1] - TotalItemTrackingLine."Quantity (Base)";
        UndefinedQtyArray[2] := SourceQuantityArray[2] - TotalItemTrackingLine."Qty. to Handle (Base)";
        UndefinedQtyArray[3] := SourceQuantityArray[3] - TotalItemTrackingLine."Qty. to Invoice (Base)";
    end;

    local procedure TempRecIsValid() OK: Boolean;
    var
        ReservEntry: Record "Reservation Entry";
        RecordCount: Integer;
        IdenticalArray: array[2] of Boolean;
    begin
        OK := false;
        TempReservEntry.SETCURRENTKEY(TempReservEntry."Entry No.", TempReservEntry.Positive);
        ReservEntry.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type",
          "Source Subtype", "Source Batch Name", "Source Prod. Order Line");

        ReservEntry.COPYFILTERS(TempReservEntry);

        if ReservEntry.FINDSET then
            repeat
                if not TempReservEntry.GET(ReservEntry."Entry No.", ReservEntry.Positive) then
                    exit(false);
                if not EntriesAreIdentical(ReservEntry, TempReservEntry, IdenticalArray) then
                    exit(false);
                RecordCount += 1;
            until ReservEntry.NEXT = 0;

        OK := RecordCount = TempReservEntry.COUNT;
    end;

    local procedure EntriesAreIdentical(var ReservEntry1: Record "Reservation Entry"; var ReservEntry2: Record "Reservation Entry"; var IdenticalArray: array[2] of Boolean): Boolean;
    begin
        IdenticalArray[1] := (
                              (ReservEntry1."Entry No." = ReservEntry2."Entry No.") and
                              (ReservEntry1."Item No." = ReservEntry2."Item No.") and
                              (ReservEntry1."Location Code" = ReservEntry2."Location Code") and
                              (ReservEntry1."Quantity (Base)" = ReservEntry2."Quantity (Base)") and
                              (ReservEntry1."Reservation Status" = ReservEntry2."Reservation Status") and
                              (ReservEntry1."Creation Date" = ReservEntry2."Creation Date") and
                              (ReservEntry1."Transferred from Entry No." = ReservEntry2."Transferred from Entry No.") and
                              (ReservEntry1."Source Type" = ReservEntry2."Source Type") and
                              (ReservEntry1."Source Subtype" = ReservEntry2."Source Subtype") and
                              (ReservEntry1."Source ID" = ReservEntry2."Source ID") and
                              (ReservEntry1."Source Batch Name" = ReservEntry2."Source Batch Name") and
                              (ReservEntry1."Source Prod. Order Line" = ReservEntry2."Source Prod. Order Line") and
                              (ReservEntry1."Source Ref. No." = ReservEntry2."Source Ref. No.") and
                              (ReservEntry1."Expected Receipt Date" = ReservEntry2."Expected Receipt Date") and
                              (ReservEntry1."Shipment Date" = ReservEntry2."Shipment Date") and
                              (ReservEntry1."Serial No." = ReservEntry2."Serial No.") and
                              (ReservEntry1."Created By" = ReservEntry2."Created By") and
                              (ReservEntry1."Changed By" = ReservEntry2."Changed By") and
                              (ReservEntry1.Positive = ReservEntry2.Positive) and
                              (ReservEntry1."Qty. per Unit of Measure" = ReservEntry2."Qty. per Unit of Measure") and
                              (ReservEntry1.Quantity = ReservEntry2.Quantity) and
                              (ReservEntry1."Action Message Adjustment" = ReservEntry2."Action Message Adjustment") and
                              (ReservEntry1.Binding = ReservEntry2.Binding) and
                              (ReservEntry1."Suppressed Action Msg." = ReservEntry2."Suppressed Action Msg.") and
                              (ReservEntry1."Planning Flexibility" = ReservEntry2."Planning Flexibility") and
                              (ReservEntry1."Lot No." = ReservEntry2."Lot No.") and
                              (ReservEntry1."Variant Code" = ReservEntry2."Variant Code") and
                              (ReservEntry1."Quantity Invoiced (Base)" = ReservEntry2."Quantity Invoiced (Base)"));

        IdenticalArray[2] := (
                              (ReservEntry1.Description = ReservEntry2.Description) and
                              (ReservEntry1."New Serial No." = ReservEntry2."New Serial No.") and
                              (ReservEntry1."New Lot No." = ReservEntry2."New Lot No.") and
                              (ReservEntry1."Expiration Date" = ReservEntry2."Expiration Date") and
                              (ReservEntry1."Warranty Date" = ReservEntry2."Warranty Date") and
                              (ReservEntry1."New Expiration Date" = ReservEntry2."New Expiration Date"));

        exit(IdenticalArray[1] and IdenticalArray[2]);
    end;

    local procedure QtyToHandleAndInvoiceChanged(var ReservEntry1: Record "Reservation Entry"; var ReservEntry2: Record "Reservation Entry"): Boolean;
    begin
        exit(
          (ReservEntry1."Qty. to Handle (Base)" <> ReservEntry2."Qty. to Handle (Base)") or
          (ReservEntry1."Qty. to Invoice (Base)" <> ReservEntry2."Qty. to Invoice (Base)"));
    end;

    local procedure NextEntryNo(): Integer;
    begin
        LastEntryNo += 1;
        exit(LastEntryNo);
    end;

    local procedure WriteToDatabase();
    var
        Window: Dialog;
        ChangeType: Option Insert,Modify,Delete;
        EntryNo: Integer;
        NoOfLines: Integer;
        i: Integer;
        ModifyLoop: Integer;
        Decrease: Boolean;
    begin
        if CurrentFormIsOpen then begin
            TempReservEntry.LOCKTABLE;
            TempRecValid;

            if Item."Order Tracking Policy" = Item."Order Tracking Policy"::None then
                QtyToAddAsBlank := 0
            else
                QtyToAddAsBlank := UndefinedQtyArray[1] * CurrentSignFactor;

            Rec.RESET;
            Rec.DELETEALL;

            Window.OPEN('#1############# @2@@@@@@@@@@@@@@@@@@@@@');
            Window.UPDATE(1, Text018);
            NoOfLines := TempItemTrackLineInsert.COUNT + TempItemTrackLineModify.COUNT + TempItemTrackLineDelete.COUNT;
            if TempItemTrackLineDelete.FIND('-') then begin
                repeat
                    i := i + 1;
                    if i mod 100 = 0 then
                        Window.UPDATE(2, ROUND(i / NoOfLines * 10000, 1));
                    RegisterChange(TempItemTrackLineDelete, TempItemTrackLineDelete, ChangeType::Delete, false);
                    if TempItemTrackLineModify.GET(TempItemTrackLineDelete."Entry No.") then
                        TempItemTrackLineModify.DELETE;
                until TempItemTrackLineDelete.NEXT = 0;
                TempItemTrackLineDelete.DELETEALL;
            end;

            for ModifyLoop := 1 to 2 do begin
                if TempItemTrackLineModify.FIND('-') then
                    repeat
                        if xTempItemTrackingLine.GET(TempItemTrackLineModify."Entry No.") then begin
                            // Process decreases before increases
                            Decrease := (xTempItemTrackingLine."Quantity (Base)" > TempItemTrackLineModify."Quantity (Base)");
                            if ((ModifyLoop = 1) and Decrease) or ((ModifyLoop = 2) and not Decrease) then begin
                                i := i + 1;
                                if (xTempItemTrackingLine."Serial No." <> TempItemTrackLineModify."Serial No.") or
                                   (xTempItemTrackingLine."Lot No." <> TempItemTrackLineModify."Lot No.") or
                                   (xTempItemTrackingLine."Appl.-from Item Entry" <> TempItemTrackLineModify."Appl.-from Item Entry") or
                                   (xTempItemTrackingLine."Appl.-to Item Entry" <> TempItemTrackLineModify."Appl.-to Item Entry")
                                then begin
                                    RegisterChange(xTempItemTrackingLine, xTempItemTrackingLine, ChangeType::Delete, false);
                                    RegisterChange(TempItemTrackLineModify, TempItemTrackLineModify, ChangeType::Insert, false);
                                    if (TempItemTrackLineInsert."Quantity (Base)" <> TempItemTrackLineInsert."Qty. to Handle (Base)") or
                                       (TempItemTrackLineInsert."Quantity (Base)" <> TempItemTrackLineInsert."Qty. to Invoice (Base)")
                                    then
                                        SetQtyToHandleAndInvoice(TempItemTrackLineInsert);
                                end else begin
                                    RegisterChange(xTempItemTrackingLine, TempItemTrackLineModify, ChangeType::Modify, false);
                                    SetQtyToHandleAndInvoice(TempItemTrackLineModify);
                                end;
                                TempItemTrackLineModify.DELETE;
                            end;
                        end else begin
                            i := i + 1;
                            TempItemTrackLineModify.DELETE;
                        end;
                        if i mod 100 = 0 then
                            Window.UPDATE(2, ROUND(i / NoOfLines * 10000, 1));
                    until TempItemTrackLineModify.NEXT = 0;
            end;

            if TempItemTrackLineInsert.FIND('-') then begin
                repeat
                    i := i + 1;
                    if i mod 100 = 0 then
                        Window.UPDATE(2, ROUND(i / NoOfLines * 10000, 1));
                    if TempItemTrackLineModify.GET(TempItemTrackLineInsert."Entry No.") then
                        TempItemTrackLineInsert.TRANSFERFIELDS(TempItemTrackLineModify);
                    if not RegisterChange(TempItemTrackLineInsert, TempItemTrackLineInsert, ChangeType::Insert, false) then
                        ERROR(Text005);
                    if (TempItemTrackLineInsert."Quantity (Base)" <> TempItemTrackLineInsert."Qty. to Handle (Base)") or
                       (TempItemTrackLineInsert."Quantity (Base)" <> TempItemTrackLineInsert."Qty. to Invoice (Base)")
                    then
                        SetQtyToHandleAndInvoice(TempItemTrackLineInsert);
                until TempItemTrackLineInsert.NEXT = 0;
                TempItemTrackLineInsert.DELETEALL;
            end;
            Window.CLOSE;
        end else begin
            TempReservEntry.LOCKTABLE;
            TempRecValid;

            if Item."Order Tracking Policy" = Item."Order Tracking Policy"::None then
                QtyToAddAsBlank := 0
            else
                QtyToAddAsBlank := UndefinedQtyArray[1] * CurrentSignFactor;

            Rec.RESET;
            Rec.SETFILTER(Rec."Buffer Status", '<>%1', 0);
            Rec.DELETEALL;
            Rec.RESET;

            xTempItemTrackingLine.RESET;
            Rec.SETCURRENTKEY(Rec."Entry No.");
            xTempItemTrackingLine.SETCURRENTKEY(xTempItemTrackingLine."Entry No.");
            if xTempItemTrackingLine.FIND('-') then
                repeat
                    Rec.SetTrackingFilterFromSpec(xTempItemTrackingLine);
                    if Rec.FIND('-') then begin
                        if RegisterChange(xTempItemTrackingLine, Rec, ChangeType::Modify, false) then begin
                            EntryNo := xTempItemTrackingLine."Entry No.";
                            xTempItemTrackingLine := Rec;
                            xTempItemTrackingLine."Entry No." := EntryNo;
                            xTempItemTrackingLine.MODIFY;
                        end;
                        SetQtyToHandleAndInvoice(Rec);
                        Rec.DELETE;
                    end else begin
                        RegisterChange(xTempItemTrackingLine, xTempItemTrackingLine, ChangeType::Delete, false);
                        xTempItemTrackingLine.DELETE;
                    end;
                until xTempItemTrackingLine.NEXT = 0;

            Rec.RESET;

            if Rec.FIND('-') then
                repeat
                    if RegisterChange(Rec, Rec, ChangeType::Insert, false) then begin
                        xTempItemTrackingLine := Rec;
                        xTempItemTrackingLine.INSERT;
                    end else
                        ERROR(Text005);
                    SetQtyToHandleAndInvoice(Rec);
                    Rec.DELETE;
                until Rec.NEXT = 0;
        end;

        UpdateOrderTracking;
        ReestablishReservations; // Late Binding

        if not BlockCommit then
            COMMIT;
    end;

    local procedure RegisterChange(var OldTrackingSpecification: Record "Tracking Specification"; var NewTrackingSpecification: Record "Tracking Specification"; ChangeType: Option Insert,Modify,FullDelete,PartDelete,ModifyAll; ModifySharedFields: Boolean) OK: Boolean;
    var
        ReservEntry1: Record "Reservation Entry";
        ReservEntry2: Record "Reservation Entry";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ReservationMgt: Codeunit "Reservation Management";
        QtyToAdd: Decimal;
        LostReservQty: Decimal;
        IdenticalArray: array[2] of Boolean;
    begin
        OK := false;

        if ((CurrentSignFactor * NewTrackingSpecification."Qty. to Handle") < 0) and
           (FormRunMode <> FormRunMode::"Drop Shipment")
        then begin
            NewTrackingSpecification."Expiration Date" := 0D;
            OldTrackingSpecification."Expiration Date" := 0D;
        end;

        case ChangeType of
            ChangeType::Insert:
                begin
                    if (OldTrackingSpecification."Quantity (Base)" = 0) or not OldTrackingSpecification.TrackingExists then
                        exit(true);
                    //TempReservEntry.SetTrackingFilter('', '');
                    OldTrackingSpecification."Quantity (Base)" :=
                      CurrentSignFactor *
                      ReservEngineMgt.AddItemTrackingToTempRecSet(
                        TempReservEntry, NewTrackingSpecification, CurrentSignFactor * OldTrackingSpecification."Quantity (Base)",
                        QtyToAddAsBlank, ItemTrackingCode);
                    TempReservEntry.ClearTrackingFilter;

                    // Late Binding
                    if ReservEngineMgt.RetrieveLostReservQty(LostReservQty) then begin
                        TempItemTrackLineReserv := NewTrackingSpecification;
                        TempItemTrackLineReserv."Quantity (Base)" := LostReservQty * CurrentSignFactor;
                        TempItemTrackLineReserv.INSERT;
                    end;

                    if OldTrackingSpecification."Quantity (Base)" = 0 then
                        exit(true);
                    /*
                    if FormRunMode = FormRunMode::Reclass then begin
                        CreateReservEntry.SetNewSerialLotNo(
                          OldTrackingSpecification."New Serial No.", OldTrackingSpecification."New Lot No.");
                        CreateReservEntry.SetNewExpirationDate(OldTrackingSpecification."New Expiration Date");
                    end;
                    */
                    CreateReservEntry.SetDates(
                      NewTrackingSpecification."Warranty Date", NewTrackingSpecification."Expiration Date");
                    CreateReservEntry.SetApplyFromEntryNo(NewTrackingSpecification."Appl.-from Item Entry");
                    CreateReservEntry.SetApplyToEntryNo(NewTrackingSpecification."Appl.-to Item Entry");
                    CreateReservEntry.CreateReservEntryFor(
                      OldTrackingSpecification."Source Type",
                      OldTrackingSpecification."Source Subtype",
                      OldTrackingSpecification."Source ID",
                      OldTrackingSpecification."Source Batch Name",
                      OldTrackingSpecification."Source Prod. Order Line",
                      OldTrackingSpecification."Source Ref. No.",
                      OldTrackingSpecification."Qty. per Unit of Measure",
                      0,
                      OldTrackingSpecification."Quantity (Base)",
                      ReservEntry1);
                    CreateReservEntry.CreateEntry(OldTrackingSpecification."Item No.",
                      OldTrackingSpecification."Variant Code",
                      OldTrackingSpecification."Location Code",
                      OldTrackingSpecification.Description,
                      ExpectedReceiptDate,
                      ShipmentDate, 0, CurrentEntryStatus);
                    CreateReservEntry.GetLastEntry(ReservEntry1);
                    if Item."Order Tracking Policy" = Item."Order Tracking Policy"::"Tracking & Action Msg." then
                        ReservEngineMgt.UpdateActionMessages(ReservEntry1);

                    if ModifySharedFields then begin
                        ReservEntry1.SetPointerFilter;
                        ReservEntry1.SetTrackingFilterFromReservEntry(ReservEntry1);
                        ReservEntry1.SETFILTER("Entry No.", '<>%1', ReservEntry1."Entry No.");
                        ModifyFieldsWithinFilter(ReservEntry1, NewTrackingSpecification);
                    end;

                    OK := true;
                end;
            ChangeType::Modify:
                begin
                    ReservEntry1.TRANSFERFIELDS(OldTrackingSpecification);
                    ReservEntry2.TRANSFERFIELDS(NewTrackingSpecification);

                    ReservEntry1."Entry No." := ReservEntry2."Entry No."; // If only entry no. has changed it should not trigger
                    if EntriesAreIdentical(ReservEntry1, ReservEntry2, IdenticalArray) then
                        exit(QtyToHandleAndInvoiceChanged(ReservEntry1, ReservEntry2));

                    if ABS(OldTrackingSpecification."Quantity (Base)") < ABS(NewTrackingSpecification."Quantity (Base)") then begin
                        // Item Tracking is added to any blank reservation entries:
                        //TempReservEntry.SetTrackingFilter('', '');
                        QtyToAdd :=
                          CurrentSignFactor *
                          ReservEngineMgt.AddItemTrackingToTempRecSet(
                            TempReservEntry, NewTrackingSpecification,
                            CurrentSignFactor * (NewTrackingSpecification."Quantity (Base)" -
                                                 OldTrackingSpecification."Quantity (Base)"), QtyToAddAsBlank,
                            ItemTrackingCode);
                        TempReservEntry.ClearTrackingFilter;

                        // Late Binding
                        if ReservEngineMgt.RetrieveLostReservQty(LostReservQty) then begin
                            TempItemTrackLineReserv := NewTrackingSpecification;
                            TempItemTrackLineReserv."Quantity (Base)" := LostReservQty * CurrentSignFactor;
                            TempItemTrackLineReserv.INSERT;
                        end;

                        OldTrackingSpecification."Quantity (Base)" := QtyToAdd;
                        OldTrackingSpecification."Warranty Date" := NewTrackingSpecification."Warranty Date";
                        OldTrackingSpecification."Expiration Date" := NewTrackingSpecification."Expiration Date";
                        OldTrackingSpecification.Description := NewTrackingSpecification.Description;
                        OnAfterCopyTrackingSpec(NewTrackingSpecification, OldTrackingSpecification);

                        RegisterChange(OldTrackingSpecification, OldTrackingSpecification,
                          ChangeType::Insert, not IdenticalArray[2]);
                    end else begin
                        TempReservEntry.SetTrackingFilterFromSpec(OldTrackingSpecification);
                        OldTrackingSpecification.ClearTracking;
                        OnAfterClearTrackingSpec(OldTrackingSpecification);
                        QtyToAdd :=
                          CurrentSignFactor *
                          ReservEngineMgt.AddItemTrackingToTempRecSet(
                            TempReservEntry, NewTrackingSpecification,
                            CurrentSignFactor * (NewTrackingSpecification."Quantity (Base)" -
                                                 OldTrackingSpecification."Quantity (Base)"), QtyToAddAsBlank,
                            ItemTrackingCode);
                        TempReservEntry.ClearTrackingFilter;
                        RegisterChange(NewTrackingSpecification, NewTrackingSpecification,
                          ChangeType::PartDelete, not IdenticalArray[2]);
                    end;
                    OK := true;
                end;
            ChangeType::FullDelete, ChangeType::PartDelete:
                begin
                    ReservationMgt.SetItemTrackingHandling(1); // Allow deletion of Item Tracking
                    ReservEntry1.TRANSFERFIELDS(OldTrackingSpecification);
                    ReservEntry1.SetPointerFilter;
                    ReservEntry1.SetTrackingFilterFromReservEntry(ReservEntry1);
                    if ChangeType = ChangeType::FullDelete then begin
                        TempReservEntry.SetTrackingFilterFromSpec(OldTrackingSpecification);
                        OldTrackingSpecification.ClearTracking;
                        OnAfterClearTrackingSpec(OldTrackingSpecification);
                        QtyToAdd :=
                          CurrentSignFactor *
                          ReservEngineMgt.AddItemTrackingToTempRecSet(
                            TempReservEntry, NewTrackingSpecification,
                            CurrentSignFactor * (NewTrackingSpecification."Quantity (Base)" -
                                                 OldTrackingSpecification."Quantity (Base)"), QtyToAddAsBlank,
                            ItemTrackingCode);
                        TempReservEntry.ClearTrackingFilter;
                        ReservationMgt.DeleteReservEntries(true, 0, ReservEntry1)
                    end else begin
                        ReservationMgt.DeleteReservEntries(false, ReservEntry1."Quantity (Base)" -
                          OldTrackingSpecification."Quantity Handled (Base)", ReservEntry1);
                        if ModifySharedFields then begin
                            ReservEntry1.SETRANGE("Reservation Status");
                            ModifyFieldsWithinFilter(ReservEntry1, OldTrackingSpecification);
                        end;
                    end;
                    OK := true;
                end;
        end;
        SetQtyToHandleAndInvoice(NewTrackingSpecification);
    end;

    local procedure UpdateOrderTracking();
    var
        TempReservEntry: Record "Reservation Entry" temporary;
    begin
        if not ReservEngineMgt.CollectAffectedSurplusEntries(TempReservEntry) then
            exit;
        if Item."Order Tracking Policy" = Item."Order Tracking Policy"::None then
            exit;
        ReservEngineMgt.UpdateOrderTracking(TempReservEntry);
    end;

    local procedure ModifyFieldsWithinFilter(var ReservEntry1: Record "Reservation Entry"; var TrackingSpecification: Record "Tracking Specification");
    begin
        // Used to ensure that field values that are common to a SN/Lot are copied to all entries.
        if ReservEntry1.FIND('-') then
            repeat
                ReservEntry1.Description := TrackingSpecification.Description;
                ReservEntry1."Warranty Date" := TrackingSpecification."Warranty Date";
                ReservEntry1."Expiration Date" := TrackingSpecification."Expiration Date";
                ReservEntry1."New Serial No." := TrackingSpecification."New Serial No.";
                ReservEntry1."New Lot No." := TrackingSpecification."New Lot No.";
                ReservEntry1."New Expiration Date" := TrackingSpecification."New Expiration Date";
                OnAfterMoveFields(TrackingSpecification, ReservEntry1);
                ReservEntry1.MODIFY;
            until ReservEntry1.NEXT = 0;
    end;

    local procedure SetQtyToHandleAndInvoice(TrackingSpecification: Record "Tracking Specification");
    var
        ReservEntry1: Record "Reservation Entry";
        TotalQtyToHandle: Decimal;
        TotalQtyToInvoice: Decimal;
        QtyToHandleThisLine: Decimal;
        QtyToInvoiceThisLine: Decimal;
    begin
        if IsCorrection then
            exit;

        TotalQtyToHandle := TrackingSpecification."Qty. to Handle (Base)" * CurrentSignFactor;
        TotalQtyToInvoice := TrackingSpecification."Qty. to Invoice (Base)" * CurrentSignFactor;

        ReservEntry1.TRANSFERFIELDS(TrackingSpecification);
        ReservEntry1.SetPointerFilter;
        ReservEntry1.SetTrackingFilterFromReservEntry(ReservEntry1);
        if TrackingSpecification.TrackingExists then begin
            ItemTrackingMgt.SetPointerFilter(TrackingSpecification);
            TrackingSpecification.SetTrackingFilterFromSpec(TrackingSpecification);
            if TrackingSpecification.FIND('-') then
                repeat
                    if not TrackingSpecification.Correction then begin
                        QtyToInvoiceThisLine :=
                          TrackingSpecification."Quantity Handled (Base)" - TrackingSpecification."Quantity Invoiced (Base)";
                        if ABS(QtyToInvoiceThisLine) > ABS(TotalQtyToInvoice) then
                            QtyToInvoiceThisLine := TotalQtyToInvoice;

                        if TrackingSpecification."Qty. to Invoice (Base)" <> QtyToInvoiceThisLine then begin
                            TrackingSpecification."Qty. to Invoice (Base)" := QtyToInvoiceThisLine;
                            TrackingSpecification.MODIFY;
                        end;

                        TotalQtyToInvoice -= QtyToInvoiceThisLine;
                    end;
                until (TrackingSpecification.NEXT = 0);
        end;

        if TrackingSpecification."Lot No." <> '' then
            for ReservEntry1."Reservation Status" := ReservEntry1."Reservation Status"::Reservation to
                ReservEntry1."Reservation Status"::Prospect
            do begin
                ReservEntry1.SETRANGE("Reservation Status", ReservEntry1."Reservation Status");
                if ReservEntry1.FIND('-') then
                    repeat
                        QtyToHandleThisLine := ReservEntry1."Quantity (Base)";
                        QtyToInvoiceThisLine := QtyToHandleThisLine;

                        if ABS(QtyToHandleThisLine) > ABS(TotalQtyToHandle) then
                            QtyToHandleThisLine := TotalQtyToHandle;
                        if ABS(QtyToInvoiceThisLine) > ABS(TotalQtyToInvoice) then
                            QtyToInvoiceThisLine := TotalQtyToInvoice;

                        if (ReservEntry1."Qty. to Handle (Base)" <> QtyToHandleThisLine) or
                           (ReservEntry1."Qty. to Invoice (Base)" <> QtyToInvoiceThisLine) and not ReservEntry1.Correction
                        then begin
                            ReservEntry1."Qty. to Handle (Base)" := QtyToHandleThisLine;
                            ReservEntry1."Qty. to Invoice (Base)" := QtyToInvoiceThisLine;
                            ReservEntry1.MODIFY;
                        end;

                        TotalQtyToHandle -= QtyToHandleThisLine;
                        TotalQtyToInvoice -= QtyToInvoiceThisLine;

                    until (ReservEntry1.NEXT = 0);
            end
        else
            if ReservEntry1.FIND('-') then
                if (ReservEntry1."Qty. to Handle (Base)" <> TotalQtyToHandle) or
                   (ReservEntry1."Qty. to Invoice (Base)" <> TotalQtyToInvoice) and not ReservEntry1.Correction
                then begin
                    ReservEntry1."Qty. to Handle (Base)" := TotalQtyToHandle;
                    ReservEntry1."Qty. to Invoice (Base)" := TotalQtyToInvoice;
                    ReservEntry1.MODIFY;
                end;
    end;

    local procedure CollectPostedTransferEntries(TrackingSpecification: Record "Tracking Specification"; var TempTrackingSpecification: Record "Tracking Specification" temporary);
    var
        ItemEntryRelation: Record "Item Entry Relation";
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        // Used for collecting information about posted Transfer Shipments from the created Item Ledger Entries.
        if TrackingSpecification."Source Type" <> DATABASE::"Transfer Line" then
            exit;

        ItemEntryRelation.SETCURRENTKEY("Order No.", "Order Line No.");
        ItemEntryRelation.SETRANGE("Order No.", TrackingSpecification."Source ID");
        ItemEntryRelation.SETRANGE("Order Line No.", TrackingSpecification."Source Ref. No.");

        case TrackingSpecification."Source Subtype" of
            0: // Outbound
                ItemEntryRelation.SETRANGE("Source Type", DATABASE::"Transfer Shipment Line");
            1: // Inbound
                ItemEntryRelation.SETRANGE("Source Type", DATABASE::"Transfer Receipt Line");
        end;

        if ItemEntryRelation.FIND('-') then
            repeat
                ItemLedgerEntry.GET(ItemEntryRelation."Item Entry No.");
                TempTrackingSpecification := TrackingSpecification;
                TempTrackingSpecification."Entry No." := ItemLedgerEntry."Entry No.";
                TempTrackingSpecification."Item No." := ItemLedgerEntry."Item No.";
                TempTrackingSpecification.CopyTrackingFromItemLedgEntry(ItemLedgerEntry);
                TempTrackingSpecification."Quantity (Base)" := ItemLedgerEntry.Quantity;
                TempTrackingSpecification."Quantity Handled (Base)" := ItemLedgerEntry.Quantity;
                TempTrackingSpecification."Quantity Invoiced (Base)" := ItemLedgerEntry.Quantity;
                TempTrackingSpecification."Qty. per Unit of Measure" := ItemLedgerEntry."Qty. per Unit of Measure";
                TempTrackingSpecification.InitQtyToShip;
                TempTrackingSpecification.INSERT;
            until ItemEntryRelation.NEXT = 0;
    end;

    local procedure CollectPostedAssemblyEntries(TrackingSpecification: Record "Tracking Specification"; var TempTrackingSpecification: Record "Tracking Specification" temporary);
    var
        ItemEntryRelation: Record "Item Entry Relation";
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        // Used for collecting information about posted Assembly Lines from the created Item Ledger Entries.
        if (TrackingSpecification."Source Type" <> DATABASE::"Assembly Line") and
           (TrackingSpecification."Source Type" <> DATABASE::"Assembly Header")
        then
            exit;

        ItemEntryRelation.SETCURRENTKEY("Order No.", "Order Line No.");
        ItemEntryRelation.SETRANGE("Order No.", TrackingSpecification."Source ID");
        ItemEntryRelation.SETRANGE("Order Line No.", TrackingSpecification."Source Ref. No.");
        if TrackingSpecification."Source Type" = DATABASE::"Assembly Line" then
            ItemEntryRelation.SETRANGE("Source Type", DATABASE::"Posted Assembly Line")
        else
            ItemEntryRelation.SETRANGE("Source Type", DATABASE::"Posted Assembly Header");

        if ItemEntryRelation.FIND('-') then
            repeat
                ItemLedgerEntry.GET(ItemEntryRelation."Item Entry No.");
                TempTrackingSpecification := TrackingSpecification;
                TempTrackingSpecification."Entry No." := ItemLedgerEntry."Entry No.";
                TempTrackingSpecification."Item No." := ItemLedgerEntry."Item No.";
                TempTrackingSpecification.CopyTrackingFromItemLedgEntry(ItemLedgerEntry);
                TempTrackingSpecification."Quantity (Base)" := ItemLedgerEntry.Quantity;
                TempTrackingSpecification."Quantity Handled (Base)" := ItemLedgerEntry.Quantity;
                TempTrackingSpecification."Quantity Invoiced (Base)" := ItemLedgerEntry.Quantity;
                TempTrackingSpecification."Qty. per Unit of Measure" := ItemLedgerEntry."Qty. per Unit of Measure";
                TempTrackingSpecification.InitQtyToShip;
                TempTrackingSpecification.INSERT;
            until ItemEntryRelation.NEXT = 0;
    end;

    local procedure CollectPostedOutputEntries(TrackingSpecification: Record "Tracking Specification"; var TempTrackingSpecification: Record "Tracking Specification" temporary);
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        BackwardFlushing: Boolean;
    begin
        // Used for collecting information about posted prod. order output from the created Item Ledger Entries.
        if TrackingSpecification."Source Type" <> DATABASE::"Prod. Order Line" then
            exit;

        if (TrackingSpecification."Source Type" = DATABASE::"Prod. Order Line") and
           (TrackingSpecification."Source Subtype" = 3)
        then begin
            ProdOrderRoutingLine.SETRANGE(Status, TrackingSpecification."Source Subtype");
            ProdOrderRoutingLine.SETRANGE("Prod. Order No.", TrackingSpecification."Source ID");
            ProdOrderRoutingLine.SETRANGE("Routing Reference No.", TrackingSpecification."Source Prod. Order Line");
            if ProdOrderRoutingLine.FINDLAST then
                BackwardFlushing :=
                  ProdOrderRoutingLine."Flushing Method" = ProdOrderRoutingLine."Flushing Method"::Backward;
        end;

        ItemLedgerEntry.SETCURRENTKEY("Order Type", "Order No.", "Order Line No.", "Entry Type");
        ItemLedgerEntry.SETRANGE("Order Type", ItemLedgerEntry."Order Type"::Production);
        ItemLedgerEntry.SETRANGE("Order No.", TrackingSpecification."Source ID");
        ItemLedgerEntry.SETRANGE("Order Line No.", TrackingSpecification."Source Prod. Order Line");
        ItemLedgerEntry.SETRANGE("Entry Type", ItemLedgerEntry."Entry Type"::Output);

        if ItemLedgerEntry.FIND('-') then
            repeat
                TempTrackingSpecification := TrackingSpecification;
                TempTrackingSpecification."Entry No." := ItemLedgerEntry."Entry No.";
                TempTrackingSpecification."Item No." := ItemLedgerEntry."Item No.";
                TempTrackingSpecification.CopyTrackingFromItemLedgEntry(ItemLedgerEntry);
                TempTrackingSpecification."Quantity (Base)" := ItemLedgerEntry.Quantity;
                TempTrackingSpecification."Quantity Handled (Base)" := ItemLedgerEntry.Quantity;
                TempTrackingSpecification."Quantity Invoiced (Base)" := ItemLedgerEntry.Quantity;
                TempTrackingSpecification."Qty. per Unit of Measure" := ItemLedgerEntry."Qty. per Unit of Measure";
                TempTrackingSpecification.InitQtyToShip;
                TempTrackingSpecification.INSERT;

                if BackwardFlushing then begin
                    SourceQuantityArray[1] += ItemLedgerEntry.Quantity;
                    SourceQuantityArray[2] += ItemLedgerEntry.Quantity;
                    SourceQuantityArray[3] += ItemLedgerEntry.Quantity;
                end;

            until ItemLedgerEntry.NEXT = 0;
    end;

    local procedure ZeroLineExists() OK: Boolean;
    var
        xTrackingSpec: Record "Tracking Specification";
    begin
        if (Rec."Quantity (Base)" <> 0) or Rec.TrackingExists then
            exit(false);
        xTrackingSpec.COPY(Rec);
        Rec.RESET;
        Rec.SETRANGE(Rec."Quantity (Base)", 0);
        //Rec.SetTrackingFilter('', '');
        OK := not Rec.ISEMPTY;
        Rec.COPY(xTrackingSpec);
    end;

    local procedure AssignSerialNo();
    var
        EnterQuantityToCreate: Page "Enter Quantity to Create";
        QtyToCreate: Decimal;
        QtyToCreateInt: Integer;
        CreateLotNo: Boolean;
    begin
        /*
        if ZeroLineExists then
            Rec.DELETE;

        QtyToCreate := UndefinedQtyArray[1] * QtySignFactor;
        if QtyToCreate < 0 then
            QtyToCreate := 0;

        if QtyToCreate mod 1 <> 0 then
            ERROR(Text008);

        QtyToCreateInt := QtyToCreate;

        CLEAR(EnterQuantityToCreate);
        EnterQuantityToCreate.SetFields(Rec."Item No.", Rec."Variant Code", QtyToCreate, false);
        if EnterQuantityToCreate.RUNMODAL = ACTION::OK then begin
            EnterQuantityToCreate.GetFields(QtyToCreateInt, CreateLotNo);
            AssignSerialNoBatch(QtyToCreateInt, CreateLotNo);
        end;
        */
    end;

    local procedure AssignSerialNoBatch(QtyToCreate: Integer; CreateLotNo: Boolean);
    var
        i: Integer;
    begin
        if QtyToCreate <= 0 then
            ERROR(Text009);
        if QtyToCreate mod 1 <> 0 then
            ERROR(Text008);

        GetItem(Rec."Item No.");

        if CreateLotNo then begin
            Rec.TESTFIELD(Rec."Lot No.", '');
            Item.TESTFIELD(Item."Lot Nos.");
            Rec.VALIDATE(Rec."Lot No.", NoSeriesMgt.GetNextNo(Item."Lot Nos.", WORKDATE, true));
        end;

        Item.TESTFIELD(Item."Serial Nos.");
        ItemTrackingDataCollection.SetSkipLot(true);
        for i := 1 to QtyToCreate do begin
            Rec.VALIDATE(Rec."Quantity Handled (Base)", 0);
            Rec.VALIDATE(Rec."Quantity Invoiced (Base)", 0);
            Rec.VALIDATE(Rec."Serial No.", NoSeriesMgt.GetNextNo(Item."Serial Nos.", WORKDATE, true));
            OnAfterAssignNewTrackingNo(Rec);
            Rec.VALIDATE(Rec."Quantity (Base)", QtySignFactor);
            Rec."Entry No." := NextEntryNo;
            if TestTempSpecificationExists then
                ERROR('');
            Rec.INSERT;
            TempItemTrackLineInsert.TRANSFERFIELDS(Rec);
            TempItemTrackLineInsert.INSERT;
            if i = QtyToCreate then
                ItemTrackingDataCollection.SetSkipLot(false);
            ItemTrackingDataCollection.UpdateTrackingDataSetWithChange(
              TempItemTrackLineInsert, CurrentSignFactor * SourceQuantityArray[1] < 0, CurrentSignFactor, 0);
        end;
        CalculateSums;
    end;

    local procedure AssignLotNo();
    var
        QtyToCreate: Decimal;
    begin
        if ZeroLineExists then
            Rec.DELETE;

        if (SourceQuantityArray[1] * UndefinedQtyArray[1] <= 0) or
           (ABS(SourceQuantityArray[1]) < ABS(UndefinedQtyArray[1]))
        then
            QtyToCreate := 0
        else
            QtyToCreate := UndefinedQtyArray[1];

        GetItem(Rec."Item No.");

        Item.TESTFIELD(Item."Lot Nos.");
        Rec.VALIDATE(Rec."Quantity Handled (Base)", 0);
        Rec.VALIDATE(Rec."Quantity Invoiced (Base)", 0);
        Rec.VALIDATE(Rec."Lot No.", NoSeriesMgt.GetNextNo(Item."Lot Nos.", WORKDATE, true));
        OnAfterAssignNewTrackingNo(Rec);
        Rec."Qty. per Unit of Measure" := QtyPerUOM;
        Rec.VALIDATE(Rec."Quantity (Base)", QtyToCreate);
        Rec."Entry No." := NextEntryNo;
        TestTempSpecificationExists;
        Rec.INSERT;
        TempItemTrackLineInsert.TRANSFERFIELDS(Rec);
        TempItemTrackLineInsert.INSERT;
        ItemTrackingDataCollection.UpdateTrackingDataSetWithChange(
          TempItemTrackLineInsert, CurrentSignFactor * SourceQuantityArray[1] < 0, CurrentSignFactor, 0);
        CalculateSums;
    end;

    local procedure CreateCustomizedSN();
    var
        EnterCustomizedSN: Page "Enter Customized SN";
        QtyToCreate: Decimal;
        QtyToCreateInt: Integer;
        Increment: Integer;
        CreateLotNo: Boolean;
        CustomizedSN: Code[20];
    begin
        /*
        if ZeroLineExists then
            Rec.DELETE;

        QtyToCreate := UndefinedQtyArray[1] * QtySignFactor;
        if QtyToCreate < 0 then
            QtyToCreate := 0;

        if QtyToCreate mod 1 <> 0 then
            ERROR(Text008);

        QtyToCreateInt := QtyToCreate;

        CLEAR(EnterCustomizedSN);
        EnterCustomizedSN.SetFields(Rec."Item No.", Rec."Variant Code", QtyToCreate, false);
        if EnterCustomizedSN.RUNMODAL = ACTION::OK then begin
            EnterCustomizedSN.GetFields(QtyToCreateInt, CreateLotNo, CustomizedSN, Increment);
            CreateCustomizedSNBatch(QtyToCreateInt, CreateLotNo, CustomizedSN, Increment);
        end;
        CalculateSums;
        */
    end;

    local procedure CreateCustomizedSNBatch(QtyToCreate: Decimal; CreateLotNo: Boolean; CustomizedSN: Code[20]; Increment: Integer);
    var
        TextManagement: Codeunit "Filter Tokens";
        i: Integer;
        Counter: Integer;
        UnincrementableStringErr: Label '%1 contains no number and cannot be incremented.';
    begin
        // TextManagement.EvaluateIncStr(CustomizedSN, CustomizedSN);
        if IncStr(CustomizedSN) = '' then
            Error(UnincrementableStringErr, CustomizedSN);

        NoSeriesMgt.TestManual(Item."Serial Nos.");

        if QtyToCreate <= 0 then
            ERROR(Text009);
        if QtyToCreate mod 1 <> 0 then
            ERROR(Text008);

        if CreateLotNo then begin
            Rec.TESTFIELD(Rec."Lot No.", '');
            Item.TESTFIELD(Item."Lot Nos.");
            Rec.VALIDATE(Rec."Lot No.", NoSeriesMgt.GetNextNo(Item."Lot Nos.", WORKDATE, true));
            OnAfterAssignNewTrackingNo(Rec);
        end;

        for i := 1 to QtyToCreate do begin
            Rec.VALIDATE(Rec."Quantity Handled (Base)", 0);
            Rec.VALIDATE(Rec."Quantity Invoiced (Base)", 0);
            Rec.VALIDATE(Rec."Serial No.", CustomizedSN);
            OnAfterAssignNewTrackingNo(Rec);
            Rec.VALIDATE(Rec."Quantity (Base)", QtySignFactor);
            Rec."Entry No." := NextEntryNo;
            if TestTempSpecificationExists then
                ERROR('');
            Rec.INSERT;
            TempItemTrackLineInsert.TRANSFERFIELDS(Rec);
            TempItemTrackLineInsert.INSERT;
            ItemTrackingDataCollection.UpdateTrackingDataSetWithChange(
              TempItemTrackLineInsert, CurrentSignFactor * SourceQuantityArray[1] < 0, CurrentSignFactor, 0);
            if i < QtyToCreate then begin
                Counter := Increment;
                repeat
                    CustomizedSN := INCSTR(CustomizedSN);
                    Counter := Counter - 1;
                until Counter <= 0;
            end;
        end;
        CalculateSums;
    end;

    local procedure TestTempSpecificationExists() Exists: Boolean;
    var
        TrackingSpecification: Record "Tracking Specification";
    begin
        TrackingSpecification.COPY(Rec);
        Rec.SETCURRENTKEY(Rec."Lot No.", Rec."Serial No.");
        Rec.SETRANGE(Rec."Serial No.", Rec."Serial No.");
        if Rec."Serial No." = '' then
            Rec.SETRANGE(Rec."Lot No.", Rec."Lot No.");
        Rec.SETFILTER(Rec."Entry No.", '<>%1', Rec."Entry No.");
        Rec.SETRANGE(Rec."Buffer Status", 0);
        Exists := not Rec.ISEMPTY;
        Rec.COPY(TrackingSpecification);
        if Exists and CurrentFormIsOpen then
            if Rec."Serial No." = '' then
                MESSAGE(Text011, Rec."Serial No.", Rec."Lot No.")
            else
                MESSAGE(Text012, Rec."Serial No.");
    end;

    local procedure QtySignFactor(): Integer;
    begin
        if SourceQuantityArray[1] < 0 then
            exit(-1);

        exit(1)
    end;

    [Scope('Cloud')]
    procedure RegisterItemTrackingLines(SourceSpecification: Record "Tracking Specification"; AvailabilityDate: Date; var TempTrackingSpecification: Record "Tracking Specification" temporary);
    begin
        SourceSpecification.TESTFIELD("Source Type"); // Check if source has been set.
        if not CalledFromSynchWhseItemTrkg then
            TempTrackingSpecification.RESET;
        if not TempTrackingSpecification.FIND('-') then
            exit;

        IsCorrection := SourceSpecification.Correction;
        ExcludePostedEntries := true;
        SetSourceSpec(SourceSpecification, AvailabilityDate);
        Rec.RESET;
        Rec.SETCURRENTKEY(Rec."Lot No.", Rec."Serial No.");

        repeat
            Rec.SetTrackingFilterFromSpec(TempTrackingSpecification);
            if Rec.FIND('-') then begin
                if IsCorrection then begin
                    Rec."Quantity (Base)" += TempTrackingSpecification."Quantity (Base)";
                    Rec."Qty. to Handle (Base)" += TempTrackingSpecification."Qty. to Handle (Base)";
                    Rec."Qty. to Invoice (Base)" += TempTrackingSpecification."Qty. to Invoice (Base)";
                end else
                    Rec.VALIDATE(Rec."Quantity (Base)", Rec."Quantity (Base)" + TempTrackingSpecification."Quantity (Base)");
                Rec.MODIFY;
            end else begin
                Rec.TRANSFERFIELDS(SourceSpecification);
                Rec."Serial No." := TempTrackingSpecification."Serial No.";
                Rec."Lot No." := TempTrackingSpecification."Lot No.";
                Rec."Warranty Date" := TempTrackingSpecification."Warranty Date";
                Rec."Expiration Date" := TempTrackingSpecification."Expiration Date";
                if FormRunMode = FormRunMode::Reclass then begin
                    Rec."New Serial No." := TempTrackingSpecification."New Serial No.";
                    Rec."New Lot No." := TempTrackingSpecification."New Lot No.";
                    Rec."New Expiration Date" := TempTrackingSpecification."New Expiration Date"
                end;
                OnAfterCopyTrackingSpec(TempTrackingSpecification, Rec);
                Rec.VALIDATE(Rec."Quantity (Base)", TempTrackingSpecification."Quantity (Base)");
                Rec."Entry No." := NextEntryNo;
                Rec.INSERT;
            end;
        until TempTrackingSpecification.NEXT = 0;
        Rec.RESET;
        if Rec.FIND('-') then
            repeat
                CheckLine(Rec);
            until Rec.NEXT = 0;

        Rec.SetTrackingFilterFromSpec(SourceSpecification);

        CalculateSums;
        if UpdateUndefinedQty then
            WriteToDatabase
        else
            ERROR(Text014, TotalItemTrackingLine."Quantity (Base)",
              LOWERCASE(TempReservEntry.TextCaption), SourceQuantityArray[1]);

        // Copy to inbound part of transfer
        if FormRunMode = FormRunMode::Transfer then
            SynchronizeLinkedSources('');
    end;

    local procedure SynchronizeLinkedSources(DialogText: Text[250]): Boolean;
    begin
        if CurrentSourceRowID = '' then
            exit(false);
        if SecondSourceRowID = '' then
            exit(false);

        ItemTrackingMgt.SynchronizeItemTracking(CurrentSourceRowID, SecondSourceRowID, DialogText);
        exit(true);
    end;

    [Scope('Cloud')]
    procedure SetBlockCommit(NewBlockCommit: Boolean);
    begin
        BlockCommit := NewBlockCommit;
    end;

    [Scope('Cloud')]
    procedure SetCalledFromSynchWhseItemTrkg(CalledFromSynchWhseItemTrkg2: Boolean);
    begin
        CalledFromSynchWhseItemTrkg := CalledFromSynchWhseItemTrkg2;
    end;

    local procedure UpdateExpDateColor();
    begin
        if (Rec."Buffer Status2" = Rec."Buffer Status2"::"ExpDate blocked") or (CurrentSignFactor < 0) then;
    end;

    local procedure UpdateExpDateEditable();
    begin
        ExpirationDateEditable :=
          not ((Rec."Buffer Status2" = Rec."Buffer Status2"::"ExpDate blocked") or (CurrentSignFactor < 0));
    end;

    local procedure LookupAvailable(LookupMode: Enum "Item Tracking Type");
    begin
        Rec."Bin Code" := ForBinCode;
        ItemTrackingDataCollection.LookupTrackingAvailability(Rec, LookupMode);
        Rec."Bin Code" := '';
        CurrPage.UPDATE;
    end;

    local procedure TrackingAvailable(var TrackingSpecification: Record "Tracking Specification"; LookupMode: Enum "Item Tracking Type"): Boolean;
    begin
        exit(ItemTrackingDataCollection.TrackingAvailable(TrackingSpecification, LookupMode));
    end;

    local procedure SelectEntries();
    var
        xTrackingSpec: Record "Tracking Specification";
        MaxQuantity: Decimal;
    begin
        xTrackingSpec.COPYFILTERS(Rec);
        MaxQuantity := UndefinedQtyArray[1];
        if MaxQuantity * CurrentSignFactor > 0 then
            MaxQuantity := 0;
        Rec."Bin Code" := ForBinCode;
        ItemTrackingDataCollection.SelectMultipleTrackingNo(Rec, MaxQuantity, CurrentSignFactor);
        Rec."Bin Code" := '';
        if Rec.FINDSET then
            repeat
                case Rec."Buffer Status" of
                    Rec."Buffer Status"::MODIFY:
                        begin
                            if TempItemTrackLineModify.GET(Rec."Entry No.") then
                                TempItemTrackLineModify.DELETE;
                            if TempItemTrackLineInsert.GET(Rec."Entry No.") then begin
                                TempItemTrackLineInsert.TRANSFERFIELDS(Rec);
                                TempItemTrackLineInsert.MODIFY;
                            end else begin
                                TempItemTrackLineModify.TRANSFERFIELDS(Rec);
                                TempItemTrackLineModify.INSERT;
                            end;
                        end;
                    Rec."Buffer Status"::INSERT:
                        begin
                            TempItemTrackLineInsert.TRANSFERFIELDS(Rec);
                            TempItemTrackLineInsert.INSERT;
                        end;
                end;
                Rec."Buffer Status" := 0;
                Rec.MODIFY;
            until Rec.NEXT = 0;
        LastEntryNo := Rec."Entry No.";
        CalculateSums;
        UpdateUndefinedQtyArray;
        Rec.COPYFILTERS(xTrackingSpec);
        CurrPage.UPDATE(false);
    end;

    local procedure ReestablishReservations();
    var
        LateBindingMgt: Codeunit "Late Binding Management";
    begin
        if TempItemTrackLineReserv.FINDSET then
            repeat
                LateBindingMgt.ReserveItemTrackingLine(TempItemTrackLineReserv, 0, TempItemTrackLineReserv."Quantity (Base)");
                SetQtyToHandleAndInvoice(TempItemTrackLineReserv);
            until TempItemTrackLineReserv.NEXT = 0;
        TempItemTrackLineReserv.DELETEALL;
    end;

    [Scope('Cloud')]
    procedure SetInbound(NewInbound: Boolean);
    begin
        InboundIsSet := true;
        Inbound := NewInbound;
    end;

    local procedure SerialNoOnAfterValidate();
    begin
        UpdateExpDateEditable;
        CurrPage.UPDATE;
    end;

    local procedure LotNoOnAfterValidate();
    begin
        UpdateExpDateEditable;
        CurrPage.UPDATE;
    end;

    local procedure QuantityBaseOnAfterValidate();
    begin
        CurrPage.UPDATE;
    end;

    local procedure QuantityBaseOnValidate();
    begin
        CheckLine(Rec);
    end;

    local procedure QtytoHandleBaseOnAfterValidate();
    begin
        CurrPage.UPDATE;
    end;

    local procedure QtytoInvoiceBaseOnAfterValidat();
    begin
        CurrPage.UPDATE;
    end;

    local procedure ExpirationDateOnFormat();
    begin
        UpdateExpDateColor;
    end;

    local procedure TempRecValid();
    begin
        if not TempRecIsValid then
            ERROR(Text007);
    end;

    local procedure GetHandleSource(TrackingSpecification: Record "Tracking Specification"): Boolean;
    var
        QtyToHandleColumnIsHidden: Boolean;
    begin
        if (TrackingSpecification."Source Type" = DATABASE::"Item Journal Line") and (TrackingSpecification."Source Subtype" = 6) then begin // 6 => Prod.order line
            ProdOrderLineHandling := true;
            exit(true);  // Display Handle column for prod. orders
        end;
        QtyToHandleColumnIsHidden :=
          (TrackingSpecification."Source Type" in
           [DATABASE::"Item Ledger Entry",
            DATABASE::"Item Journal Line",
            DATABASE::"Job Journal Line",
            DATABASE::"Requisition Line"]) or
          ((TrackingSpecification."Source Type" in [DATABASE::"Sales Line", DATABASE::"Purchase Line", DATABASE::"Service Line"]) and
           (TrackingSpecification."Source Subtype" in [0, 2, 3])) or
          ((TrackingSpecification."Source Type" = DATABASE::"Assembly Line") and (TrackingSpecification."Source Subtype" = 0));
        exit(not QtyToHandleColumnIsHidden);
    end;

    local procedure GetInvoiceSource(TrackingSpecification: Record "Tracking Specification"): Boolean;
    var
        QtyToInvoiceColumnIsHidden: Boolean;
    begin
        QtyToInvoiceColumnIsHidden :=
            (TrackingSpecification."Source Type" in
            [DATABASE::"Item Ledger Entry",
                DATABASE::"Item Journal Line",
                DATABASE::"Job Journal Line",
                DATABASE::"Requisition Line",
                DATABASE::"Transfer Line",
                DATABASE::"Assembly Line",
                DATABASE::"Assembly Header",
                DATABASE::"Prod. Order Line",
                DATABASE::"Prod. Order Component"]) or
            ((TrackingSpecification."Source Type" in [DATABASE::"Sales Line", DATABASE::"Purchase Line", DATABASE::"Service Line"]) and
            (TrackingSpecification."Source Subtype" in [0, 2, 3, 4]));
        exit(not QtyToInvoiceColumnIsHidden);
    end;

    [Scope('Cloud')]
    procedure SetSecondSourceID(SourceID: Integer; IsATO: Boolean);
    begin
        SecondSourceID := SourceID;
        IsAssembleToOrder := IsATO;
    end;

    local procedure SynchronizeWarehouseItemTracking();
    var
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    begin
        if ItemTrackingMgt.ItemTrkgIsManagedByWhse(
             Rec."Source Type", Rec."Source Subtype", Rec."Source ID",
             Rec."Source Prod. Order Line", Rec."Source Ref. No.", Rec."Location Code", Rec."Item No.")
        then
            exit;

        WarehouseShipmentLine.SETRANGE("Source Type", Rec."Source Type");
        WarehouseShipmentLine.SETRANGE("Source Subtype", Rec."Source Subtype");
        WarehouseShipmentLine.SETRANGE("Source No.", Rec."Source ID");
        WarehouseShipmentLine.SETRANGE("Source Line No.", Rec."Source Ref. No.");
        if WarehouseShipmentLine.FINDSET then
            repeat
                DeleteWhseItemTracking(WarehouseShipmentLine);
                WarehouseShipmentLine.CreateWhseItemTrackingLines;
            until WarehouseShipmentLine.NEXT = 0;
    end;

    local procedure DeleteWhseItemTracking(WarehouseShipmentLine: Record "Warehouse Shipment Line");
    var
        WhseItemTrackingLine: Record "Whse. Item Tracking Line";
    begin
        WhseItemTrackingLine.SETRANGE("Source Type", DATABASE::"Warehouse Shipment Line");
        WhseItemTrackingLine.SETRANGE("Source ID", WarehouseShipmentLine."No.");
        WhseItemTrackingLine.SETRANGE("Source Ref. No.", WarehouseShipmentLine."Line No.");
        WhseItemTrackingLine.DELETEALL(true);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCopyTrackingSpec(var SourceTrackingSpec: Record "Tracking Specification"; var DestTrkgSpec: Record "Tracking Specification");
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterClearTrackingSpec(var OldTrkgSpec: Record "Tracking Specification");
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterMoveFields(var TrkgSpec: Record "Tracking Specification"; var ReservEntry: Record "Reservation Entry");
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAssignNewTrackingNo(var TrkgSpec: Record "Tracking Specification");
    begin
    end;
}

