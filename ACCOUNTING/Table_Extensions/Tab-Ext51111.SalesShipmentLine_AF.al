namespace ACCOUNTING.ACCOUNTING;

using Microsoft.Sales.History;
using Microsoft.Sales.Customer;

tableextension 51111 SalesShipmentLine_AF extends "Sales Shipment Line"
{
    fields
    {
        field(51100; "Customer Name"; Text[1000])
        {
            Caption = 'Customer Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field("Sell-to Customer No.")));
        }
    }
}
