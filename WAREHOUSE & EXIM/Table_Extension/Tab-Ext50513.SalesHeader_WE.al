tableextension 50513 SalesHeader_WE extends "Sales Header"
{
    fields
    {
        field(50500; "Packing No."; Code[150])
        {
            // TableRelation = "Pack. Header"."No.";
        } 
    } 
}