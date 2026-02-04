table 50105 RegTaxNumLine_FT
{
    DataClassification = ToBeClassified;

    fields
    {
 
        field(10;ID;Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
            Caption = 'ID';
        }
        field(11;RegTaxNumId;Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'RegTaxNumId';
        }
        field(20;TaxNum;Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tax No';
        }
        field(30;Reff;Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Refference';
        }
        field(40;Status;Enum TaxLineStatus_FT)
        {
            DataClassification = ToBeClassified;
            Caption = 'Status';
        }
    }
    keys
    {

        key(PrimaryKey;ID)
        {
            Clustered = true;
        }
    }

}
