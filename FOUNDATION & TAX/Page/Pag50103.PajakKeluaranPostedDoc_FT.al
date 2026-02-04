page 50103 PajakKeluaranPostedDoc_FT
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    SourceTable = PPN_FT;
    Caption = 'Posted Outgoing Tax';

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
                    Caption = 'Account No.';
                    Editable = false;
                }
                field("Country Code"; Rec."Country Code")
                {
                    ApplicationArea = All;
                }
                field("Facility Ref"; Rec."Facility Ref")
                {
                    ApplicationArea = All;
                }
                field("Add Info Ref"; Rec."Add Info Ref")
                {
                    ApplicationArea = All;
                }
                field("Identity Type"; Rec."Identity Type")
                {
                    ApplicationArea = All;
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
                Caption = 'Invoice Header';

                field(Currency; Rec.Currency)
                {
                    ApplicationArea = All;
                    Caption = 'Currency';
                }
                field(DPP; Rec.DPP)
                {
                    ApplicationArea = All;
                    Caption = 'DPP Amount';
                }
                field(VAT; Rec.VAT)
                {
                    ApplicationArea = All;
                    Caption = 'VAT Amount';
                }
                field(VatBusPostGroup; Rec.VatBusPostGroup)
                {
                    ApplicationArea = All;
                    Caption = 'VAT Business Posting Group';
                }

            }
            Group(Other)
            {
                Caption = 'Invoice Line';
                part(Lines; PajakKeluaranPostedSub_FT)
                {
                    ApplicationArea = All;
                    SubPageLink = InvoiceNo = Field(InvoiceNo);
                }
            }
        }
        area(Factboxes)
        {
        }
    }
    actions
    {
    }
}
