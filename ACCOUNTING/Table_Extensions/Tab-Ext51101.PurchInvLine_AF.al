tableextension 51101 PurchInvLine_AF extends "Purch. Inv. Line"
{
    fields
    {
        field(51100; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Inv. Header"."Currency Factor" where("No." = field("Document No.")));
        }
        field(51101; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field("Buy-from Vendor No.")));
        }
        field(51102; "Tax Number"; Code[40])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Inv. Header"."Tax Number_FT" where("No." = field("Document No.")));
            Editable = false;
        }
    }
}
