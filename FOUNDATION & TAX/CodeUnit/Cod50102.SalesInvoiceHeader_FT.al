codeunit 50102 SalesInvoiceHeader_FT
{
    trigger OnRun()begin
    end;
    var _RecTaxParam: Record TaxIndoParameter_FT;
    procedure CheckTaxSetup(): Boolean begin
        if _RecTaxParam.TaxOut = true then begin
            exit(true)end
        else
        begin
            exit(false)end;
    end;
}