tableextension 51104 PurchCrMemoLine_AF extends "Purch. Cr. Memo Line"
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
    }
}
