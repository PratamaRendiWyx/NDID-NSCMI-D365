pageextension 50344 "Posted Sales Shipment - Update" extends "Posted Sales Shipment - Update"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Prepared By"; Rec."Prepared By")
            {
                ApplicationArea = All;
                TableRelation = Employee."No.";
            }
            field("Prepared By Name"; Rec."Prepared By Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Checked By"; Rec."Checked By")
            {
                ApplicationArea = All;
                TableRelation = Employee."No.";
            }
            field("Checked By Name"; Rec."Checked By Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Warehouse Person"; Rec."Warehouse Person")
            {
                ApplicationArea = All;
                TableRelation = Employee."No.";
            }
            field("Warehouse Person Name"; Rec."Warehouse Person Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Trucking No."; Rec."Trucking No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
