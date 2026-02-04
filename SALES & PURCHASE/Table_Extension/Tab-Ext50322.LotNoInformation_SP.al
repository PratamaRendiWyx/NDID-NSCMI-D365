tableextension 50322 LotNoInformation_SP extends "Lot No. Information"
{
    fields
    {
        field(50300; "USDFS Code"; Text[100])
        {
            trigger OnValidate()
            var
                myInt: Integer;
                UpdMgt: Codeunit "Event Subscriber Purch Mgt";
            begin
                if "USDFS Code" <> '' then begin
                    UpdMgt.updateUSDFSCodeonILE(Rec);
                end;
            end;
        }
    }
}
