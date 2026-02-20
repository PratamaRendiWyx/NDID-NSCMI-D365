tableextension 50316 TrackingSpecification_SP extends "Tracking Specification"
{
    fields
    {
        field(50300; "Shipping Mark No."; Code[20])
        {
            Caption = 'Shipping Mark No.';
        }
        field(50301; "Box Qty."; Decimal)
        {

        }
        field(50302; "USDFS Code"; Text[100])
        {

        }
        modify("Lot No.")
        {
            trigger OnBeforeValidate()
            var
                myInt: Integer;
                LotInformation: Record "Lot No. Information";
            begin
                if "Lot No." <> '' then begin
                    LotInformation.SetRange("Lot No.", "Lot No.");
                    LotInformation.SetRange("Item No.", "Item No.");
                    if LotInformation.FindFirst() then
                        Rec."USDFS Code" := LotInformation."USDFS Code";
                end;
            end;
        }
    }
}
