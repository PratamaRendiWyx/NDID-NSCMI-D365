page 50764 "Find Show Document Prod. Order"
{
    ApplicationArea = All;
    Caption = 'Find & Show Document Prod. Order';
    PageType = StandardDialog;

    layout
    {
        area(Content)
        {
            field(glbProdOrderNo; glbProdOrderNo)
            {
                ApplicationArea = All;
                Caption = 'No.';
                ExtendedDatatype = Barcode;
                trigger OnValidate()
                var
                    myInt: Integer;
                    ProductionOrder: Record "Production Order";
                begin
                    Clear(ProductionOrder);
                    ProductionOrder.SetRange("No.", glbProdOrderNo);
                    if ProductionOrder.Find('-') then begin
                        //initiate order
                        Clear(glbProdOrder);
                        glbProdOrder.Reset();
                        glbProdOrder.Copy(ProductionOrder);
                        //-
                        Clear(PopupCard);
                        PopupCard.OpenProdOrderCard(1, ProductionOrder);
                    end else begin
                        Error('Production Order does not exists.');
                    end;
                end;
            }
        }
    }

    procedure getProdOrder(): Record "Production Order"
    begin
        exit(glbProdOrder);
    end;

    var
        glbProdOrderNo: Code[20];
        PopupCard: Codeunit "Pop-up Cards";
        glbProdOrder: Record "Production Order";
}
