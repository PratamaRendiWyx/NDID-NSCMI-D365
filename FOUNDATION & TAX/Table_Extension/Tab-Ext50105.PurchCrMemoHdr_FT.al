tableextension 50105 PurchCrMemoHdr_FT extends "Purch. Cr. Memo Hdr."
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Tax Number_FT"; Code[40])
        {
            Caption = 'Tax Number';
        }
        field(50101; "Tax Date_FT"; Date)
        {
            Caption = 'Tax Date';
        }
        field(50102; ReturnTaxNo_FT; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'RecID';
        }
        field(50103; ReturnDocNo_FT; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'ReturnDocNo';
        }
        field(50104; ReturnDate_FT; Date)
        {
            Caption = 'ReturnDate';
        }

        field(50105; FlagTransfer_FT; Enum EnumYN_FT)
        {
            Caption = 'Flag Transfer';
        }
    }
}