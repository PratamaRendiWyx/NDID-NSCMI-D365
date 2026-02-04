page 50107 PajakMasukanDocument_FT
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = PPN_FT;
    Caption = 'Pajak Masukan Card';
    DeleteAllowed = true;
    ModifyAllowed = true;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(InvoiceNo;Rec.InvoiceNo)
                {
                    ApplicationArea = All;
                    Caption = 'Invoice No.';
                    Editable = false;
                }
                field(invcdt;Rec.InvoiceDate)
                {
                    ApplicationArea = All;
                    Caption = 'Invoice Date';
                    Editable = false;
                }
                field(FPPengganti;Rec.FPPengganti)
                {
                    ApplicationArea = All;
                    Caption = 'Faktur Pajak Pengganti';
                }
                field(TaxNumber;Rec.TaxNumber)
                {
                    ApplicationArea = All;
                    Caption = 'Tax Number';
                }
                field(TaxDate;Rec.TaxDate)
                {
                    ApplicationArea = All;
                    Caption = 'Tax Date';
                }
                field(ReturnTaxNo;Rec.ReturnTaxNo)
                {
                    ApplicationArea = All;
                    Caption = 'Return Tax No';
                }
                field(ReturnDocNo;Rec.ReturnDocNo)
                {
                    ApplicationArea = All;
                    Caption = 'Return Doc No';
                }
                field(ReturnDate;Rec.ReturnDate)
                {
                    ApplicationArea = All;
                    Caption = 'Return Date';
                }
                field(AccountNo;Rec.AccountNo)
                {
                    ApplicationArea = All;
                    Caption = 'Account No';
                    Editable = false;
                }
                field(NPWP;Rec.NPWP)
                {
                    ApplicationArea = All;
                    Caption = 'NPWP';
                }
                field(Nama;Rec.Nama)
                {
                    ApplicationArea = All;
                    Caption = 'Nama';
                //Lookup = true;
                //LookupPageId = "Option Lookup List";
                }
                field(Address;Rec.Address)
                {
                    ApplicationArea = All;
                    Caption = 'Address';
                }
            }
            Group(Invoice)
            {
                field(Currency;Rec.Currency)
                {
                    ApplicationArea = All;
                    Caption = 'Currency';
                    Editable = false;
                }
                field(inceamt;Rec.InvoiceAmt)
                {
                    ApplicationArea = All;
                    Caption = 'Invoice Amount';
                    Editable = false;
                }
                field(DPP;Rec.DPP)
                {
                    ApplicationArea = All;
                    Caption = 'DPP';
                    Editable = false;
                //CharAllowed = '19';// char that allowed 1 to 9
                }
                field(VAT;Rec.VAT)
                {
                    ApplicationArea = All;
                    Caption = 'VAT Amount';
                    Editable = false;
                //CharAllowed = '19'; // char that allowed 1 to 9
                }
                field(VatBusPostGroup;Rec.VatBusPostGroup)
                {
                    ApplicationArea = All;
                    Caption = 'VAT Business Posting Group';
                    Editable = false;
                }
            // field(VatProdPostGroup; VatProdPostGroup)
            // {
            //     ApplicationArea = All;
            //     Caption = 'VAT Product Posting Group';
            //     Editable = false;
            // }
            // field(VatCalType; VatCalType)
            // {
            //     ApplicationArea = All;
            //     Caption = 'VAT Calculate Type';
            //     Editable = false;
            // }
            }
            part(Lines;PajakMasukanSubPage_FT)
            {
                ApplicationArea = All;
                SubPageLink = InvoiceNo=Field(InvoiceNo);
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

                trigger OnAction()var //itkPPN: Record PPN_FT;
                answer: Boolean;
                begin
                    answer:=Dialog.Confirm('Are you sure want to posting this document?');
                    if answer then begin
                        //Message('mantap!');
                        //itkPPN.Get(RecID);
                        Rec.FlagPosted:=EnumYN_FT::Y;
                        if Rec.Modify()then begin
                            Message('Posted Successfully');
                            CurrPage.Close();
                        end;
                    end;
                end;
            }
        }
    }
}
