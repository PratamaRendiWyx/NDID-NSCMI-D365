reportextension 50100 CalculatePlanWksh_FT extends "Calculate Plan - Plan. Wksh."
{
    dataset
    {
        // Add new columns to the dataset here
        modify(Item)
        {
            RequestFilterFields = "No.", "Item Category Code";
            
        }
    }
}