table 50730 ItemCostStatistics_PQ
{

    Caption = 'Item Cost Statistics';
    LookupPageID = ItemCostStatisticsList_PQ;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Item;
        }
        field(2; Description; Text[100])
        {
            CalcFormula = Lookup (Item.Description WHERE ("No." = FIELD ("Item No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Lot Size"; Decimal)
        {
            CalcFormula = Lookup (Item."Lot Size" WHERE ("No." = FIELD ("Item No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Indirect Cost %"; Decimal)
        {
            CalcFormula = Lookup (Item."Indirect Cost %" WHERE ("No." = FIELD ("Item No.")));
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
            MinValue = 0;
        }
        field(6; "Overhead Rate"; Decimal)
        {
            AutoFormatType = 2;
            CalcFormula = Lookup (Item."Overhead Rate" WHERE ("No." = FIELD ("Item No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Scrap %"; Decimal)
        {
            CalcFormula = Lookup (Item."Scrap %" WHERE ("No." = FIELD ("Item No.")));
            DecimalPlaces = 0 : 2;
            Editable = false;
            FieldClass = FlowField;
            MaxValue = 100;
            MinValue = 0;
        }
        field(8; "Production BOM No."; Code[20])
        {
            CalcFormula = Lookup (Item."Production BOM No." WHERE ("No." = FIELD ("Item No.")));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Production BOM Header";
        }
        field(9; "Routing No."; Code[20])
        {
            CalcFormula = Lookup (Item."Routing No." WHERE ("No." = FIELD ("Item No.")));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Routing Header";
        }
        field(10; "CurrSingle-Lev Material Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            Editable = false;
        }
        field(11; "CurrSingle-Lev Capacity Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            Editable = false;
        }
        field(12; "CurrSingle-Lev Subcon. Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            Editable = false;
        }
        field(13; "CurrSingle-Lev Cap. Ovhd Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            Editable = false;
        }
        field(14; "CurrSingle-Lev Mfg. Ovhd Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            Editable = false;
        }
        field(16; "CurrRolled-up Material Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            DecimalPlaces = 2 : 5;
            Editable = false;
        }
        field(17; "CurrRolled-up Capacity Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            DecimalPlaces = 2 : 5;
            Editable = false;
        }
        field(18; "CurrRolled-up Subcontrd Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            Editable = false;
        }
        field(19; "CurrRolled-up Mfg. Ovhd Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            Editable = false;
        }
        field(20; "CurrRolled-up Cap. Overhd Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            Editable = false;
        }
        field(30; "Last CurrCost Calc. Lot Size"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(31; "Last CurrCost Calc BOM No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Production BOM Header";
        }
        field(32; "Last CurrCost Calc BOM Rev."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(33; "Last CurrCost Calc Router No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Routing Header";
        }
        field(34; "Last CurrCost Calc Router Rev."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(35; "Last CurrCost Calc Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(36; "Last CurrCost Action Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(37; "Last CurrCost Calc User ID"; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup";
        }
        field(38; "Current Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(39; "Last CurrCalc Indirect Cost %"; Decimal)
        {
            CalcFormula = Lookup (Item."Indirect Cost %" WHERE ("No." = FIELD ("Item No.")));
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
            MinValue = 0;
        }
        field(40; "Last CurrCalc Overhead Rate"; Decimal)
        {
            AutoFormatType = 2;
            CalcFormula = Lookup (Item."Overhead Rate" WHERE ("No." = FIELD ("Item No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(41; "Last CurrCost Scrap %"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
            MaxValue = 100;
            MinValue = 0;
        }
        field(42; "Last CurrCost Factor"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50; "UnitSingle-Lev Material Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            Editable = false;
        }
        field(51; "UnitSingle-Lev Capacity Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            Editable = false;
        }
        field(52; "UnitSingle-Lev Subcon. Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            Editable = false;
        }
        field(53; "UnitSingle-Lev Cap. Ovhd Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            Editable = false;
        }
        field(54; "UnitSingle-Lev Mfg. Ovhd Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            Editable = false;
        }
        field(56; "UnitRolled-up Material Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            DecimalPlaces = 2 : 5;
            Editable = false;
        }
        field(57; "UnitRolled-up Capacity Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            DecimalPlaces = 2 : 5;
            Editable = false;
        }
        field(58; "UnitRolled-up Subcontrd Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            Editable = false;
        }
        field(59; "UnitRolled-up Mfg. Ovhd Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            Editable = false;
        }
        field(60; "UnitRolled-up Cap. Overhd Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            Editable = false;
        }
        field(61; "Last UnitCost Calc. Lot Size"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(62; "Last UnitCost Calc BOM No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Production BOM Header";
        }
        field(63; "Last UnitCost Calc BOM Rev."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(64; "Last UnitCost Calc Router No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Routing Header";
        }
        field(65; "Last UnitCost Calc Router Rev."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(66; "Last UnitCost Calc Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(67; "Last UnitCost Action Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(68; "Last UnitCost Calc User ID"; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup";
        }
        field(69; "Standard Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(70; "Last UnitCost Indirect Cost %"; Decimal)
        {
            CalcFormula = Lookup (Item."Indirect Cost %" WHERE ("No." = FIELD ("Item No.")));
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
            MinValue = 0;
        }
        field(71; "Last UnitCost Overhead Rate"; Decimal)
        {
            AutoFormatType = 2;
            CalcFormula = Lookup (Item."Overhead Rate" WHERE ("No." = FIELD ("Item No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(72; "Last UnitCost Scrap %"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
            MaxValue = 100;
            MinValue = 0;
        }
        field(73; "Last UnitCost Factor"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(100; "New Indirect Cost %"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(101; "New Scrap %"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(102; "New Overhead Rate"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(103; "New Lot Size"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(104; "New Production BOM No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Production BOM Header";
        }
        field(105; "New Routing No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Routing Header";
        }
        field(106; "New Calculation Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(107; "New Cost Factor"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "New Cost Factor" < 0 then
                    Error(PMText000);
            end;
        }
        field(108; "Last Std. Cost Change"; Date)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Item No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        PMText000: Label 'Cost Factors must be greater then one.  1.2 would calculate a 20% increase.';
        NewCalcMultiLevel: Boolean;
        NewLotSize: Decimal;
        NewOverheadRate: Decimal;
        NewIndirectCostPercent: Decimal;
        NewScrapPercent: Decimal;
        NewCostFactor: Decimal;
        NewCalcDate: Date;
}

