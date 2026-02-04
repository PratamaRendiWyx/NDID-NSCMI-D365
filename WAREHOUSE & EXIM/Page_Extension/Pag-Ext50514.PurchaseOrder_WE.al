pageextension 50514 PurchaseOrder_WE extends "Purchase Order"
{
    layout
    {
/*         addafter(Status)
        {
             field("Document Status"; Rec."Document Status")
            {
                ApplicationArea = All;
                BlankZero = true;
                ShowMandatory = true;
                trigger OnValidate()
                var
                    myInt: Integer;
                begin
                    if not checkLocationNonStock() then begin
                        if Rec."Document Status" <> Rec."Document Status"::" " then
                            Rec.TestField("Vendor Shipment No.");
                    end;
                end;
            } 
        } */
        modify("Vendor Shipment No.")
        {
            ShowMandatory = true;
        }
    }
    actions
    {
        modify(Post)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                if not checkLocationNonStock() then begin
                    Rec.TestField("Vendor Shipment No.");
                    /* Rec.TestField("Document Status"); */
                end;
            end;
        }
        modify("Post and &Print")
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                if not checkLocationNonStock() then begin
                    Rec.TestField("Vendor Shipment No.");
                   /*  Rec.TestField("Document Status"); */
                end;
            end;
        }
        modify("Post &Batch")
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                if not checkLocationNonStock() then begin
                    Rec.TestField("Vendor Shipment No.");
                    /* Rec.TestField("Document Status"); */
                end;
            end;
        }
    }
    local procedure checkLocationNonStock(): Boolean
    begin
        if Rec."Location Code" = 'NON STOCK' then
            exit(true);
        exit(false);
    end;
}
