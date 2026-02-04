namespace ACCOUNTING.ACCOUNTING;

using Microsoft.Finance.Currency;

tableextension 51113 Currency_AF extends Currency
{
    fields
    {
        field(50200; Description2; Text[100])
        {
            Caption = 'Description 2';
            DataClassification = ToBeClassified;
        }
    }
}
