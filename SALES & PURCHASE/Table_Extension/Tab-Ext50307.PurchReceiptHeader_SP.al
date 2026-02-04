tableextension 50307 PurchReceiptHeader extends "Purch. Rcpt. Header"
{
    fields
    {
        field(60100; "PIC Goods Receipt"; Text[100])
        {
            Caption = 'PIC Goods Receipt';
        }
        field(60101; "PIC Goods Receipt Name"; Text[100])
        {
            Caption = 'PIC Goods Receipt Name';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
}
