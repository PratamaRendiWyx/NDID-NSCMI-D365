tableextension 50309 PriceListLine_SP extends "Price List Line"
{
    fields
    {
        field(50300; "OEM Type"; Code[30])
        {
            Caption = 'OEM Type';
            FieldClass = FlowField;
            CalcFormula = lookup("Default Dimension"."Dimension Value Code" where("Dimension Code" = filter('OEM TYPE'), "No." = field("Product No.")));
        }
        field(50301; "Quote No."; Text[50])
        {
            Caption = 'Quote No.';
            DataClassification = ToBeClassified;
        }
    }
}
