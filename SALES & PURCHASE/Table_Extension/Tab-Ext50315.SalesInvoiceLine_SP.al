tableextension 50315 SalesInvoiceLine_SP extends "Sales Invoice Line"
{
    fields
    {
        field(50315; "Cust. PO No."; Text[35])
        {
        }
        field(50312; "Part Number"; Text[30])
        {
        }
        field(50313; "Part Name"; Text[100])
        {
        }
        field(50200; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            FieldClass = FlowField;
            AllowInCustomizations = Always;
            CalcFormula = lookup("Sales Invoice Header"."Sell-to Customer Name" where("No." = field("Document No.")));
        }
    }
}
