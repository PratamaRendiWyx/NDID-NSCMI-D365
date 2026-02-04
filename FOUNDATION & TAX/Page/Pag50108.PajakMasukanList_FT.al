page 50108 PajakMasukanList_FT
{
    PageType = List;
    Caption = 'Incoming Tax List';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = PPN_FT;
    InsertAllowed = false;
    CardPageId = PajakMasukanDocument_FT;
    SourceTableView = sorting(RecID) order(ascending) where(FlagTaxType = filter(Input), FlagPosted = filter(N));

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
                field(FlagRetur; Rec.FlagRetur)
                {
                    ApplicationArea = All;
                    Caption = 'Is Return Item';
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
                    Caption = 'Invoice No';
                    Editable = false;
                }
                field(InvoiceDate; Rec.InvoiceDate)
                {
                    ApplicationArea = All;
                    Caption = 'Invoice Date';
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
                // field(NPWP; NPWP)
                // {
                //     ApplicationArea = All;
                //     Caption = 'NPWP';
                //     Editable = false;
                // }
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
            action("Posting")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = Post;


                trigger OnAction()
                var
                    itkPPN: Record PPN_FT;
                    answer: Boolean;
                begin
                    answer := Dialog.Confirm('Are you sure want to posting this document?');
                    // if answer then begin
                    //     //Message('mantap!');
                    //     itkPPN.Get(RecID);
                    //     itkPPN.FlagPosted := EnumYN_FT::Y;
                    //     if itkPPN.Modify() then begin
                    //         Message('Posted Successfully');
                    //         //CurrPage.Close();
                    //     end;
                    // end;
                    CurrPage.SetSelectionFilter(itkPPN);
                    itkPPN.FindSet();
                    if answer then begin
                        repeat begin
                            //Message('mantap!');
                            //itkPPN.Get(RecID);
                            itkPPN.FlagPosted := 1;
                            if itkPPN.Modify() then begin
                                Message('Posted Successfully');
                                //CurrPage.Close();
                            end;
                        end until itkPPN.Next = 0;
                    end;
                end;
            }
        }
    }

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

    // var
    //     FileInstream: InStream;
    //     TempBlob: Record TempBlob;
    //     FileName: Text;
    //     MyOutStream: OutStream;
    //     MyInStream: InStream;
    //     outputFileName: Text;
    //     Xmlport1: XMLport "Export/Import User Groups";
    //     flagimport: Boolean;
    //     xmlportno: Integer;
    // procedure RunXMLPortImport()
    // begin
    //     UploadIntoStream('', '', '', FileName, FileInstream);
    //     XMLPORT.Import(xmlportno, FileInstream); //Dynamic XMLPort No.
    //     Message('Import Done successfully.');
    // end;
    // procedure RunXMLPortExport()
    // begin
    //     TempBlob.Blob.CreateOutStream(MyOutStream);
    //     XMLPORT.Export(xmlportno, MyOutStream); //Dynamic XMLPort No.
    //     TempBlob.Blob.CreateInStream(MyInStream);
    //     outputFileName := 'MyOutput.xml';
    //     DownloadFromStream(MyInStream, '', '', '', outputFileName);  //Save in Download folder
    //     Message('Export Done successfully.');
    // end;
    // local procedure ExportPPN(RecId: Integer)
    // var
    //     _instream: InStream;
    //     _outstream: OutStream;
    //     _ITKPPN: Record PPN_FT;
    //     _fileName: Text;
    //     _TempBlob: Record TempBlob temporary;
    //     _variable: Text;
    // begin
    //     //Message(Format(RecId));
    //     _variable[1] := 10;
    //     _ITKPPN.Get(RecId);
    //     _fileName := 'Pajak Masukan ' + Format(_ITKPPN.InvoiceNo) + '.txt';
    //     _TempBlob.Blob.CreateOutStream(_outstream);
    //     _outstream.WriteText(
    //                             '"' + 'RecId: ' + Format(_ITKPPN.RecID) + '"'
    //                             + ',' + '"' + 'Tax Number: ' + Format(_ITKPPN.TaxNumber) + '"'
    //                             + ',' + '"' + 'Tax Date:' + Format(_ITKPPN.TaxDate) + '"'
    //                             + ',' + '"' + 'Invoice No:' + Format(_ITKPPN.InvoiceNo) + '"'
    //                             + _variable
    //                             + ',' + '"' + 'Account No:' + Format(_ITKPPN.AccountNo) + '"'
    //                             );
    //     _TempBlob.Blob.CreateInStream(_instream);
    //     DownloadFromStream(_instream, '', '', '', _fileName)
    // end;
    // trigger OnOpenPage()
    // var
    //     // FlagTaxType: Enum EnumInOut_FT;
    //     YesNo: Enum EnumYN_FT;
    // begin
    //     rec.SetRange(FlagTaxType, FlagTaxType::Input);
    //     rec.SetRange(FlagPosted, YesNo::N);
    // end;
}
