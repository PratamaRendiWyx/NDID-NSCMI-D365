tableextension 50701 PurchRcptLine_PQ extends "Purch. Rcpt. Line"
{

    fields
    {
        field(50700; "CCS QC Required"; Boolean)
        {
            Caption = 'Quality Test Mandatory';
            Description = 'Informational only';
            DataClassification = CustomerContent;
        }
    }
}

