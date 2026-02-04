pageextension 50121 ItemList_FT extends "Item List"
{
    layout
    {
        // Add changes to page layout here

        modify("Inventory Posting Group")
        {
            Caption = 'Item Type';
        }

        addafter("No.")
        {
            field("Reff. No.";Rec."Reff. No.")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

}