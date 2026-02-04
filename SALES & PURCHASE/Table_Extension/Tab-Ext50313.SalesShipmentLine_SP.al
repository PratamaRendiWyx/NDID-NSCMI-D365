tableextension 50313 SalesShipmentLine_SP extends "Sales Shipment Line"
{
    fields
    {
        field(50315; "Cust. PO No."; Text[35])
        {
        }
        field(50316; "Status Approval"; enum "Status Approval Shipment Lines")
        {

        }
        field(50317; "Comment Line"; Text[250])
        {
            Caption = 'Comment (Approver)';
        }
        field(50320; "Comment Line QC Worker"; Text[250])
        {
            Caption = 'Comment QC Worker';
        }
        field(50318; "Approval By"; Text[100]) { }
        field(50319; "Approval Date"; DateTime) { }
        field(50321; "QC By"; Text[100]) { }
        field(50322; "QC Date"; DateTime) { }
    }
}
