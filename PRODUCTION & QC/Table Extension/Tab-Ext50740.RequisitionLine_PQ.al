namespace PRODUCTIONQC.PRODUCTIONQC;

using Microsoft.Inventory.Requisition;
using Microsoft.Purchases.Vendor;
using Microsoft.Inventory.Item;
using Microsoft.Manufacturing.Setup;

tableextension 50740 RequisitionLine_PQ extends "Requisition Line"
{
    fields
    {
        
        field(50700; "Vendor Posting Group"; Code[20])
        {
            Caption = 'Vendor Posting Group';
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor."Vendor Posting Group" where("No." = field("Vendor No.")));
            Editable = false;
        }

        field(50701; "Production Line"; Code[20])
        {
            Caption = 'Production Line';
            DataClassification = ToBeClassified;
        }
        field(50702; Shift; Code[20])
        {
            Caption = 'Shift';
            DataClassification = ToBeClassified;
            TableRelation = "Work Shift".Code;
        }
        field(50703; "Capacity Line"; Decimal)
        {
            Caption = 'Capacity Line';
        }
        field(50704; "Qty. to Plan Order"; Decimal)
        {
            Caption = 'Qty. to Plan Orders';
        }

        field(50705; "Remain Qty."; Decimal)
        {
            Caption = 'Remain Qty.';
            Editable = false;
        }
        field(50706; "Starting Date (Plan)"; Date)
        {
            Caption = 'Starting Date (Plan)';
        }

        field(50707; "Capacity Mix"; Decimal)
        {
            Caption = 'Capacity Mix';
        }
        field(50708; "Is Subcon (?)"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Is Subcon (?)" where("No." = field("No.")));
            Editable = false;
        }

    }
}
