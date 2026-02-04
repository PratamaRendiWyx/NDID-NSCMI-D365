tableextension 50721 TransferHeader_PQ extends "Transfer Header"
{
    fields
    {
        field(50200; "IsFromProdOrder"; Boolean)
        {
            Caption = 'Is from Prod. Order';
        }
        field(50201; "Prod. Order No."; Code[20])
        {
            Caption = 'Prod. Order No.';
        }

    }
}