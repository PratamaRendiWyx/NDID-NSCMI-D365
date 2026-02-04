pageextension 50308 ItemTrackingSummary_SP extends "Item Tracking Summary"
{
    layout
    {
        addafter("Package No.")
        {
            field("USDFS Code"; getUSDFCOde())
            {
                ApplicationArea = All;
            }
        }
    }

    local procedure getUSDFCOde(): Text
    var
        LotInformation: Record "Lot No. Information";
    begin
        LotInformation.Reset();
        LotInformation.SetRange("Item No.", Rec."Item No.");
        LotInformation.SetRange("Lot No.", Rec."Lot No.");
        if LotInformation.Find('-') then
            exit(LotInformation."USDFS Code");
        exit('');
    end;


}
