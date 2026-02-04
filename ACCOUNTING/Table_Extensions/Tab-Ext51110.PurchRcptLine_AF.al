namespace ACCOUNTING.ACCOUNTING;

using Microsoft.Purchases.History;
using Microsoft.Purchases.Vendor;

tableextension 51110 PurchRcptLine_AF extends "Purch. Rcpt. Line"
{
    fields
    {
        field(51100; "Vendor Name"; Text[100])
        {
            Caption = '';
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field("Buy-from Vendor No.")));
        }
    }
}
