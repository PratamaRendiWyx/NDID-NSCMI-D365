page 50104 PajakKeluaranPostedList_FT
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = PPN_FT;
    Caption = 'Posted Outgoing Taxes';
    SourceTableView = sorting(RecID) order(ascending) where(FlagTaxType = filter(Out), FlagPosted = filter(Y));
    CardPageId = PajakKeluaranPostedDoc_FT;


    //  SourceTableView = sorting (Name) order(descending)
    //  where ("Balance (LCY)" = filter (>= 50000), "Sales (LCY)" = filter (<> 0));
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(FlagTaxType; Rec.FlagTaxType)
                {
                    ApplicationArea = All;
                    Caption = 'Tax Type';
                    Visible = false;
                }
                field(FlagPosted; Rec.FlagPosted)
                {
                    ApplicationArea = All;
                    Caption = 'FlagPosted';
                    Visible = false;
                }
                field(RecID; Rec.RecID)
                {
                    ApplicationArea = All;
                    Caption = 'ID';
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
                field(FlagRetur; Rec.FlagRetur)
                {
                    ApplicationArea = All;
                    Caption = 'Return';
                }
                field(ReturnTaxNo; Rec.ReturnTaxNo)
                {
                    ApplicationArea = All;
                    Caption = 'Return Tax No.';
                }
                field(ReturnDocNo; Rec.ReturnDocNo)
                {
                    ApplicationArea = All;
                    Caption = 'Return Document No.';
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
                // field(InvoiceDate; GetInvDate(InvoiceNo))
                // {
                //     ApplicationArea = All;
                //     Enabled = False;
                //     Caption = 'Invoice Date';
                // }
                field(AccountNo; Rec.AccountNo)
                {
                    ApplicationArea = All;
                    Caption = 'Account No.';
                    Editable = false;
                }
                field("Source Name"; Rec."Source Name")
                {
                    ApplicationArea = All;
                    Caption = 'Customer Name';
                }
                field(exportdate; Rec.ExportDate)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(exportstatus; Rec.ExportStatus)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
        area(Factboxes)
        {
        }
    }
    actions
    {
        area(Reporting)
        {
            action("Export EFaktur")
            {
                ApplicationArea = All;
                Caption = 'Export to e-Faktur';

                trigger OnAction()
                var
                begin
                    ExportPPN(Rec.RecID);
                end;
            }
            action("Export EFaktur (XML)")
            {
                ApplicationArea = All;
                Caption = 'Export to e-Faktur (XML)';

                trigger OnAction()
                var
                    PPN: Record PPN_FT;
                begin
                    Clear(FakturPajak);
                    CurrPage.SetSelectionFilter(PPN);
                    if PPN.FindSet() then begin
                        FakturPajak.CreateXML(PPN);
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        Customer: Record Customer;
    begin
        if Rec."Source Name" = '' then begin
            Clear(Customer);
            if Customer.Get(Rec.AccountNo) then begin
                Rec."Source Name" := Customer.Name;
                Rec.Modify();
            end;
        end;
    end;

    var
        v_FixLabelEPTEGroup: Text;
        v_globalExchangeRate: Decimal;

    local procedure getInfoContractSI(iSalesInvNo: Code[20]): Text
    var
        salesInvoice: Record "Sales Invoice Header";
    begin
        Clear(salesInvoice);
        salesInvoice.SetRange("No.", iSalesInvNo);
        if salesInvoice.Find('-') then begin
            exit(salesInvoice."External Document No.");
        end;
        exit('');
    end;

    local procedure CustomerGrpEPTEData(iCurrCode: Text; iPostingDate: Date): Text
    var
        curexchangeRate: Record "Currency Exchange Rate";
        v_exchangeRate: Decimal;
        v_DateExchange: Text;
        v_startDateExhRate: Text;
        v_startDateExhRate1: Text;
        v_additionalInfoCustomerEPTE: Text;
    begin
        //get currencyRate 
        Clear(v_globalExchangeRate);
        Clear(curexchangeRate);
        curexchangeRate.Reset();
        curexchangeRate.SetRange("Currency Code", iCurrCode);
        curexchangeRate.SetRange("Starting Date", 0D, iPostingDate);
        if curexchangeRate.FindLast() then begin
            v_exchangeRate := curexchangeRate."Relational Exch. Rate Amount";
            v_startDateExhRate := (Format(curexchangeRate."Starting Date", 0, '<Day,2>'));
            v_startDateExhRate1 := Format(curexchangeRate."Starting Date", 0, '<Day,2> <Month Text> <Year4>');
        end;
        //get range date 
        Clear(curexchangeRate);
        curexchangeRate.Reset();
        curexchangeRate.SetRange("Currency Code", iCurrCode);
        curexchangeRate.SetFilter("Starting Date", '>%1', iPostingDate);
        if curexchangeRate.FindFirst() then begin
            v_startDateExhRate := v_startDateExhRate + '-' + Format(curexchangeRate."Starting Date" - 1, 0, '<Day,2> <Month Text> <Year4>');
        end else begin
            v_startDateExhRate := v_startDateExhRate1;
        end;

        v_globalExchangeRate := v_exchangeRate;

        //Assign Fix Label
        v_FixLabelEPTEGroup := 'PPN TIDAK DIPUNGUT SESUAI PP TEMPAT PENIMBUNAN BERIKAT';
        v_additionalInfoCustomerEPTE := v_startDateExhRate + '=' + Format(v_exchangeRate) + ' ' + v_FixLabelEPTEGroup;
        exit(v_additionalInfoCustomerEPTE);
    end;

    var
        v_totalddp: Decimal;
        v_totalamount: Decimal;
        v_totalvat: Decimal;

    local procedure getTotalVatDDPCustomerEPTE(iNo: Text)
    var
        salesInvoiceLines: Record "Sales Invoice Line";
        salesInvoiceLines1: Record "Sales Invoice Line";
        salesInvoiceHeader: Record "Sales Invoice Header";
        v_curCode: Text;
        VATPostingSetup: Record "VAT Posting Setup";
        vat_value: Decimal;
        currencyexchangerate: Record "Currency Exchange Rate";
        v_exchangeRate: Decimal;
        Direction: Text;
        Precision: Decimal;
    begin
        Precision := 1;
        Direction := '=';
        Clear(v_totalddp);
        Clear(v_totalvat);
        Clear(v_totalamount);
        Clear(v_exchangeRate);
        Clear(salesInvoiceHeader);
        salesInvoiceHeader.Reset();
        salesInvoiceHeader.SetRange("No.", iNo);
        if salesInvoiceHeader.Find('-') then begin
            v_curCode := salesInvoiceHeader."Currency Code";
            v_exchangeRate := getExchageRate(v_curCode, salesInvoiceHeader."Posting Date");
            // Clear(currencyexchangerate);
            // currencyexchangerate.Reset();
            // currencyexchangerate.SetRange("Currency Code", v_curCode);
            // currencyexchangerate.SetRange("Starting Date", 0D, salesInvoiceHeader."Posting Date");
            // if currencyexchangerate.FindLast() then begin
            //     v_exchangeRate := currencyexchangerate."Relational Exch. Rate Amount";
            // end;
        end;

        Clear(VATPostingSetup);
        VATPostingSetup.Reset();
        // VATPostingSetup.SetRange("VAT Bus. Posting Group", 'VAT');
        // VATPostingSetup.SetRange("VAT Prod. Posting Group", 'VAT');
        VATPostingSetup.SetRange("E-Faktur KB", true);
        if VATPostingSetup.Find('-') then
            vat_value := VATPostingSetup."VAT %";

        Clear(CurrData);
        Clear(TempData);
        Clear(salesInvoiceLines);
        salesInvoiceLines.Reset();
        salesInvoiceLines.SetRange("Document No.", iNo);
        salesInvoiceLines.SetRange(Type, salesInvoiceLines.Type::Item);
        salesInvoiceLines.SetCurrentKey(Description, "No.", "Unit Price");
        if salesInvoiceLines.FindSet() then begin
            repeat
                CurrData := salesInvoiceLines.Description + '#' + salesInvoiceLines."No." + '#' + format(salesInvoiceLines."Unit Price");
                if TempData <> CurrData then begin
                    Clear(salesInvoiceLines1);
                    salesInvoiceLines1.Reset();
                    salesInvoiceLines1.SetRange("Document No.", salesInvoiceLines."Document No.");
                    salesInvoiceLines1.SetRange("No.", salesInvoiceLines."No.");
                    salesInvoiceLines1.SetRange("Unit Price", salesInvoiceLines."Unit Price");
                    if salesInvoiceLines1.FindSet() then begin
                        salesInvoiceLines1.CalcSums(Quantity, "Line Amount", "Line Discount Amount");
                        v_totalamount += (salesInvoiceLines1."Line Amount" * v_exchangeRate);
                        v_totalddp += (salesInvoiceLines."Line Discount Amount" * v_exchangeRate);
                    end;
                end;
                TempData := CurrData;
            until salesInvoiceLines.Next() = 0;
        end;
        //final calculate 
        v_totalddp := v_totalamount - v_totalddp;
        v_totalvat := v_totalamount * (vat_value / 100);
    end;

    local procedure ExportPPN(RecId: Integer)
    var
        _instream: InStream;
        _outstream: OutStream;
        _PPN: Record PPN_FT;
        _PPNDTL: Record PPNDetail_FT;
        _PPNDTL1: Record PPNDetail_FT;
        _fileName: Text;
        _TempBlob: codeunit "Temp Blob";
        _variable: Text;
        _customer: Record Customer;
        _prefix: Text;
        _DataPrint1: Text;
        _DataPrint2: Text;
        _taxnum: Text;
        _fppPengganti: Text;
        _company: Record "Company Information";
        _indparam: Record TaxIndoParameter_FT;
        _kodepos: Text;
        _notelp: Text;
        _datetxt: Text;
        _TxtDownload: Text;
        _headtxtdonlot: Text;
        _npwp: Text;
        _npwpName: Text;
        _npwpAlamat: Text;
        _flagretur: Enum EnumYN_FT;
        Direction: Text;
        Precision: Decimal;
        _perbaikanjmldpp: Decimal;
        _perbaikanjmlvat: Decimal;
        _qtytukerkomatitik: Text;
        v_InfoSalesInvoice: Text;
        //Posted Sales Invoice Line.
        postedsalesinvoice: Record "Sales Invoice Line";
        postedsalesinvoice1: Record "Sales Invoice Line";
        v_dppamount: Decimal;
        v_vatamount: Decimal;
        VATPostingSetup: Record "VAT Posting Setup";
        v_test: Text[100];
        v_NewExchRate: Decimal;
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        Precision := 1;
        Direction := '=';
        _variable[1] := 10;
        _company.Get();
        _TempBlob.CreateOutStream(_outstream);
        CurrPage.SetSelectionFilter(_PPN);
        _PPN.FindSet();
        _flagretur := _PPN.FlagRetur;
        _datetxt := DelChr(Format(WorkDate()), '=', '/');
        _datetxt := DelStr(_datetxt, 5, 2) + Format(Date2DMY(Today, 3));
        _fileName := 'PajakKeluaran_' + _datetxt + '.txt';
        if _flagretur = EnumYN_FT::Y then begin
            _fileName := 'PajakKeluaranRetur_' + _datetxt + '.txt';
        end;
        _indparam.FindFirst();
        repeat begin
            if _flagretur <> _PPN.FlagRetur then begin
                Error('You cannot choose normal tax and retur tax in same report');
            end;
            _npwp := _PPN.NPWP;
            _npwpName := _PPN.Nama;
            _npwpAlamat := _PPN.Address;
            _DataPrint1 := '';
            _DataPrint2 := '';
            _kodepos := '-';
            _notelp := '-';
            _taxnum := '-';
            _fppPengganti := '-';
            _prefix := '-';
            _perbaikanjmldpp := 0;
            _perbaikanjmlvat := 0;
            _customer.SetFilter("NPWP No_FT", '=%1', _PPN.NPWP); // "NPWP No" := NPWP;
            _customer.SetFilter("No.", '=%1', _PPN.AccountNo);
            if _customer.FindSet then begin
            end;
            //_PPN.Get(RecId);
            if _PPN.TaxDate = 0D then begin
                Error('Error. tax date is empty');
            end;
            _taxnum := _PPN.TaxNumber;
            _fppPengganti := CopyStr(_taxnum, 3, 1);
            _prefix := CopyStr(_taxnum, 1, 2);
            _taxnum := DelStr(_taxnum, 1, 3);
            _taxnum := DelChr(_taxnum, '=', '.-');
            if _customer."Post Code" <> '' then begin
                _kodepos := _customer."Post Code";
            end;
            if _customer."Phone No." <> '' then begin
                _notelp := _customer."Phone No.";
            end;
            if _PPN.FlagRetur = EnumYN_FT::N then begin
                //perbaikan
                Clear(_PPNDTL);
                _PPNDTL.SetFilter(_PPNDTL.InvoiceNo, '=%1', _PPN.InvoiceNo);
                if _PPNDTL.FindSet then begin
                    repeat begin
                        //Old Version
                        // _perbaikanjmldpp := _perbaikanjmldpp + ROUND(_PPNDTL.DPPAmt, Precision, Direction);
                        // _perbaikanjmlvat := _perbaikanjmlvat + ROUND(_PPNDTL.VatAmt, Precision, Direction);
                        //New Version
                        _perbaikanjmldpp := _perbaikanjmldpp + _PPNDTL.DPPAmt;
                        _perbaikanjmlvat := _perbaikanjmlvat + _PPNDTL.VatAmt;
                    end until _PPNDTL.Next = 0;
                end;
                _PPN.DPP := _perbaikanjmldpp;
                _PPN.VAT := _perbaikanjmlvat;
                //endperbaikan

                //additional info, add by rnd 21 Jul 2023, Request arief-san from customer SAITAMA
                v_InfoSalesInvoice := _PPN.InvoiceNo;
                _DataPrint1 := '"FK"' + ',' + '"' + _prefix + '"' + ',' + '"' + _fppPengganti + '"' + ',' + '"' + _taxnum + '"' + ',' + '"' + Format(Date2DMY(_PPN.TaxDate, 2)) + '"' + ',' + '"' + Format(Date2DMY(_PPN.TaxDate, 3)) + '"' + ',' + '"' + Format(_PPN.TaxDate, 0, '<Day,2>/<Month,2>/<Year4>') + '"' + ',' + '"' + _npwp + '"' + ',' + '"' + _npwpName + '"' + ',' + '"' + _npwpAlamat + '"' + ',' + '"' + Format(ROUND(_PPN.DPP, Precision, '<')).Replace(',', '').Replace('.', '') + '"' + ',' + '"' + Format(ROUND(_PPN.VAT, Precision, '<')).Replace(',', '').Replace('.', '') + '"' + ',' //+ '"' + 'JUMLAH_PPNBM' + '"' + ',' + '"' + 'ID_KETERANGAN_TAMBAHAN' + '"' + ',' + '"' + 'FGUANGMUKA' + '"' + ',' + '"' + 'UANGMUKADPP' + '"' + ',' + '"' + 'UANGMUKAPPN' + '"' + ',' + '"' + 'UANGMUKAPPNBM' + '"' + ',' + '"' + 'REFERENSI' + '"'
               + '"' + '0' + '"' + ',' + '"' + '' + '"' + ',' + '"' + '0' + '"' + ',' + '"' + '0' + '"' + ',' + '"' + '0' + '"' + ',' + '"' + '0' + '"' + ',' + '"' + v_InfoSalesInvoice + '"' + ',' + '"' + _PPN.KodeDokumenPendukung + '"' + _variable + '"FAPR"' + ',' + '"' + _company.Name + '"' + ',' + '"' + _company.Address + '"' + ',' + '"' + _indparam.Signer + '"' + ',' + '"' + _company.City + '"' + _variable;
                //EPTE Customer | Kawasan berikat
                if _customer."NPWP PrefixWapu_FT" = _customer."NPWP PrefixWapu_FT"::"070" then begin
                    getTotalVatDDPCustomerEPTE(_PPN.InvoiceNo);
                    v_test := Format(ROUND(v_totalvat, Precision, '<')).Replace(',', '').Replace('.', '');
                    _prefix := CopyStr(Format(_customer."NPWP PrefixWapu_FT"), 1, 2);
                    v_InfoSalesInvoice := _PPN.InvoiceNo + '/Contract No:' + getInfoContractSI(_PPN.InvoiceNo); //CustomerGrpEPTEData(_PPN.Currency, _PPN.InvoiceDate);
                    _DataPrint1 := '"FK"' + ',' + '"' + _prefix + '"' + ',' + '"' + _fppPengganti + '"' + ',' + '"' + _taxnum + '"' + ',' + '"' + Format(Date2DMY(_PPN.TaxDate, 2)) + '"' + ',' + '"' + Format(Date2DMY(_PPN.TaxDate, 3)) + '"' + ',' + '"' + Format(_PPN.TaxDate, 0, '<Day,2>/<Month,2>/<Year4>') + '"' + ',' + '"' + _npwp + '"' + ',' + '"' + _npwpName + '"' + ',' + '"' + _npwpAlamat + '"' + ',' + '"' + Format(ROUND(v_totalddp, Precision, '<')).Replace(',', '').Replace('.', '') + '"' + ',' + '"' +
                    Format(ROUND(v_totalvat, Precision, '<')).Replace(',', '').Replace('.', '') + '"' + ',' //+ '"' + 'JUMLAH_PPNBM' + '"' + ',' + '"' + 'ID_KETERANGAN_TAMBAHAN' + '"' + ',' + '"' + 'FGUANGMUKA' + '"' + ',' + '"' + 'UANGMUKADPP' + '"' + ',' + '"' + 'UANGMUKAPPN' + '"' + ',' + '"' + 'UANGMUKAPPNBM' + '"' + ',' + '"' + 'REFERENSI' + '"'
               + '"' + '0' + '"' + ',' + '"' + '2' + '"' + ',' + '"' + '0' + '"' + ',' + '"' + '0' + '"' + ',' + '"' + '0' + '"' + ',' + '"' + '0' + '"' + ',' + '"' + v_InfoSalesInvoice + '"' + ',' + '"' + _PPN.KodeDokumenPendukung + '"' + _variable + '"FAPR"' + ',' + '"' + _company.Name + '"' + ',' + '"' + _company.Address + '"' + ',' + '"' + _indparam.Signer + '"' + ',' + '"' + _company.City + '"' + _variable;
                end;

                Clear(_PPNDTL);
                _PPNDTL.SetFilter(_PPNDTL.InvoiceNo, '=%1', _PPN.InvoiceNo);
                //sorting & additional filter
                // _PPNDTL.SetFilter(Price, '<>0');
                // _PPNDTL.SetFilter(DiscAmt, '<>0');
                _PPNDTL.SetCurrentKey(InvoiceNo, Description, ItemID, Price);
                _PPNDTL.Ascending(true);
                if _PPNDTL.FindSet then begin
                    //Message(Format(_PPNDTL.Count));
                    repeat begin
                        // Message(Format(_PPNDTL.ItemID));
                        // if (_PPNDTL.Price = 0) and (_PPNDTL.DiscAmt = 0) then begin
                        // end
                        // else begin
                        CurrData := _PPNDTL.Description + '#' + _PPNDTL.ItemID + '#' + format(_PPNDTL.Price);
                        if TempData <> CurrData then begin
                            //Do action here, Grouping Data
                            Clear(_PPNDTL1);
                            _PPNDTL1.Reset();
                            _PPNDTL1.SetRange(InvoiceNo, _PPN.InvoiceNo);
                            _PPNDTL1.SetRange(ItemID, _PPNDTL.ItemID);
                            _PPNDTL1.SetRange(Price, _PPNDTL.Price);
                            // _PPNDTL1.SetFilter(Price, '<>0');
                            // _PPNDTL1.SetFilter(DiscAmt, '<>0');
                            if _PPNDTL1.FindSet() then begin
                                //Summary the data
                                _PPNDTL1.CalcSums(QtyDecimal, TotAmt, DiscAmt, DPPAmt, VatAmt);
                                _qtytukerkomatitik := Format(_PPNDTL1.QtyDecimal);
                                _qtytukerkomatitik := _qtytukerkomatitik.Replace(',', '[1]');
                                _qtytukerkomatitik := _qtytukerkomatitik.Replace('.', '');
                                _qtytukerkomatitik := _qtytukerkomatitik.Replace('[1]', '.');
                                //_qtytukerkomatitik := _qtytukerkomatitik.Replace('[2]', ',');
                                /*_DataPrint2 := _DataPrint2 //+ '"OF"' + ',' + '"' + _PPNDTL.ItemID + '"' + ',' + '"' + _customer."NPWP Nama" + '"' + ',' + '"' + Format(_PPNDTL.Price) + '"' + ',' + '"' + Format(_PPNDTL.Qty) + '"' + ',' + '"' + Format(_PPNDTL.TotAmt) + '"' + ',' + '"' + Format(_PPNDTL.DiscAmt) + '"' + ',' + '"' + Format(_PPNDTL.DPPAmt) + '"' + ',' + '"' + Format(_PPNDTL.VatAmt) + '"' + ',' + '"' + 'tarifPPNBM' + '"' + ',' + '"' + 'PPNBM' + '"'
                                                           //+ '"OF"' + ',' + '"' + _PPNDTL.ItemID + '"' + ',' + '"' + _PPNDTL.Description03132021 + '"' + ',' + '"' + Format(ROUND(_PPNDTL.Price, Precision, Direction)).Replace(',', '').Replace('.', '') + '"' + ',' + '"' + Format(_PPNDTL.QtyDecimal) + '"' + ',' + '"' + Format(ROUND(_PPNDTL.TotAmt, Precision, Direction)).Replace(',', '').Replace('.', '') + '"' + ',' + '"' + Format(ROUND(_PPNDTL.DiscAmt, Precision, Direction)).Replace(',', '').Replace('.', '') + '"' + ',' + '"' + Format(ROUND(_PPNDTL.DPPAmt, Precision, Direction)).Replace(',', '').Replace('.', '') + '"' + ',' + '"' + Format(ROUND(_PPNDTL.VatAmt, Precision, Direction)).Replace(',', '').Replace('.', '') + '"' + ',' + '"' + '0' + '"' + ',' + '"' + '0' + '"'
                                + '"OF"' + ',' + '"' + _PPNDTL.ItemID + '"' + ','
                                + '"' + _PPNDTL.Description03132021 + '"' + ',' + '"'
                                + Format(ROUND(_PPNDTL.Price, Precision, Direction)).Replace(',', '').Replace('.', '') + '"'
                                + ',' + '"' + _qtytukerkomatitik + '"' + ',' + '"'
                                + Format(ROUND(_PPNDTL1.TotAmt, Precision, Direction)).Replace(',', '').Replace('.', '')
                                + '"' + ',' + '"' + Format(ROUND(_PPNDTL1.DiscAmt, Precision, Direction)).Replace(',', '').Replace('.', '') + '"' + ',' + '"'
                                + Format(ROUND(_PPNDTL1.DPPAmt, Precision, Direction)).Replace(',', '').Replace('.', '') + '"' + ',' + '"' 
                                + Format(ROUND(_PPNDTL1.VatAmt, Precision, Direction)).Replace(',', '').Replace('.', '') + '"' + ',' + '"' + '0' + '"' + ',' + '"' + '0' + '"' + _variable;
                                */
                                _DataPrint2 := _DataPrint2 + '"OF"' + ',' + '"' + _PPNDTL.ItemID + '"' + ','
                                + '"' + _PPNDTL.Description + '"' + ',' + '"'
                                + Format(_PPNDTL.Price).Replace('.', '').Replace(',', '.') + '"'
                                + ',' + '"' + _qtytukerkomatitik + '"' + ',' + '"'
                                + Format(_PPNDTL1.TotAmt).Replace('.', '').Replace(',', '.')
                                + '"' + ',' + '"' + Format(_PPNDTL1.DiscAmt).Replace('.', '').Replace(',', '.') + '"' + ',' + '"'
                                + Format(_PPNDTL1.DPPAmt).Replace('.', '').Replace(',', '.') + '"' + ',' + '"'
                                + Format(_PPNDTL1.VatAmt).Replace('.', '').Replace(',', '.') + '"' + ',' + '"' + '0' + '"' + ',' + '"' + '0' + '"' + _variable;

                                // end;
                            end
                        end;
                        TempData := CurrData;
                    end until _PPNDTL.Next = 0;
                end;

                //Start Generate Detail for customer EPTE (Kawasan Berikat).
                if _customer."NPWP PrefixWapu_FT" = _customer."NPWP PrefixWapu_FT"::"070" then begin
                    Clear(_DataPrint2);
                    Clear(TempData);
                    Clear(CurrData);
                    Clear(postedsalesinvoice);
                    postedsalesinvoice.Reset();
                    postedsalesinvoice.SetCurrentKey(Description, "No.", "Unit Price");
                    postedsalesinvoice.SetRange("Document No.", _PPN.InvoiceNo);
                    postedsalesinvoice.SetRange(Type, postedsalesinvoice.Type::Item);
                    if postedsalesinvoice.FindSet() then begin
                        repeat
                            CurrData := postedsalesinvoice.Description + '#' + postedsalesinvoice."No." + '#' + format(postedsalesinvoice."Unit Price");
                            if TempData <> CurrData then begin
                                Clear(postedsalesinvoice1);
                                postedsalesinvoice1.Reset();
                                postedsalesinvoice1.SetRange("Document No.", postedsalesinvoice."Document No.");
                                postedsalesinvoice1.SetRange("No.", postedsalesinvoice."No.");
                                postedsalesinvoice1.SetRange("Unit Price", postedsalesinvoice."Unit Price");
                                if postedsalesinvoice1.FindSet() then begin
                                    postedsalesinvoice1.CalcSums(Quantity, "Line Amount", "Line Discount Amount");

                                    //New update 22 May 2024, by rnd 
                                    Clear(v_NewExchRate);
                                    Clear(SalesInvoiceHeader);
                                    SalesInvoiceHeader.Reset();
                                    SalesInvoiceHeader.SetRange("No.", postedsalesinvoice1."Document No.");
                                    if SalesInvoiceHeader.Find('-') then begin
                                        v_NewExchRate := getExchageRate(SalesInvoiceHeader."Currency Code", SalesInvoiceHeader."Posting Date");
                                        postedsalesinvoice1."Line Amount" := v_NewExchRate * postedsalesinvoice1."Line Amount";
                                        postedsalesinvoice1."Line Discount Amount" := v_NewExchRate * postedsalesinvoice1."Line Discount Amount";
                                        postedsalesinvoice1."Unit Price" := v_NewExchRate * postedsalesinvoice1."Unit Price";
                                    end;
                                    //-
                                    Clear(v_dppamount);
                                    Clear(v_vatamount);
                                    Clear(VATPostingSetup);
                                    VATPostingSetup.Reset();
                                    VATPostingSetup.SetRange("E-Faktur KB", true);
                                    if VATPostingSetup.Find('-') then begin
                                        postedsalesinvoice1."Line Discount Amount" := (postedsalesinvoice1."Line Discount Amount");
                                        v_dppamount := postedsalesinvoice1."Line Discount Amount"; //line discount
                                        postedsalesinvoice1."Line Amount" := (postedsalesinvoice1."Line Amount");
                                        v_vatamount := (postedsalesinvoice1."Line Amount") * (VATPostingSetup."VAT %" / 100);
                                        v_dppamount := postedsalesinvoice1."Line Amount" - v_dppamount;
                                        postedsalesinvoice1."Unit Price" := postedsalesinvoice1."Unit Price";
                                    end;
                                    Clear(_qtytukerkomatitik);
                                    _qtytukerkomatitik := Format(postedsalesinvoice1.Quantity);
                                    _qtytukerkomatitik := _qtytukerkomatitik.Replace(',', '[1]');
                                    _qtytukerkomatitik := _qtytukerkomatitik.Replace('.', '');
                                    _qtytukerkomatitik := _qtytukerkomatitik.Replace('[1]', '.');
                                    //details
                                    v_test := Format(postedsalesinvoice1."Unit Price").Replace('.', '').Replace(',', '.');
                                    _DataPrint2 := _DataPrint2
                                    + '"OF"' + ',' + '"' + postedsalesinvoice1."No." + '"' + ','
                                    + '"' + postedsalesinvoice1.Description + '"' + ',' + '"'
                                    // + Format(ROUND(postedsalesinvoice1."Unit Price", Precision, Direction)).Replace(',', '').Replace('.', '') + '"'
                                    + Format(postedsalesinvoice1."Unit Price").Replace('.', '').Replace(',', '.') + '"'
                                    + ',' + '"' + _qtytukerkomatitik + '"' + ',' + '"'
                                    + Format(postedsalesinvoice1."Line Amount").Replace('.', '').Replace(',', '.')
                                    + '"' + ',' + '"' + Format(postedsalesinvoice1."Line Discount Amount").Replace('.', '').Replace(',', '.') + '"' + ',' + '"'
                                    + Format(v_dppamount).Replace('.', '').Replace(',', '.') + '"' + ',' + '"' + Format(v_vatamount).Replace('.', '').Replace(',', '.') + '"' + ',' + '"' + '0' + '"' + ',' + '"' + '0' + '"' + _variable;
                                end;
                            end;
                            TempData := CurrData;
                        until postedsalesinvoice.Next() = 0;
                    end;
                    //End Generate Detail for customer EPTE (Kawasan Berikat).
                end
            end
            else begin
                _DataPrint1 := '"RK","' + _npwp + '","' + _npwpName + '","' + _prefix + '","' + _fppPengganti + '","' + _taxnum + '","' + Format(_PPN.TaxDate, 0, '<Day,2>/<Month,2>/<Year4>') + '","' + _PPN.ReturnDocNo + '","' + Format(_PPN.ReturnDate, 0, '<Day,2>/<Month,2>/<Year4>') + '","' + Format(Date2DMY(_PPN.ReturnDate, 2)) + '","' + Format(Date2DMY(_PPN.ReturnDate, 3)) + '","' + Format(ROUND(_PPN.DPP, Precision, Direction)).Replace(',', '').Replace('.', '') + '","' + Format(ROUND(_PPN.VAT, Precision, Direction)).Replace(',', '').Replace('.', '') + '","0"' + _variable;
            end;
            _TxtDownload := _TxtDownload + _DataPrint1 + _DataPrint2 + _variable + _variable;
            if _PPN.FlagExport = EnumYN_FT::N then begin
                _PPN.FlagExport := EnumYN_FT::Y;
                _PPN.ExportDate := WorkDate();
                _PPN.ExportStatus := ExportStatus_FT::Exported;
                _PPN.Modify();
            end;
        end until _PPN.Next = 0;
        if _flagretur = EnumYN_FT::N then begin
            _headtxtdonlot := '"FK","KD_JENIS_TRANSAKSI","FG_PENGGANTI","NOMOR_FAKTUR","MASA_PAJAK","TAHUN_PAJAK","TANGGAL_FAKTUR","NPWP","NAMA","ALAMAT_LENGKAP","JUMLAH_DPP","JUMLAH_PPN","JUMLAH_PPNBM","ID_KETERANGAN_TAMBAHAN","FG_UANG_MUKA","UANG_MUKA_DPP","UANG_MUKA_PPN","UANG_MUKA_PPNBM","REFERENSI","KODE_DOKUMEN_PENDUKUNG"' + _variable + '"LT","NPWP","NAMA","JALAN","BLOK","NOMOR","RT","RW","KECAMATAN","KELURAHAN","KABUPATEN","PROPINSI","KODE_POS","NOMOR_TELEPON"' + _variable + '"OF","KODE_OBJEK","DESKRIPSI","HARGA_SATUAN","JUMLAH_BARANG","HARGA_TOTAL","DISKON","DPP","PPN","TARIF_PPNBM","PPNBM"' + _variable;
        end
        else begin
            _headtxtdonlot := '"RK","NPWP","NAMA","KD_JENIS_TRANSAKSI","FG_PENGGANTI","NOMOR_FAKTUR","TANGGAL_FAKTUR","NOMOR_DOKUMEN_RETUR","TANGGAL_RETUR","MASA_PAJAK_RETUR","TAHUN_PAJAK_RETUR"," NILAI_RETUR_DPP"," NILAI_RETUR_PPN"," NILAI_RETUR_PPNBM"' + _variable;
        end;
        _TxtDownload := _headtxtdonlot + _TxtDownload;
        _outstream.WriteText(_TxtDownload);
        _TempBlob.CreateInStream(_instream);
        if DownloadFromStream(_instream, '', '', '', _fileName) then begin
        end;
    end;

    local procedure getExchageRate(iCurr: Code[20]; iPostingDate: Date): Decimal
    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        CalculatedExchRate: Decimal;
        GeneralLedgerSetup: Record "General Ledger Setup";
        CurrExch: Code[20];
        LocalCurr: Code[20];
    begin
        Clear(CalculatedExchRate);
        Clear(CurrencyExchangeRate);
        CalculatedExchRate := 1;
        LocalCurr := 'IDR';
        CurrExch := iCurr;
        GeneralLedgerSetup.Get();
        if iCurr = '' then
            CurrExch := GeneralLedgerSetup."LCY Code";
        if CurrExch = GeneralLedgerSetup."LCY Code" then begin
            CurrencyExchangeRate.FindCurrency(iPostingDate, LocalCurr, 1);
            CalculatedExchRate := CurrencyExchangeRate."Exchange Rate Amount";
        end;
        exit(CalculatedExchRate);
    end;

    var
        TempData: Text;
        CurrData: Text;
        FakturPajak: Codeunit "Faktur Pajak_FT";
}
