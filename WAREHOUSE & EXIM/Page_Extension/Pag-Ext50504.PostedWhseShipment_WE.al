pageextension 50504 PostedWhseShipment_WE extends "Posted Whse. Shipment"
{
    layout
    {
        addafter("External Document No.")
        {
            //Additional information 
            field("Prepared By"; Rec."Prepared By")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Prepared By Name"; Rec."Prepared By Name")
            {
                ApplicationArea = All;
                Enabled = false;
            }
            field("Checked By"; Rec."Checked By")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Checked By Name"; Rec."Checked By Name")
            {
                ApplicationArea = All;
                Enabled = false;
            }
            field("Warehouse Person"; Rec."Warehouse Person")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Warehouse Person Name"; Rec."Warehouse Person Name")
            {
                ApplicationArea = All;
                Enabled = false;
            }
            //-
        }
    }
}
