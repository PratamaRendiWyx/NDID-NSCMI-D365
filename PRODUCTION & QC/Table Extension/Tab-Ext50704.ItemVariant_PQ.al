tableextension 50704 ItemVariant_PQ extends "Item Variant"
{
    fields
    {
        // Add changes to table fields here
        field(50700; "Production BOM No."; code[20])
        {
            Caption = 'Production BOM No.';
            DataClassification = CustomerContent;
            TableRelation = "Production BOM Header";
        }
        field(50701; "Routing No."; code[20])
        {
            Caption = 'Routing No.';
            DataClassification = CustomerContent;
            TableRelation = "Routing Header";
        }
    }
}