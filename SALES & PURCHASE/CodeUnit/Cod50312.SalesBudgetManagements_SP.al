codeunit 50312 SalesBudgetManagements_SP
{
    procedure importItemBudgetEntries(iBudgetName: Text)
    var
        RowNo: Integer;
        ColNo: Integer;
        LineNo: Integer;
        MaxRowNo: Integer;
        ItemBudgetEntry: Record "Item Budget Entry";

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

        Clear(ItemBudgetEntry);
        LineNo := ItemBudgetEntry.GetLastEntryNo() + 1;
        for RowNo := 2 to MaxRowNo do begin
            ItemBudgetEntry.Init();
            // GetValueAtCell(RowNo, 8)
            //++++++++++++++++++++++++++++
            ItemBudgetEntry."Entry No." := LineNo;
            ItemBudgetEntry."Analysis Area" := ItemBudgetEntry."Analysis Area"::Sales;
            ItemBudgetEntry."Budget Name" := iBudgetName;
            Evaluate(ItemBudgetEntry.Date, GetValueAtCell(RowNo, 1));
            Evaluate(ItemBudgetEntry."Item No.", GetValueAtCell(RowNo, 2));
            Evaluate(ItemBudgetEntry."Source Type", GetValueAtCell(RowNo, 3));
            Evaluate(ItemBudgetEntry."Source No.", GetValueAtCell(RowNo, 4));
            Evaluate(ItemBudgetEntry.Description, GetValueAtCell(RowNo, 5));
            Evaluate(ItemBudgetEntry.Quantity, GetValueAtCell(RowNo, 6));
            Evaluate(ItemBudgetEntry."Cost Amount", GetValueAtCell(RowNo, 7));
            Evaluate(ItemBudgetEntry."Sales Amount", GetValueAtCell(RowNo, 8));
            ItemBudgetEntry."User ID" := UserId;
            Evaluate(ItemBudgetEntry."Location Code", GetValueAtCell(RowNo, 9));
            Evaluate(ItemBudgetEntry."Global Dimension 1 Code", GetValueAtCell(RowNo, 10));
            Evaluate(ItemBudgetEntry."Global Dimension 2 Code", GetValueAtCell(RowNo, 11));
            Evaluate(ItemBudgetEntry."Budget Dimension 1 Code", GetValueAtCell(RowNo, 12)); //Country Code
            Evaluate(ItemBudgetEntry."Budget Dimension 2 Code", GetValueAtCell(RowNo, 13)); //Oem Type
            Evaluate(ItemBudgetEntry."Budget Dimension 3 Code", GetValueAtCell(RowNo, 14)); //Catalist Maker
            ItemBudgetEntry.Insert();
            LineNo := LineNo + 1;
        end;
        Message(FinishProcess);
    end;

    local procedure getMaxBudgetEntryNo(iBudgetName: Text): Integer
    var
        ItemBudgetEntry: Record "Item Budget Entry";
    begin
        Clear(ItemBudgetEntry);
        ItemBudgetEntry.Reset();
        ItemBudgetEntry.SetRange("Budget Name", iBudgetName);
        if ItemBudgetEntry.FindLast() then
            exit(ItemBudgetEntry."Entry No.");
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
