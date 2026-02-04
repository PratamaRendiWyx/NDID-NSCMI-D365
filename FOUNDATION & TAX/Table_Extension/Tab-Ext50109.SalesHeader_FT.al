tableextension 50109 SalesHeader_FT extends "Sales Header"
{
    fields
    {
        field(50100;ReturnTaxNo_FT;Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'RecID';
        }
        field(50101;ReturnDocNo_FT;Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'ReturnDocNo';
        }
        field(50102;ReturnDate_FT;Date)
        {
            Caption = 'ReturnDate';
        }
    }
    
}
