table 50113 BarangJasaRef_FT
{
    Caption = 'Barang Jasa Ref. Tax';
    DrillDownPageID = "Barang Jasa Ref.";
    LookupPageID = "Barang Jasa Ref.";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[150])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
