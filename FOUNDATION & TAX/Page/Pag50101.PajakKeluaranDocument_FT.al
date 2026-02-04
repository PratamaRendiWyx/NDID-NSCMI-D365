page 50101 PajakKeluaranDocument_FT
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = PPN_FT;
    Caption = 'Pajak Keluaran';
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(InvoiceNo; Rec.InvoiceNo)
                {
                    ApplicationArea = All;
                    Caption = 'Invoice No.';
                    Editable = false;
                }
                field(invcdt; Rec.InvoiceDate)
                {
                    ApplicationArea = All;
                    Caption = 'Invoice Date';
                    Editable = false;
                }
                field(FPPengganti; Rec.FPPengganti)
                {
                    ApplicationArea = All;
                    Caption = 'Faktur Pajak Pengganti';
                    //Enabled = false;
                }
                field(TaxNumber; Rec.TaxNumber)
                {
                    ApplicationArea = All;
                    Caption = 'Tax Number';
                }
                field(TaxDate;Rec.TaxDate)
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
                    Caption = 'Return Doc No';
                }
                field(ReturnDate; Rec.ReturnDate)
                {
                    ApplicationArea = All;
                    Caption = 'Return Date';
                }
                field(AccountNo; Rec.AccountNo)
                {
                    ApplicationArea = All;
                    Caption = 'Account No';
                    Editable = false;
                }
                field(NPWP; Rec.NPWP)
                {
                    ApplicationArea = All;
                    Caption = 'NPWP';
                }
                field(Nama; Rec.Nama)
                {
                    ApplicationArea = All;
                    Caption = 'Nama';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    Caption = 'Address';
                }
                field(KodeDokumenPendukung; Rec.KodeDokumenPendukung)
                {
                    ApplicationArea = All;
                }
            }
            Group(Invoice)
            {
                Editable = false;

                field(Currency;Rec.Currency)
                {
                    ApplicationArea = All;
                    Caption = 'Currency';
                }
                field(invcamt; Rec.InvoiceAmt)
                {
                    ApplicationArea = All;
                    Caption = 'Invoice Amount';
                }
                field(DPP; Rec.DPP)
                {
                    ApplicationArea = All;
                    Caption = 'DPP';
                    //CharAllowed = '19';// char that allowed 1 to 9
                }
                field(VAT; Rec.VAT)
                {
                    ApplicationArea = All;
                    Caption = 'VAT Amount';
                    //CharAllowed = '19'; // char that allowed 1 to 9
                }
                field(VatBusPostGroup; Rec.VatBusPostGroup)
                {
                    ApplicationArea = All;
                    Caption = 'VAT Business Posting Group';
                }
                // field(VatProdPostGroup; VatProdPostGroup)
                // {
                //     ApplicationArea = All;
                //     Caption = 'VAT Product Posting Group';
                // }
                // field(VatCalType; VatCalType)
                // {
                //     ApplicationArea = All;
                //     Caption = 'VAT Calculate Type';
                // }
            }
            part(Lines; PajakKeluaranSubPage_FT)
            {
                Caption = 'Pajak Keluaran Lines';
                ApplicationArea = All;
                SubPageLink = InvoiceNo = Field(InvoiceNo);
                SubPageView = sorting();
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

                trigger OnAction()
                var //itkPPN: Record ITK_PPN;
                    answer: Boolean;
                    _pagelist: Page PajakKeluaranList_FT;
                    sisataxnum: Text;
                begin
                    answer := Dialog.Confirm('Are you sure want to posting this document?');
                    if answer then begin
                        sisataxnum := cekketersediaanTaxNum();
                        if Rec.TaxNumber = '' then begin
                            if _pagelist.gettaxnumpostinglist(Rec) then begin
                                Message('Posted Successfully');
                                CurrPage.Close();
                            end;
                        end
                        else begin
                            // kalo tax numbernya uda keisi
                            if Rec.FlagPosted = EnumYN_FT::N then begin
                                Rec.FlagPosted := EnumYN_FT::Y;
                                if Rec.Modify() then begin
                                    Message('Posted Successfully');
                                end;
                            end
                            else begin
                                Message('Nothing happend, tax number already filled');
                            end;
                        end;
                        //Message('mantap!');
                        //itkPPN.Get(RecID);
                        // Rec.FlagPosted := 1;
                        // if Rec.Modify() then begin
                        //     Message('Posted Successfully');
                        //     CurrPage.Close();
                        // end;
                        if sisataxnum <> '' then Message(sisataxnum);
                    end;
                end;
            }
        }
    }
    procedure cekketersediaanTaxNum(): Text
    var
        _RTNH: Record RegTaxNumHeader_FT;
        _RTNL: Record RegTaxNumLine_FT;
        _recidtax: Text;
        _TaxSetup: Record TaxIndoParameter_FT;
    begin
        //Message('jml selected %1', itkppn.Count);
        _RTNH.SetFilter(FromDate, '<=%1', Rec.TaxDate);
        _RTNH.SetFilter(ToDate, '>=%1', Rec.TaxDate);
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
                exit('remaining tax amount : ' + Format(_RTNL.Count - 1));
            end;
        end
        else begin
            exit('tax no not available on ' + Format(Rec.TaxDate));
        end;
    end;
}
