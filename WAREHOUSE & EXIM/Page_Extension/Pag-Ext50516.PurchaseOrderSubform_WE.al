pageextension 50516 PurchaseOrderSubform_WE extends "Purchase Order Subform"
{
    layout
    {
        modify("Qty. to Receive")
        {
            trigger OnBeforeValidate()
            var
                myInt: Integer;
                UserSetup: Record "User Setup";
            begin
                if UserSetup.Get(UserId) then begin
                    if not UserSetup."Allow Update Qty. to Receive" then
                        Error('You are not allowed to update Qty. to receive');
                end else begin
                    Error('You are not allowed to update Qty. to receive.');
                end;
            end;

            trigger OnAfterValidate()
            var
                myInt: Integer;
                PurchaseHeader: Record "Purchase Header";
            begin
                if not Rec."Completely Received" then begin
                    Clear(PurchaseHeader);
                    PurchaseHeader.Reset();
                    PurchaseHeader.SetRange("No.", Rec."Document No.");
                    if PurchaseHeader.FindSet() then begin
                        PurchaseHeader."Vendor Shipment No." := '';
                        PurchaseHeader."Document Status" := PurchaseHeader."Document Status"::" ";
                        PurchaseHeader.Modify();
                    end;
                end;
            end;
        }
    }
}
