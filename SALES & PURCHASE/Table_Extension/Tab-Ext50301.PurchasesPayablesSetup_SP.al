tableextension 50301 PurchasesPayablesSetup_SP extends "Purchases & Payables Setup"
{
    fields
    {
        field(50300; "Enable Finish Orders"; Boolean)
        {
            Caption = 'Enable Close Purchase Orders';
            DataClassification = CustomerContent;
        }
        field(50301; "Posted Sub Cont. Nos."; Code[20])
        {
            Caption = 'Posted Sub Cont. Nos.';
            TableRelation = "No. Series";
        }
    }
}