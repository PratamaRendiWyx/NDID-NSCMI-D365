tableextension 50507 Item_WE extends Item
{
    fields
    {
        field(50500; "Shipping Lot No."; Code[20])
        {
            Caption = 'Shipping Lot No.';
            DataClassification = ToBeClassified;
        }
        field(50501; "Product Type"; Enum "Product Type")
        {
            Caption = 'Product Type';
            DataClassification = ToBeClassified;
        }

    }
}
