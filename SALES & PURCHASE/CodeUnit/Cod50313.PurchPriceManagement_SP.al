codeunit 50313 PurchasePriceManagement_SP
{
    procedure importPurchPrice(iPurchPriceCode: Text)
    var
        RowNo: Integer;
        ColNo: Integer;
        LineNo: Integer;
        MaxRowNo: Integer;
        PurchPriceLine: Record "Price List Line";
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        RowNo := 0;
        ColNo := 0;
        MaxRowNo := 0;
        LineNo := 0;
        ReadExcelSheet();

        if TempExcelBuffer.FindLast() then begin
            MaxRowNo := TempExcelBuffer."Row No.";
        end;

        if not Confirm('Are you sure want to import data Excel?') then
            exit;

        Clear(PurchPriceLine);
        LineNo := getMaxBudgetEntryNo(iPurchPriceCode) + 1000;
        for RowNo := 2 to MaxRowNo do begin
            // GetValueAtCell(RowNo, 8)
            //++++++++++++++++++++++++++++
            PurchPriceLine.Init();
            PurchPriceLine."Line No." := LineNo;
            PurchPriceLine."Price List Code" := iPurchPriceCode;
            PurchPriceLine."Source Type" := PurchPriceLine."Source Type"::Vendor;
            PurchPriceLine."Assign-to No." := GetValueAtCell(RowNo, 1);
            PurchPriceLine.Validate("Assign-to No.");
            Evaluate(PurchPriceLine."Starting Date", GetValueAtCell(RowNo, 2));
            Evaluate(PurchPriceLine."Ending Date", GetValueAtCell(RowNo, 3));

            PurchPriceLine."Asset Type" := PurchPriceLine."Asset Type"::Item;
            PurchPriceLine."Product No." := GetValueAtCell(RowNo, 4);
            PurchPriceLine.Validate("Product No.");
            //PurchPriceLine."Variant Code" := GetValueAtCell(RowNo, 5);
            PurchPriceLine.Validate("Variant Code");
            if GetValueAtCell(RowNo, 5) <> '' then
                PurchPriceLine."Unit of Measure Code" := GetValueAtCell(RowNo, 5);
            PurchPriceLine."Amount Type" := PurchPriceLine."Amount Type"::Any;
            // Evaluate(PurchPriceLine."Rate Agreement", GetValueAtCell(RowNo, 7));
            Evaluate(PurchPriceLine."Unit Cost", GetValueAtCell(RowNo, 6));
            Evaluate(PurchPriceLine."Direct Unit Cost", GetValueAtCell(RowNo, 6));
            // Evaluate(PurchPriceLine.Kickback, GetValueAtCell(RowNo, 9));
            //initiate value
            PurchPriceLine."Allow Line Disc." := false;
            //-
            PurchPriceLine."Currency Code" := '';
            if (GetValueAtCell(RowNo, 7) <> '') AND (GetValueAtCell(RowNo, 7) <> '0') then
                PurchPriceLine."Currency Code" := GetValueAtCell(RowNo, 7);
            PurchPriceLine.Insert();
            LineNo := LineNo + 100;
        end;
        Message(FinishProcess);
    end;

    local procedure getMaxBudgetEntryNo(iCode: Text): Integer
    var
        PurchPriceLine: Record "Price List Line";
    begin
        Clear(PurchPriceLine);
        PurchPriceLine.Reset();
        PurchPriceLine.SetRange("Price List Code", iCode);
        if PurchPriceLine.FindLast() then
            exit(PurchPriceLine."Line No.");
        exit(0);
    end;

    local procedure ReadExcelSheet()
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text[100];
    begin
        UploadIntoStream(UploadExcelMsg, '', 'All Files (*.*)|*.xlsx', FromFile, IStream);
        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            TempExcelBuffer.GetSheetsNameListFromStream(IStream, NameValueBufferOut);
            // SheetName := TempExcelBuffer.SelectSheetsNameStream(IStream);
        end else
            Error(NoFileFoundMsg);
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        NameValueBufferOut.Reset();
        if NameValueBufferOut.FindSet() then begin
            Clear(SheetName);
            SheetName := NameValueBufferOut.Value;
            TempExcelBuffer.OpenBookStream(IStream, SheetName);
            TempExcelBuffer.ReadSheet();
        end;
    end;
    //End Import Excel Job Task

    procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        TempExcelBuffer.Reset();
        If TempExcelBuffer.Get(RowNo, ColNo) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        FileName: Text[100];
        SheetName: Text[100];
        NameValueBufferOut: Record "Name/Value Buffer" temporary;
        FinishProcess: Label 'The process has been finished.';
}
