codeunit 50105 RegisterTaxNumber_FT
{
    trigger OnRun()
    begin
    end;

    procedure GetNewRegTaxID(): Text;
    var
        _RegID: record "RegTaxNumHeader_FT";
    begin
        _RegID.Reset();
        if (_RegID.find('+')) then begin
            //exit('0000000099999999999999999');
            //exit(INCSTR(_RegID.RegTaxNumId));
        end
        else begin
            exit('0000000000000000000000001');
            //exit('9');
        end;
    end;

    procedure GetRegTaxNumbHeader(_InvDate: Date): Text
    var
        MyFieldRef: FieldRef;
        _RTNH: Record RegTaxNumHeader_FT;
    begin
        _RTNH.find('-');
        //Message(Format(_InvDate));
        if _RTNH.IsEmpty() then begin
            Message('There is No Tax Registration Found');
        end
        else begin
            repeat begin
                //Message(Format(_RTNH.Count()));
                if (_RTNH.FromDate <= _InvDate) and (_RTNH.ToDate >= _InvDate) and (_RTNH.Status = TaxStatus_FT::Generate) then begin
                    //Message(Format(_RTNH.RegTaxNumId) + ' ' + Format(_RTNH.FromDate));
                    //exit(_RTNH.RegTaxNumId);
                end;
            end until _RTNH.Next() = 0;
            Message('Posting Cancelled, No Tax registration found matched for this invoice');
            exit('0');
        end;
    end;

    procedure GetTaxNum(_InvoiceNo: Code[30];
    _TaxDate: date): Text
    Var
        _RTNL: record RegTaxNumLine_FT;
        _RegTaxNumID: Text;
    begin
        //_RegTaxNumID := GetRegTaxNumbHeader(_RTNCU.GetInvDate(_InvoiceNo));
        _RegTaxNumID := GetRegTaxNumbHeader(_TaxDate);
        //_RTNL.SetRange(RegTaxNumId, _RegTaxNumID);
        _RTNL.SetRange(Status, TaxLineStatus_FT::Free);
        _RTNL.Find('-');
        repeat begin
            if _RTNL.Status = TaxLineStatus_FT::Free then begin
                exit(_RTNL.TaxNum);
            end;
        end until _RTNL.Next() = 0;
        exit(' ');
    end;

    procedure GetInvDate(_No: Code[25]): Date
    var
        _SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        _SalesInvoiceHeader.SetFilter("No.", _No);
        if _SalesInvoiceHeader.Find('-') then
            exit(_SalesInvoiceHeader."Document Date")
        Else
            exit(0D);
    end;

    var
        myInt: Integer;
}
