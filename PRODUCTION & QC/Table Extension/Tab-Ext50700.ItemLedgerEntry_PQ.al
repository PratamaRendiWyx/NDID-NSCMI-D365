tableextension 50700 ItemLedgerEntry_PQ extends "Item Ledger Entry"
{

    fields
    {
        field(50700; "CCS Quality Test"; Code[20])
        {
            Caption = 'Quality Test';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50701; "CCS Blocked"; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }
        field(50702; "CCS Create from Test No."; Code[20])
        {
            Caption = 'Create from Test No.';
            DataClassification = CustomerContent;
        }
        field(50703; "Lot Unrestricted"; Enum LotSerialStatus_PQ)
        {
            Caption = 'Lot Unrestricted';
            CalcFormula = LOOKUP("Lot No. Information"."CCS Status" WHERE("Item No." = FIELD("Item No."),
                                                                          "Variant Code" = FIELD("Variant Code"),
                                                                          "Lot No." = FIELD("Lot No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50704; "Serial Unrestricted"; Enum LotSerialStatus_PQ)
        {
            Caption = 'Serial Unrestricted';
            CalcFormula = LOOKUP("Serial No. Information"."CCS Status" WHERE("Item No." = FIELD("Item No."),
                                                                             "Variant Code" = FIELD("Variant Code"),
                                                                             "Serial No." = FIELD("Serial No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50715; "IsRemainQty"; Boolean)
        {
            Caption = 'Is Remain Qty.';
        }
        field(50716; IsBlock; Boolean)
        {
            Caption = 'Is Block (?)';
            FieldClass = FlowField;
            CalcFormula = lookup("Lot No. Information".Blocked where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Lot No." = field("Lot No.")));
        }
        field(50717; "Reason Code"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Value Entry"."Reason Code" where("Item Ledger Entry No." = field("Entry No.")));
            Editable = false;
        }
    }

}
