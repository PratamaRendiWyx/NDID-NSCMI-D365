pageextension 50512 InvtShipmentSubform_WE extends "Invt. Shipment Subform"
{
    actions
    {
        addafter("Item &Tracking Lines")
        {
            action("Import Excel File")
            {
                ApplicationArea = All;
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Import Data From Excel';

                trigger OnAction()
                begin
                    ImportShipmentLineExcel();
                    ExcelBuffer.DeleteAll();
                end;

            }
        }
    }

    var
        ExcelBuffer: Record "Excel Buffer";
        Rows: Integer;
        Columns: Integer;
        Filename: Text;
        FileMgmt: Codeunit "File Management";
        ExcelFile: File;
        Instr: InStream;
        Sheetname: Text;
        FileUploaded: Boolean;
        RowNo: Integer;
        ColNo: Integer;
        Rec_InvLine: Record "Invt. Document Line";



    procedure ImportShipmentLineExcel()
    var
        DocType: Integer;
    begin
        ExcelBuffer.DeleteAll();
        Rows := 0;
        Columns := 0;
        FileUploaded := UploadIntoStream('Select File to Upload', '', '', Filename, Instr);

        if Filename <> '' then
            Sheetname := ExcelBuffer.SelectSheetsNameStream(Instr)
        else
            exit;

        ExcelBuffer.Reset;
        ExcelBuffer.OpenBookStream(Instr, Sheetname);
        ExcelBuffer.ReadSheet();

        Commit();
        ExcelBuffer.Reset();
        ExcelBuffer.SetRange("Column No.", 1);
        if ExcelBuffer.FindFirst() then
            repeat
                Rows := Rows + 1;
            until ExcelBuffer.Next() = 0;
        //Message(Format(Rows));

        ExcelBuffer.Reset();
        ExcelBuffer.SetRange("Row No.", 1);
        if ExcelBuffer.FindFirst() then
            repeat
                Columns := Columns + 1;
            until ExcelBuffer.Next() = 0;
        //Message(Format(Columns));
        //Insert
        for RowNo := 2 to Rows do begin
            Rec_InvLine.Reset();
            Rec_InvLine.Init();
            Evaluate(Rec_InvLine."Document Type", GetValueAtIndex(RowNo, 1));
            Rec_InvLine.Validate("Document Type");
            Evaluate(Rec_InvLine."Document No.", GetValueAtIndex(RowNo, 2));
            Rec_InvLine.Validate("Document No.");
            Evaluate(Rec_InvLine."Line No.", GetValueAtIndex(RowNo, 3));
            Evaluate(Rec_InvLine."Item No.", GetValueAtIndex(RowNo, 4));
            Rec_InvLine.Validate("Item No.");
            Evaluate(Rec_InvLine.Quantity, GetValueAtIndex(RowNo, 5));
            Rec_InvLine.Validate(Quantity);
            Rec_InvLine.Validate("Unit Amount");
            Rec_InvLine.Validate("Unit Cost");
            Rec_InvLine.Insert();
        end;
        Message('%1 Rows Imported Successfully!!', Rows - 1);
    end;

    local procedure GetValueAtIndex(RowNo: Integer; ColNo: Integer): Text
    var
    begin
        ExcelBuffer.Reset();
        IF ExcelBuffer.Get(RowNo, ColNo) then
            exit(ExcelBuffer."Cell Value as Text");
    end;
}
