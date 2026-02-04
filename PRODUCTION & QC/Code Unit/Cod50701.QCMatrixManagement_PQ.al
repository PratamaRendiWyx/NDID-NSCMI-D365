codeunit 50701 QCMatrixManagement_PQ
{
    // version QC3.7

    // NP1.1
    //   - Increased "ID" variable Length to 50

    Permissions = TableData Item = r,
                  TableData "Production BOM Header" = r,
                  TableData "Production BOM Version" = r,
                  TableData "Production Matrix BOM Line" = rimd,
                  TableData "Production Matrix  BOM Entry" = rimd;

    trigger OnRun();
    begin
    end;

    var
        Item: Record Item;
        ItemAssembly: Record Item;
        ProdBOMHeader: Record "Production BOM Header";
        QCSpecHeader: Record QCSpecificationHeader_PQ;
        ProdBOMVersion: Record "Production BOM Version";
        QCSpecVersion: Record QCSpecificationVersions_PQ;
        ProdBOMVersion2: Record "Production BOM Version";
        QCSpecVersion2: Record QCSpecificationVersions_PQ;
        ComponentList: Record "Production Matrix BOM Line" temporary;
        MeasuresList: Record QCMatrixSpecLine_PQ temporary;
        ComponentEntry: Record "Production Matrix  BOM Entry" temporary;
        MeasuresEntry: Record QCMatrixSpecEntry_PQ temporary;
        ComponentEntry2: Record "Production Matrix  BOM Entry";
        MeasuresEntry2: Record QCMatrixSpecEntry_PQ;
        UOMMgt: Codeunit "Unit of Measure Management";
        VersionMgt: Codeunit VersionManagement;
        QCVersionMgt: Codeunit QCFunctionLibrary_PQ;
        GlobalCalcDate: Date;
        MatrixType: Option Version,Item;
        MultiLevel: Boolean;
        MeasuresListT: Record QCMatrixSpecLine_PQ;

    procedure FindRecord(Which: Text[30]; var QCMeasuresList2: Record QCMatrixSpecLine_PQ): Boolean;
    begin
        MeasuresList := QCMeasuresList2;
        if not MeasuresList.FIND(Which) then
            exit(false);
        QCMeasuresList2 := MeasuresList;
        exit(true);
    end;

    procedure NextRecord(Steps: Integer; var QCMeasuresList2: Record QCMatrixSpecLine_PQ): Integer;
    var
        CurrentSteps: Integer;
    begin
        MeasuresList := QCMeasuresList2;
        CurrentSteps := MeasuresList.NEXT(Steps);
        if CurrentSteps <> 0 then
            QCMeasuresList2 := MeasuresList;
        exit(CurrentSteps);
    end;

    procedure GetComponentNeed(ItemNo: Code[20]; CustNo: Code[20]; Type: Code[20]; Measure: Code[20]; ID: Code[50]): Decimal;
    begin
        MeasuresEntry.SETRANGE("Item No.", ItemNo);
        MeasuresEntry.SETRANGE("Customer No.", CustNo);
        MeasuresEntry.SETRANGE(Type, Type);
        //MeasuresEntry.SETRANGE("Variant Code",VariantCode);
        MeasuresEntry.SETRANGE("Measure Code", Measure);
        MeasuresEntry.SETRANGE(ID, ID);
        if MeasuresEntry.FIND('-') then
            if not MeasuresEntry.FIND('-') then begin
                exit(0);
                //CLEAR(MeasuresEntry);
            end else
                exit(MeasuresEntry.Quantity);
    end;

    procedure CompareTwoItems(Item1: Record Item; Item2: Record Item; Cust1: Record Customer; Cust2: Record Customer; Type1: Code[20]; Type2: Code[20]; "Calc.Date": Date; NewMultiLevel: Boolean; var VersionCode1: Code[10]; var VersionCode2: Code[10]; var UnitOfMeasure1: Code[10]; var UnitOfMeasure2: Code[10]);
    begin
        MeasuresList.DELETEALL;
        MeasuresEntry.RESET;
        MeasuresEntry.DELETEALL;

        MultiLevel := NewMultiLevel;
        MatrixType := MatrixType::Item;

        VersionCode1 :=
          QCVersionMgt.GetQCVersion(
            Item1."No.", Cust1."No.", Type1,
            WORKDATE, 1);
        /*
        UnitOfMeasure1 :=
          VersionMgt.GetBOMUnitOfMeasure(
            Item1."Production BOM No.",VersionCode1);
        */

        ItemAssembly := Item1;
        BuildMatrix(
          Item1."No.", Cust1."No.", Type1,
          VersionCode1, 1, 1);

        VersionCode2 :=
          QCVersionMgt.GetQCVersion(
            Item2."No.", Cust2."No.", Type2,
            WORKDATE, 1);

        /*
        UnitOfMeasure2 :=
          VersionMgt.GetBOMUnitOfMeasure(
            Item2."Production BOM No.",VersionCode2);
         */

        ItemAssembly := Item2;
        BuildMatrix(
          Item2."No.", Cust2."No.", Type2,
          VersionCode2, 1, 1);

    end;

    procedure BOMMatrixFromBOM(QCSpecH: Record QCSpecificationHeader_PQ; NewMultiLevel: Boolean);
    begin
        MeasuresList.DELETEALL;
        MeasuresEntry.RESET;
        MeasuresEntry.DELETEALL;

        MultiLevel := NewMultiLevel;
        MatrixType := MatrixType::Version;
        BuildMatrix(QCSpecH."Item No.", '', '', '', 1, 1);
        QCSpecVersion.SETRANGE("Item No.", QCSpecH."Item No.");
        QCSpecVersion.SETRANGE("Customer No.", QCSpecH."Customer No.");
        QCSpecVersion.SETRANGE(Type, QCSpecH.Type);
        if QCSpecVersion.FIND('-') then
            repeat
                BuildMatrix(QCSpecH."Item No.", QCSpecH."Customer No.", QCSpecH.Type, QCSpecVersion."Version Code", 1, 1);
            until QCSpecVersion.NEXT = 0;
    end;

    local procedure BuildMatrix(ItemNo: Code[20]; CustNo: Code[20]; Type: Code[20]; VersionCode: Code[20]; Level: Integer; Quantity: Decimal);
    var
        QCSpecMeasures: Record QCSpecificationLine_PQ;
        QCBaseLines: Record QCSpecificationLine_PQ;
        QCSpecL: Record QCSpecificationLine_PQ;
    begin
        if Level > 20 then
            exit;

        QCSpecMeasures.SETRANGE("Item No.", ItemNo);
        QCSpecMeasures.SETRANGE("Customer No.", CustNo);
        QCSpecMeasures.SETRANGE(Type, Type);
        QCSpecMeasures.SETRANGE("Version Code", VersionCode);
        if QCSpecMeasures.FIND('-') then
            repeat
                if Item.GET(QCSpecMeasures."Item No.") then begin
                    MeasuresList."Base Measure" := false;
                    MeasuresList."Item No." := QCSpecMeasures."Item No.";
                    MeasuresList."Customer No." := QCSpecMeasures."Customer No.";
                    MeasuresList.Type := QCSpecMeasures.Type;
                    MeasuresList."Measure Code" := QCSpecMeasures."Quality Measure";
                    //MeasuresList."Variant Code" := QCSpecMeasures."Variant Code";
                    MeasuresList.Description := QCSpecMeasures."Measure Description";
                    MeasuresList."Unit of Measure Code" := QCSpecMeasures."Testing UOM";
                    QCBaseLines.SETRANGE("Item No.", QCSpecMeasures."Item No.");
                    QCBaseLines.SETRANGE("Customer No.", QCSpecMeasures."Customer No.");
                    QCBaseLines.SETRANGE(Type, '');
                    QCBaseLines.SETRANGE("Version Code", '');
                    QCBaseLines.SETRANGE("Quality Measure", QCSpecMeasures."Quality Measure");
                    if QCBaseLines.FIND('-') then begin
                        MeasuresList."Base Measure" := true;
                        MeasuresList."Nominal Value" := QCBaseLines."Nominal Value";
                    end else
                        MeasuresList."Nominal Value" := 0;  //**

                    //MeasuresListT.SETRANGE("Item No.",QCSpecMeasures."Item No.");
                    //MeasuresListT.SETRANGE("Customer No.",QCSpecMeasures."Customer No.");
                    //MeasuresListT.SETRANGE(Type,QCSpecMeasures.Type);
                    //MeasuresListT.SETRANGE("Measure Code",QCSpecMeasures."Quality Measure");
                    if not MeasuresList.FIND then
                        MeasuresList.INSERT;

                    MeasuresEntry2."Item No." := QCSpecMeasures."Item No.";
                    MeasuresEntry2."Customer No." := QCSpecMeasures."Customer No.";
                    MeasuresEntry2.Type := QCSpecMeasures.Type;
                    MeasuresEntry2."Measure Code" := QCSpecMeasures."Quality Measure";
                    //MeasuresEntry2."Variant Code" := QCSpecMeasures."Variant Code";
                    case MatrixType of
                        MatrixType::Version:
                            MeasuresEntry2.ID := QCSpecVersion."Version Code";
                        MatrixType::Item:
                            MeasuresEntry2.ID := ItemAssembly."No.";
                    end;

                    MeasuresEntry2.Quantity := QCSpecMeasures."Nominal Value";
                    /*
                    MeasuresEntry2.Quantity :=
                      QCSpecMeasures.Quantity *
                      UOMMgt.GetQtyPerUnitOfMeasure(Item,QCSpecMeasures."Testing UOM") /
                      UOMMgt.GetQtyPerUnitOfMeasure(Item,Item."Base Unit of Measure") *
                      Quantity;
                    */
                    MeasuresEntry := MeasuresEntry2;
                    MeasuresEntry.SETRANGE("Item No.", MeasuresEntry2."Item No.");
                    MeasuresEntry.SETRANGE("Customer No.", MeasuresEntry2."Customer No.");
                    MeasuresEntry.SETRANGE(Type, MeasuresEntry2.Type);
                    MeasuresEntry.SETRANGE(ID, MeasuresEntry2.ID);
                    MeasuresEntry.SETRANGE("Measure Code", MeasuresEntry2."Measure Code");
                    //MeasuresEntry.SETRANGE("Variant Code",MeasuresEntry2."Variant Code");
                    if MeasuresEntry.FIND('-') then begin
                        MeasuresEntry.Quantity :=
                          MeasuresEntry.Quantity + MeasuresEntry2.Quantity;
                        MeasuresEntry.MODIFY;

                    end else
                        MeasuresEntry.INSERT;
                end;
            until QCSpecMeasures.NEXT = 0;

    end;

    local procedure GetVersion(ItemNo: Code[20]; CustomerNo: Code[20]; Type: Code[20]): Code[10];
    begin
        QCSpecVersion2.SETRANGE("Item No.", ItemNo);
        QCSpecVersion2.SETRANGE("Customer No.", CustomerNo);
        QCSpecVersion2.SETRANGE(Type, Type);
        QCSpecVersion2.SETFILTER("Effective Date", '%1|..%2', 0D, QCSpecVersion."Effective Date");
        if QCSpecVersion2.FIND('+') then
            exit(QCSpecVersion2."Version Code");

        exit('');
    end;
}

