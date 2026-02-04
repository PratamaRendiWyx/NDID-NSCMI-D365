codeunit 50107 "Faktur Pajak_FT"
{
    procedure CreateXML(var iPPn: Record PPN_FT): Text
    var
        Declaration: XmlDeclaration;
        XmlDoc: XmlDocument;
        Elements: XmlElement;
        Element: XmlElement;
        ElementItem: XmlElement;
        Comment: XmlComment;
        e,
        i : Integer;
        XmlData: Text;
        XmlWriteOptions: XmlWriteOptions;
        OutStream: OutStream;
        TempBlob: Codeunit "Temp Blob";
        inStr: InStream;
        fileName: Text;
        TINElement: XmlElement;
        ListOfTaxInvoiceElement: XmlElement;
        TaxInvoiceElement: XmlElement;
        TaxInvoiceElementItem: XmlElement;
        ListOfGoodServiceElement: XmlElement;
        GoodServiceElement: XmlElement;
        GoodServiceElementItem: XmlElement;
        TempData: Text;
        CurrData: Text;
        _PPNDTL: Record PPNDetail_FT;
        _PPNDTL1: Record PPNDetail_FT;
        xsiNamespace: XmlNamespaceManager;
        NamespaceAttr: XmlAttribute;
        NamespaceManager: XmlNamespaceManager;
        CompanyInfo: Record "Company Information";
        Customer: Record Customer;
        TrxCode: Text;
        v_InfoSalesInvoice: Text;
        NPWPCompany: Text;
        NPWPCompany1: Text;
        NPWPBuyyer: Text;
        NPWPBuyyer1: Text;
        UOMRef: Record "Unit of Measure";
        UOMTax: Text;
        Item: Record Item;
        OptLine: Text;
        TaxBase: Decimal;
        OtherTaxBase: Decimal;
        VatInfo: Decimal;
    begin
        CompanyInfo.Get();
        NPWPCompany := CompanyInfo."VAT Registration No.";
        NPWPCompany := NPWPCompany.Replace('-', '').Replace('.', '');
        NPWPCompany1 := NPWPCompany + '000000';
        // Create the XML Document
        XmlDoc := XmlDocument.Create();
        // Create the Declaration
        Declaration := XmlDeclaration.Create('1.0', 'utf-8', 'yes');
        NamespaceManager.NameTable(XmlDoc.NameTable);
        NamespaceManager.AddNamespace('xsi', 'http://www.w3.org/2001/XMLSchema-instance');

        // Add the declaration to the XML File
        XmlDoc.SetDeclaration(Declaration);
        // Create Root Element
        Elements := XmlElement.Create('TaxInvoiceBulk');
        // Create a namespace declaration attribute
        NamespaceAttr := XmlAttribute.CreateNamespaceDeclaration('xsi', 'http://www.w3.org/2001/XMLSchema-instance');
        Elements.SetAttribute('noNamespaceSchemaLocation', 'http://www.w3.org/2001/XMLSchema-instance', 'TaxInvoice.xsd');
        Elements.Add(NamespaceAttr);
        TINElement := XmlElement.Create('TIN');
        TINElement.Add(XmlText.Create(NPWPCompany));
        Elements.Add(TINElement);

        ListOfTaxInvoiceElement := XmlElement.Create('ListOfTaxInvoice');
        //Tax Invoice : Invoice Header 
        repeat
            //get infor customer
            Clear(TrxCode);
            Clear(Customer);
            Customer.SetRange("No.", iPPn.AccountNo);
            if Customer.Find('-') then begin
                TrxCode := Format(Customer."NPWP PrefixWapu_FT");
                TrxCode := CopyStr(TrxCode, 1, 2);
            end;

            Clear(TaxInvoiceElement);
            TaxInvoiceElement := XmlElement.Create('TaxInvoice');
            Clear(TaxInvoiceElementItem);
            //list of tax invoice
            TaxInvoiceElementItem := XmlElement.Create('TaxInvoiceDate');
            TaxInvoiceElementItem.Add(XmlText.Create(Format(iPPn.InvoiceDate, 0, '<Year4>-<Month,2>-<Day,2>')));
            TaxInvoiceElement.Add(TaxInvoiceElementItem);
            TaxInvoiceElementItem := XmlElement.Create('TaxInvoiceOpt');
            TaxInvoiceElementItem.Add(XmlText.Create('Normal'));
            TaxInvoiceElement.Add(TaxInvoiceElementItem);
            TaxInvoiceElementItem := XmlElement.Create('TrxCode');
            TaxInvoiceElementItem.Add(XmlText.Create(TrxCode));
            TaxInvoiceElement.Add(TaxInvoiceElementItem);
            TaxInvoiceElementItem := XmlElement.Create('AddInfo');
            if TrxCode in ['07', '08'] then
                TaxInvoiceElementItem.Add(XmlText.Create(iPPn."Add Info Ref"));
            TaxInvoiceElement.Add(TaxInvoiceElementItem);
            TaxInvoiceElementItem := XmlElement.Create('CustomDoc');
            // if iPPn.KodeDokumenPendukung <> '' then
            //     TaxInvoiceElementItem.Add(XmlText.Create(iPPn.KodeDokumenPendukung));
            TaxInvoiceElement.Add(TaxInvoiceElementItem);
            //Reference
            Clear(v_InfoSalesInvoice);
            v_InfoSalesInvoice := iPPn.InvoiceNo + '/Contract No:' + getInfoContractSI(iPPn.InvoiceNo);
            TaxInvoiceElementItem := XmlElement.Create('RefDesc');
            if v_InfoSalesInvoice <> '' then
                TaxInvoiceElementItem.Add(XmlText.Create(v_InfoSalesInvoice));
            TaxInvoiceElement.Add(TaxInvoiceElementItem);
            //facility reff
            TaxInvoiceElementItem := XmlElement.Create('FacilityStamp');
            if iPPn."Facility Ref" <> '' then
                TaxInvoiceElementItem.Add(XmlText.Create(iPPn."Facility Ref"));
            TaxInvoiceElement.Add(TaxInvoiceElementItem);
            //SellerIDTKU
            TaxInvoiceElementItem := XmlElement.Create('SellerIDTKU');
            if NPWPCompany1 <> '' then
                TaxInvoiceElementItem.Add(XmlText.Create(NPWPCompany1));
            TaxInvoiceElement.Add(TaxInvoiceElementItem);
            //BuyerTin
            Clear(NPWPBuyyer);
            Clear(NPWPBuyyer1);
            NPWPBuyyer := iPPn.NPWP;
            NPWPBuyyer := NPWPBuyyer.Replace('-', '').Replace('.', '');
            NPWPBuyyer1 := NPWPBuyyer + '000000';
            TaxInvoiceElementItem := XmlElement.Create('BuyerTin');
            if NPWPBuyyer <> '' then
                TaxInvoiceElementItem.Add(XmlText.Create(NPWPBuyyer));
            TaxInvoiceElement.Add(TaxInvoiceElementItem);
            //BuyerDocument
            TaxInvoiceElementItem := XmlElement.Create('BuyerDocument');
            if Format(iPPn."Identity Type") <> '' then
                TaxInvoiceElementItem.Add(XmlText.Create(Format(iPPn."Identity Type")));
            TaxInvoiceElement.Add(TaxInvoiceElementItem);
            //BuyerCountry
            TaxInvoiceElementItem := XmlElement.Create('BuyerCountry');
            if iPPn."Country Code" <> '' then
                TaxInvoiceElementItem.Add(XmlText.Create(iPPn."Country Code"));
            TaxInvoiceElement.Add(TaxInvoiceElementItem);
            //BuyerDocumentNumber
            TaxInvoiceElementItem := XmlElement.Create('BuyerDocumentNumber');
            TaxInvoiceElementItem.Add(XmlText.Create('-'));
            // TaxInvoiceElementItem.Add(XmlText.Create(iPPn.InvoiceNo));
            TaxInvoiceElement.Add(TaxInvoiceElementItem);
            //BuyerNames
            TaxInvoiceElementItem := XmlElement.Create('BuyerName');
            TaxInvoiceElementItem.Add(XmlText.Create(iPPn.Nama));
            TaxInvoiceElement.Add(TaxInvoiceElementItem);
            //BuyerAdress
            TaxInvoiceElementItem := XmlElement.Create('BuyerAdress');
            if Customer.Address <> '' then
                TaxInvoiceElementItem.Add(XmlText.Create(Customer.Address));
            TaxInvoiceElement.Add(TaxInvoiceElementItem);
            //BuyerEmail
            TaxInvoiceElementItem := XmlElement.Create('BuyerEmail');
            if Customer."E-Mail" <> '' then
                TaxInvoiceElementItem.Add(XmlText.Create(Customer."E-Mail"));
            TaxInvoiceElement.Add(TaxInvoiceElementItem);
            //BuyerIDTKU
            TaxInvoiceElementItem := XmlElement.Create('BuyerIDTKU');
            if NPWPBuyyer1 <> '' then
                TaxInvoiceElementItem.Add(XmlText.Create(NPWPBuyyer1));
            // TaxInvoiceElement.Add(TaxInvoiceElementItem);

            //list of goods service (Detail GoodService)
            Clear(CurrData);
            Clear(TempData);
            Clear(ListOfGoodServiceElement);
            ListOfGoodServiceElement := XmlElement.Create('ListOfGoodService');
            //fetch detail PPN
            Clear(_PPNDTL);
            _PPNDTL.SetFilter(_PPNDTL.InvoiceNo, '=%1', iPPN.InvoiceNo);
            _PPNDTL.SetCurrentKey(InvoiceNo, Description, ItemID, Price);
            _PPNDTL.SetAutoCalcFields("UOM Code");
            _PPNDTL.Ascending(true);
            if _PPNDTL.FindSet then begin
                repeat
                    CurrData := _PPNDTL.Description + '#' + _PPNDTL.ItemID + '#' + format(_PPNDTL.Price) + '#' + _PPNDTL."UOM Code";
                    if TempData <> CurrData then begin
                        Clear(_PPNDTL1);
                        _PPNDTL1.Reset();
                        _PPNDTL1.SetRange(InvoiceNo, iPPN.InvoiceNo);
                        _PPNDTL1.SetRange(ItemID, _PPNDTL.ItemID);
                        _PPNDTL1.SetRange(Price, _PPNDTL.Price);
                        _PPNDTL1.SetRange("UOM Code", _PPNDTL."UOM Code");
                        _PPNDTL1.SetAutoCalcFields("UOM Code");
                        if _PPNDTL1.FindSet() then begin
                            _PPNDTL1.CalcSums(QtyDecimal, TotAmt, DiscAmt, DPPAmt, VatAmt);
                            Clear(UOMRef);
                            Clear(UOMTax);
                            UOMRef.Reset();
                            UOMRef.SetRange(Code, _PPNDTL."UOM Code");
                            if UOMRef.Find('-') then
                                UOMTax := UOMRef."UOM Code TAX";
                            Clear(GoodServiceElement);
                            GoodServiceElement := XmlElement.Create('GoodService');
                            Clear(GoodServiceElementItem);
                            //Opt
                            Clear(Item);
                            Clear(OptLine);
                            Item.SetRange("No.", _PPNDTL1.ItemID);
                            if Item.Find('-') then begin
                                OptLine := 'B';
                                if Item.Type = Item.Type::Inventory then
                                    OptLine := 'A';
                            end;
                            GoodServiceElementItem := XmlElement.Create('Opt');
                            if OptLine <> '' then
                                GoodServiceElementItem.Add(XmlText.Create(OptLine));
                            GoodServiceElement.Add(GoodServiceElementItem);
                            //COde
                            GoodServiceElementItem := XmlElement.Create('Code');
                            GoodServiceElementItem.Add(XmlText.Create('000000'));
                            GoodServiceElement.Add(GoodServiceElementItem);
                            //Name
                            GoodServiceElementItem := XmlElement.Create('Name');
                            GoodServiceElementItem.Add(XmlText.Create(_PPNDTL1.Description));
                            GoodServiceElement.Add(GoodServiceElementItem);
                            //Unit
                            GoodServiceElementItem := XmlElement.Create('Unit');
                            if UOMTax <> '' then
                                GoodServiceElementItem.Add(XmlText.Create(UOMTax));
                            GoodServiceElement.Add(GoodServiceElementItem);
                            //Price
                            GoodServiceElementItem := XmlElement.Create('Price');
                            GoodServiceElementItem.Add(XmlText.Create(Format(_PPNDTL1.Price).Replace('.', '').Replace(',', '.')));
                            GoodServiceElement.Add(GoodServiceElementItem);
                            //Qty
                            GoodServiceElementItem := XmlElement.Create('Qty');
                            GoodServiceElementItem.Add(XmlText.Create(Format(_PPNDTL1.QtyDecimal).Replace('.', '').Replace(',', '.')));
                            GoodServiceElement.Add(GoodServiceElementItem);
                            //Discount
                            GoodServiceElementItem := XmlElement.Create('TotalDiscount');
                            GoodServiceElementItem.Add(XmlText.Create(Format(_PPNDTL1.DiscAmt).Replace('.', '').Replace(',', '.')));
                            GoodServiceElement.Add(GoodServiceElementItem);
                            //Tax Base
                            Clear(TaxBase);
                            Clear(OtherTaxBase);
                            TaxBase := (_PPNDTL1.Price * _PPNDTL1.QtyDecimal) - _PPNDTL1.DiscAmt;
                            OtherTaxBase := TaxBase * 11 / 12;
                            GoodServiceElementItem := XmlElement.Create('TaxBase');
                            GoodServiceElementItem.Add(XmlText.Create(Format(TaxBase).Replace('.', '').Replace(',', '.')));
                            GoodServiceElement.Add(GoodServiceElementItem);
                            //Other Tax
                            GoodServiceElementItem := XmlElement.Create('OtherTaxBase');
                            GoodServiceElementItem.Add(XmlText.Create(Format(OtherTaxBase).Replace('.', '').Replace(',', '.')));
                            GoodServiceElement.Add(GoodServiceElementItem);
                            //Vat Rate
                            Clear(VatInfo);
                            Evaluate(VatInfo, _PPNDTL1.VatIdentifier);
                            VatInfo := VatInfo / 100;
                            GoodServiceElementItem := XmlElement.Create('VATRate');
                            // GoodServiceElementItem.Add(XmlText.Create(Format(VatInfo).Replace('.', '').Replace(',', '.')));
                            GoodServiceElementItem.Add(XmlText.Create(Format(12).Replace('.', '').Replace(',', '.')));
                            GoodServiceElement.Add(GoodServiceElementItem);
                            //VAT
                            OtherTaxBase := OtherTaxBase * VatInfo;
                            GoodServiceElementItem := XmlElement.Create('VAT');
                            GoodServiceElementItem.Add(XmlText.Create(Format(OtherTaxBase).Replace('.', '').Replace(',', '.')));
                            GoodServiceElement.Add(GoodServiceElementItem);
                            //SGL Rate
                            GoodServiceElementItem := XmlElement.Create('STLGRate');
                            GoodServiceElementItem.Add(XmlText.Create('0'));
                            GoodServiceElement.Add(GoodServiceElementItem);
                            //STLG
                            GoodServiceElementItem := XmlElement.Create('STLG');
                            GoodServiceElementItem.Add(XmlText.Create('0'));
                            GoodServiceElement.Add(GoodServiceElementItem);
                            ListOfGoodServiceElement.Add(GoodServiceElement);
                            //-
                        end;
                    end;
                    TempData := CurrData;
                until _PPNDTL.Next() = 0;
            end;
            //-
            TaxInvoiceElement.Add(TaxInvoiceElementItem);
            TaxInvoiceElement.Add(ListOfGoodServiceElement);
            ListOfTaxInvoiceElement.Add(TaxInvoiceElement);
        //-
        until iPPn.Next() = 0;
        //-
        Elements.Add(ListOfTaxInvoiceElement);
        // Add Elements to document
        XmlDoc.Add(Elements);
        // Set the option to preserve whitespace - true makes it "more human readable"
        // XmlWriteOptions.PreserveWhitespace(true);
        // Create an outStream from the Blob, notice the encoding.
        TempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);
        XmlDoc.WriteTo(OutStream);
        // From the same Blob, that now contains the XML document, create an inStr
        TempBlob.CreateInStream(inStr, TextEncoding::UTF8);
        // Save the data of the InStream as a file.
        fileName := 'Pajak_Keluaran_' + Format(CurrentDateTime, 0, '<Day,2><Month,2><Year>_<Hours24,2><Minutes,2><Seconds,2>') + '.xml';
        File.DownloadFromStream(inStr, 'Export', '', '', fileName);
    end;

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
}
