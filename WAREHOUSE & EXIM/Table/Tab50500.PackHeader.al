table 50500 "Pack. Header"
{
    Caption = 'Pack. Header';
    DataCaptionFields = "No.";
    DrillDownPageID = "Packing Shipments List";
    LookupPageID = "Packing Shipments List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                WhseSetup.Get();
                if "No." <> xRec."No." then begin
                    NoSeries.TestManual(WhseSetup."Packing Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));

            trigger OnValidate()
            var
                WhseShptLine: Record "Warehouse Shipment Line";
            begin
                if not WmsManagement.LocationIsAllowed("Location Code") then
                    Error(Text003, "Location Code");

                if "Location Code" <> xRec."Location Code" then begin
                    "Zone Code" := '';
                    "Bin Code" := '';
                    WhseShptLine.SetRange("No.", "No.");
                    if not WhseShptLine.IsEmpty() then
                        Error(
                          Text001,
                          FieldCaption("Location Code"));
                end;

                GetLocation("Location Code");
                Location.TestField("Require Shipment");
                if Location."Bin Mandatory" then
                    Validate("Bin Code", Location."Shipment Bin Code");

                if UserId <> '' then begin
                    FilterGroup := 2;
                    SetRange("Location Code", "Location Code");
                    FilterGroup := 0;
                end;
            end;
        }
        field(6; "Sorting Method"; Enum "Warehouse Shipment Sorting Method")
        {
            Caption = 'Sorting Method';

            trigger OnValidate()
            begin
                if "Sorting Method" <> xRec."Sorting Method" then
                    SortWhseDoc();
            end;
        }
        field(7; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(11; Comment; Boolean)
        {
            CalcFormula = exist("Warehouse Comment Line" where("Table Name" = const("Whse. Shipment"),
                                                                Type = const(" "),
                                                                "No." = field("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
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
                if (xRec."Bin Code" <> "Bin Code") or ("Zone Code" = '') then begin
                    TestField(Status, Status::Open);
                    if "Bin Code" <> '' then begin
                        GetLocation("Location Code");
                        WhseIntegrationMgt.CheckBinTypeAndCode(
                            Database::"Pack. Header", FieldCaption("Bin Code"), "Location Code", "Bin Code", 0);
                        Bin.Get("Location Code", "Bin Code");
                        "Zone Code" := Bin."Zone Code";
                    end;
                    MessageIfShipmentLinesExist(FieldCaption("Bin Code"));
                end;
            end;
        }
        field(13; "Zone Code"; Code[10])
        {
            Caption = 'Zone Code';
            TableRelation = Zone.Code where("Location Code" = field("Location Code"));

            trigger OnValidate()
            begin
                if "Zone Code" <> xRec."Zone Code" then begin
                    TestField(Status, Status::Open);
                    if "Zone Code" <> '' then begin
                        GetLocation("Location Code");
                        Location.TestField("Directed Put-away and Pick");
                    end;
                    "Bin Code" := '';
                    MessageIfShipmentLinesExist(FieldCaption("Zone Code"));
                end;
            end;
        }
        field(39; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(41; "Shipping Agent Code"; Code[10])
        {
            AccessByPermission = TableData "Shipping Agent Services" = R;
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";

            trigger OnValidate()
            begin
                if xRec."Shipping Agent Code" = "Shipping Agent Code" then
                    exit;

                "Shipping Agent Service Code" := '';
            end;
        }
        field(42; "Shipping Agent Service Code"; Code[10])
        {
            Caption = 'Shipping Agent Service Code';
            TableRelation = "Shipping Agent Services".Code where("Shipping Agent Code" = field("Shipping Agent Code"));
        }
        field(43; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";
        }
        field(45; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
        }
        field(47; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Released';
            OptionMembers = Open,Released;
        }
        field(48; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(49; "Wrshe. Shipment No."; Code[20])
        {
            Caption = 'Wrshe. Shipment No.';
        }
        field(50; "Shipping Mark No."; Code[20])
        {
            Caption = 'Shipping Mark No.';
        }
        field(51; "Shipping Mark Date"; Date)
        {
            Caption = 'Shipping Mark Date';
        }
        /*Consignee info*/
        field(52; "Consignee Name"; Text[100])
        {
            Caption = 'Consignee Name';
        }
        field(53; "Consignee Address"; Text[100])
        {
            Caption = 'Consignee Address';
        }
        field(54; "Consignee Address2"; Text[100])
        {
            Caption = 'Consignee Address 2';
        }
        field(56; "Consignee Phone"; Text[100])
        {
            Caption = 'Consignee Phone';
        }
        field(57; "Consignee Phone2"; Text[100])
        {
            Caption = 'Consignee Phone2';
        }
        //-
        //Additional
        field(55; "Port of Loading"; Text[100])
        {
            Caption = 'Port of Loading';
        }
        field(58; "Port of Discharge"; Text[100])
        {
            Caption = 'Port of Discharge';
        }
        field(59; "Name of Vessel"; Text[100])
        {
            Caption = 'Name of Vessel';
        }
        field(60; "ETD"; Date)
        {
            Caption = 'ETD';
        }
        field(61; "ETA"; Date)
        {
            Caption = 'ETA';
        }
        field(62; "PO No."; Code[250])
        {
            Caption = 'PO No.';
        }
        field(63; "Invoice"; Code[20])
        {
            Caption = 'Invoice';
        }
        field(64; "Terms"; Text[100])
        {
            Caption = 'Terms';
        }
        field(65; "Country of Origin"; Text[100])
        {
            Caption = 'Country of Origin';
        }
        field(66; "IsCancel"; Boolean)
        {
            Caption = 'Is Cancel (?)';
        }
        field(67; "Consignee"; Code[20])
        {
            Caption = 'Consignee';
            TableRelation = Customer."No.";
            trigger OnValidate()
            var
                myInt: Integer;
                customer: Record Customer;
            begin
                if Consignee <> '' then begin
                    Clear(customer);
                    customer.Reset();
                    customer.SetRange("No.", Rec.Consignee);
                    if customer.Find('-') then begin
                        "Consignee Name" := customer.Name;
                        "Consignee Phone" := customer."Phone No.";
                        "Consignee Address" := customer.Address;
                        "Consignee Address2" := customer."Address 2";
                    end;
                end
            end;
        }
        field(68; "Delivery Type"; Enum "Delivery Type")
        {
            Caption = 'Delivery Type';
        }
        field(73; "IsManual"; Boolean)
        {
            Caption = 'Manual (?)';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Location Code")
        {
        }
        key(Key3; "Shipment Date")
        {
        }
    }


    trigger OnDelete()
    begin
        TestField(Status, Status::Open);
        OnDeleteOnBeforeDeleteWarehouseShipmentLines(Rec, HideValidationDialog);
        //DeleteWarehouseShipmentLines();
        //DeleteRelatedLines();
    end;

    trigger OnInsert()
    var
        IsHandled: Boolean;
        Whsetup: Record "Warehouse Setup";
        PackingNo: Code[20];
    begin
        // IsHandled := false;
        Whsetup.Get();
        if Rec.IsManual then begin
            PackingNo := NoSeriesMgt.GetNextNo(Whsetup."Packing Nos.");
            Rec."No." := PackingNo;
        end;
        IsHandled := false;
    end;

    trigger OnRename()
    begin
        Error(Text000, TableCaption);
    end;

    procedure GetLocation(LocationCode: Code[10]): Record Location
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit(Location);

        if LocationCode = '' then
            Location.GetLocationSetup(LocationCode, Location)
        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
        exit(Location);
    end;

    local procedure ConfirmModification() Result: Boolean
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeConfirmModification(Rec, Result, IsHandled);
        if IsHandled then
            exit(Result);

        Result := Confirm(StrSubstNo(Text008, Rec.FieldCaption("Shipment Date")), false);
    end;

    procedure SortWhseDoc()
    var
        WhseShptLine: Record "Warehouse Shipment Line";
        SequenceNo: Integer;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeSortWhseDoc(Rec, IsHandled);
        if IsHandled then
            exit;

        WhseShptLine.SetRange("No.", "No.");
        case "Sorting Method" of
            "Sorting Method"::Item:
                WhseShptLine.SetCurrentKey("No.", "Item No.");
            "Sorting Method"::Document:
                WhseShptLine.SetCurrentKey("No.", "Source Document", "Source No.");
            "Sorting Method"::"Shelf or Bin":
                begin
                    GetLocation("Location Code");
                    if Location."Bin Mandatory" then
                        WhseShptLine.SetCurrentKey("No.", "Bin Code")
                    else
                        WhseShptLine.SetCurrentKey("No.", "Shelf No.");
                end;
            "Sorting Method"::"Due Date":
                WhseShptLine.SetCurrentKey("No.", "Due Date");
            "Sorting Method"::Destination:
                WhseShptLine.SetCurrentKey("No.", "Destination Type", "Destination No.");
            else
                OnSortWhseDocCaseElse(Rec, WhseShptLine);
        end;

        if WhseShptLine.Find('-') then begin
            SequenceNo := 10000;
            repeat
                WhseShptLine."Sorting Sequence No." := SequenceNo;
                WhseShptLine.Modify();
                SequenceNo := SequenceNo + 10000;
            until WhseShptLine.Next() = 0;
        end;
    end;

    procedure MessageIfShipmentLinesExist(ChangedFieldName: Text[80])
    var
        WhseShptLine: Record "Warehouse Shipment Line";
    begin
        WhseShptLine.SetRange("No.", "No.");
        if not WhseShptLine.IsEmpty() then
            if not HideValidationDialog then
                Message(
                  StrSubstNo(
                    Text006, ChangedFieldName, TableCaption) + Text007);
    end;

    protected var
        HideValidationDialog: Boolean;


    var
        Location: Record Location;
        WhseSetup: Record "Warehouse Setup";

        PackHeader: Record "Pack. Header";

#if not CLEAN24
        NoSeriesMgt: Codeunit "No. Series";
#endif
        NoSeries: Codeunit "No. Series";
        WmsManagement: Codeunit "WMS Management";

        Text000: Label 'You cannot rename a %1.';
        Text001: Label 'You cannot change the %1, because the document has one or more lines.';
        Text003: Label 'You are not allowed to use location code %1.';
        Text006: Label 'You have changed %1 on the %2, but it has not been changed on the existing Warehouse Shipment Lines.\';
        Text007: Label 'You must update the existing Warehouse Shipment Lines manually.';
        Text008: Label 'You have modified the %1.\\Do you want to update the lines?';
        Text009: Label 'The items have been picked. If you delete the warehouse shipment, then the items will remain in the shipping area until you put them away.\Related item tracking information that is defined during the pick will be deleted.\Are you sure that you want to delete the warehouse shipment?';

    [IntegrationEvent(false, false)]
    local procedure OnSortWhseDocCaseElse(var PackHeader: Record "Pack. Header"; var WarehouseShipmentLine: Record "Warehouse Shipment Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateShipmentDate(var PackHeader: Record "Pack. Header"; xPackHeader: Record "Pack. Header"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeConfirmModification(PackHeader: Record "Pack. Header"; var Result: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSortWhseDoc(var PackHeader: Record "Pack. Header"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnInsert(var PackHeader: Record "Pack. Header"; var xPackHeader: Record "Pack. Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnInsert(var PackHeader: Record "Pack. Header"; var xPackHeader: Record "Pack. Header"; var WhseSetup: Record "Warehouse Setup"; var NoSeriesMgt: Codeunit "No. Series"; var Location: Record Location; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnDeleteOnBeforeDeleteWarehouseShipmentLines(var PackHeader: Record "Pack. Header"; HideValidationDialog: Boolean)
    begin
    end;

}
