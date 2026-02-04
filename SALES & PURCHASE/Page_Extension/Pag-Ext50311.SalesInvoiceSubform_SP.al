pageextension 50311 SalesInvoiceSubform_SP extends "Sales Invoice Subform"
{

    layout
    {
        modify("No.")
        {
            trigger OnBeforeValidate()
            var
                myInt: Integer;
                Item: Record Item;
            begin
                if Rec.Type = Rec.Type::Item then begin
                    Clear(Item);
                    if Item.Get(Rec."No.") then begin
                        Rec."Part Name" := Item."Description 2";
                        Rec."Part Number" := Item."Common Item No.";
                    end;
                end;
            end;
        }
        addafter(Description)
        {
            field("Part Number"; Rec."Part Number")
            {
                ApplicationArea = All;
                // Editable = false;
            }
            field("Part Name"; Rec."Part Name")
            {
                ApplicationArea = All;
                // Editable = false;
            }
        }

        addafter("Line Amount")
        {
            field("Cust. PO No."; Rec."Cust. PO No.")
            {
                ApplicationArea = All;
            }
        }
    }

}