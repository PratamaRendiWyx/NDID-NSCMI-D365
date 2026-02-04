tableextension 50512 PurchRcptLine_WE extends "Purch. Rcpt. Line"
{
    fields
    {
        field(50500; "Vendor Shipment No."; Code[35])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Rcpt. Header"."Vendor Shipment No." where("No." = field("Document No.")));
            Editable = false;
        }
    }
}
