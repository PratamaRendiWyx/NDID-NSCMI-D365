pageextension 50321 CustomerCard_SP extends "Customer Card"
{
    layout
    {
        modify("Shipment Method Code")
        {
            Caption = 'Incoterms';
        }

        addafter("Preferred Bank Account Code")
        {
            field("Receiving Bank Account"; Rec."Receiving Bank Account")
            {
                ApplicationArea = All;
            }
            field("Receiving Bank Name"; Rec."Receiving Bank Name")
            {
                ApplicationArea = All;
                Enabled = false;
                Editable = false;
            }
        }
    }
}
