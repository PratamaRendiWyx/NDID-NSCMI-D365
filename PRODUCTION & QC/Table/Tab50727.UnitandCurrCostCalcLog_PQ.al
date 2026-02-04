table 50727 UnitandCurrCostCalcLog_PQ
{

    //     Added a new Entry Type Option called "Mass Update" for
    //     when costs are changed by the new batch Report that calculates
    //     cost on a global basis

    Caption = 'Unit and Current Cost Calc Log';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(2; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            NotBlank = true;
            TableRelation = Item;
        }
        field(3; "Action Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Calculation Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(6; "User ID"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(7; "Entry Type"; Option)
        {
            DataClassification = CustomerContent;
            Description = 'Std Cost Calc,Current Cost Calc,Std Cost Field Change';
            OptionMembers = "Std Cost Calc","Current Cost Calc","Std Cost Field Change","Mass Update";
        }
        field(8; "Calculation Method"; Option)
        {
            DataClassification = CustomerContent;
            Description = ' ,Single Level,Rolled-up Cost';
            OptionMembers = " ","Single Level","Rolled-up Cost";
        }
        field(9; "Previous Std. Cost"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Calcd or Entered Std. Cost"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(11; "Item Card Lot Size"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Current Cost Calc Lot Size"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(13; "Calculated Current Cost"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(20; "Time of Day"; Time)
        {
            DataClassification = CustomerContent;
        }
        field(30; "Last UnitCost Calc BOM No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Production BOM Header";
        }
        field(31; "Last UnitCost Calc BOM Rev."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(32; "Last UnitCost Calc Router No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Routing Header";
        }
        field(33; "Last UnitCost Calc Router Rev."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(40; "Last CurrCost Calc BOM No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Production BOM Header";
        }
        field(41; "Last CurrCost Calc BOM Rev."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(42; "Last CurrCost Calc Router No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Routing Header";
        }
        field(43; "Last CurrCost Calc Router Rev."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50; "Indirect Cost %"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51; "Scrap %"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(52; "Overhead Rate"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(53; "Cost Factor"; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "Item No.", "Action Date")
        {
        }
    }

    fieldgroups
    {
    }
}

