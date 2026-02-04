pageextension 50315 PriceListLines_SP extends "Price List Lines"
{
    layout
    {
        addafter(Description)
        {
            field("OEM Type"; Rec."OEM Type")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}
