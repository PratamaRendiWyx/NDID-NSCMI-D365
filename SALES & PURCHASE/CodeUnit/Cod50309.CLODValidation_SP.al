codeunit 50309 CLODValidation_SP
{

    /*   procedure OnValidateToPost(_salesHeader: Record "Sales Header") begin
        if(_salesHeader.Status <> enum::"Sales Document Status"::Released)then begin
          Error('Mohon untuk melakukan proses Release !!!');
        end;
        if _salesHeader."Payment Method Code" = '' then
          Error('Mohon TOP di Input !!!');
      end; */

    procedure FormatNumber(Value: Decimal): Text
    var
        FormattedValue: Text;
    begin
        if Round(Value, 1) <> Value then
            // Jika nilai adalah desimal, format dengan dua angka di belakang koma
            FormattedValue := Format(Value, 0, '<Integer Thousand><Decimals,2>')
        else
            // Jika nilai bukan desimal, format tanpa angka di belakang koma
            FormattedValue := Format(Value, 0, '<Integer Thousand>');

        exit(FormattedValue);
    end;

    procedure CheckCreditLimit(_no: Text; _SalesDocumentType: Enum "Sales Document Type"): boolean
    var
        SalesRecord: Record "Sales Header";
        ret: Boolean;
        customer: Record Customer;
        creditLimit: Decimal;
    begin
        SalesRecord.get(_SalesDocumentType, _no);
        ret := true;
        customer.get(SalesRecord."Sell-to Customer No.");
        creditLimit := customer.CalcAvailableCredit();
        if (creditLimit < 0) then begin
            ret := false;
        end;
        exit(ret);
    end;

    procedure CheckOverdueBalance(_no: Text; _SalesDocumentType: Enum "Sales Document Type"): Boolean
    var
        SalesRecord: Record "Sales Header";
        ret: Boolean;
        currentBalance: Decimal;
        custLedgerEntries: Record "Cust. Ledger Entry";
    begin
        SalesRecord.get(_SalesDocumentType, _no);
        ret := true;
        custLedgerEntries.SetFilter("Customer No.", SalesRecord."Sell-to Customer No.");
        custLedgerEntries.SetFilter(Open, '1');
        custLedgerEntries.SetFilter("Due Date", '<=%1', WorkDate());
        custLedgerEntries.CalcSums("Sales (LCY)");
        currentBalance := custLedgerEntries."Sales (LCY)";
        if (currentBalance > 0) then begin
            ret := false;
        end;
        exit(ret);
    end;
}
