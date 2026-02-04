codeunit 50712 "Pop-up Cards"
{
    //#1 Purchase Order Card => Trigger is in pageextension 50505
    procedure OpenPurchaseOrderCard(RecCount: Integer; Rec: Record "Purchase Header") res: Boolean
    var
        PurchaseOrderCardPage: Page "Purchase Order";
    begin
        if RecCount = 1 then begin
            PurchaseOrderCardPage.SetRecord(Rec);
            PurchaseOrderCardPage.Run();
            exit(true);
        end;
    end;

    procedure OpenProdOrderCard(RecCount: Integer; Rec: Record "Production Order") res: Boolean
    var
        FirmPLanned: Page "Firm Planned Prod. Order";
        ReleaseProd: Page "Released Production Order";
        FinishProd: Page "Finished Production Order";
        PlannedProd: Page "Planned Production Order";
    begin
        case Rec.Status of
            Rec.Status::"Firm Planned":
                begin
                    FirmPLanned.SetRecord(Rec);
                    FirmPLanned.Run();
                end;
            Rec.Status::Released:
                begin
                    ReleaseProd.SetRecord(Rec);
                    ReleaseProd.Run();
                end;
            Rec.Status::Finished:
                begin
                    FinishProd.SetRecord(Rec);
                    FinishProd.Run();
                end;
            else begin
                PlannedProd.SetRecord(Rec);
                PlannedProd.Run();
            end;
        end;
    end;
}

