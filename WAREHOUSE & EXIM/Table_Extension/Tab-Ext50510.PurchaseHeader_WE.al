tableextension 50510 PurchaseHeader_WE extends "Purchase Header"
{
    fields
    {
        field(50500; "Document Status"; Enum "Document Status")
        {
            Caption = 'Document Status';
            DataClassification = ToBeClassified;
        }
        field(50501; "Additional Notes"; Text[250])
        {
            Caption = 'Additional Notes';
            DataClassification = ToBeClassified;
        }
    }
}
