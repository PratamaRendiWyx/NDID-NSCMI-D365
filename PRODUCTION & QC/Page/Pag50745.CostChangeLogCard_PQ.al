page 50745 CostChangeLogCard_PQ
{

    Caption = 'Cost Change Log Card';
    PageType = Card;
    SourceTable = UnitandCurrCostCalcLog_PQ;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = false;
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Entry No. of the Cost Change';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Item affected by the cost change';
                }
                field("Action Date"; Rec."Action Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'When the cost change occured.';
                }
                field("Calculation Date"; Rec."Calculation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'As of Date used in cost calculations';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Who made the cost change';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'What type of cost was calculated.';
                }
                field("Calculation Method"; Rec."Calculation Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'How was the cost calculated.';
                }
                field("Time of Day"; Rec."Time of Day")
                {
                    ApplicationArea = All;
                    ToolTip = 'What time was the calculation done';
                }
                field("Indirect Cost %"; Rec."Indirect Cost %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Percent increase in cost for indirect cost';
                }
                field("Overhead Rate"; Rec."Overhead Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'How much overhead is applied to the Item cost';
                }
                field("Scrap %"; Rec."Scrap %")
                {
                    ApplicationArea = All;
                    ToolTip = 'how much scrap is associated with the Item';
                }
                field("Cost Factor"; Rec."Cost Factor")
                {
                    ApplicationArea = All;
                    ToolTip = 'What cost factor was used for cost calculation.';
                }
                fixed(Control14004556)
                {
                    ShowCaption = false;
                    group("Unit/Standard Cost")
                    {
                        Caption = 'Unit/Standard Cost';
                        field("Previous Std. Cost"; Rec."Previous Std. Cost")
                        {
                            ApplicationArea = All;
                            ToolTip = 'The Previous Standard Cost of the Item';
                        }
                        field("Calcd or Entered Std. Cost"; Rec."Calcd or Entered Std. Cost")
                        {
                            ApplicationArea = All;
                            ToolTip = 'The new standard cost of the item';
                        }
                        field("Item Card Lot Size"; Rec."Item Card Lot Size")
                        {
                            ApplicationArea = All;
                            Caption = 'Lot Size';
                            ToolTip = 'Lot size from the Item Card';
                        }
                        field("Last UnitCost Calc BOM No."; Rec."Last UnitCost Calc BOM No.")
                        {
                            ApplicationArea = All;
                            ToolTip = 'The BOM No. associated with previous Unit Cost Calculation';
                        }
                        field("Last UnitCost Calc BOM Rev."; Rec."Last UnitCost Calc BOM Rev.")
                        {
                            ApplicationArea = All;
                            ToolTip = 'The BOM Revision No. associated with previous Unit Cost Calculation';
                        }
                        field("Last UnitCost Calc Router No."; Rec."Last UnitCost Calc Router No.")
                        {
                            ApplicationArea = All;
                            ToolTip = 'The Routier No. associated with previous Unit Cost Calculation';
                        }
                        field("Last UnitCost Calc Router Rev."; Rec."Last UnitCost Calc Router Rev.")
                        {
                            ApplicationArea = All;
                            ToolTip = 'The Routier Revision No. associated with previous Unit Cost Calculation';
                        }
                    }
                    group("Current Cost")
                    {
                        Caption = 'Current Cost';
                        field(filler; filler)
                        {
                            ApplicationArea = All;
                            Visible = false;
                        }
                        field("Calculated Current Cost"; Rec."Calculated Current Cost")
                        {
                            ApplicationArea = All;
                            ToolTip = 'The Current Calculated Cost';
                        }
                        field("Current Cost Calc Lot Size"; Rec."Current Cost Calc Lot Size")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Lot Size to do Current Cost Calculation';
                        }
                        field("Last CurrCost Calc BOM No."; Rec."Last CurrCost Calc BOM No.")
                        {
                            ApplicationArea = All;
                            ToolTip = 'BOM used for the Current Cost Calculation';
                        }
                        field("Last CurrCost Calc BOM Rev."; Rec."Last CurrCost Calc BOM Rev.")
                        {
                            ApplicationArea = All;
                            ToolTip = 'BOM Revision used for the Current Cost Calculation';
                        }
                        field("Last CurrCost Calc Router No."; Rec."Last CurrCost Calc Router No.")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Router used for the Current Cost Calculation';
                        }
                        field("Last CurrCost Calc Router Rev."; Rec."Last CurrCost Calc Router Rev.")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Router Revision used for the Current Cost Calculation';
                        }
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        ClearAll;
    end;

    var
        filler: Text[1];
}

