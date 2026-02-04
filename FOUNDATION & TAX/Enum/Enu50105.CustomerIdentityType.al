enum 50105 "Customer Identity Type"
{
    Extensible = true;

    value(0; TIN)
    {
        Caption = 'TIN';
    }
    value(1; NIK)
    {
        Caption = 'NIK';
    }
    value(2; Passport)
    {
        Caption = 'Passport';
    }
    value(3; Other)
    {
        Caption = 'Other';
    }
}
