tableextension 50117 FALedgerEntry_FT extends "FA Ledger Entry"
{
    fields
    {
        field(50100; "Serial No."; Text[50])
        {
            Caption = 'Serial No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Fixed Asset"."Serial No." where("No." = field("FA No.")));
        }
    }
}
