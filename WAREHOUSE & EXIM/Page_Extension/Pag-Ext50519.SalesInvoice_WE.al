pageextension 50519 SalesInvoice_WE extends "Sales Invoice"
{
    layout
    {
        addafter("Your Reference")
        {
            field("Packing No."; Rec."Packing No.")
            {
                ApplicationArea = All;
                trigger OnLookup(var Text: Text): Boolean
                var
                    myInt: Integer;
                    Packheader: Record "Pack. Header";
                    PackShpList: page "Packing Shipments List";
                begin
                    Clear(Packheader);
                    Clear(PackShpList);
                    PackShpList.SetRecord(Packheader);
                    PackShpList.SetTableView(Packheader);
                    PackShpList.LookupMode := true;
                    if PackShpList.RunModal() = Action::LookupOK then begin
                        PackShpList.SetSelectionFilter(Packheader);
                        if Packheader.FindSet() then
                            repeat
                                if StrPos(Rec."Packing No.", Packheader."No.") = 0 then begin
                                    if Rec."Packing No." <> '' then
                                        Rec."Packing No." += '|';
                                    Rec."Packing No." += Packheader."No.";
                                end;
                            until Packheader.Next() = 0;
                    end;
                end;
            }
        }
    }
}
