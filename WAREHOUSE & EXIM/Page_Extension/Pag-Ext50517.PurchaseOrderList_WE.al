pageextension 50517 PurchaseOrderList_WE extends "Purchase Order List"
{
    actions
    {
        modify(Post)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                Rec.TestField("Vendor Shipment No.");
                Rec.TestField("Document Status");
            end;

            trigger OnAfterAction()
            var
                myInt: Integer;
                PurchaseHeader: Record "Purchase Header";
            begin
                Clear(PurchaseHeader);
                PurchaseHeader.Reset();
                PurchaseHeader.SetRange("No.", Rec."No.");
                PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
                PurchaseHeader.SetAutoCalcFields("Completely Received");
                if PurchaseHeader.FindSet() then begin
                    if Not PurchaseHeader."Completely Received" then begin
                        Rec."Vendor Shipment No." := '';
                        Rec."Document Status" := Rec."Document Status"::" ";
                        Rec.Modify();
                    end;
                end;
            end;
        }
        modify(PostAndPrint)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                Rec.TestField("Vendor Shipment No.");
                Rec.TestField("Document Status");
            end;
        }
        modify(PostBatch)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                Rec.TestField("Vendor Shipment No.");
                Rec.TestField("Document Status");
            end;
        }
    }
}
