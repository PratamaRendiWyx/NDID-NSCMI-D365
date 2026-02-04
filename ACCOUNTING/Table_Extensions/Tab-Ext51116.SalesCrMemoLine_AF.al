namespace ACCOUNTING.ACCOUNTING;

using Microsoft.Sales.History;
using Microsoft.Finance.Dimension;
using Microsoft.Inventory.Ledger;

tableextension 51116 SalesCrmemoLine_AF extends "Sales Cr.Memo Line"
{
    fields
    {
        field(51100; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Cr.Memo Header"."Currency Code" where("No." = field("Document No.")));
            Editable = false;
        }
        field(51101; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Cr.Memo Header"."Currency Factor" where("No." = field("Document No.")));
            Editable = false;
        }
        field(51103; "Unit Cost (VE)"; Decimal)
        {
            Caption = 'Unit Cost (VE)';
            FieldClass = FlowField;
            CalcFormula = sum("Value Entry"."Cost Posted to G/L" where("Document No." = field("Document No."), "Document Line No." = field("Line No.")));
            Editable = false;
        }
        field(51104; "Sales Amount (VE)"; Decimal)
        {
            Caption = 'Sales Amount (VE)';
            FieldClass = FlowField;
            CalcFormula = sum("Value Entry"."Sales Amount (Actual)" where("Document No." = field("Document No."), "Document Line No." = field("Line No.")));
            Editable = false;
        }
        field(51105; "Cost Amount (VE)"; Decimal)
        {
            Caption = 'Cost Amount (VE)';
            FieldClass = FlowField;
            CalcFormula = sum("Value Entry"."Cost Amount (Actual)" where("Document No." = field("Document No."), "Document Line No." = field("Line No.")));
            Editable = false;
        }
        field(51106; "Customer Name"; Text[150])
        {
            Caption = 'Customer Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Cr.Memo Header"."Sell-to Customer Name" where("No." = field("Document No.")));
            Editable = false;
        }
        field(51107; "Shipment Method"; Code[10])
        {
            Caption = 'Shipment Method';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Cr.Memo Header"."Shipment Method Code" where("No." = field("Document No.")));
            Editable = false;
        }

    }
}
