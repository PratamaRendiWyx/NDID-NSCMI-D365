tableextension 50115 SalesCue_FT extends "Sales Cue"

{
    fields
    {   

        //Add by CS
        field(50200; "Sales This Month"; Decimal )
        {
            Caption = 'Sales This Month';
            DecimalPlaces = 0 : 0;
            DataClassification = ToBeClassified;
        }
    
        field(50205; "Overdue Sales Invoice Amount"; Decimal)
        {
            Caption = 'Overdue Sales Invoice Amount';
            DecimalPlaces = 0 : 0;
            DataClassification = ToBeClassified;
        }
    }
}
