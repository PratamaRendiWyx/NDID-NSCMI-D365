codeunit 50310 SalesPriceManagement_SP
{
    procedure importSalesPrice(iSalesPriceCode: Text)
    var
        RowNo: Integer;
        ColNo: Integer;
        LineNo: Integer;
        MaxRowNo: Integer;
        SalesPriceLine: Record "Price List Line";
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

        Clear(SalesPriceLine);
        LineNo := getMaxBudgetEntryNo(iSalesPriceCode) + 1000;
        for RowNo := 2 to MaxRowNo do begin
            // GetValueAtCell(RowNo, 8)
            //++++++++++++++++++++++++++++
            SalesPriceLine.Init();
            SalesPriceLine."Line No." := LineNo;
            SalesPriceLine."Price List Code" := iSalesPriceCode;
            SalesPriceLine."Source Type" := SalesPriceLine."Source Type"::Customer;
            SalesPriceLine."Assign-to No." := GetValueAtCell(RowNo, 1);
            SalesPriceLine.Validate("Assign-to No.");
            Evaluate(SalesPriceLine."Starting Date", GetValueAtCell(RowNo, 2));
            Evaluate(SalesPriceLine."Ending Date", GetValueAtCell(RowNo, 3));

            SalesPriceLine."Asset Type" := SalesPriceLine."Asset Type"::Item;
            SalesPriceLine."Product No." := GetValueAtCell(RowNo, 4);
            SalesPriceLine.Validate("Product No.");
            //SalesPriceLine."Variant Code" := GetValueAtCell(RowNo, 5);
            SalesPriceLine.Validate("Variant Code");
            if GetValueAtCell(RowNo, 5) <> '' then
                SalesPriceLine."Unit of Measure Code" := GetValueAtCell(RowNo, 5);
            SalesPriceLine."Amount Type" := SalesPriceLine."Amount Type"::Any;
            // Evaluate(SalesPriceLine."Rate Agreement", GetValueAtCell(RowNo, 7));
            Evaluate(SalesPriceLine."Unit Price", GetValueAtCell(RowNo, 6));
            // Evaluate(SalesPriceLine.Kickback, GetValueAtCell(RowNo, 9));
            //initiate value
            SalesPriceLine."Allow Line Disc." := false;
            //-
            if (GetValueAtCell(RowNo, 7) <> '') AND (GetValueAtCell(RowNo, 7) <> '0') then
                SalesPriceLine."Currency Code" := GetValueAtCell(RowNo, 7);
            SalesPriceLine.Insert();
            LineNo := LineNo + 100;
        end;
        Message(FinishProcess);
    end;

    local procedure getMaxBudgetEntryNo(iCode: Text): Integer
    var
        SalesPriceLine: Record "Price List Line";
    begin
        Clear(SalesPriceLine);
        SalesPriceLine.Reset();
        SalesPriceLine.SetRange("Price List Code", iCode);
        if SalesPriceLine.FindLast() then
            exit(SalesPriceLine."Line No.");
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
