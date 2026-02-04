tableextension 50108 SalesCrMemoHeader_FT extends "Sales Cr.Memo Header"
{
    fields
    {
        // Add changes to table fields here
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
        field(50103;FlagTransfer_FT;Enum EnumYN_FT)
        {
            Caption = 'FlagTransfer';
        } 
    }

}
