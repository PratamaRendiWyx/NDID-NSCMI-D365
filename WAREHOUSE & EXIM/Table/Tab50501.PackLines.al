table 50501 "Pack. Lines"
{
    Caption = 'Pack. Lines';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
        }
        field(3; "Source Type"; Integer)
        {
            Caption = 'Source Type';
            Editable = false;
        }
        field(4; "Source Subtype"; Option)
        {
            Caption = 'Source Subtype';
            Editable = false;
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
        }
        field(6; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            Editable = false;
        }
        field(7; "Source Line No."; Integer)
        {
            Caption = 'Source Line No.';
            Editable = false;
        }
        field(9; "Source Document"; Enum "Warehouse Activity Source Document")
        {
            Caption = 'Source Document';
            Editable = false;
        }
        field(10; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            Editable = false;
            TableRelation = Location;
        }
        field(11; "Shelf No."; Code[10])
        {
            Caption = 'Shelf No.';
        }
        field(12; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            TableRelation = if ("Zone Code" = filter('')) Bin.Code where("Location Code" = field("Location Code"))
            else
            if ("Zone Code" = filter(<> '')) Bin.Code where("Location Code" = field("Location Code"),
                                                                               "Zone Code" = field("Zone Code"));
            trigger OnValidate()
            var
                Bin: Record Bin;
                WhseIntegrationMgt: Codeunit "Whse. Integration Management";
            begin
                TestReleased();
                if xRec."Bin Code" <> "Bin Code" then
                    if "Bin Code" <> '' then begin
                        GetLocation("Location Code");
                        WhseIntegrationMgt.CheckBinTypeAndCode(
                            Database::"Pack. Lines", FieldCaption("Bin Code"), "Location Code", "Bin Code", 0);
                        Bin.Get("Location Code", "Bin Code");
                        "Zone Code" := Bin."Zone Code";
                        CheckBin(0, 0);
                    end;
            end;
        }
        field(13; "Zone Code"; Code[10])
        {
            Caption = 'Zone Code';
            TableRelation = Zone.Code where("Location Code" = field("Location Code"));

            trigger OnValidate()
            begin
                TestReleased();
                if xRec."Zone Code" <> "Zone Code" then
                    "Bin Code" := '';
            end;
        }
        field(14; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            Editable = false;
            TableRelation = Item;
        }
        field(15; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            // Editable = false;
            MinValue = 0;
        }
        field(16; "Qty. (Base)"; Decimal)
        {
            Caption = 'Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(19; "Qty. Outstanding"; Decimal)
        {
            Caption = 'Qty. Outstanding';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(20; "Qty. Outstanding (Base)"; Decimal)
        {
            Caption = 'Qty. Outstanding (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(21; "Qty. to Ship"; Decimal)
        {
            Caption = 'Qty. to Ship';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(22; "Qty. to Ship (Base)"; Decimal)
        {
            Caption = 'Qty. to Ship (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(29; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            Editable = false;
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
        }
        field(30; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(31; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            Editable = false;
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));
        }
        field(32; Description; Text[100])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(33; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
            Editable = false;
        }
        field(35; "Sorting Sequence No."; Integer)
        {
            Caption = 'Sorting Sequence No.';
            Editable = false;
        }
        field(36; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(39; "Destination Type"; Enum "Warehouse Destination Type")
        {
            Caption = 'Destination Type';
            Editable = false;
        }
        field(40; "Destination No."; Code[20])
        {
            Caption = 'Destination No.';
            Editable = false;
            TableRelation = if ("Destination Type" = const(Customer)) Customer."No."
            else
            if ("Destination Type" = const(Vendor)) Vendor."No."
            else
            if ("Destination Type" = const(Location)) Location.Code;
        }
        field(41; Cubage; Decimal)
        {
            Caption = 'Cubage';
            DecimalPlaces = 0 : 5;
        }
        field(42; Weight; Decimal)
        {
            Caption = 'Weight';
            DecimalPlaces = 0 : 5;
        }
        field(44; "Shipping Advice"; Enum "Sales Header Shipping Advice")
        {
            Caption = 'Shipping Advice';
            Editable = false;
        }
        field(45; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
        }
        field(46; "Completely Picked"; Boolean)
        {
            Caption = 'Completely Picked';
            Editable = false;
        }
        field(48; "Not upd. by Src. Doc. Post."; Boolean)
        {
            Caption = 'Not upd. by Src. Doc. Post.';
            Editable = false;
        }
        field(49; "Posting from Whse. Ref."; Integer)
        {
            Caption = 'Posting from Whse. Ref.';
            Editable = false;
        }
        field(50; "Qty. Rounding Precision"; Decimal)
        {
            Caption = 'Qty. Rounding Precision';
            InitValue = 0;
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 1;
            Editable = false;
        }
        field(51; "Qty. Rounding Precision (Base)"; Decimal)
        {
            Caption = 'Qty. Rounding Precision (Base)';
            InitValue = 0;
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 1;
            Editable = false;
        }
        field(900; "Assemble to Order"; Boolean)
        {
            AccessByPermission = TableData "BOM Component" = R;
            Caption = 'Assemble to Order';
            Editable = false;
        }
        field(901; "Warehouse Shpt Line No."; Integer)
        {
            Editable = false;
        }
        field(904; "Warehouse Shpt No."; Code[20])
        {
            Editable = false;
        }
        field(905; "Shipping Mark"; Code[20])
        {
            // Editable = false;
        }
        //Additional
        field(902; "Nett Weight"; Decimal)
        {

        }
        field(903; "Gross Weight"; Decimal)
        {

        }
        field(1001; "Lot No."; Code[50])
        {

        }
        field(1002; "Qty to Handle"; Decimal)
        {

        }
        field(1003; "Package No."; Code[50])
        {

        }
        field(1004; "Box Qty."; Decimal)
        {

        }
        field(1005; "Customer PO No."; Text[35])
        {

        }
        field(1006; "Measurement"; Decimal)
        {

        }
        field(1009; "Ismanual"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Pack. Header".IsManual where("No." = field("No.")));
            Editable = false;
        }
        field(1010; "Consignee Header"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Pack. Header".Consignee where("No." = field("No.")));
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "No.", "Sorting Sequence No.")
        {
            MaintainSQLIndex = false;
        }
        key(Key3; "No.", "Item No.")
        {
            MaintainSQLIndex = false;
        }
        key(Key4; "No.", "Source Document", "Source No.")
        {
            MaintainSQLIndex = false;
        }
        key(Key5; "No.", "Shelf No.")
        {
            MaintainSQLIndex = false;
        }
        key(Key6; "No.", "Bin Code")
        {
            MaintainSQLIndex = false;
        }
        key(Key7; "No.", "Due Date")
        {
            MaintainSQLIndex = false;
        }
        key(Key8; "No.", "Destination Type", "Destination No.")
        {
            MaintainSQLIndex = false;
        }
        key(Key9; "Source Type", "Source Subtype", "Source No.", "Source Line No.", "Assemble to Order")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Qty. Outstanding", "Qty. Outstanding (Base)";
        }
        key(Key10; "No.", "Source Type", "Source Subtype", "Source No.", "Source Line No.")
        {
            MaintainSQLIndex = false;
        }
        key(Key11; "Item No.", "Location Code", "Variant Code", "Due Date")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Qty. Outstanding (Base)";
        }
        key(Key12; "Bin Code", "Location Code")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = Cubage, Weight;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        IsHandled: Boolean;
    begin

    end;

    trigger OnRename()
    begin
        Error(Text008, TableCaption);
    end;

    var
        Location: Record Location;
        Item: Record Item;
        UOMMgt: Codeunit "Unit of Measure Management";
        IgnoreErrors: Boolean;
        ErrorOccured: Boolean;

        Text000: Label 'You cannot handle more than the outstanding %1 units.';
        Text001: Label 'must not be less than %1 units';
        Text002: Label 'must not be greater than %1 units';
        Text003: Label 'must be greater than zero';
        Text005: Label 'The picked quantity is not enough to ship all lines.';
        Text007: Label '%1 = %2 is greater than %3 = %4. If you delete the %5, the items will remain in the shipping area until you put them away.\Related Item Tracking information defined during pick will be deleted.\Do you still want to delete the %5?', Comment = 'Qty. Picked = 2 is greater than Qty. Shipped = 0. If you delete the Warehouse Shipment Line, the items will remain in the shipping area until you put them away.\Related Item Tracking information defined during pick will be deleted.\Do you still want to delete the Warehouse Shipment Line?';
        Text008: Label 'You cannot rename a %1.';
        Text009: Label '%1 is set to %2. %3 should be %4.\\';
        Text010: Label 'Accept the entered value?';
        Text011: Label 'Nothing to handle. The quantity on the shipment lines are completely picked.';

    protected var
        WhseShptHeader: Record "Warehouse Shipment Header";
        HideValidationDialog: Boolean;
        StatusCheckSuspended: Boolean;

    procedure InitNewLine(DocNo: Code[20])
    begin
        Reset();
        "No." := DocNo;
        SetRange("No.", "No.");
        LockTable();
        if FindLast() then;

        Init();
        SetIgnoreErrors();
        "Line No." := "Line No." + 10000;
    end;

    procedure CalcQty(QtyBase: Decimal): Decimal
    begin
        TestField("Qty. per Unit of Measure");
        exit(UOMMgt.RoundQty(QtyBase / "Qty. per Unit of Measure", "Qty. Rounding Precision"));
    end;

    procedure CalcBaseQty(Qty: Decimal; FromFieldName: Text; ToFieldName: Text): Decimal
    begin
        OnBeforeCalcBaseQty(Rec, Qty, FromFieldName, ToFieldName);

        TestField("Qty. per Unit of Measure");
        exit(UOMMgt.CalcBaseQty(
            "Item No.", "Variant Code", "Unit of Measure Code", Qty, "Qty. per Unit of Measure", "Qty. Rounding Precision (Base)", FieldCaption("Qty. Rounding Precision"), FromFieldName, ToFieldName));
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
            Location.GetLocationSetup(LocationCode, Location)
        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
    end;

    local procedure TestReleased()
    begin
        TestField("No.");
        GetWhseShptHeader("No.");
        OnBeforeTestReleased(WhseShptHeader, StatusCheckSuspended);
        if not StatusCheckSuspended then
            WhseShptHeader.TestField(Status, WhseShptHeader.Status::Open);
    end;

    local procedure UpdateDocumentStatus()
    var
        OrderStatus: Option;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeUpdateDocumentStatus(Rec, IsHandled);
        if IsHandled then
            exit;

        OrderStatus := WhseShptHeader.GetDocumentStatus("Line No.");
        if OrderStatus <> WhseShptHeader."Document Status" then begin
            WhseShptHeader.Validate("Document Status", OrderStatus);
            WhseShptHeader.Modify();
        end;
    end;

    local procedure ValidateQuantityIsBalanced()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeValidateQuantityIsBalanced(Rec, IsHandled, xRec);
        if IsHandled then
            exit;

        // UOMMgt.ValidateQtyIsBalanced(Quantity, CalcQtyBase("Qty. (Base)", Quantity), "Qty. to Ship",
        //     CalcQtyBase("Qty. to Ship (Base)", "Qty. to Ship"), "Qty. Shipped", CalcQtyBase("Qty. Shipped (Base)", "Qty. Shipped"));
    end;

    local procedure CalcQtyBase(QtyToRound: Decimal; Qty: Decimal): Decimal
    begin
        if QtyToRound = 0 then
            exit(0);

        if "Qty. per Unit of Measure" = 1 then
            exit(QtyToRound);

        exit(Qty * "Qty. per Unit of Measure");
    end;

    procedure CheckBin(DeductCubage: Decimal; DeductWeight: Decimal)
    var
        Bin: Record Bin;
        BinContent: Record "Bin Content";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCheckBin(Rec, Bin, DeductCubage, DeductWeight, IgnoreErrors, ErrorOccured, IsHandled);
        if IsHandled then
            exit;

        if "Bin Code" <> '' then begin
            GetLocation("Location Code");
            if Location."Bin Capacity Policy" = Location."Bin Capacity Policy"::"Never Check Capacity" then begin
                if Location."Check Whse. Class" then
                    if BinContent.Get("Location Code", "Bin Code", "Item No.", "Variant Code", "Unit of Measure Code") then begin
                        if not BinContent.CheckWhseClass(IgnoreErrors) then
                            ErrorOccured := true;
                    end else begin
                        Bin.Get("Location Code", "Bin Code");
                        if not Bin.CheckWhseClass("Item No.", IgnoreErrors) then
                            ErrorOccured := true;
                    end;
                if ErrorOccured then
                    "Bin Code" := '';
                exit;
            end;

            if BinContent.Get(
                 "Location Code", "Bin Code",
                 "Item No.", "Variant Code", "Unit of Measure Code")
            then begin
                if not BinContent.CheckIncreaseBinContent(
                     "Qty. Outstanding", "Qty. Outstanding",
                     DeductCubage, DeductWeight, Cubage, Weight, false, IgnoreErrors)
                then
                    ErrorOccured := true;
            end else begin
                Bin.Get("Location Code", "Bin Code");
                if not Bin.CheckIncreaseBin(
                     "Bin Code", "Item No.", "Qty. Outstanding",
                     DeductCubage, DeductWeight, Cubage, Weight, false, IgnoreErrors)
                then
                    ErrorOccured := true;
            end;
        end;
        if ErrorOccured then
            "Bin Code" := '';
    end;

    procedure CheckSourceDocLineQty()
    var
        WhseShptLine: Record "Pack. Lines";
        SalesLine: Record "Sales Line";
        PurchaseLine: Record "Purchase Line";
        TransferLine: Record "Transfer Line";
        ServiceLine: Record "Service Line";
        WhseQtyOutstandingBase: Decimal;
        QtyOutstandingBase: Decimal;
        QuantityBase: Decimal;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCheckSourceDocLineQty(Rec, IsHandled);
        if IsHandled then
            exit;

        SetQuantityBase(QuantityBase);

        WhseShptLine.SetSourceFilter("Source Type", "Source Subtype", "Source No.", "Source Line No.", true);
        WhseShptLine.CalcSums("Qty. Outstanding (Base)");
        if WhseShptLine.Find('-') then
            repeat
                if (WhseShptLine."No." <> "No.") or
                   (WhseShptLine."Line No." <> "Line No.")
                then
                    WhseQtyOutstandingBase := WhseQtyOutstandingBase + WhseShptLine."Qty. Outstanding (Base)";
            until WhseShptLine.Next() = 0;

        case "Source Type" of
            Database::"Sales Line":
                begin
                    SalesLine.Get("Source Subtype", "Source No.", "Source Line No.");
                    if Abs(SalesLine."Outstanding Qty. (Base)") < WhseQtyOutstandingBase + QuantityBase then
                        FieldError(Quantity, StrSubstNo(Text002, CalcQty(SalesLine."Outstanding Qty. (Base)" - WhseQtyOutstandingBase)));
                    QtyOutstandingBase := Abs(SalesLine."Outstanding Qty. (Base)");
                end;
            Database::"Purchase Line":
                begin
                    PurchaseLine.Get("Source Subtype", "Source No.", "Source Line No.");
                    if Abs(PurchaseLine."Outstanding Qty. (Base)") < WhseQtyOutstandingBase + QuantityBase then
                        FieldError(Quantity, StrSubstNo(Text002, CalcQty(Abs(PurchaseLine."Outstanding Qty. (Base)") - WhseQtyOutstandingBase)));
                    QtyOutstandingBase := Abs(PurchaseLine."Outstanding Qty. (Base)");
                end;
            Database::"Transfer Line":
                begin
                    TransferLine.Get("Source No.", "Source Line No.");
                    if TransferLine."Outstanding Qty. (Base)" < WhseQtyOutstandingBase + QuantityBase then
                        FieldError(Quantity, StrSubstNo(Text002, CalcQty(TransferLine."Outstanding Qty. (Base)" - WhseQtyOutstandingBase)));
                    QtyOutstandingBase := TransferLine."Outstanding Qty. (Base)";
                end;
            Database::"Service Line":
                begin
                    ServiceLine.Get("Source Subtype", "Source No.", "Source Line No.");
                    if Abs(ServiceLine."Outstanding Qty. (Base)") < WhseQtyOutstandingBase + QuantityBase then
                        FieldError(Quantity, StrSubstNo(Text002, CalcQty(ServiceLine."Outstanding Qty. (Base)" - WhseQtyOutstandingBase)));
                    QtyOutstandingBase := Abs(ServiceLine."Outstanding Qty. (Base)");
                end;
            else
                OnCheckSourceDocLineQtyOnCaseSourceType(Rec, WhseQtyOutstandingBase, QtyOutstandingBase, QuantityBase);
        end;
        IsHandled := false;
        OnCheckSourceDocLineQtyOnBeforeFieldError(Rec, WhseQtyOutstandingBase, QtyOutstandingBase, QuantityBase, IsHandled);
        if not IsHandled then
            if QuantityBase > QtyOutstandingBase then
                FieldError(Quantity, StrSubstNo(Text002, FieldCaption("Qty. Outstanding")));
    end;

    procedure DeleteQtyToHandle(var WhseShptLine: Record "Pack. Lines")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeDeleteQtyToHandle(WhseShptLine, IsHandled);
        if IsHandled then
            exit;

        if WhseShptLine.FindSet() then
            repeat
                WhseShptLine.Validate("Qty. to Ship", 0);
                OnDeleteQtyToHandleOnBeforeModify(WhseShptLine);
                WhseShptLine.Modify();
            until WhseShptLine.Next() = 0;
    end;

    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    protected procedure GetWhseShptHeader(WhseShptNo: Code[20])
    begin
        if WhseShptHeader."No." <> WhseShptNo then
            WhseShptHeader.Get(WhseShptNo);

        OnAfterGetWhseShptHeader(Rec, WhseShptHeader, WhseShptNo);
    end;

    local procedure GetItem()
    begin
        if Item."No." <> "Item No." then
            Item.Get("Item No.");
    end;

    procedure OpenItemTrackingLines()
    var
        PurchaseLine: Record "Purchase Line";
        SalesLine: Record "Sales Line";
        ServiceLine: Record "Service Line";
        TransferLine: Record "Transfer Line";
        PurchLineReserve: Codeunit "Purch. Line-Reserve";
        SalesLineReserve: Codeunit "Sales Line-Reserve";
        TransferLineReserve: Codeunit "Transfer Line-Reserve";
        ServiceLineReserve: Codeunit "Service Line-Reserve";
        SecondSourceQtyArray: array[3] of Decimal;
        Direction: Enum "Transfer Direction";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeOpenItemTrackingLines(Rec, IsHandled);
        if IsHandled then
            exit;

        TestField("No.");
        TestField("Qty. (Base)");

        GetItem();
        Item.TestField("Item Tracking Code");

        SecondSourceQtyArray[1] := Database::"Pack. Lines";
        SecondSourceQtyArray[2] := "Qty. to Ship (Base)";
        SecondSourceQtyArray[3] := 0;

        case "Source Type" of
            Database::"Sales Line":
                if SalesLine.Get("Source Subtype", "Source No.", "Source Line No.") then
                    SalesLineReserve.CallItemTrackingSecondSource(SalesLine, SecondSourceQtyArray, "Assemble to Order");
            Database::"Service Line":
                if ServiceLine.Get("Source Subtype", "Source No.", "Source Line No.") then
                    ServiceLineReserve.CallItemTracking(ServiceLine);
            Database::"Purchase Line":
                if PurchaseLine.Get("Source Subtype", "Source No.", "Source Line No.") then
                    PurchLineReserve.CallItemTracking(PurchaseLine, SecondSourceQtyArray);
            Database::"Transfer Line":
                begin
                    Direction := Direction::Outbound;
                    if TransferLine.Get("Source No.", "Source Line No.") then
                        TransferLineReserve.CallItemTracking(TransferLine, Direction, SecondSourceQtyArray);
                end;
        end;

        OnAfterOpenItemTrackingLines(Rec, SecondSourceQtyArray);
    end;

    procedure SetIgnoreErrors()
    begin
        IgnoreErrors := true;
    end;

    procedure HasErrorOccured(): Boolean
    begin
        exit(ErrorOccured);
    end;

    procedure GetATOAndNonATOLines(var ATOWhseShptLine: Record "Pack. Lines"; var NonATOWhseShptLine: Record "Pack. Lines"; var ATOLineFound: Boolean; var NonATOLineFound: Boolean)
    var
        WhseShptLine: Record "Pack. Lines";
    begin
        WhseShptLine.Copy(Rec);
        WhseShptLine.SetSourceFilter("Source Type", "Source Subtype", "Source No.", "Source Line No.", false);

        NonATOWhseShptLine.Copy(WhseShptLine);
        NonATOWhseShptLine.SetRange("Assemble to Order", false);
        NonATOLineFound := NonATOWhseShptLine.FindFirst();

        ATOWhseShptLine.Copy(WhseShptLine);
        ATOWhseShptLine.SetRange("Assemble to Order", true);
        ATOLineFound := ATOWhseShptLine.FindFirst();
    end;

    procedure FullATOPosted(): Boolean
    var
        SalesLine: Record "Sales Line";
        ATOWhseShptLine: Record "Pack. Lines";
    begin
        if "Source Document" <> "Source Document"::"Sales Order" then
            exit(true);
        SalesLine.SetRange("Document Type", "Source Subtype");
        SalesLine.SetRange("Document No.", "Source No.");
        SalesLine.SetRange("Line No.", "Source Line No.");
        if not SalesLine.FindFirst() then
            exit(true);
        if SalesLine."Qty. Shipped (Base)" >= SalesLine."Qty. to Asm. to Order (Base)" then
            exit(true);
        ATOWhseShptLine.SetRange("No.", "No.");
        ATOWhseShptLine.SetSourceFilter("Source Type", "Source Subtype", "Source No.", "Source Line No.", false);
        ATOWhseShptLine.SetRange("Assemble to Order", true);
        ATOWhseShptLine.CalcSums("Qty. to Ship (Base)");
        exit((SalesLine."Qty. Shipped (Base)" + ATOWhseShptLine."Qty. to Ship (Base)") >= SalesLine."Qty. to Asm. to Order (Base)");
    end;

    procedure GetWhseShptLine(ShipmentNo: Code[20]; SourceType: Integer; SourceSubtype: Option; SourceNo: Code[20]; SourceLineNo: Integer): Boolean
    begin
        SetRange("No.", ShipmentNo);
        SetSourceFilter(SourceType, SourceSubtype, SourceNo, SourceLineNo, false);
        if FindFirst() then
            exit(true);
    end;

    procedure CreateWhseItemTrackingLines()
    var
        ATOSalesLine: Record "Sales Line";
        AsmHeader: Record "Assembly Header";
        AsmLineMgt: Codeunit "Assembly Line Management";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCreateWhseItemTrackingLines(Rec, IsHandled);
        if not IsHandled then
            if "Assemble to Order" then begin
                TestField("Source Type", Database::"Sales Line");
                ATOSalesLine.Get("Source Subtype", "Source No.", "Source Line No.");
                ATOSalesLine.AsmToOrderExists(AsmHeader);
                AsmLineMgt.CreateWhseItemTrkgForAsmLines(AsmHeader);
            end else
                if ItemTrackingMgt.GetWhseItemTrkgSetup("Item No.") then
                    ItemTrackingMgt.InitItemTrackingForTempWhseWorksheetLine(
                      Enum::"Warehouse Worksheet Document Type"::Shipment, "No.", "Line No.",
                      "Source Type", "Source Subtype", "Source No.", "Source Line No.", 0);

        OnAfterCreateWhseItemTrackingLines(Rec);
    end;

    procedure DeleteWhseItemTrackingLines()
    var
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    begin
        ItemTrackingMgt.DeleteWhseItemTrkgLinesWithRunDeleteTrigger(
          Database::"Pack. Lines", 0, "No.", '', 0, "Line No.", "Location Code", true, true);
    end;

    procedure SetItemData(ItemNo: Code[20]; ItemDescription: Text[100]; ItemDescription2: Text[50]; LocationCode: Code[10]; VariantCode: Code[10]; UoMCode: Code[10]; QtyPerUoM: Decimal)
    begin
        "Item No." := ItemNo;
        Description := ItemDescription;
        "Description 2" := ItemDescription2;
        "Location Code" := LocationCode;
        "Variant Code" := VariantCode;
        "Unit of Measure Code" := UoMCode;
        "Qty. per Unit of Measure" := QtyPerUoM;

        OnAfterSetItemData(Rec);
    end;

    procedure SetItemData(ItemNo: Code[20]; ItemDescription: Text[100]; ItemDescription2: Text[50]; LocationCode: Code[10]; VariantCode: Code[10]; UoMCode: Code[10]; QtyPerUoM: Decimal; QtyRndPrec: Decimal; QtyRndPrecBase: Decimal)
    begin
        SetItemData(ItemNo, ItemDescription, ItemDescription2, LocationCode, VariantCode, UoMCode, QtyPerUoM);
        "Qty. Rounding Precision" := QtyRndPrec;
        "Qty. Rounding Precision (Base)" := QtyRndPrecBase;
    end;

    procedure SetSource(SourceType: Integer; SourceSubType: Option; SourceNo: Code[20]; SourceLineNo: Integer)
    var
        WhseMgt: Codeunit "Whse. Management";
    begin
        "Source Type" := SourceType;
        "Source Subtype" := SourceSubType;
        "Source No." := SourceNo;
        "Source Line No." := SourceLineNo;
        "Source Document" := WhseMgt.GetWhseActivSourceDocument("Source Type", "Source Subtype");
    end;

    procedure SetSourceFilter(SourceType: Integer; SourceSubType: Option; SourceNo: Code[20]; SourceLineNo: Integer; SetKey: Boolean)
    begin
        if SetKey then
            SetCurrentKey("Source Type", "Source Subtype", "Source No.", "Source Line No.");
        SetRange("Source Type", SourceType);
        if SourceSubType >= 0 then
            SetRange("Source Subtype", SourceSubType);
        SetRange("Source No.", SourceNo);
        if SourceLineNo >= 0 then
            SetRange("Source Line No.", SourceLineNo);

        OnAfterSetSourceFilter(Rec, SourceType, SourceSubType, SourceNo, SourceLineNo, SetKey);
    end;

    procedure ClearSourceFilter()
    begin
        SetRange("Source Type");
        SetRange("Source Subtype");
        SetRange("Source No.");
        SetRange("Source Line No.");
    end;

    procedure SuspendStatusCheck(Suspend: Boolean)
    begin
        StatusCheckSuspended := Suspend;
    end;

    local procedure SetQuantityBase(var QuantityBase: Decimal)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeSetQuantityBase(Rec, QuantityBase, IsHandled);
        if IsHandled then
            exit;

        if "Qty. (Base)" = 0 then
            QuantityBase :=
                UOMMgt.CalcBaseQty("Item No.", "Variant Code", "Unit of Measure Code", Quantity, "Qty. per Unit of Measure")
        else
            QuantityBase := "Qty. (Base)";
    end;

    local procedure MaxQtyToShipBase(QtyToShipBase: Decimal): Decimal
    begin
        if Abs(QtyToShipBase) > Abs("Qty. Outstanding (Base)") then
            exit("Qty. Outstanding (Base)");
        exit(QtyToShipBase);
    end;

    internal procedure CheckDirectTransfer(DirectTransfer: Boolean; DoCheck: Boolean): Boolean
    var
        InventorySetup: Record "Inventory Setup";
        TransferHeader: Record "Transfer Header";
    begin
        if "Source Type" <> Database::"Transfer Line" then
            exit(false);

        InventorySetup.Get();
        if InventorySetup."Direct Transfer Posting" = InventorySetup."Direct Transfer Posting"::"Direct Transfer" then begin
            TransferHeader.SetLoadFields("Direct Transfer");
            TransferHeader.Get(Rec."Source No.");
            if DoCheck then
                TransferHeader.TestField("Direct Transfer", DirectTransfer)
            else
                exit(TransferHeader."Direct Transfer");
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAutofillQtyToHandle(var PackShipmentLine: Record "Pack. Lines"; var HideValidationDialog: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreatePickDoc(var WarehouseShipmentHeader: Record "Warehouse Shipment Header"; var WhseShptLine: Record "Pack. Lines")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateWhseItemTrackingLines(var PackShipmentLine: Record "Pack. Lines")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetWhseShptHeader(var PackShipmentLine: Record "Pack. Lines"; var WarehouseShipmentHeader: Record "Warehouse Shipment Header"; WhseShptNo: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitQtyToShip(var PackShipmentLine: Record "Pack. Lines"; CurrentFieldNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOpenItemTrackingLines(var PackShipmentLine: Record "Pack. Lines"; var SecondSourceQtyArray: array[3] of Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetSourceFilter(var PackShipmentLine: Record "Pack. Lines"; SourceType: Integer; SourceSubType: Option; SourceNo: Code[20]; SourceLineNo: Integer; SetKey: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAutoFillQtyToHandleOnBeforeModify(var PackShipmentLine: Record "Pack. Lines")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAutofillQtyToHandle(var PackShipmentLine: Record "Pack. Lines"; var HideValidationDialog: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalcStatusShptLine(var PackShipmentLine: Record "Pack. Lines"; var NewStatus: Integer; var IsHandled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckBin(var PackShipmentLine: Record "Pack. Lines"; var Bin: Record Bin; DeductCubage: Decimal; DeductWeight: Decimal; IgnoreErrors: Boolean; var ErrorOccured: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckSourceDocLineQty(var PackShipmentLine: Record "Pack. Lines"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreatePickDoc(var PackShipmentLine: Record "Pack. Lines"; WarehouseShipmentHeader: Record "Warehouse Shipment Header"; HideValidationDialog: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCompareQtyToShipAndOutstandingQty(var PackShipmentLine: Record "Pack. Lines"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCompareShipAndPickQty(PackShipmentLine: Record "Pack. Lines"; var IsHandled: Boolean; CurrentFieldNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInitOutstandingQtys(var PackShipmentLine: Record "Pack. Lines"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOpenItemTrackingLines(var PackShipmentLine: Record "Pack. Lines"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestReleased(var WhseShptHeader: Record "Warehouse Shipment Header"; var StatusCheckSuspended: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateDocumentStatus(var PackShipmentLine: Record "Pack. Lines"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateQuantityIsBalanced(var PackShipmentLine: Record "Pack. Lines"; var IsHandled: Boolean; xPackShipmentLine: Record "Pack. Lines")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateQtyToShipBase(var PackShipmentLine: Record "Pack. Lines"; xPackShipmentLine: Record "Pack. Lines"; CallingFieldNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateWhseItemTrackingLines(var PackShipmentLine: Record "Pack. Lines"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCheckSourceDocLineQtyOnBeforeFieldError(var PackShipmentLine: Record "Pack. Lines"; WhseQtyOutstandingBase: Decimal; var QtyOutstandingBase: Decimal; QuantityBase: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCheckSourceDocLineQtyOnCaseSourceType(var PackShipmentLine: Record "Pack. Lines"; WhseQtyOutstandingBase: Decimal; var QtyOutstandingBase: Decimal; QuantityBase: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnValidateQuantityStatusUpdate(var PackShipmentLine: Record "Pack. Lines"; xPackShipmentLine: Record "Pack. Lines"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnDeleteQtyToHandleOnBeforeModify(var WhseShptLine: Record "Pack. Lines")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCreatePickDocOnBeforeCreatePickDoc(var PackShipmentLine: Record "Pack. Lines"; var WhseShptLine: Record "Pack. Lines"; var WhseShptHeader2: Record "Warehouse Shipment Header"; HideValidationDialog: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDeleteQtyToHandle(var WhseShptLine: Record "Pack. Lines"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSetQuantityBase(var Rec: Record "Pack. Lines"; var QuantityBase: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidateQtyToShip(var PackShipmentLine: Record "Pack. Lines"; var xPackShipmentLine: Record "Pack. Lines")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalcBaseQty(var PackShipmentLine: Record "Pack. Lines"; var Qty: Decimal; FromFieldName: Text; ToFieldName: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetItemData(var PackShipmentLine: Record "Pack. Lines")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCreatePickDocFromWhseShptOnBeforeRunWhseShipmentCreatePick(var WhseShipmentCreatePick: Report "Whse.-Shipment - Create Pick")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnDeleteOnBeforeConfirmDelete(var PackShipmentLine: Record "Pack. Lines"; var IsHandled: Boolean)
    begin
    end;

}
