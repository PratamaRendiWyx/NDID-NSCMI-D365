table 50300 PurchaseCue_SP
{
    Caption = 'Purchase Cue';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Purch. Return Orders - Qty"; Integer)
        {
            CalcFormula = count("Purchase Line" where("Document Type" = const("Return Order"),
                                                        "Outstanding Quantity" = filter(<> 0)
                                                      ));
            Caption = 'Purch. Return Orders - Qty.';
            Editable = false;
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }
}
