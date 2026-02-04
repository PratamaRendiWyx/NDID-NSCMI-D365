table 50106 TaxIndoParameter_FT
{
    DataClassification = ToBeClassified;

    fields
    {
        field(10;TaxIndoParamID;Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(20;TaxIN;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(30;TaxOut;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(40;Signer;Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50;"Remain Tax Number Warning";Integer)
        {
            Caption = 'Remain Tax No Warning';
            DataClassification = ToBeClassified;
        }
    }

}