pageextension 50313 ItemBudgetEntries_SP extends "Item Budget Entries"
{
    layout
    {
        // Add changes to page layout here

        modify("Budget Dimension 1 Code")
        {
            Visible = true;
        }
        modify("Budget Dimension 2 Code")
        {
            Visible = true;
        }
        modify("Budget Dimension 3 Code")
        {
            Visible = true;
        }
    }
    
    actions
    {
        // Add changes to page actions here
    }
    
    var
        myInt: Integer;
}