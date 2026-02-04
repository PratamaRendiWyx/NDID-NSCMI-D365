tableextension 50326 "Inventory Setup_SP" extends "Inventory Setup"
{
    fields
    {
        field(50300; "Ignore Package No. for Exp.Qty"; Boolean)
        {
            Caption = 'Ignore Package No. for Exp.Qty (Invt. Order)';
            DataClassification = ToBeClassified;
        }
    }
}
