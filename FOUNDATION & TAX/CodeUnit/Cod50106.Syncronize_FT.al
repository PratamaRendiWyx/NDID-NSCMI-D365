codeunit 50106 Syncronize_FT
{
    //Permissions = TableData "Sales Invoice Header" = rmid;
    //TableNo = "Sales Invoice Header";
    Permissions = TableData "Sales Invoice Header" = rm,
        tabledata "Sales Cr.Memo Header" = rm,
        tabledata "Purch. Inv. Header" = rm,
        tabledata "Purch. Cr. Memo Hdr." = rm;
    //tabledata "Sales Cr.Memo Header" = rm;

    //sales check flag transfer 
    /*local procedure checkFlagTransferSales(var iRecPenampung: Record Penampung_FT): Boolean
    var
        _HeaderCrMemo: Record "Sales Cr.Memo Header";
        _HeaderInvc: Record "Sales Invoice Header";
        o_result: Boolean;
        var_RecPenampung: Record Penampung_FT;
        var_invoiceno: Text;
    begin
        //iniate
        o_result := false;
        //credit memo
        Clear(_HeaderCrMemo);
        _HeaderCrMemo.Reset();
        _HeaderCrMemo.SetRange("No.", iRecPenampung.InvoiceNo);
        if _HeaderCrMemo.Find('-') then begin
            if _HeaderCrMemo.FlagTransfer_FT = _HeaderCrMemo.FlagTransfer_FT::Y then begin
                o_result := true;
            end
        end;
        //sales invoice
        Clear(_HeaderInvc);
        _HeaderInvc.Reset();
        _HeaderInvc.SetRange("No.", iRecPenampung.InvoiceNo);
        if _HeaderInvc.Find('-') then begin
            if _HeaderInvc.FlagTransfer_FT = _HeaderInvc.FlagTransfer_FT::Y then begin
                o_result := true;
            end;
        end;

        if o_result then begin
            //update
            Clear(var_RecPenampung);
            var_RecPenampung.Reset();
            var_RecPenampung.SetRange(InvoiceNo, iRecPenampung.InvoiceNo);
            if var_RecPenampung.FindSet() then begin
                repeat
                    var_RecPenampung.FlagTransfer := var_RecPenampung.FlagTransfer::Y;
                    var_RecPenampung.Modify();
                until var_RecPenampung.Next() = 0;
            end;
        end;
        exit(o_result);
    end;
    */

    procedure CheckPrefix(iInvoiceNo: Code[20]; Prefix: Code[10]): Boolean
    var
        IsPrefixPresent: Boolean;
    begin
        IsPrefixPresent := false;
        if CopyStr(iInvoiceNo, 1, StrLen(Prefix)) = Prefix then
            IsPrefixPresent := true;
        exit(IsPrefixPresent);
    end;

    local procedure checkStatusCancel(iDocumentNo: Text): Boolean
    var
        PostedSalesInvoice: Record "Sales Invoice Header";
    begin
        Clear(PostedSalesInvoice);
        PostedSalesInvoice.SetRange("No.", iDocumentNo);
        PostedSalesInvoice.SetRange(Cancelled, true);
        if PostedSalesInvoice.Find('-') then
            exit(true);
        exit(false);
    end;

    procedure SynDataPenampungToPPN(): Text
    begin
        // _RecPenampung.SetFilter(FlagTransfer, 'N');
        _RecPenampung.SetRange(FlagTransfer, _RecPenampung.FlagTransfer::N);
        if _RecPenampung.FindSet then begin
            //Message('jumlah record head' + Format(_RecPenampung.Count));
            _countHEAD := 0;
            repeat begin
                if Not (CheckPrefix(_RecPenampung.InvoiceNo, 'SIE') OR CheckPrefix(_RecPenampung.InvoiceNo, 'CN') OR checkStatusCancel(_RecPenampung.InvoiceNo)) then begin
                    //_RecPPN.RecID := getNextRecIdPPN();
                    //Message('recPPN ' + Format(_RecPPN.RecID));
                    Clear(_RecPPN);
                    _RecPPN.AccountNo := _RecPenampung.AccountNo;
                    _RecPPN."Source Name" := _RecPenampung."Source Name";
                    _RecPPN.FlagTaxType := _RecPenampung.FlagTaxType;
                    _RecPPN.InvoiceNo := _RecPenampung.InvoiceNo;
                    _RecPPN.InvoiceDate := _RecPenampung.InvoiceDate;
                    _RecPPN.FPPengganti := _RecPenampung.FPPengganti;
                    _RecPPN.FlagRetur := _RecPenampung.FlagRetur;
                    _RecPPN.TaxNumber := _RecPenampung.TaxNumber;
                    _RecPPN.TaxDate := _RecPenampung.TaxDate;
                    _RecPPN.ReturnTaxNo := _RecPenampung.ReturnTaxNo;
                    _RecPPN.ReturnDocNo := _RecPenampung.ReturnDocNo;
                    _RecPPN.ReturnDate := _RecPenampung.ReturnDate;
                    _RecPPN.NPWP := _RecPenampung.NPWP;
                    _RecPPN.Nama := _RecPenampung.Nama;
                    _RecPPN.Address := _RecPenampung.Address;
                    _RecPPN.Currency := _RecPenampung.Currency;
                    _RecPPN.InvoiceAmt := _RecPenampung.InvoiceAmt;
                    _RecPPN.DPP := _RecPenampung.DPP;
                    _RecPPN.VAT := _RecPenampung.VAT;
                    _RecPPN.VatBusPostGroup := _RecPenampung.VatBusPostGroup;
                    _RecPPN.VatProdPostGroup := _RecPenampung.VatProdPostGroup;
                    _RecPPN.VatCalType := _RecPenampung.VatCalType;
                    _RecPPN.FlagExport := EnumYN_FT::N;
                    //Message(Format('before Insert Head' + _RecPPN.InvoiceNo));
                    if _RecPPN.Insert() then begin
                        //Message(Format('Inserted Head' + _RecPPN.InvoiceNo));
                        //if true then begin
                        _PenampungDtl.SetFilter(_PenampungDtl.InvoiceNo, _RecPenampung.InvoiceNo);
                        if _PenampungDtl.FindSet() then begin
                            //Message('jumlah record line: ' + Format(_PenampungDtl.Count));
                            repeat begin
                                //_PpnDetail.RecId := getNextRecIdPPNDtl();
                                //Message('recPPN ' + Format(_PpnDetail.RecID));
                                Clear(_PpnDetail);
                                _PpnDetail.LineNo := _PenampungDtl.LineNo;
                                _PpnDetail.InvoiceNo := _PenampungDtl.InvoiceNo;
                                _PpnDetail.Type := _PenampungDtl.Type;
                                _PpnDetail.ItemID := _PenampungDtl.ItemID;
                                _PpnDetail.Description := _PenampungDtl.Description;
                                _PpnDetail.VatBusPostGroup := _PenampungDtl.VatBusPostGroup;
                                _PpnDetail.VatProdPostGroup := _PenampungDtl.VatProdPostGroup;
                                _PpnDetail.VatIdentifier := _PenampungDtl.VatIdentifier;
                                _PpnDetail.Price := _PenampungDtl.Price;
                                _PpnDetail.QtyDecimal := _PenampungDtl.QtyDecimal;
                                _PpnDetail.TotAmt := _PenampungDtl.TotAmt;
                                _PpnDetail.DiscAmt := _PenampungDtl.DiscAmt;
                                _PpnDetail.DPPAmt := _PenampungDtl.DPPAmt;
                                _PpnDetail.VatAmt := _PenampungDtl.VatAmt;
                                if _PpnDetail.Insert() then begin //test aja
                                                                  //if true then begin
                                                                  //Message('Inserted detail ' + _PpnDetail.InvoiceNo + ' ' + Format(_PpnDetail.LineNo));
                                                                  //--------------------------------------------------------- FLAG TRANSFER PENAMPUNG ---------------------------------------------------
                                                                  /*
                                                                  _RecPenampung.FlagTransfer := EnumYN_FT::Y;
                                                                  _RecPenampung.Modify();
                                                                  */
                                end
                                else begin
                                    exit('false');
                                    //Message('Failed Sync detail Invoice : ' + _RecPPN.InvoiceNo);
                                end;
                            end until _PenampungDtl.Next = 0;
                        end;
                        _RecPenampung.FlagTransfer := EnumYN_FT::Y;
                        _RecPenampung.Modify();
                    end
                    else begin
                        //Message('Failed Sync Invoice : ' + _RecPPN.InvoiceNo);
                        exit('false');
                    end;
                end;
            end until _RecPenampung.Next = 0;
            exit('true');
        end
        else begin
            exit('NoData');
        end;
    end;
    // local procedure getNextRecIdPPN(): Text
    // var
    //     myInt: Integer;
    // begin
    //     _RecPPN.Reset();
    //     if (_RecPPN.find('+')) then begin
    //         exit(IncStr(_RecPPN.RecID));
    //     end else begin
    //         exit('0000000000000000000000001');
    //     end;
    // end;
    // procedure getNextRecIdPPNDtl(): Text
    // var
    //     myInt: Integer;
    // begin
    //     _RecPPNDtl.Reset();
    //     if (_RecPPNDtl.find('+')) then begin
    //         exit(IncStr(_RecPPNDtl.RecID));
    //     end else begin
    //         exit('0000000000000000000000001');
    //     end;
    // end;
    procedure SyncSalesInvcHdrtoPenampung(): Text
    var
        myInt: Integer;
        TaxSetup: Boolean;
        _HeaderInvc: Record "Sales Invoice Header";
        _Penampung: Record Penampung_FT;
        _PenampungDtl: Record PenampungDetail_FT;
        _HeaderInvcDtl: Record "Sales Invoice Line";
        flgtransfer: Text;
        _Custmr: Record Customer;
        DiskonAmount: Decimal;
        DiskonResource: Decimal;
        TotAmountLine: Decimal;
    begin
        flgtransfer := '';
        //_RecPenampung.SetFilter(FlagTransfer, 'N');
        _HeaderInvc.SetFilter(FlagTransfer_FT, Format(EnumYN_FT::N));
        _HeaderInvc.SetFilter("No.", '<>SIE*');
        _HeaderInvc.SetFilter(Cancelled, '<>%1', true);
        if _HeaderInvc.FindSet then begin
            //Message(Format(_HeaderInvc.Count));
            repeat begin
                //Message(Format(_HeaderInvc."No."));
                //_Penampung.RecID := getNextRecIdPenampung();
                Clear(_Penampung);
                _Penampung.FlagTaxType := EnumInOut_FT::Out;
                _Penampung.InvoiceNo := _HeaderInvc."No.";
                _Penampung.InvoiceDate := _HeaderInvc."Document Date";
                if _HeaderInvc.Corrective then begin
                    _Penampung.FPPengganti := EnumYN_FT::Y; // .Corrective;
                end
                else begin
                    _Penampung.FPPengganti := EnumYN_FT::N; // .Corrective;
                end;
                _Penampung.FlagRetur := EnumYN_FT::N;
                _Penampung.TaxNumber := '';
                _Penampung.TaxDate := _HeaderInvc."Document Date";
                // _Penampung.ReturnTaxNo := _HeaderInvc.ReturnTaxNo_FT;
                // _Penampung.ReturnDocNo := _HeaderInvc.ReturnDocNo_FT;
                // _Penampung.ReturnDate := _HeaderInvc.ReturnDate_FT;
                _Penampung.AccountNo := _HeaderInvc."Bill-to Customer No.";
                _Penampung."Source Name" := _HeaderInvc."Bill-to Name";
                _Custmr.Reset();
                _Custmr.SetFilter("No.", _HeaderInvc."Bill-to Customer No.");
                if _Custmr.FindSet then begin
                    //Message(Format(_Custmr.Count) + ' : ' + _Custmr."NPWP No_FT");
                    _Penampung.NPWP := _Custmr."NPWP No_FT";
                    _Penampung.Nama := _Custmr."NPWP Nama_FT";
                    _Penampung.Address := _Custmr."NPWP Alamat_FT";
                end;
                //_Penampung.Nama := _HeaderInvc."Sell-to Customer Name";
                //_Penampung.Address := _HeaderInvc."Sell-to Address";
                _Penampung.Currency := _HeaderInvc."Currency Code";
                _Penampung.InvoiceAmt := 0; //_HeaderInvc."Amount Including VAT";
                _Penampung.DPP := 0; //CalculateDPPSalesInvcHdr(_HeaderInvc."No.", _HeaderInvc."VAT Bus. Posting Group");
                _Penampung.VAT := 0; //CalculateVATSalesInvcHdr(_HeaderInvc."No."); //_HeaderInvc."Amount Including VAT" - _HeaderInvc.Amount;
                _Penampung.VatBusPostGroup := _HeaderInvc."VAT Bus. Posting Group";
                _Penampung.VatProdPostGroup := '';
                _Penampung.VatCalType := '';
                _Penampung.FlagTransfer := EnumYN_FT::N;
                DiskonAmount := diskonAmount(_HeaderInvc."No.");
                DiskonResource := DiskonResource(_HeaderInvc."No.");
                //TotAmountLine := totlineamount(_HeaderInvc."No.");
                TotAmountLine := totlineamountexclcudeVAT(_HeaderInvc."No.");
                if _Penampung.Insert() then begin
                    _HeaderInvcDtl.SetFilter("Document No.", _HeaderInvc."No.");
                    _HeaderInvcDtl.SetFilter(Type, '<>%1', _HeaderInvcDtl.Type::Resource);
                    if _HeaderInvcDtl.FindSet() then begin
                        repeat begin
                            if IsDPPPercentage(_HeaderInvcDtl."VAT Prod. Posting Group", _HeaderInvcDtl."VAT Bus. Posting Group") then begin
                                //_PenampungDtl.RecId := getNextRecIdPenampungDtl();
                                Clear(_PenampungDtl);
                                _PenampungDtl.LineNo := _HeaderInvcDtl."Line No.";
                                _PenampungDtl.InvoiceNo := _HeaderInvcDtl."Document No.";
                                _PenampungDtl.Type := _HeaderInvcDtl.Type.AsInteger();
                                _PenampungDtl.ItemID := _HeaderInvcDtl."No.";
                                _PenampungDtl.Description := _HeaderInvcDtl.Description;
                                _PenampungDtl.VatBusPostGroup := _HeaderInvcDtl."VAT Bus. Posting Group";
                                _PenampungDtl.VatProdPostGroup := _HeaderInvcDtl."VAT Prod. Posting Group";
                                _PenampungDtl.VatIdentifier := _HeaderInvcDtl."VAT Identifier";
                                _PenampungDtl.Price := _HeaderInvcDtl."Unit Price";
                                _PenampungDtl.QtyDecimal := _HeaderInvcDtl.Quantity;
                                _PenampungDtl.DiscAmt := _HeaderInvcDtl."Line Discount Amount";
                                _prcentageDPP := NilaiPercentageDPP(_PenampungDtl.VatProdPostGroup);
                                if _prcentageDPP > 0 then begin
                                    _PenampungDtl.DPPAmt := _HeaderInvcDtl.Amount * (_prcentageDPP / 100);
                                end
                                else begin
                                    _PenampungDtl.DPPAmt := _HeaderInvcDtl.Amount;
                                end;
                                _PenampungDtl.VatAmt := _HeaderInvcDtl."Amount Including VAT" - _HeaderInvcDtl.Amount;
                                //_PenampungDtl.TotAmt := _PenampungDtl.DPPAmt + _PenampungDtl.VatAmt;
                                _PenampungDtl.TotAmt := _PenampungDtl.Price * _PenampungDtl.QtyDecimal;
                                if (DiskonAmount > 0) or (DiskonResource > 0) then begin
                                    //_PenampungDtl.DiscAmt := _PenampungDtl.DiscAmt + ((DiskonAmount + DiskonResource) * _PenampungDtl.TotAmt / TotAmountLine);
                                    _PenampungDtl.DiscAmt := _PenampungDtl.DiscAmt + ((DiskonAmount + DiskonResource) * _HeaderInvcDtl.Amount / TotAmountLine);
                                    _penampungDtl.DPPAmt := _penampungDtl.TotAmt - _penampungDtl.DiscAmt;
                                    _penampungDtl.VatAmt := _penampungDtl.DPPAmt * (_HeaderInvcDtl."VAT %" / 100);
                                    //_PenampungDtl.TotAmt := _PenampungDtl.TotAmt - _PenampungDtl.DiscAmt;
                                end;
                                if _PenampungDtl.Insert() then begin
                                    // _HeaderInvc.FlagTransfer_FT := 1; //EnumYN_FT::Y;
                                    // _HeaderInvc.Modify();
                                    //Message('modify sales header invoice ' + _HeaderInvc."No.");
                                end
                                else begin
                                    exit('false');
                                end;
                                _Penampung.DPP := _Penampung.DPP + _PenampungDtl.DPPAmt;
                                _Penampung.VAT := _Penampung.VAT + _PenampungDtl.VatAmt;
                            end;
                        end until _HeaderInvcDtl.Next = 0;
                        _HeaderInvc.FlagTransfer_FT := EnumYN_FT::Y;
                        _HeaderInvc.Modify();
                        _Penampung.InvoiceAmt := _Penampung.DPP + _Penampung.VAT;
                        _Penampung.Modify();
                    end;
                end
                else begin
                    exit('false');
                end;
            end until _HeaderInvc.Next = 0;
            exit('true');
        end
        else begin
            //kalo ga ada data return null aja
            exit('NoData');
        end; //;
    end;

    procedure SyncSalesCrMemoHdrtoPenampung(): Text
    var
        myInt: Integer;
        TaxSetup: Boolean;
        _HeaderCrMemo: Record "Sales Cr.Memo Header";
        _Penampung: Record Penampung_FT;
        _PenampungDtl: Record PenampungDetail_FT;
        _HeaderCrMemoDtl: Record "Sales Cr.Memo Line";
        _Custmr: Record Customer;
    begin
        _HeaderCrMemo.SetFilter(FlagTransfer_FT, Format(EnumYN_FT::N));
        _HeaderCrMemo.SetFilter("No.", '<>CN*');
        if _HeaderCrMemo.FindSet then begin
            repeat begin
                //isinya
                //Message(Format(_HeaderInvc."No."));
                //_Penampung.RecID := getNextRecIdPenampung();
                Clear(_Penampung);
                _Penampung.FlagTaxType := EnumInOut_FT::Out;
                _Penampung.InvoiceNo := _HeaderCrMemo."No.";
                _Penampung.InvoiceDate := _HeaderCrMemo."Document Date";
                if _HeaderCrMemo.Corrective then begin
                    _Penampung.FPPengganti := EnumYN_FT::Y; // .Corrective;
                end
                else begin
                    _Penampung.FPPengganti := EnumYN_FT::N; // .Corrective;
                end;
                _Penampung.FlagRetur := EnumYN_FT::Y;
                //_Penampung.TaxNumber := '';
                //_Penampung.TaxDate := _HeaderCrMemo."Document Date";
                _Penampung.ReturnTaxNo := _HeaderCrMemo.ReturnTaxNo_FT;
                _Penampung.ReturnDocNo := _HeaderCrMemo.ReturnDocNo_FT;
                _Penampung.ReturnDate := _HeaderCrMemo.ReturnDate_FT;
                _Penampung.AccountNo := _HeaderCrMemo."Bill-to Customer No.";
                _Penampung."Source Name" := _HeaderCrMemo."Bill-to Name";
                _Custmr.Reset();
                _Custmr.SetFilter("No.", _HeaderCrMemo."Bill-to Customer No.");
                if _Custmr.FindSet then begin
                    //Message(Format(_Custmr.Count));
                    _Penampung.NPWP := _Custmr."NPWP No_FT";
                    _Penampung.Nama := _Custmr."NPWP Nama_FT";
                    _Penampung.Address := _Custmr."NPWP Alamat_FT";
                end;
                //_Penampung.Nama := _HeaderCrMemo."Sell-to Customer Name";
                //_Penampung.Address := _HeaderCrMemo."Sell-to Address";
                _Penampung.Currency := _HeaderCrMemo."Currency Code";
                _Penampung.InvoiceAmt := 0; // _HeaderCrMemo."Amount Including VAT";
                _Penampung.DPP := 0; //CalculateDPPSalesCrMemo(_HeaderCrMemo."No.", _HeaderCrMemo."VAT Bus. Posting Group");
                _Penampung.VAT := 0; //CalculateVATSalesCrMemo(_HeaderCrMemo."No.");//_HeaderCrMemo."Amount Including VAT" - _HeaderCrMemo.Amount;
                //Message(_Penampung.InvoiceNo + ' VAT ' + Format(_Penampung.VAT) + ' tes ' + Format(_HeaderCrMemo."Amount Including VAT") + ' ' + Format(_HeaderCrMemo.Amount));
                _Penampung.VatBusPostGroup := _HeaderCrMemo."VAT Bus. Posting Group";
                _Penampung.VatProdPostGroup := '';
                _Penampung.VatCalType := '';
                _Penampung.FlagTransfer := EnumYN_FT::N;
                if _Penampung.Insert() then begin
                    _HeaderCrMemoDtl.SetFilter("Document No.", _HeaderCrMemo."No.");
                    if _HeaderCrMemoDtl.FindSet then begin
                        repeat begin
                            if IsDPPPercentage(_HeaderCrMemoDtl."VAT Prod. Posting Group", _HeaderCrMemoDtl."VAT Bus. Posting Group") then begin
                                //isinya
                                //_PenampungDtl.RecId := getNextRecIdPenampungDtl();
                                Clear(_PenampungDtl);
                                _PenampungDtl.LineNo := _HeaderCrMemoDtl."Line No.";
                                _PenampungDtl.InvoiceNo := _HeaderCrMemoDtl."Document No.";
                                _PenampungDtl.Type := _HeaderCrMemoDtl.Type.AsInteger();
                                _PenampungDtl.ItemID := _HeaderCrMemoDtl."No.";
                                _PenampungDtl.Description := _HeaderCrMemoDtl.Description;
                                _PenampungDtl.VatBusPostGroup := _HeaderCrMemoDtl."VAT Bus. Posting Group";
                                _PenampungDtl.VatProdPostGroup := _HeaderCrMemoDtl."VAT Prod. Posting Group";
                                _PenampungDtl.VatIdentifier := _HeaderCrMemoDtl."VAT Identifier";
                                _PenampungDtl.Price := _HeaderCrMemoDtl."Unit Price";
                                _PenampungDtl.QtyDecimal := _HeaderCrMemoDtl.Quantity;
                                _PenampungDtl.DiscAmt := _HeaderCrMemoDtl."Line Discount Amount";
                                _prcentageDPP := NilaiPercentageDPP(_PenampungDtl.VatProdPostGroup);
                                if _prcentageDPP > 0 then begin
                                    _PenampungDtl.DPPAmt := _HeaderCrMemoDtl.Amount * (_prcentageDPP / 100);
                                end
                                else begin
                                    _PenampungDtl.DPPAmt := _HeaderCrMemoDtl.Amount;
                                end;
                                _PenampungDtl.VatAmt := _HeaderCrMemoDtl."Amount Including VAT" - _HeaderCrMemoDtl.Amount;
                                //_PenampungDtl.TotAmt := _PenampungDtl.DPPAmt + _PenampungDtl.VatAmt;
                                _PenampungDtl.TotAmt := _PenampungDtl.Price * _PenampungDtl.QtyDecimal;
                                if _PenampungDtl.Insert() then begin
                                end
                                else begin
                                    exit('false');
                                end;
                                _Penampung.DPP := _Penampung.DPP + _PenampungDtl.DPPAmt;
                                _Penampung.VAT := _Penampung.VAT + _PenampungDtl.VatAmt;
                            end;
                        end until _HeaderCrMemoDtl.Next = 0;
                        _HeaderCrMemo.FlagTransfer_FT := EnumYN_FT::Y;
                        _HeaderCrMemo.Modify();
                        _Penampung.InvoiceAmt := _Penampung.DPP + _Penampung.VAT;
                        _Penampung.Modify();
                    end;
                end
                else begin
                    exit('false');
                end;
            end until _HeaderCrMemo.Next = 0;
            exit('true');
        end
        else begin
            exit('NoData');
        end;
    end;

    procedure SyncPurcInvtoPenampung(): Text
    var
        myInt: Integer;
        TaxSetup: Boolean;
        _HeaderCrMemo: Record "Purch. Inv. Header";
        _Penampung: Record Penampung_FT;
        _PenampungDtl: Record PenampungDetail_FT;
        _HeaderCrMemoDtl: Record "Purch. Inv. Line";
        _Vndr: Record Vendor;
    begin
        _HeaderCrMemo.SetFilter(FlagTransfer_FT, Format(EnumYN_FT::N));
        _HeaderCrMemo.SetFilter(Cancelled, '<>%1', true);
        if _HeaderCrMemo.FindSet then begin
            repeat begin
                if not checkPIOnCreditMemo(_HeaderCrMemo."No.") then begin
                    //isinya
                    //Message(Format(_HeaderInvc."No."));
                    Clear(_Penampung);
                    //_Penampung.RecID := getNextRecIdPenampung();
                    _Penampung.FlagTaxType := EnumINOUT_FT::Input;
                    _Penampung.InvoiceNo := _HeaderCrMemo."No.";
                    _Penampung.InvoiceDate := _HeaderCrMemo."Document Date";
                    if _HeaderCrMemo.Corrective then begin
                        _Penampung.FPPengganti := EnumYN_FT::Y; // .Corrective;
                    end
                    else begin
                        _Penampung.FPPengganti := EnumYN_FT::N; // .Corrective;
                    end;
                    _Penampung.FlagRetur := EnumYN_FT::N;
                    _Penampung.TaxNumber := _HeaderCrMemo."Tax Number_FT";
                    _Penampung.TaxDate := _HeaderCrMemo."Tax Date_FT";
                    _Penampung.AccountNo := _HeaderCrMemo."Pay-to Vendor No.";
                    _Penampung."Source Name" := _HeaderCrMemo."Pay-to Name";
                    _Vndr.Reset();
                    _Vndr.SetFilter("No.", _HeaderCrMemo."Pay-to Vendor No.");
                    if _Vndr.FindSet then begin
                        //Message(Format(_Custmr.Count));
                        _Penampung.NPWP := _Vndr."NPWP No_FT";
                        _Penampung.Nama := _Vndr."NPWP Nama_FT";
                        _Penampung.Address := _Vndr."NPWP Alamat_FT";
                    end;
                    //_Penampung.Nama := _HeaderCrMemo."Pay-to Name";
                    //_Penampung.Address := _HeaderCrMemo."Pay-to Address";
                    _Penampung.Currency := _HeaderCrMemo."Currency Code";
                    _Penampung.InvoiceAmt := 0; //_HeaderCrMemo. "Amount Including VAT";
                    _Penampung.DPP := 0; // CalculateDPPPurchInvcHdr(_HeaderCrMemo."No.", _HeaderCrMemo."VAT Bus. Posting Group");
                    _Penampung.VAT := 0; // CalculateVATPurchInvcHdr(_HeaderCrMemo."No.");//_HeaderCrMemo."Amount Including VAT" - _HeaderCrMemo.Amount;
                    _Penampung.VatBusPostGroup := _HeaderCrMemo."VAT Bus. Posting Group";
                    _Penampung.VatProdPostGroup := '';
                    _Penampung.VatCalType := '';
                    _Penampung.FlagTransfer := EnumYN_FT::N;
                    //Message('insert before penampung');
                    if _Penampung.Insert() then begin
                        //Message('insert penampung');
                        _HeaderCrMemoDtl.SetFilter("Document No.", _HeaderCrMemo."No.");
                        if _HeaderCrMemoDtl.FindSet then begin
                            repeat begin
                                if IsDPPPercentage(_HeaderCrMemoDtl."VAT Prod. Posting Group", _HeaderCrMemoDtl."VAT Bus. Posting Group") then begin
                                    //isinya
                                    //_PenampungDtl.RecId := getNextRecIdPenampungDtl();
                                    Clear(_PenampungDtl);
                                    _PenampungDtl.LineNo := _HeaderCrMemoDtl."Line No.";
                                    _PenampungDtl.InvoiceNo := _HeaderCrMemoDtl."Document No.";
                                    _PenampungDtl.Type := _HeaderCrMemoDtl.Type.AsInteger();
                                    _PenampungDtl.ItemID := _HeaderCrMemoDtl."No.";
                                    _PenampungDtl.Description := _HeaderCrMemoDtl.Description;
                                    _PenampungDtl.VatBusPostGroup := _HeaderCrMemoDtl."VAT Bus. Posting Group";
                                    _PenampungDtl.VatProdPostGroup := _HeaderCrMemoDtl."VAT Prod. Posting Group";
                                    _PenampungDtl.VatIdentifier := _HeaderCrMemoDtl."VAT Identifier";
                                    _PenampungDtl.Price := _HeaderCrMemoDtl."Direct Unit Cost";
                                    _PenampungDtl.QtyDecimal := _HeaderCrMemoDtl.Quantity;
                                    _PenampungDtl.DiscAmt := _HeaderCrMemoDtl."Line Discount Amount";
                                    _prcentageDPP := 0;
                                    _prcentageDPP := NilaiPercentageDPP(_PenampungDtl.VatProdPostGroup);
                                    if _prcentageDPP > 0 then begin
                                        _PenampungDtl.DPPAmt := _HeaderCrMemoDtl.Amount * (_prcentageDPP / 100);
                                    end
                                    else begin
                                        _PenampungDtl.DPPAmt := _HeaderCrMemoDtl.Amount;
                                    end;
                                    _PenampungDtl.VatAmt := _HeaderCrMemoDtl."Amount Including VAT" - _HeaderCrMemoDtl.Amount;
                                    //_PenampungDtl.TotAmt := _PenampungDtl.DPPAmt + _PenampungDtl.VatAmt;
                                    _PenampungDtl.TotAmt := _PenampungDtl.Price * _PenampungDtl.QtyDecimal;
                                    if _PenampungDtl.Insert() then begin
                                    end
                                    else begin
                                        exit('false');
                                    end;
                                    _Penampung.DPP := _Penampung.DPP + _PenampungDtl.DPPAmt;
                                    _Penampung.VAT := _Penampung.VAT + _PenampungDtl.VatAmt;
                                    // Message('jml DPP : ' + Format(_Penampung.DPP));
                                    // Message('jml VAT : ' + Format(_Penampung.VAT));
                                end;
                            end until _HeaderCrMemoDtl.Next = 0;
                        end;
                        _HeaderCrMemo.FlagTransfer_FT := EnumYN_FT::Y;
                        _HeaderCrMemo.Modify();
                        _Penampung.InvoiceAmt := _Penampung.DPP + _Penampung.VAT;
                        _Penampung.Modify();
                    end
                    else begin
                        exit('false');
                    end;
                end;
            end until _HeaderCrMemo.Next = 0;
            exit('true');
        end
        else begin
            exit('NoData');
        end;
    end;

    local procedure checkPIOnCreditMemo(var iPINo: Code[20]): Boolean
    var
        PosteCRMemo: Record "Purch. Cr. Memo Hdr.";
    begin
        Clear(PosteCRMemo);
        PosteCRMemo.Reset();
        PosteCRMemo.SetRange("Applies-to Doc. No.", iPINo);
        if PosteCRMemo.Find('-') then
            exit(true);
        exit(false);
    end;

    procedure SyncPurcCrMemotoPenampung(): Text
    var
        myInt: Integer;
        TaxSetup: Boolean;
        _HeaderCrMemo: Record "Purch. Cr. Memo Hdr.";
        _Penampung: Record Penampung_FT;
        _PenampungDtl: Record PenampungDetail_FT;
        _HeaderCrMemoDtl: Record "Purch. Cr. Memo Line";
        //_Custmr: Record Customer;
        _Vndr: Record Vendor;
    begin
        _HeaderCrMemo.SetFilter(FlagTransfer_FT, Format(EnumYN_FT::N));
        if _HeaderCrMemo.FindSet then begin
            repeat begin
                //isinya
                //Message(Format(_HeaderInvc."No."));
                //_Penampung.RecID := getNextRecIdPenampung();
                Clear(_Penampung);
                _Penampung.FlagTaxType := EnumINOUT_FT::Input;
                _Penampung.InvoiceNo := _HeaderCrMemo."No.";
                _Penampung.InvoiceDate := _HeaderCrMemo."Document Date";
                if _HeaderCrMemo.Corrective then begin
                    _Penampung.FPPengganti := EnumYN_FT::Y; // .Corrective;
                end
                else begin
                    _Penampung.FPPengganti := EnumYN_FT::N; // .Corrective;
                end;
                _Penampung.FlagRetur := EnumYN_FT::Y;
                //_Penampung.TaxNumber := _HeaderCrMemo."Tax Number_FT";
                //_Penampung.TaxDate := _HeaderCrMemo."Tax Date_FT";
                _Penampung.ReturnTaxNo := _HeaderCrMemo.ReturnTaxNo_FT;
                _Penampung.ReturnDocNo := _HeaderCrMemo.ReturnDocNo_FT;
                _Penampung.ReturnDate := _HeaderCrMemo.ReturnDate_FT;
                _Penampung.AccountNo := _HeaderCrMemo."Pay-to Vendor No.";
                _Penampung."Source Name" := _HeaderCrMemo."Pay-to Name";
                _Vndr.Reset();
                _Vndr.SetFilter("No.", _HeaderCrMemo."Pay-to Vendor No.");
                if _Vndr.FindSet then begin
                    //Message(Format(_Custmr.Count));
                    _Penampung.NPWP := _Vndr."NPWP No_FT";
                    _Penampung.Nama := _Vndr."NPWP Nama_FT";
                    _Penampung.Address := _Vndr."NPWP Alamat_FT";
                end;
                //_Penampung.Nama := _HeaderCrMemo."Pay-to Name";
                //_Penampung.Address := _HeaderCrMemo."Pay-to Address";
                _Penampung.Currency := _HeaderCrMemo."Currency Code";
                _Penampung.InvoiceAmt := 0; // _HeaderCrMemo."Amount Including VAT";
                _Penampung.DPP := 0; // CalculateDPPPurcCrMemo(_HeaderCrMemo."No.", _HeaderCrMemo."VAT Bus. Posting Group");
                _Penampung.VAT := 0; // CalculateVATPurcCrMemo(_HeaderCrMemo."No.");//_HeaderCrMemo."Amount Including VAT" - _HeaderCrMemo.Amount;
                _Penampung.VatBusPostGroup := _HeaderCrMemo."VAT Bus. Posting Group";
                _Penampung.VatProdPostGroup := '';
                _Penampung.VatCalType := '';
                _Penampung.FlagTransfer := EnumYN_FT::N;
                if _Penampung.Insert() then begin
                    _HeaderCrMemoDtl.SetFilter("Document No.", _HeaderCrMemo."No.");
                    if _HeaderCrMemoDtl.FindSet then begin
                        repeat begin
                            if IsDPPPercentage(_HeaderCrMemoDtl."VAT Prod. Posting Group", _HeaderCrMemoDtl."VAT Bus. Posting Group") then begin
                                //isinya
                                //_PenampungDtl.RecId := getNextRecIdPenampungDtl();
                                Clear(_PenampungDtl);
                                _PenampungDtl.LineNo := _HeaderCrMemoDtl."Line No.";
                                _PenampungDtl.InvoiceNo := _HeaderCrMemoDtl."Document No.";
                                _PenampungDtl.Type := _HeaderCrMemoDtl.Type.AsInteger();
                                _PenampungDtl.ItemID := _HeaderCrMemoDtl."No.";
                                _PenampungDtl.Description := _HeaderCrMemoDtl.Description;
                                _PenampungDtl.VatBusPostGroup := _HeaderCrMemoDtl."VAT Bus. Posting Group";
                                _PenampungDtl.VatProdPostGroup := _HeaderCrMemoDtl."VAT Prod. Posting Group";
                                _PenampungDtl.VatIdentifier := _HeaderCrMemoDtl."VAT Identifier";
                                _PenampungDtl.Price := _HeaderCrMemoDtl."Direct Unit Cost";
                                _PenampungDtl.QtyDecimal := _HeaderCrMemoDtl.Quantity;
                                _PenampungDtl.DiscAmt := _HeaderCrMemoDtl."Line Discount Amount";
                                _prcentageDPP := NilaiPercentageDPP(_PenampungDtl.VatProdPostGroup);
                                if _prcentageDPP > 0 then begin
                                    _PenampungDtl.DPPAmt := _HeaderCrMemoDtl.Amount * (_prcentageDPP / 100);
                                end
                                else begin
                                    _PenampungDtl.DPPAmt := _HeaderCrMemoDtl.Amount;
                                end;
                                _PenampungDtl.VatAmt := _HeaderCrMemoDtl."Amount Including VAT" - _HeaderCrMemoDtl.Amount;
                                //_PenampungDtl.TotAmt := _PenampungDtl.DPPAmt + _PenampungDtl.VatAmt;
                                _PenampungDtl.TotAmt := _PenampungDtl.Price * _PenampungDtl.QtyDecimal;
                                if _PenampungDtl.Insert() then begin
                                end
                                else begin
                                    exit('false');
                                end;
                                _Penampung.DPP := _Penampung.DPP + _PenampungDtl.DPPAmt;
                                //Message('jml DPP : ' + Format(_Penampung.DPP));
                                _Penampung.VAT := _Penampung.VAT + _PenampungDtl.VatAmt;
                                //Message('jml VAT : ' + Format(_Penampung.VAT));
                            end;
                        end until _HeaderCrMemoDtl.Next = 0;
                        _HeaderCrMemo.FlagTransfer_FT := EnumYN_FT::Y;
                        _HeaderCrMemo.Modify();
                        _Penampung.InvoiceAmt := _Penampung.DPP + _Penampung.VAT;
                        _Penampung.Modify();
                    end;
                end
                else begin
                    exit('false');
                end;
            end until _HeaderCrMemo.Next = 0;
            exit('true');
        end
        else begin
            exit('NoData');
        end;
    end;
    // local procedure getNextRecIdPenampung(): Text
    // var
    //     myInt: Integer;
    //     _RecPnmpg: Record Penampung_FT;
    // begin
    //     _RecPnmpg.Reset();
    //     if (_RecPnmpg.find('+')) then begin
    //         exit(INCSTR(_RecPnmpg.RecID));
    //     end else begin
    //         exit('0000000000000000000000001');
    //     end;
    // end;
    // procedure getNextRecIdPenampungDtl(): Text
    // var
    //     myInt: Integer;
    //     _RecPnpmgDtl: Record Penampung_FTDetail;
    // begin
    //     _RecPnpmgDtl.Reset();
    //     if (_RecPnpmgDtl.find('+')) then begin
    //         exit(IncStr(_RecPnpmgDtl.RecID));
    //     end else begin
    //         exit('0000000000000000000000001');
    //     end;
    // end;
    procedure CalculateDPPSalesInvcHdr(Invoice: Text;
    vatbusposgroup: Text): Decimal
    var
        myInt: Integer;
        _line: Record "Sales Invoice Line";
        //dev
        //_line: Record "Sales Line";
        _VATSetup: Record "VAT Posting Setup";
        _JmlDPP: Decimal;
        _noRecord: Integer;
    begin
        //Invoice := '103006';
        //vatbusposgroup := 'DOMESTIC';
        _line."Document No." := Invoice;
        _line.SetFilter(_line."Document No.", Invoice);
        if _line.FindSet then begin
            repeat begin
                // abis ini diambil vat bus posting group
                // terus di cek ada % VAT nya ga ?
                _VATSetup.SetFilter("VAT Prod. Posting Group", _line."VAT Prod. Posting Group");
                _VATSetup.SetFilter("VAT Bus. Posting Group", vatbusposgroup);
                if _VATSetup.FindSet then begin
                    //Message(_line."VAT Prod. Posting Group" + ' : vat % : ' + Format(_VATSetup."VAT %"));
                    if _VATSetup."VAT %" > 0 then begin
                        _JmlDPP := _JmlDPP + _line.Amount;
                        //Message(Format(_line.Amount));
                    end;
                end;
            end until _line.Next = 0;
        end
        else begin
        end;
        exit(_JmlDPP);
    end;

    procedure CalculateVATSalesInvcHdr(Invoice: Text): Decimal
    var
        myInt: Integer;
        _line: Record "Sales Invoice Line";
        //dev
        //_line: Record "Sales Line";
        _VATSetup: Record "VAT Posting Setup";
        _JmlVAT: Decimal;
        _noRecord: Integer;
    begin
        _line."Document No." := Invoice;
        _line.SetFilter(_line."Document No.", Invoice);
        if _line.FindSet then begin
            repeat begin
                _JmlVAT := _JmlVAT + (_line."Amount Including VAT" - _line.Amount);
            end until _line.Next = 0;
        end
        else begin
        end;
        exit(_JmlVAT);
    end;

    procedure CalculateDPPSalesCrMemo(Invoice: Text;
    vatbusposgroup: Text): Decimal
    var
        myInt: Integer;
        _line: Record "Sales Cr.Memo Line";
        //dev
        //_line: Record "Sales Line";
        _VATSetup: Record "VAT Posting Setup";
        _JmlDPP: Decimal;
        _noRecord: Integer;
    begin
        //Invoice := '103006';
        //vatbusposgroup := 'DOMESTIC';
        _line."Document No." := Invoice;
        _line.SetFilter(_line."Document No.", Invoice);
        if _line.FindSet then begin
            repeat begin
                // abis ini diambil vat bus posting group
                // terus di cek ada % VAT nya ga ?
                _VATSetup.SetFilter("VAT Prod. Posting Group", _line."VAT Prod. Posting Group");
                _VATSetup.SetFilter("VAT Bus. Posting Group", vatbusposgroup);
                //Message(Invoice + ' : ' + vatbusposgroup + ' : ' + _line."VAT Prod. Posting Group");
                if _VATSetup.FindSet then begin
                    //Message(_line."VAT Prod. Posting Group" + ' : vat % : ' + Format(_VATSetup."VAT %"));
                    if _VATSetup."VAT %" > 0 then begin
                        _JmlDPP := _JmlDPP + _line.Amount;
                        //Message(Format(_line.Amount));
                    end;
                end;
            end until _line.Next = 0;
        end
        else begin
        end;
        exit(_JmlDPP);
    end;

    procedure CalculateVATSalesCrMemo(Invoice: Text): Decimal
    var
        myInt: Integer;
        _line: Record "Sales Cr.Memo Line";
        //dev
        //_line: Record "Sales Line";
        _VATSetup: Record "VAT Posting Setup";
        _JmlVAT: Decimal;
        _noRecord: Integer;
    begin
        _line."Document No." := Invoice;
        _line.SetFilter(_line."Document No.", Invoice);
        if _line.FindSet then begin
            repeat begin
                _JmlVAT := _JmlVAT + (_line."Amount Including VAT" - _line.Amount);
            end until _line.Next = 0;
        end
        else begin
        end;
        exit(_JmlVAT);
    end;

    procedure CalculateDPPPurchInvcHdr(Invoice: Text;
    vatbusposgroup: Text): Decimal
    var
        myInt: Integer;
        _line: Record "Purch. Inv. Line";
        //dev
        //_line: Record "Sales Line";
        _VATSetup: Record "VAT Posting Setup";
        _JmlDPP: Decimal;
        _noRecord: Integer;
    begin
        //Invoice := '103006';
        //vatbusposgroup := 'DOMESTIC';
        _line."Document No." := Invoice;
        _line.SetFilter(_line."Document No.", Invoice);
        if _line.FindSet then begin
            repeat begin
                // abis ini diambil vat bus posting group
                // terus di cek ada % VAT nya ga ?
                _VATSetup.SetFilter("VAT Prod. Posting Group", _line."VAT Prod. Posting Group");
                _VATSetup.SetFilter("VAT Bus. Posting Group", vatbusposgroup);
                if _VATSetup.FindSet then begin
                    //Message(_line."VAT Prod. Posting Group" + ' : vat % : ' + Format(_VATSetup."VAT %"));
                    if _VATSetup."VAT %" > 0 then begin
                        _JmlDPP := _JmlDPP + _line.Amount;
                        //Message(Format(_line.Amount));
                    end;
                end;
            end until _line.Next = 0;
        end
        else begin
        end;
        exit(_JmlDPP);
    end;

    procedure CalculateVATPurchInvcHdr(Invoice: Text): Decimal
    var
        myInt: Integer;
        _line: Record "Purch. Inv. Line";
        //dev
        //_line: Record "Sales Line";
        _VATSetup: Record "VAT Posting Setup";
        _JmlVAT: Decimal;
        _noRecord: Integer;
    begin
        _line."Document No." := Invoice;
        _line.SetFilter(_line."Document No.", Invoice);
        if _line.FindSet then begin
            repeat begin
                _JmlVAT := _JmlVAT + (_line."Amount Including VAT" - _line.Amount);
            end until _line.Next = 0;
        end
        else begin
        end;
        exit(_JmlVAT);
    end;

    procedure CalculateDPPPurcCrMemo(Invoice: Text;
    vatbusposgroup: Text): Decimal
    var
        myInt: Integer;
        _line: Record "Purch. Cr. Memo Line";
        //dev
        //_line: Record "Sales Line";
        _VATSetup: Record "VAT Posting Setup";
        _JmlDPP: Decimal;
        _noRecord: Integer;
    begin
        //Invoice := '103006';
        //vatbusposgroup := 'DOMESTIC';
        _line."Document No." := Invoice;
        _line.SetFilter(_line."Document No.", Invoice);
        if _line.FindSet then begin
            repeat begin
                // abis ini diambil vat bus posting group
                // terus di cek ada % VAT nya ga ?
                _VATSetup.SetFilter("VAT Prod. Posting Group", _line."VAT Prod. Posting Group");
                _VATSetup.SetFilter("VAT Bus. Posting Group", vatbusposgroup);
                if _VATSetup.FindSet then begin
                    //Message(_line."VAT Prod. Posting Group" + ' : vat % : ' + Format(_VATSetup."VAT %"));
                    if _VATSetup."VAT %" > 0 then begin
                        _JmlDPP := _JmlDPP + _line.Amount;
                        //Message(Format(_line.Amount));
                    end;
                end;
            end until _line.Next = 0;
        end
        else begin
        end;
        exit(_JmlDPP);
    end;

    procedure CalculateVATPurcCrMemo(Invoice: Text): Decimal
    var
        myInt: Integer;
        _line: Record "Purch. Cr. Memo Line";
        //dev
        //_line: Record "Sales Line";
        _VATSetup: Record "VAT Posting Setup";
        _JmlVAT: Decimal;
        _noRecord: Integer;
    begin
        _line."Document No." := Invoice;
        _line.SetFilter(_line."Document No.", Invoice);
        if _line.FindSet then begin
            repeat begin
                _JmlVAT := _JmlVAT + (_line."Amount Including VAT" - _line.Amount);
            end until _line.Next = 0;
        end
        else begin
        end;
        exit(_JmlVAT);
    end;

    procedure IsDPPPercentage(vatProd: Code[20];
    vatbus: Code[20]): Boolean
    var
        myInt: Integer;
        _VATSetup: Record "VAT Posting Setup";
    begin
        _VATSetup.SetFilter("VAT Prod. Posting Group", vatProd);
        _VATSetup.SetFilter("VAT Bus. Posting Group", vatbus);
        if _VATSetup.FindSet then begin
            //Message(_line."VAT Prod. Posting Group" + ' : vat % : ' + Format(_VATSetup."VAT %"));
            if _VATSetup."VAT %" > 0 then begin
                exit(true);
            end
            else begin
                exit(false);
            end;
        end;
    end;

    procedure NilaiPercentageDPP(vatprodpostgroup: Text): Integer
    var
        _vatprodpostgroup: Record "VAT Product Posting Group";
    begin
        //Message('procedure nilaipercentage dpp');
        _vatprodpostgroup.SetFilter(Code, vatprodpostgroup);
        _vatprodpostgroup.Code := vatprodpostgroup;
        if _vatprodpostgroup.Find('=') then begin
            //Message(Format(_vatprodpostgroup.Count));
            exit(_vatprodpostgroup.Percentage_FT);
        end
        else begin
            exit(0);
        end;
        //Message('luping didalem proc : ' + Format(_vatprodpostgroup.Count));
    end;

    procedure MigrateDataField()
    var
        myInt: Integer;
        penampungdtl: Record PenampungDetail_FT;
        ppndtl: Record PPNDetail_FT;
        penampung: Record Penampung_FT;
    begin
        // penampungdtl.SetFilter(Description03132021, '=%1', '');
        // if penampungdtl.FindSet then begin
        //     repeat begin
        //         penampungdtl.Description03132021 := penampungdtl.Description;
        //         penampungdtl.Modify();
        //     end until penampungdtl.Next = 0;
        // end;
        // ppndtl.SetFilter(Description03132021, '=%1', '');
        // if ppndtl.FindSet then begin
        //     repeat begin
        //         ppndtl.Description03132021 := ppndtl.Description;
        //         ppndtl.Modify();
        //     end until ppndtl.Next = 0;
        // end;
        // penampung.SetFilter(Address03132021, '=%1', '');
        // if penampung.FindSet then begin
        //     repeat begin
        //         penampung.Address03132021 := penampung.Address;
        //         penampung.Modify();
        //     end until penampung.Next = 0;
        // end;
    end;

    procedure diskonresource(noHeader: Text): Decimal
    var
        myInt: Integer;
        salesInvoiceLine: Record "Sales Invoice Line";
        diskonresource: Decimal;
        ppndtl: Record PPNDetail_FT;
        penampungdtl: Record PenampungDetail_FT;
    begin
        diskonresource := 0;
        salesInvoiceLine.SetFilter("Document No.", '=%1', noHeader);
        salesInvoiceLine.SetFilter(Type, '=%1', salesInvoiceLine.Type::Resource);
        if salesInvoiceLine.FindSet then begin
            repeat begin
                diskonresource := diskonresource + (salesInvoiceLine."Line Amount" * -1);
            end until salesInvoiceLine.Next = 0;
        end;
        exit(diskonresource);
    end;

    procedure diskonAmount(noHeader: Text): Decimal
    var
        myInt: Integer;
        AmountWithDiscountAllowed: Decimal;
        InvoiceDiscountAmount: Decimal;
        DocumentTotals: Codeunit "Document Totals";
        InvoiceDiscountPct: Decimal;
        Currency: Record Currency;
        TotalSalesHeader: Record "Sales Header";
        TotalSalesLine: Record "Sales Line";
        VATAmount: Decimal;
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        TotalSalesInvoiceHeader: Record "Sales Invoice Header";
        postedSalesLine: Record "Sales Invoice Line";
    begin
        // SalesHeader.SetFilter("No.", 'SINV-20-000013');
        // SalesLine.SetFilter("Document No.", '=SINV-20-000013');
        // if SalesLine.FindSet then begin
        //     DocumentTotals.GetTotalSalesHeaderAndCurrency(SalesLine, TotalSalesHeader, Currency);
        //     DocumentTotals.CalculateSalesSubPageTotals(TotalSalesHeader, TotalSalesLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
        //     AmountWithDiscountAllowed := DocumentTotals.CalcTotalSalesAmountOnlyDiscountAllowed(SalesLine);
        //     InvoiceDiscountAmount := Round(AmountWithDiscountAllowed * InvoiceDiscountPct / 100, Currency."Amount Rounding Precision");
        // end;
        // postedSalesLine.SetFilter("Document No.", '=SI-20-000082');
        postedSalesLine.SetFilter("Document No.", '=%1', noHeader);
        if postedSalesLine.FindSet then begin
            DocumentTotals.CalculatePostedSalesInvoiceTotals(TotalSalesInvoiceHeader, VATAmount, postedSalesLine);
            InvoiceDiscountAmount := TotalSalesInvoiceHeader."Invoice Discount Amount";
        end;
        exit(InvoiceDiscountAmount);
    end;

    procedure totlineamount(noHeader: Text): Decimal
    var
        myInt: Integer;
        postedSalesLine: Record "Sales Invoice Line";
        totlineamount: Decimal;
        diskonperitem: Decimal;
        InvoiceDiscountAmount: Decimal;
    begin
        postedSalesLine.SetFilter("Document No.", '=%1', noHeader);
        postedSalesLine.SetFilter(Type, '<>%1', postedSalesLine.Type::Resource);
        if postedSalesLine.FindSet then begin
            repeat begin
                totlineamount := totlineamount + (postedSalesLine."Unit Price" * postedSalesLine.Quantity);
            end until postedSalesLine.Next = 0;
            //InvoiceDiscountAmount := diskonAmount(noHeader);
        end;
        // Clear(postedSalesLine);
        // postedSalesLine.SetFilter("Document No.", '=%1', noHeader);
        // if postedSalesLine.FindSet then begin
        //     repeat begin
        //         diskonperitem := InvoiceDiscountAmount * (postedSalesLine."Unit Price" * postedSalesLine.Quantity) / totlineamount;
        //     end until postedSalesLine.Next = 0;
        // end;
        exit(totlineamount);
    end;

    procedure totlineamountexclcudeVAT(noHeader: Text): Decimal
    var
        myInt: Integer;
        postedSalesLine: Record "Sales Invoice Line";
        totlineamount: Decimal;
        diskonperitem: Decimal;
        InvoiceDiscountAmount: Decimal;
    begin
        // line amount excl VAT = amount doang
        postedSalesLine.SetFilter("Document No.", '=%1', noHeader);
        postedSalesLine.SetFilter(Type, '<>%1', postedSalesLine.Type::Resource);
        if postedSalesLine.FindSet then begin
            repeat begin
                totlineamount := totlineamount + (postedSalesLine.Amount);
            end until postedSalesLine.Next = 0;
            //InvoiceDiscountAmount := diskonAmount(noHeader);
        end;
        // Clear(postedSalesLine);
        // postedSalesLine.SetFilter("Document No.", '=%1', noHeader);
        // if postedSalesLine.FindSet then begin
        //     repeat begin
        //         diskonperitem := InvoiceDiscountAmount * (postedSalesLine."Unit Price" * postedSalesLine.Quantity) / totlineamount;
        //     end until postedSalesLine.Next = 0;
        // end;
        exit(totlineamount);
    end;

    var
        _RecPenampung: Record Penampung_FT;
        _RecPPN: Record PPN_FT;
        _PenampungDtl: Record PenampungDetail_FT;
        _PpnDetail: Record PPNDetail_FT;
        _CUPenampung: Codeunit Penampung_FT;
        //Test variable
        _countHEAD: Integer;
        _countLINE: Integer;
        _prcentageDPP: Integer;
        _page: Page "Sales Invoice Subform";
}
