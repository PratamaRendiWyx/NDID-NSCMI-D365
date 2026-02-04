pageextension 50102 ItemCard_FT extends "Item Card"
{
    layout
    {

        modify(Warehouse)
        {
            Visible = false;
        }

/*      modify(ReorderPointParameters)
        {
            Visible = false;
        } */

        modify(Replenishment_Assembly)
        {
            Visible = false;
        }
        addafter("VAT Prod. Posting Group")
        {
            field("WHT Product Posting Group"; Rec."WHT Product Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a WHT Product posting group.';
            }
        }

        modify("Common Item No.")
        {
            Caption = 'Part No.';
        }

        modify ("Description 2")
        {
            Caption = 'Part Name';
        }

        addafter("No.")
        {
            field("Reff. No.";Rec."Reff. No.")
            {
                ApplicationArea = All;
            }
        }
        
    }
}