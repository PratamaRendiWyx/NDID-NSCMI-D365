pageextension 50300 SalesReceivablesSetup_SP extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(General)
        {
            field("Enable Finish Orders";Rec."Enable Finish Orders")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies if a sales order (or one of its lines) can be finished.';
            }
        }

        addafter("Invoice Nos.")
        {
            field("Invoice Nos. (Export)"; Rec."Invoice Nos. (Export)")
            {
                ApplicationArea = All;
            }
            field("Invoice Nos. (Others)"; Rec."Invoice Nos. (Others)")
            {
                ApplicationArea = All;
            }
        }

          addafter("Calc. Inv. Discount")
        {
            field("HS Code"; Rec."HS Code")
            {
                ApplicationArea = All;
            }
            field("USCI No"; Rec."USCI No")
            {
                ApplicationArea = All;
            }
        }

         addafter(General)
        {
            group(QItemAttr)
            {
                Caption = 'Quotation Attribute Setup';
                field("Honey Comb Diameter"; Rec."Honey Comb Diameter")
                {
                    ApplicationArea = All;
                    TableRelation = "Item Attribute".Name where(Blocked = const(false));
                }
                field("Honey Comb Length"; Rec."Honey Comb Length")
                {
                    ApplicationArea = All;
                    TableRelation = "Item Attribute".Name where(Blocked = const(false));
                }
                field("Honey Comb Thickness"; Rec."Honey Comb Thickness")
                {
                    ApplicationArea = All;
                    TableRelation = "Item Attribute".Name where(Blocked = const(false));
                }
                field(CPSI; Rec.CPSI)
                {
                    ApplicationArea = All;
                    TableRelation = "Item Attribute".Name where(Blocked = const(false));
                }
                field("Mantle Diameter"; Rec."Mantle Diameter")
                {
                    ApplicationArea = All;
                    TableRelation = "Item Attribute".Name where(Blocked = const(false));
                }
                field("Mantle Length"; Rec."Mantle Length")
                {
                    ApplicationArea = All;
                    TableRelation = "Item Attribute".Name where(Blocked = const(false));
                }
                field("Spec Standard/HI"; Rec."Spec Standard/HI")
                {
                    ApplicationArea = All;
                    TableRelation = "Item Attribute".Name where(Blocked = const(false));
                }
            }
        }
    }
}