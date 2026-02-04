table 50102 PPN_FT
{
    DataClassification = AccountData;

    Permissions = TableData "Sales Invoice Header" = m,
    TableData "Sales Cr.Memo Header" = m,
    tabledata "Purch. Inv. Header" = m,
    tabledata "Purch. Cr. Memo Hdr." = m;

    fields
    {
        field(1; RecID; Integer)
        {
            DataClassification = AccountData;
            Caption = 'RecID';
            AutoIncrement = true;
        }
        field(10; FlagTaxType; Enum EnumInOut_FT)
        {
            DataClassification = AccountData;
            Caption = 'Flag Tax Type';
        }
        field(20; InvoiceNo; Code[30])
        {
            DataClassification = AccountData;
            Caption = 'Invoice No';
        }
        field(30; FPPengganti; Enum EnumYN_FT)
        {
            DataClassification = AccountData;
            Caption = 'Replacement Tax No';
        }
        field(40; FlagRetur; Enum EnumYN_FT)
        {
            DataClassification = AccountData;
            Caption = 'Return';
        }
        field(50; TaxNumber; Code[40])
        {
            DataClassification = AccountData;
            Caption = 'Tax No';
        }
        field(60; TaxDate; Date)
        {
            DataClassification = AccountData;
            Caption = 'Tax Date';
        }
        field(70; ReturnTaxNo; Code[30])
        {
            DataClassification = AccountData;
            Caption = 'Return Tax No';
        }
        field(80; ReturnDocNo; Code[30])
        {
            DataClassification = AccountData;
            Caption = 'Return Document No';
        }
        field(90; ReturnDate; Date)
        {
            DataClassification = AccountData;
            Caption = 'Return Date';
        }
        field(100; AccountNo; Code[15])
        {
            DataClassification = AccountData;
            Caption = 'Account No';
        }
        field(110; NPWP; Code[20])
        {
            DataClassification = AccountData;
            Caption = 'NPWP';
        }
        field(120; Nama; Code[50])
        {
            DataClassification = AccountData;
            Caption = 'Name';
        }
        field(130; Address; Text[250])
        {
            DataClassification = AccountData;
            Caption = 'Address';
        }
        field(140; Currency; Code[3])
        {
            DataClassification = AccountData;
            Caption = 'Currency';
        }
        field(150; InvoiceAmt; Decimal)
        {
            DataClassification = AccountData;
            Caption = 'Invoice Amt';
        }
        field(160; DPP; Decimal)
        {
            DataClassification = AccountData;
            Caption = 'DPP';
        }
        field(170; VAT; Decimal)
        {
            DataClassification = AccountData;
            Caption = 'VAT';
        }
        field(180; VatBusPostGroup; Code[15])
        {
            DataClassification = AccountData;
            Caption = 'VAT Bus. Posting Group';
        }
        field(190; VatProdPostGroup; Code[15])
        {
            DataClassification = AccountData;
            Caption = 'VAT Prod. Posting Group';
        }
        field(200; VatCalType; Code[15])
        {
            DataClassification = AccountData;
            Caption = 'VAT Cal. Type';
        }
        field(210; FlagPosted; Enum EnumYN_FT)
        {
            DataClassification = AccountData;
            Caption = 'Flag Posted';
        }
        field(220; FlagExport; Enum EnumYN_FT)
        {
            DataClassification = AccountData;
            Caption = 'Flag Export';
        }
        field(230; InvoiceDate; Date)
        {
            DataClassification = AccountData;
            Caption = 'Invoice Date';
        }
        field(240; ExportDate; Date)
        {
            DataClassification = AccountData;
            Caption = 'Export Date';
        }
        field(250; ExportStatus; Enum ExportStatus_FT)
        {
            DataClassification = AccountData;
            Caption = 'Export Status';
        }
        field(260; KodeDokumenPendukung; Text[50])
        {
            DataClassification = AccountData;
            Caption = 'No Dokumen Pendukung';
        }
        field(261; "Source Name"; Text[100])
        {
            DataClassification = AccountData;
            Caption = 'Source Name';
        }
        //Custom by rnd 6 Jul 2023
        //additional 7 feb 2025
        field(262; "Country Code"; Text[100])
        {
            TableRelation = CountryRef_FT.Code;
            Caption = 'Country Code';
        }
        field(263; "Identity Type"; enum "Customer Identity Type")
        {
            Caption = 'Identity Type';
        }
        field(264; "Facility Ref"; Code[20])
        {
            Caption = 'Facility Ref';
            TableRelation = FacilityRef_FT.Code;
        }
        field(265; "Add Info Ref"; Code[20])
        {
            Caption = 'Add Info Ref';
            TableRelation = AddInfoRef_FT.Code;
        }
        //-
    }
    keys
    {
        key(PK; RecID)
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        _Penampung: Record Penampung_FT;
        _PPNDetail: Record PPNDetail_FT;
        _regtaxline: Record RegTaxNumLine_FT;
        _invoiceno: Code[30];
        _pagetaxnoLine: Page RegisterTaxNumberSubPage_FT;
        PurInvHeader: Record "Purch. Inv. Header";
        PurCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        SaleInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        Clear(_Penampung);
        Clear(_PPNDetail);
        Clear(_regtaxline);
        Clear(_invoiceno);
        _PPNDetail.SetRange(InvoiceNo, Rec.InvoiceNo);
        If _PPNDetail.FindSet then begin
            //Message(Format(_PPNDetail.Count));
            _PPNDetail.DeleteAll();
        end;
        _invoiceno := InvoiceNo;

        if Rec.FlagTaxType = Rec.FlagTaxType::Input then begin
            Clear(PurInvHeader);
            PurInvHeader.SetRange("No.", InvoiceNo);
            if PurInvHeader.FindSet() then begin
                PurInvHeader.FlagTransfer_FT := EnumYN_FT::N;
                PurInvHeader.Modify();
            end;
            Clear(PurCrMemoHeader);
            PurCrMemoHeader.SetRange("No.", InvoiceNo);
            if PurCrMemoHeader.FindSet() then begin
                PurCrMemoHeader.FlagTransfer_FT := EnumYN_FT::N;
                PurCrMemoHeader.Modify();
            end;
        end else begin
            Clear(SaleInvHeader);
            SaleInvHeader.SetRange("No.", InvoiceNo);
            if SaleInvHeader.FindSet() then begin
                SaleInvHeader.FlagTransfer_FT := EnumYN_FT::N;
                SaleInvHeader.Modify();
            end;
            Clear(SalesCrMemoHeader);
            SalesCrMemoHeader.SetRange("No.", InvoiceNo);
            if SalesCrMemoHeader.FindSet() then begin
                SalesCrMemoHeader.FlagTransfer_FT := EnumYN_FT::N;
                SalesCrMemoHeader.Modify();
            end;
        end;

        _Penampung.SetFilter(InvoiceNo, _invoiceno);
        if _Penampung.Find('-') then begin
            _Penampung.FlagTransfer := EnumYN_FT::N;

            // cari dulu taxnumnya ada yang pake ga
            if _pagetaxnoLine.cekrelatetaxnumonPPN(Rec.TaxNumber) then begin
                if _Penampung.Modify() then begin
                    Message('Delete success');
                end;
            end
            else begin
                _regtaxline.SetFilter(Reff, '=%1', _Penampung.InvoiceNo);
                if _regtaxline.FindSet then begin
                    //Message('jml line : %1', _regtaxline.Count);
                    //Message('reff : %1', _regtaxline.Reff);
                    _regtaxline.Reff := '';
                    _regtaxline.Status := TaxLineStatus_FT::Free;
                end;
                if _Penampung.Modify() and _regtaxline.Modify() then begin
                    Message('Delete success');
                end;
            end;
        end;
    end;

    trigger OnRename()
    begin
    end;

    procedure GetIncrementRecIDPPN(): Text;
    var
        myInt: Integer;
        _RecPPN: record PPN_FT;
    begin
        _RecPPN.Reset();
        if (_RecPPN.find('+')) then begin
            //exit(IncStr(_RecPPN.RecID));
        end
        else begin
            exit('1');
        end;
    end;

    var
        CUnit: Codeunit CodeUnitPPN_FT;
}