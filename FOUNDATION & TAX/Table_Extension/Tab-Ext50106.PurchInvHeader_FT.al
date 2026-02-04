tableextension 50106 PurchInvHeader_FT extends "Purch. Inv. Header"
{
    fields
    {
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
            Caption = 'FlagTransfer';
        }

        field(50110; "No. Bukti Potong"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'No. Bukti Potong';
        }

    }
}