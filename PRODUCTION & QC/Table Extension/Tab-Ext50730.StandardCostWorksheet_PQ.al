tableextension 50730 StandardCostWorksheet_PQ extends "Standard Cost Worksheet"
{

    fields
    {
        field(50700; "Current Unit Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Item Cost Stats';
            Description = 'MP6 - see caption';
            Editable = false;
        }
        field(50701; "Qty. On Hand"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty. On Hand';
            Description = 'MP6';
            Editable = false;
        }
    }
}