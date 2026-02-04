tableextension 50300 SalesReceivablesSetup_SP extends "Sales & Receivables Setup"
{
    fields
    {
        field(50300; "Enable Finish Orders"; Boolean)
        {
            Caption = 'Enable Close Sales Orders';
            DataClassification = CustomerContent;
        }
        field(50305; "Invoice Nos. (Export)"; Code[20])
        {
            Caption = 'Invoice Nos. (Export)';
            TableRelation = "No. Series";
        }
        field(50310; "Invoice Nos. (Others)"; Code[20])
        {
            Caption = 'Invoice Nos. (Others)';
            TableRelation = "No. Series";
        }
        field(50301; "HS Code"; Text[30])
        {
            Caption = 'HS Code';
            DataClassification = ToBeClassified;
        }
        field(50302; "USCI No"; Text[30])
        {
            Caption = 'USCI No';
            DataClassification = ToBeClassified;
        }
        field(50303; "Honey Comb Diameter"; Text[30])
        {
            Caption = 'Honey Comb Diameter';
            DataClassification = ToBeClassified;
        }
        field(50304; "Honey Comb Length"; Text[30])
        {
            Caption = 'Honey Comb Length';
            DataClassification = ToBeClassified;
        }
        field(50311; "Honey Comb Thickness"; Text[30])
        {
            Caption = 'Honey Comb Thickness';
            DataClassification = ToBeClassified;
        }
        field(50306; "CPSI"; Text[30])
        {
            Caption = 'CPSI';
            DataClassification = ToBeClassified;
        }
        field(50307; "Mantle Diameter"; Text[30])
        {
            Caption = 'Mantle Diameter';
            DataClassification = ToBeClassified;
        }
        field(50308; "Mantle Length"; Text[30])
        {
            Caption = 'Mantle Length';
            DataClassification = ToBeClassified;
        }
        field(50309; "Spec Standard/HI"; Text[30])
        {
            Caption = 'Spec Standard/HI';
            DataClassification = ToBeClassified;
        }
    }
}