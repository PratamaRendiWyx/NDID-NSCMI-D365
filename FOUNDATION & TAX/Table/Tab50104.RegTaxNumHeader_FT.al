table 50104 RegTaxNumHeader_FT
{
    DataClassification = ToBeClassified;

    fields
    {
        field(10;RegTaxNumId;Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'ID';
            AutoIncrement = true;
        }
        field(20;FromDate;Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'From Date';
        }
        field(30;ToDate;Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'To Date';
        }
        field(40;Prefix;Text[16])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tax Prefix';
        }
        field(50;NoFrom;Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Tax No From';
        }
        field(60;NoTo;Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Tax No To';
        }
        field(70;Status;Enum TaxStatus_FT)
        {
            DataClassification = ToBeClassified;
            Caption = 'Status';
        }
    }
    keys
    {
        key(PK;RegTaxNumID)
        {
            Clustered = true;
        }
    }
    var 
    RTN: Codeunit RegisterTaxNumber_FT;

}
