page 50110 PajakMasukanPostedList_FT
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = PPN_FT;
    InsertAllowed = false;
    CardPageId = PajakMasukaPostedDoc_FT;
    SourceTableView = sorting(RecID) order(ascending) where(FlagTaxType = filter(Input), FlagPosted = filter(Y));
    Caption = 'Posted Incoming Taxes';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(RecID; Rec.RecID)
                {
                    ApplicationArea = All;
                    Caption = 'ID';
                    Editable = false;
                }
                field(TaxNumber; Rec.TaxNumber)
                {
                    ApplicationArea = All;
                    Caption = 'Tax No';
                }
                field(TaxDate; Rec.TaxDate)
                {
                    ApplicationArea = All;
                    Caption = 'Tax Date';
                }
                field(ReturnTaxNo; Rec.ReturnTaxNo)
                {
                    ApplicationArea = All;
                    Caption = 'Return Tax No';
                }
                field(ReturnDocNo; Rec.ReturnDocNo)
                {
                    ApplicationArea = All;
                    Caption = 'Return Document No';
                }
                field(ReturnDate; Rec.ReturnDate)
                {
                    ApplicationArea = All;
                    Caption = 'Return Date';
                }
                field(InvoiceNo; Rec.InvoiceNo)
                {
                    ApplicationArea = All;
                    Caption = 'Invoice No';
                    Editable = false;
                }
                field(AccountNo; Rec.AccountNo)
                {
                    ApplicationArea = All;
                    Caption = 'Account No';
                    Editable = false;
                }
                field("Source Name"; Rec."Source Name")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Name';
                }
                field(exportdate; Rec.ExportDate)
                {
                    ApplicationArea = All;
                    //Caption = 'Account. No';
                    Editable = false;
                }
                field(exportstatus; Rec.ExportStatus)
                {
                    ApplicationArea = All;
                    //Caption = 'Account. No';
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(Reporting)
        {
            action("Export EFaktur")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    _itkppn: Record PPN_FT;
                begin
                    ExportPPN(Rec.RecID);
                end;
            }
        }
    }
    //local procedure ExportPPN(RecId: Code[25])

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        Vendor: Record Vendor;
    begin
        if Rec."Source Name" = '' then begin
            Clear(Vendor);
            if Vendor.Get(Rec.AccountNo) then begin
                Rec."Source Name" := Vendor.Name;
                Rec.Modify();
            end;
        end;
    end;

    local procedure ExportPPN(RecId: Integer)
    var
        _instream: InStream;
        _outstream: OutStream;
        _ITKPPN: Record PPN_FT;
        _fileName: Text;
        //_TempBlob: Record TempBlob temporary;
        _TempBlob: codeunit "Temp Blob";
        _variable: Text;
        _vndr: Record Vendor;
        _prefix: Text;
        _taxnum: Text;
        _fppPengganti: Text;
        _TxtDownload: Text;
        _datetxt: Text;
        _Headtxtdonlot: Text;
        _npwp: Text;
        _npwpName: Text;
        _npwpAlamat: Text;
        _flagretur: Enum EnumYN_FT;
    begin
        //Message(Format(RecId));
        Precision := 1;
        Direction := '=';
        _variable[1] := 10;
        ////
        // _TempBlob.Blob.CreateOutStream(_outstream);
        _TempBlob.CreateOutStream(_outstream);
        CurrPage.SetSelectionFilter(_ITKPPN);
        _ITKPPN.FindSet();
        _flagretur := _ITKPPN.FlagRetur;
        //_datetxt := Format(Date2DMY(Today, 1)) + Format(Date2DMY(Today, 2)) + Format(Date2DMY(Today, 3));
        _datetxt := DelChr(Format(WorkDate()), '=', '/');
        // if _ITKPPN.FlagExport = EnumYN_FT::Y then begin
        //     _datetxt := DelChr(Format(_ITKPPN.ExportDate), '=', '/');
        // end;
        //Message(_datetxt);
        _datetxt := DelStr(_datetxt, 5, 2) + Format(Date2DMY(Today, 3));
        _fileName := 'PajakMasukan_' + _datetxt + '.txt';
        if _flagretur = EnumYN_FT::Y then begin
            _fileName := 'PajakMasukanRetur_' + _datetxt + '.txt';
        end;
        repeat begin
            //_ITKPPN.Get(RecId);
            if _flagretur <> _ITKPPN.FlagRetur then begin
                Error('You cannot choose normal tax and retur tax in same report');
            end;
            _npwp := _ITKPPN.NPWP;
            _npwpName := _ITKPPN.Nama;
            _npwpAlamat := _ITKPPN.Address;
            //_TxtDownload := ''; 
            _taxnum := '-';
            _fppPengganti := '-';
            _prefix := '-';

            if _ITKPPN.TaxDate = 0D then begin
                Error('Error. tax date is empty');
            end;
            _taxnum := _ITKPPN.TaxNumber;
            _fppPengganti := CopyStr(_taxnum, 3, 1);
            _prefix := CopyStr(_taxnum, 1, 2);
            _taxnum := DelStr(_taxnum, 1, 3);
            _taxnum := DelChr(_taxnum, '=', '.-');
            if _ITKPPN.FlagRetur = EnumYN_FT::N then begin
                _TxtDownload := _TxtDownload + '"FM"' + ',' + '"' + _prefix + '"' + ',' + '"' + _fppPengganti + '"' + ',' + '"' + _taxnum + '"' + ',' + '"' + Format(Date2DMY(_ITKPPN.TaxDate, 2)) + '"' + ',' + '"' + Format(Date2DMY(_ITKPPN.TaxDate, 3)) + '"' + ',' + '"' + Format(_ITKPPN.TaxDate, 0, '<Day,2>/<Month,2>/<Year4>') + '"' + ',' + '"' + _npwp + '"' + ',' + '"' + _npwpName + '"' + ',' + '"' + _npwpAlamat + '"' + ',' + '"' + Format(ROUND(_ITKPPN.DPP, Precision, Direction)).Replace(',', '').Replace('.', '') + '"' + ',' + '"' + Format(ROUND(_ITKPPN.VAT, Precision, Direction)).Replace(',', '').Replace('.', '') + '"' + ',' + '"' + '0' + '"' + ',' + '"' + '1' + '"' + _variable + _variable;
            end
            else begin
                _TxtDownload := _TxtDownload + '"RM","' + _npwp + '","' + _npwpName + '","' + _prefix + '","' + _fppPengganti + '","' + _taxnum + '","' + Format(_ITKPPN.TaxDate, 0, '<Day,2>/<Month,2>/<Year4>') + '","0","' + _ITKPPN.ReturnDocNo + '","' + Format(_ITKPPN.ReturnDate, 0, '<Day,2>/<Month,2>/<Year4>') + '","' + Format(Date2DMY(_ITKPPN.ReturnDate, 2)) + '","' + Format(Date2DMY(_ITKPPN.ReturnDate, 3)) + '","' + Format(ROUND(_ITKPPN.DPP, Precision, Direction)).Replace(',', '').Replace('.', '') + '","' + Format(ROUND(_ITKPPN.VAT, Precision, Direction)).Replace(',', '').Replace('.', '') + '","0"' + _variable + _variable;
                ;
            end;
            if _ITKPPN.FlagExport = EnumYN_FT::N then begin
                _ITKPPN.FlagExport := EnumYN_FT::Y;
                _ITKPPN.ExportDate := WorkDate();
                _ITKPPN.ExportStatus := ExportStatus_FT::Exported;
                _ITKPPN.Modify();
            end;
        end until _ITKPPN.Next = 0;
        if _flagretur = EnumYN_FT::N then begin
            _Headtxtdonlot := '"FM","KD_JENIS_TRANSAKSI","FG_PENGGANTI","NOMOR_FAKTUR","MASA_PAJAK","TAHUN_PAJAK","TANGGAL_FAKTUR","NPWP","NAMA","ALAMAT_LENGKAP","JUMLAH_DPP","JUMLAH_PPN","JUMLAH_PPNBM","IS_CREDITABLE"' + _variable;
        end
        else begin
            _Headtxtdonlot := '"RM","NPWP","NAMA","KD_JENIS_TRANSAKSI","FG_PENGGANTI","NOMOR_FAKTUR","TANGGAL_FAKTUR","IS_CREDITABLE","NOMOR_DOKUMEN_RETUR","TANGGAL_RETUR","MASA_PAJAK_RETUR","TAHUN_PAJAK_RETUR","NILAI_RETUR_DPP","NILAI_RETUR_PPN","NILAI_RETUR_PPNBM"' + _variable;
        end;
        _TxtDownload := _Headtxtdonlot + _TxtDownload;
        _outstream.WriteText(_TxtDownload);
        ////
        // _TempBlob.Blob.CreateInStream(_instream);
        _TempBlob.CreateInStream(_instream);
        if DownloadFromStream(_instream, '', '', '', _fileName) then begin
            // Rec.FlagExport := EnumYN_FT::Y;
            // if Rec.Modify() then begin
            //     Message('Download success');
            // end;
        end;
    end;

    var
        myInt: Integer;
        Direction: Text;
        Precision: Decimal;
}
