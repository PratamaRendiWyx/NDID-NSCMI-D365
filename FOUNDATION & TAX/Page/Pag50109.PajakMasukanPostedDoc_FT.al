page 50109 PajakMasukaPostedDoc_FT
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = PPN_FT;
    Caption = 'Posted Incoming Tax';
    DeleteAllowed = true;
    ModifyAllowed = true;
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
                }
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
                    //Lookup = true;
                    //LookupPageId = "Option Lookup List";
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    Caption = 'Address';
                }
            }
            Group(Invoice)
            {
                field(Currency; Rec.Currency)
                {
                    ApplicationArea = All;
                    Caption = 'Currency';
                    Editable = false;
                }
                field(invcamt; Rec.InvoiceAmt)
                {
                    ApplicationArea = All;
                    Caption = 'Invoice Amount';
                    Editable = false;
                }
                field(DPP; Rec.DPP)
                {
                    ApplicationArea = All;
                    Caption = 'DPP';
                    Editable = false;
                    //CharAllowed = '19';// char that allowed 1 to 9
                }
                field(VAT; Rec.VAT)
                {
                    ApplicationArea = All;
                    Caption = 'VAT Amount';
                    Editable = false;
                    //CharAllowed = '19'; // char that allowed 1 to 9
                }
                field(VatBusPostGroup; Rec.VatBusPostGroup)
                {
                    ApplicationArea = All;
                    Caption = 'VAT Business Posting Group';
                    Editable = false;
                }

            }
            part(Lines; PajakMasukaPostedSubPage_FT)
            {
                ApplicationArea = All;
                SubPageLink = InvoiceNo = Field(InvoiceNo);
                SubPageView = sorting();
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                end;
            }
        }
    }
    var
    //myInt: Integer;
}
