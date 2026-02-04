page 50102 PajakKeluaranList_FT
{
    PageType = List;
    Caption = 'Outgoing Tax List';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = PPN_FT;
    InsertAllowed = false;
    CardPageId = PajakKeluaranDocument_FT;

    //SourceTableView = sorting(RecID) order(ascending) where(FlagTaxType = filter(Out), FlagPosted = filter(N));
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
                // field(FlagTaxType; FlagTaxType)
                // {
                //     ApplicationArea = All;
                //     Caption = 'Tax Type';
                //     Editable = false;
                // }
                // field(FPPengganti; FPPengganti)
                // {
                //     ApplicationArea = All;
                //     Caption = 'FPPengganti';
                //     Editable = false;
                // }
                // field(FlagRetur; FlagRetur)
                // {
                //     ApplicationArea = All;
                //     Caption = 'FlagRetur';
                // }
                field(TaxNumber; Rec.TaxNumber)
                {
                    ApplicationArea = All;
                    Caption = 'Tax Number';
                }
                field(TaxDate; Rec.TaxDate)
                {
                    ApplicationArea = All;
                    Caption = 'Tax Date';
                }
                field(ReturnTaxNo; Rec.ReturnTaxNo)
                {
                    ApplicationArea = All;
                    Caption = 'Return Tax Number';
                }
                field(ReturnDocNo; Rec.ReturnDocNo)
                {
                    ApplicationArea = All;
                    Caption = 'Return Document Number';
                }
                field(ReturnDate; Rec.ReturnDate)
                {
                    ApplicationArea = All;
                    Caption = 'Return Date';
                }
                field(InvoiceNo; Rec.InvoiceNo)
                {
                    ApplicationArea = All;
                    Caption = 'InvoiceNo';
                    Editable = false;
                }
                field(NPWP; Rec.NPWP)
                {
                    ApplicationArea = All;
                    Caption = 'NPWP';
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
                    Caption = 'Customer Name';
                }
                // field(Nama; Nama)
                // {
                //     ApplicationArea = All;
                //     Caption = 'Nama';
                //     Editable = false;
                // }
                // field(Address; Address)
                // {
                //     ApplicationArea = All;
                //     Caption = 'Address';
                //     Editable = false;
                // }
                // field(Currency; Currency)
                // {
                //     ApplicationArea = All;
                //     Caption = 'Currency';
                //     Editable = false;
                // }
                // field(InvoiceAmt; InvoiceAmt)
                // {
                //     ApplicationArea = All;
                //     Caption = 'InvoiceAmt';
                //     //CharAllowed = '19'; // char that allowed 1 to 9
                //     Editable = false;
                // }
                // field(DPP; DPP)
                // {
                //     ApplicationArea = All;
                //     Caption = 'DPP';
                //     //CharAllowed = '19';// char that allowed 1 to 
                //     Editable = false;
                // }
                // field(VAT; VAT)
                // {
                //     ApplicationArea = All;
                //     Caption = 'VAT';
                //     //CharAllowed = '19'; // char that allowed 1 to 9
                //     Editable = false;
                // }
                // field(VatBusPostGroup; VatBusPostGroup)
                // {
                //     ApplicationArea = All;
                //     Caption = 'VATBusPostGroup';
                //     Editable = false;
                // }
                // field(VatProdPostGroup; VatProdPostGroup)
                // {
                //     ApplicationArea = All;
                //     Caption = 'VatProdPostGroup';
                //     Editable = false;
                // }
                // field(VatCalType; VatCalType)
                // {
                //     ApplicationArea = All;
                //     Caption = 'VatCalType';
                //     Editable = false;
                // }
                // field(FlagPosted; FlagPosted)
                // {
                //     ApplicationArea = All;
                //     Caption = 'FlagPosted';
                //     Editable = false;
                // }
                // field(FlagExport; FlagExport)
                // {
                //     ApplicationArea = All;
                //     Caption = 'FlagExport';
                //     Editable = false;
                // }
            }
        }
        area(Factboxes)
        {
        }
    }
    actions
    {
        area(Processing)
        {
            action(Posting)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = Post;

                trigger OnAction();
                var
                    _RegTaxNumHdr: Code[25];
                    _RTNL: Record RegTaxNumLine_FT;
                    _PPN: Record PPN_FT;
                    answer: Boolean;
                    sisataxnum: Text;
                begin
                    answer := Dialog.Confirm('Are you sure want to posting this document?');
                    // if answer then begin
                    //     if TaxNumber = '' then begin
                    //         if gettaxnum(TaxDate, NPWP) then begin
                    //             Message('Posted Successfully');
                    //         end;
                    //         // _RegTaxNumHdr := _RTNCU.GetTaxNum(InvoiceNo, TaxDate);
                    //         // //Message('Masuk %1', TaxNumber);
                    //         // Rec.TaxNumber := _RegTaxNumHdr;
                    //         // Rec.FlagPosted := EnumYN_FT::Y;
                    //         // if Rec.Modify() then begin
                    //         //     //Message('sukses modify pajak keluaran header');
                    //         //     _RTNL.Get(_RegTaxNumHdr);
                    //         //     _RTNL.Status := TaxLineStatus_FT::Used;
                    //         //     _RTNL.Reff := InvoiceNo;
                    //         //     if _RTNL.Modify() then begin
                    //         //         Message('Posted Successfully');
                    //         //         //CurrPage.Close();
                    //         //     end;
                    //         // end;
                    //     end else begin
                    //         //penjagaan kalau datanya flag postednya ga ke update
                    //         // kalo tax numnya ada
                    //         if Rec.FlagPosted = EnumYN_FT::N then begin
                    //             Rec.FlagPosted := EnumYN_FT::Y;
                    //             if Rec.Modify() then begin
                    //                 Message('Posted Successfully');
                    //             end;
                    //         end else begin
                    //             Message('Nothing happend, tax number already filled');
                    //         end;
                    //     end;
                    // end;
                    // Buat posting list
                    CurrPage.SetSelectionFilter(_PPN);
                    _PPN.FindSet();
                    if answer then begin
                        ValidasiketersediaanTaxNum(_PPN);
                        sisataxnum := cekketersediaanTaxNum(_PPN);
                        repeat begin
                            if _PPN.TaxNumber = '' then begin
                                if gettaxnumpostinglist(_PPN) then begin
                                    // if _PPN.FlagPosted = EnumYN_FT::N then begin
                                    //     _PPN.FlagPosted := EnumYN_FT::Y;
                                    //     if _PPN.Modify() then begin
                                    //         //Message('Data has been updated');
                                    //     end;
                                    // end
                                    Message('Posted Successfully');
                                end;
                            end
                            else begin
                                //penjagaan kalau datanya flag postednya ga ke update
                                if _PPN.FlagPosted = EnumYN_FT::N then begin
                                    _PPN.FlagPosted := EnumYN_FT::Y;
                                    if _PPN.Modify() then begin
                                        //Message('Data has been updated');
                                    end;
                                end
                                else begin
                                    Message('Nothing happend, tax number already filled');
                                end;
                            end;
                        end until _PPN.Next = 0;
                        Message('Posted Successfully');
                        if sisataxnum <> '' then Message(sisataxnum);
                    end;
                end;
            }
            // action(Test)
            // {
            //     ApplicationArea = All;
            //     trigger OnAction()
            //     var
            //         _rtnh: Record RegTaxNumHeader_FT;
            //         _recidtax: Text;
            //         _dt: Date;
            //     begin
            //         _dt := DMY2DATE(1, 1, 2020);
            //         gettaxnum(_dt, 'tre');
            //         // // _rtnh.SetFilter(RegTaxNumId, '= 1');
            //         // _rtnh.SetFilter(Status, '=%1', TaxStatus_FT::ReadyToUse);
            //         // // _rtnh.FindSet();
            //         // Message('jml filter =%1', _rtnh.Count);
            //         // repeat begin
            //         //     if _RTNH.RegTaxNumId > 0 then begin
            //         //         Message(Format(_RTNH.RegTaxNumId));
            //         //         _recidtax := _recidtax + ' | ' + Format(_RTNH.RegTaxNumId);
            //         //     end;
            //         // end until _rtnh.Next = 0;
            //         // _recidtax := DelStr(_recidtax, 1, 2);
            //         // Message(_recidtax);
            //     end;
            // }
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
        _SalesInvoiceHeader: Record "Sales Invoice Header";
    //_RTNCU: Codeunit RegisterTaxNumber_FT;
    trigger OnOpenPage()
    begin
        rec.SetRange(FlagTaxType, Rec.FlagTaxType::Out);
        rec.SetRange(FlagPosted, EnumYN_FT::N);
    end;

    procedure gettaxnum(taxDate: Date; npwp: Code[50]): Boolean
    var
        _RTNH: Record RegTaxNumHeader_FT;
        _RTNL: Record RegTaxNumLine_FT;
        _taxnum: Text;
        _cstmr: Record Customer;
        _txtprefix: Text;
        _recidtax: Text;
    begin
        _cstmr.SetFilter("NPWP No_FT", '=%1', npwp);
        if _cstmr.FindSet then begin
            // kalo is wapu dan nilai dpp 0 - 10 juta maka prefixnya 010
            // kalo is wapu dan nilai dpp > 10 juta maka ikutin prefixnya cstmr
            if Rec.DPP <= 10000000 then begin
                _txtprefix := '010'; // Format(_cstmr."NPWP PrefixWapu_FT");
            end
            else begin
                _txtprefix := Format(_cstmr."NPWP PrefixWapu_FT");
            end;
            //Message('prefix : %1', _txtprefix);
            if _cstmr."Customer Posting Group" = 'EPTE' then
                _txtprefix := Format(_cstmr."NPWP PrefixWapu_FT");
        end;
        _RTNH.SetFilter(FromDate, '<=%1', taxDate);
        _RTNH.SetFilter(ToDate, '>=%1', taxDate);
        _RTNH.SetFilter(Status, '=%1', TaxStatus_FT::Generate);
        if _RTNH.FindSet then begin
            repeat begin
                if _RTNH.RegTaxNumId > 0 then begin
                    //Message(Format(_RTNH.RegTaxNumId));
                    _recidtax := _recidtax + ' | ' + Format(_RTNH.RegTaxNumId);
                end;
            end until _RTNH.Next = 0;
            _recidtax := DelStr(_recidtax, 1, 2);
            _RTNL.SetFilter(RegTaxNumId, _recidtax);
            _RTNL.SetFilter(Status, '=%1', TaxLineStatus_FT::Free);
            if _RTNL.FindSet then begin
                _RTNL.SetAscending(TaxNum, true);
                repeat begin
                    //Message(_RTNL.TaxNum);
                    if _RTNL.Status = TaxLineStatus_FT::Free then begin
                        Rec.TaxNumber := _txtprefix + _RTNL.TaxNum;
                        Rec.FlagPosted := EnumYN_FT::Y;
                        _RTNL.Status := TaxLineStatus_FT::Used;
                        _RTNL.Reff := Rec.InvoiceNo;
                        if (_RTNL.Modify()) and (Rec.Modify()) then begin
                            exit(true);
                        end
                        else begin
                            Error('Error when posting');
                        end;
                    end;
                end until _RTNL.Next = 0;
            end
            else begin
                Error('tax number not available on ' + Format(taxDate));
            end;
        end
        else begin
            Error('tax number not available on ' + Format(taxDate));
        end;
    end;

    procedure gettaxnumpostinglist(_PPN: Record PPN_FT): Boolean //(taxDate: Date; npwp: Code[50]): Boolean
    var
        _RTNH: Record RegTaxNumHeader_FT;
        _RTNL: Record RegTaxNumLine_FT;
        _taxnum: Text;
        _cstmr: Record Customer;
        _txtprefix: Text;
        _recidtax: Text;
    begin
        // _cstmr.SetFilter("NPWP No_FT", '=%1', _PPN.NPWP);
        // if _cstmr.FindSet then begin
        //     // kalo is wapu dan nilai dpp 0 - 10 juta maka prefixnya 010
        //     // kalo is wapu dan nilai dpp > 10 juta maka ikutin prefixnya cstmr
        //     if DPP <= 10000000 then begin
        //         _txtprefix := '010'; // Format(_cstmr."NPWP PrefixWapu_FT");
        //     end else begin
        //         _txtprefix := Format(_cstmr."NPWP PrefixWapu_FT");
        //     end;
        //     //Message('prefix : %1', _txtprefix);
        // end;
        // _RTNH.SetFilter(FromDate, '<=%1', _PPN.TaxDate);
        // _RTNH.SetFilter(ToDate, '>=%1', _PPN.TaxDate);
        // _RTNH.SetFilter(Status, '=%1', TaxStatus_FT::Generate);
        // if _RTNH.FindSet then begin
        //     _RTNL.SetFilter(RegTaxNumId, '=%1', _RTNH.RegTaxNumId);
        //     if _RTNL.FindSet then begin
        //         repeat begin
        //             if _RTNL.Status = TaxLineStatus_FT::Free then begin
        //                 _PPN.TaxNumber := _txtprefix + _RTNL.TaxNum;
        //                 _PPN.FlagPosted := EnumYN_FT::Y;
        //                 _RTNL.Status := TaxLineStatus_FT::Used;
        //                 _RTNL.Reff := _PPN.InvoiceNo;
        //                 if (_RTNL.Modify()) and (_PPN.Modify()) then begin
        //                     exit(true);
        //                 end else begin
        //                     Error('Error when posting');
        //                 end;
        //             end;
        //         end until _RTNL.Next = 0;
        //     end;
        // end else begin
        //     Error('tax number not available on ' + Format(taxDate));
        // end;
        _cstmr.SetFilter("NPWP No_FT", '=%1', _PPN.NPWP);
        if _cstmr.FindSet then begin
            // kalo is wapu dan nilai dpp 0 - 10 juta maka prefixnya 010
            // kalo is wapu dan nilai dpp > 10 juta maka ikutin prefixnya cstmr
            /* Comment by rnd 22 May 2024, this is implement on SSI 
            if Rec.DPP <= 10000000 then begin
                _txtprefix := '010'; // Format(_cstmr."NPWP PrefixWapu_FT");
            end
            else begin
                _txtprefix := Format(_cstmr."NPWP PrefixWapu_FT");
            end;

            if _cstmr."Customer Posting Group" = 'EPTE' then
                _txtprefix := Format(_cstmr."NPWP PrefixWapu_FT");
            */
            _txtprefix := Format(_cstmr."NPWP PrefixWapu_FT");
            //Message('prefix : %1', _txtprefix);
        end;
        //Message(Format(_PPN.InvoiceNo));
        _RTNH.SetFilter(FromDate, '<=%1', _PPN.TaxDate);
        _RTNH.SetFilter(ToDate, '>=%1', _PPN.TaxDate);
        _RTNH.SetFilter(Status, '=%1', TaxStatus_FT::Generate);
        if _RTNH.FindSet then begin
            repeat begin
                if _RTNH.RegTaxNumId > 0 then begin
                    //Message('regtaxnumid %1', Format(_RTNH.RegTaxNumId));
                    _recidtax := _recidtax + ' | ' + Format(_RTNH.RegTaxNumId);
                end;
            end until _RTNH.Next = 0;
            _recidtax := DelStr(_recidtax, 1, 2);
            _RTNL.SetFilter(RegTaxNumId, _recidtax);
            _RTNL.SetFilter(Status, '=%1', TaxLineStatus_FT::Free);
            //_RTNL.SetFilter(RegTaxNumId, '=%1', _RTNH.RegTaxNumId);
            if _RTNL.FindSet then begin
                //_RTNL.SetAscending(TaxNum, true);
                //Message('jml taxnum: %1', _RTNL.Count);
                repeat begin
                    //Message(_RTNL.TaxNum);
                    if _RTNL.Status = TaxLineStatus_FT::Free then begin
                        _PPN.TaxNumber := _txtprefix + _RTNL.TaxNum;
                        _PPN.FlagPosted := EnumYN_FT::Y;
                        _RTNL.Status := TaxLineStatus_FT::Used;
                        _RTNL.Reff := _PPN.InvoiceNo;
                        if (_RTNL.Modify()) and (_PPN.Modify()) then begin
                            exit(true);
                        end
                        else begin
                            Error('Error when posting');
                        end;
                    end;
                end until _RTNL.Next = 0;
            end
            else begin
                Error('tax no not available on ' + Format(Rec.taxDate));
            end;
        end
        else begin
            Error('tax no not available on ' + Format(Rec.taxDate));
        end;
    end;

    local procedure ValidasiketersediaanTaxNum(_PPN: Record PPN_FT)
    var
        myInt: Integer;
        _RTNH: Record RegTaxNumHeader_FT;
        _RTNL: Record RegTaxNumLine_FT;
        _recidtax: Text;
    begin
        CurrPage.SetSelectionFilter(_PPN);
        _PPN.FindSet();
        //Message('jml selected %1', _PPN.Count);
        _RTNH.SetFilter(FromDate, '<=%1', _PPN.TaxDate);
        _RTNH.SetFilter(ToDate, '>=%1', _PPN.TaxDate);
        _RTNH.SetFilter(Status, '=%1', TaxStatus_FT::Generate);
        if _RTNH.FindSet then begin
            repeat begin
                if _RTNH.RegTaxNumId > 0 then begin
                    //Message('regtaxnumid %1', Format(_RTNH.RegTaxNumId));
                    _recidtax := _recidtax + ' | ' + Format(_RTNH.RegTaxNumId);
                end;
            end until _RTNH.Next = 0;
        end;
        _recidtax := DelStr(_recidtax, 1, 2);
        _RTNL.SetFilter(RegTaxNumId, _recidtax);
        _RTNL.SetFilter(Status, '=%1', TaxLineStatus_FT::Free);
        if _RTNL.FindSet then begin
            if (_RTNL.Count < _PPN.Count) then begin
                //Message('selected %1 jml tax : %2', _PPN.Count, _RTNL.Count);
                Error('Insufficient tax no');
            end;
        end
        else begin
            Error('tax no not available on ' + Format(_PPN.TaxDate));
        end;
    end;

    procedure cekketersediaanTaxNum(_PPN: Record PPN_FT): Text
    var
        myInt: Integer;
        _RTNH: Record RegTaxNumHeader_FT;
        _RTNL: Record RegTaxNumLine_FT;
        _recidtax: Text;
        _TaxSetup: Record TaxIndoParameter_FT;
    begin
        CurrPage.SetSelectionFilter(_PPN);
        _PPN.FindSet();
        //Message('jml selected %1', _PPN.Count);
        _RTNH.SetFilter(FromDate, '<=%1', _PPN.TaxDate);
        _RTNH.SetFilter(ToDate, '>=%1', _PPN.TaxDate);
        _RTNH.SetFilter(Status, '=%1', TaxStatus_FT::Generate);
        if _RTNH.FindSet then begin
            repeat begin
                if _RTNH.RegTaxNumId > 0 then begin
                    //Message('regtaxnumid %1', Format(_RTNH.RegTaxNumId));
                    _recidtax := _recidtax + ' | ' + Format(_RTNH.RegTaxNumId);
                end;
            end until _RTNH.Next = 0;
        end;
        _recidtax := DelStr(_recidtax, 1, 2);
        _RTNL.SetFilter(RegTaxNumId, _recidtax);
        _RTNL.SetFilter(Status, '=%1', TaxLineStatus_FT::Free);
        if _RTNL.FindSet then begin
            _TaxSetup.FindFirst();
            if _RTNL.Count <= _TaxSetup."Remain Tax Number Warning" then begin
                exit('remaining tax amount : ' + Format(_RTNL.Count - _PPN.Count));
            end;
        end
        else begin
            exit('tax no not available on ' + Format(_PPN.TaxDate));
        end;
    end;

    trigger OnDeleteRecord(): Boolean
    var
        myInt: Integer;
    begin
    end;
}
