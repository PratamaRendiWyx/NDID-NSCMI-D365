pageextension 50343 "Posted Sales Invoice Lines SP" extends "Posted Sales Invoice Lines"
{
    layout
    {
        addafter("Sell-to Customer No.")
        {
            field("Customer Name"; Rec."Customer Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}
