pageextension 50317 SalesQuoteSubform_SP extends "Sales Quote Subform"
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
        addbefore(Quantity)
        {
            field(Remarks; Rec.Remarks)
            {
                ApplicationArea = All;
            }
        }
        addafter(Description)
        {
            field("Part Number"; Rec."Part Number")
            {
                ApplicationArea = All;
            }
            field("Part Name"; Rec."Part Name")
            {
                ApplicationArea = All;
            }
        }
    }
}
