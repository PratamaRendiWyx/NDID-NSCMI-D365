tableextension 50703 Item_PQ extends Item
{

    fields
    {
        field(50700; "CCS Auto Enter Ser No. Master"; Boolean)
        {

            Caption = 'Auto Enter Serial No. Master';
            Description = 'FP';
            DataClassification = CustomerContent;
        }
        field(50701; "Has Quality Specifications"; Boolean)
        {
            CalcFormula = Exist(QCSpecificationHeader_PQ WHERE("Item No." = FIELD("No."),
                                                                     "Customer No." = FILTER('')));
            Caption = 'Has Quality Specifications';
            Description = 'Triggered when Cust. No. is entered on a item spec';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50702; "QC Spec Status"; Option)
        {
            CalcFormula = Lookup(QCSpecificationHeader_PQ.Status WHERE("Item No." = FIELD("No.")));
            Caption = 'Quality Specification Status';
            Description = 'Flowfield from Quality Lot test Header';
            FieldClass = FlowField;
            OptionMembers = New,Certified,"Under Development",Closed;
        }
        field(50703; "Inventory Available"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                                                  "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                  "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                  "Location Code" = FIELD("Location Filter"),
                                                                  "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                  "Variant Code" = FIELD("Variant Filter"),
                                                                  "Lot No." = FIELD("Lot No. Filter"),
                                                                  "Serial No." = FIELD("Serial No. Filter"),
                                                                  "Unit of Measure Code" = FIELD("Unit of Measure Filter"),
                                                                  "Package No." = FIELD("Package No. Filter"),
                                                                  "Lot Unrestricted" = CONST(Unrestricted),
                                                                  "Serial Unrestricted" = CONST(Unrestricted)));
            Caption = 'Inventory Available';
            CaptionClass = GetInventoryCaption();
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50704; "Last Std Cost Change"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Last Std. Cost Change';
            Description = 'MP';
            Editable = false;
        }
        field(50705; "Last Lot Size Change"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Last Lot Size Change';
            Description = 'MP';
            Editable = false;
        }
        field(50706; "Qty On Sales Invoice"; Decimal)
        {
            CalcFormula = - Sum("Value Entry"."Valued Quantity" WHERE("Item No." = FIELD("No."),
                                                                      "Document Type" = FILTER("Sales Invoice" | "Sales Return Receipt" | "Sales Credit Memo"),
                                                                      "Posting Date" = FIELD("Date Filter")));
            Caption = 'Qty. on Sales Invoice';
            Description = 'MP';
            FieldClass = FlowField;
        }
        field(50707; "Prod BOM Curr Version"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Prod BOM Curr Version';
            Description = 'MP';
            Editable = false;
        }
        field(50708; "Routing Curr Version"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Routing Curr Version';
            Description = 'MP';
            Editable = false;
        }
        field(50709; "Specification No."; Code[20])
        {

        }
        field(50502; "Product Type Code"; Enum "Product Type")
        {
            Caption = 'Product Type';
            DataClassification = ToBeClassified;
            ObsoleteState = Removed;
        }
        field(50503; "Is Subcon (?)"; Boolean)
        {
        }
        field(50504; "BOP Type"; enum "BOP Type")
        {
        }
    }
    keys
    {
    }

    local procedure GetInventoryCaption(): Text[1024]
    var
        TranslationHelper: Codeunit "Translation Helper";
        InventoryENUCaption: Text[1024];
        Text001: Label 'Quantity on Hand', Locked = true;
        Text002: Label ' Available';
        Text003: Label ' Unrestricted';
    begin
        InventoryENUCaption := TranslationHelper.GetTranslatedFieldCaption('ENU', Database::Item, FieldNo(Inventory));
        if InventoryENUCaption = Text001 then
            exit('3, ' + FieldCaption(Inventory) + Text003);
        exit('3, ' + FieldCaption(Inventory) + Text002)
    end;
}
