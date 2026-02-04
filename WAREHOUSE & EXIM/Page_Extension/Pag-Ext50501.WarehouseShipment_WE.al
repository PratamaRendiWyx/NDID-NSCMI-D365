pageextension 50501 WarehouseShipment_WE extends "Warehouse Shipment"
{
    layout
    {
        // Add changes to page layout here

        modify(Shipping)
        {
            Visible = false;
        }
        addafter(Status)
        {
            field("Completely Packing"; Rec."Completely Packing")
            {
                ApplicationArea = Warehouse;
                Editable = false;
            }
            field("Completely Shipping Mark"; Rec."Completely Shipping Mark")
            {
                ApplicationArea = Warehouse;
                Editable = false;
            }
        }

        addafter("Document Status")
        {
            field("Whse. Sales Type"; Rec."Whse. Sales Type")
            {
                ApplicationArea = All;
                Caption = 'Shipment Type';

            }
            field("Trucking No."; Rec."Trucking No.")
            {
                ApplicationArea = All;
            }
            //Additional information 
            field("Prepared By"; Rec."Prepared By")
            {
                ApplicationArea = All;
            }
            field("Prepared By Name"; Rec."Prepared By Name")
            {
                ApplicationArea = All;
                Enabled = false;
            }
            field("Checked By"; Rec."Checked By")
            {
                ApplicationArea = All;
            }
            field("Checked By Name"; Rec."Checked By Name")
            {
                ApplicationArea = All;
                Enabled = false;
            }
            field("Warehouse Person"; Rec."Warehouse Person")
            {
                ApplicationArea = All;
            }
            field("Warehouse Person Name"; Rec."Warehouse Person Name")
            {
                ApplicationArea = All;
                Enabled = false;
            }
            //-
        }
    }

    var
    //myInt: Integer;
}