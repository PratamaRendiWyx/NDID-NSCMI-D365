tableextension 50100 Customer_FT extends Customer
{
    fields
    {
        field(50100; "NPWP No_FT"; Code[20])
        {
            Caption = 'NPWP';
        }
        field(50101; "NPWP Nama_FT"; Code[50])
        {
            Caption = 'Nama NPWP';
        }
        field(50102; "NPWP Alamat_FT"; Text[250])
        {
            Caption = 'Alamat NPWP';
        }
        field(50103; "NPWP IsWapu_FT"; Boolean)
        {
            Caption = 'Is Wapu?';
        }
        field(50104; "NPWP PrefixWapu_FT"; Option)
        {
            Caption = 'Prefix';
            OptionMembers = "010","020","030","040","050","060","070","080","090";
        }
        field(50105; "NPWP TaxDigunggung_FT"; Boolean)
        {
            Caption = 'Tax Digunggung?';
        }
        field(50106; "Identity Type"; enum "Customer Identity Type")
        {
            Caption = 'Identity Type';
        }
        field(50107; "Country Code"; Code[20])
        {
            TableRelation = CountryRef_FT.Code;
        }
    }
}