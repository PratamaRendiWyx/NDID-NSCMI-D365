pageextension 50301 PurchasesPayablesSetup_SP extends "Purchases & Payables Setup"
{
    layout
    {
        addlast(General)
        {
            field("Enable Finish Orders"; Rec."Enable Finish Orders")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies if a purchase order (or one of its lines) can be finished.', comment = 'ESP="Especifica si un pedido de compra (o una de sus líneas) puede ser terminado."';
            }
        }
        addafter("Return Order Nos.")
        {
            field("Posted Sub Cont. Nos."; Rec."Posted Sub Cont. Nos.")
            {
                ApplicationArea = All;
            }
        }
    }
}