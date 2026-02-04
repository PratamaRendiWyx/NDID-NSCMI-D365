pageextension 50347 "User Setup_SP" extends "User Setup"
{
    layout
    {
        addafter("Allow VAT To")
        {
            field("QC Worker"; Rec."QC Worker")
            {
                ApplicationArea = All;
            }
            field("Is Approver COA"; Rec."Is Approver COA")
            {
                ApplicationArea = All;
            }
            field("Re-Open Shipment Line"; Rec."Re-Open Shipment Line")
            {
                ApplicationArea = All;
            }
        }
    }
}
