pageextension 50704 PurchaseOrderSubform_PQ extends "Purchase Order Subform"
{

    layout
    {
        addafter("Unit of Measure Code")
        {
            field("QC Required"; Rec."CCS QC Required")
            {
                ToolTip = 'Indicates that Quality Control is required for items on this PO Line';
                Editable = false; //QC13.02 Added
                ApplicationArea = All;
            }
            field("Test No."; Rec."Test No.")
            {
                ApplicationArea = All;
                Caption = 'No. of Quality Tests';
                Visible = false;
                // Visible = VisibleTestNo;
            }
            field("No. of Quality Tests"; Rec."No. of Quality Tests")
            {
                ApplicationArea = All;
                Caption = 'No. of Quality Tests';
            }
        }
    }

}
