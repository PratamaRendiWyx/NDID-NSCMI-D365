page 50743 CostChangeLog_PQ
{
    ApplicationArea = All;
    Caption = 'Cost Change Log';
    CardPageID = CostChangeLogCard_PQ;
    Editable = false;
    PageType = List;
    SourceTable = UnitandCurrCostCalcLog_PQ;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control14004561)
            {
                ShowCaption = false;
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'No. of the Item the Change Log applies to.';
                }
                field("Action Date"; Rec."Action Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Date the change occured.';
                }
                field("Calculation Date"; Rec."Calculation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Date used for the Calculation change.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Who requested the change.';
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
                field("Previous Std. Cost"; Rec."Previous Std. Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'What was the previous cost amount.';
                }
                field("Calcd or Entered Std. Cost"; Rec."Calcd or Entered Std. Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'The new standard cost for the Item.';
                }
                field("Item Card Lot Size"; Rec."Item Card Lot Size")
                {
                    ApplicationArea = All;
                    ToolTip = 'Base lot size from the Item.';
                }
                field("Current Cost Calc Lot Size"; Rec."Current Cost Calc Lot Size")
                {
                    ApplicationArea = All;
                    ToolTip = 'Lot size used to do the new calculation';
                }
                field("Calculated Current Cost"; Rec."Calculated Current Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'The new calculated Current Cost.';
                }
                field("Time of Day"; Rec."Time of Day")
                {
                    ApplicationArea = All;
                    ToolTip = 'What time was the calculation done';
                }
                field("Last UnitCost Calc BOM No."; Rec."Last UnitCost Calc BOM No.")
                {
                    ApplicationArea = All;
                }
                field("Last UnitCost Calc BOM Rev."; Rec."Last UnitCost Calc BOM Rev.")
                {
                    ApplicationArea = All;
                }
                field("Last UnitCost Calc Router No."; Rec."Last UnitCost Calc Router No.")
                {
                    ApplicationArea = All;
                }
                field("Last UnitCost Calc Router Rev."; Rec."Last UnitCost Calc Router Rev.")
                {
                    ApplicationArea = All;
                }
                field("Last CurrCost Calc BOM No."; Rec."Last CurrCost Calc BOM No.")
                {
                    ApplicationArea = All;
                }
                field("Last CurrCost Calc BOM Rev."; Rec."Last CurrCost Calc BOM Rev.")
                {
                    ApplicationArea = All;
                }
                field("Last CurrCost Calc Router No."; Rec."Last CurrCost Calc Router No.")
                {
                    ApplicationArea = All;
                }
                field("Last CurrCost Calc Router Rev."; Rec."Last CurrCost Calc Router Rev.")
                {
                    ApplicationArea = All;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Entry Card")
            {
                ApplicationArea = All;
                Caption = '&Entry Card';
                Image = Statistics;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page CostChangeLogCard_PQ;
                RunPageLink = "Entry No." = FIELD("Entry No.");
                ToolTip = 'Open Entry Card';
            }
            group("&Print")
            {
                Caption = '&Print';
                action("Print Cost Change Log")
                {
                    ApplicationArea = All;
                    Caption = 'All Cost Change Log';
                    Image = ChangeTo;
                    Promoted = true;
                    PromotedCategory = Process;
                    //RunObject = Report "AM Item Cost Re-Calc Log";
                    ToolTip = 'Print Item cost re-calc Log';
                }
                action("Print Cost Log for Standard Cost Change")
                {
                    ApplicationArea = All;
                    Caption = 'Cost Log for &Standard Cost Changes';
                    Promoted = true;
                    PromotedCategory = "Report";
                    ToolTip = 'Print Cost Log for Standard Cost Changes';

                    trigger OnAction()
                    begin
                        Rec.SetRange(Rec."Item No.", Rec."Item No.");
                        Rec.SetRange(Rec."Entry Type", Rec."Entry Type"::"Std Cost Calc");
                        //REPORT.Run(REPORT::"AM Item Cost Re-Calc Log", true, true, Rec);
                        Rec.SetRange(Rec."Item No.");
                        Rec.SetRange(Rec."Entry Type");
                    end;
                }
                action("Print Cost Log for Current Cost Changes")
                {
                    ApplicationArea = All;
                    Caption = 'Cost Log for &Current Cost Changes';
                    Promoted = true;
                    PromotedCategory = "Report";
                    ToolTip = 'Print Cost Log for Current Cost Changes';

                    trigger OnAction()
                    begin
                        Rec.SetRange(Rec."Item No.", Rec."Item No.");
                        Rec.SetRange(Rec."Entry Type", Rec."Entry Type"::"Current Cost Calc");
                        //REPORT.Run(REPORT::"AM Item Cost Re-Calc Log", true, true, Rec);
                        Rec.SetRange(Rec."Item No.");
                        Rec.SetRange(Rec."Entry Type");
                    end;
                }
                action("Print Cost Log for Std Cost Field Changes")
                {
                    ApplicationArea = All;
                    Caption = 'Cost Log for Std Cost &Field Changes';
                    Promoted = true;
                    PromotedCategory = "Report";
                    ToolTip = 'Print Cost Log for Standard Cost Field Changes';

                    trigger OnAction()
                    begin
                        Rec.SetRange(Rec."Item No.", Rec."Item No.");
                        Rec.SetRange(Rec."Entry Type", Rec."Entry Type"::"Std Cost Field Change");
                        //REPORT.Run(REPORT::"AM Item Cost Re-Calc Log", true, true, Rec);
                        Rec.SetRange(Rec."Item No.");
                        Rec.SetRange(Rec."Entry Type");
                    end;
                }
            }
        }
    }
}

