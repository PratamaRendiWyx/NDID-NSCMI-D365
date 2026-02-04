tableextension 51102 GLEntry_AF extends "G/L Entry"
{
    fields
    {
        field(51102; "Tax Date"; Date)
        {
            Caption = 'Tax Date';
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Inv. Header"."Tax Date_FT" where("No." = field("Document No.")));
        }
        field(50000; "WHT Certificate No."; Code[20])
        {
            Caption = 'WHT Certificate No.';
            DataClassification = SystemMetadata;
        }
        field(50001; "Document No. Before Posted"; Code[20])
        {
            Caption = 'Document No. Before Posted';
            DataClassification = SystemMetadata;
        }
        field(50002; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = SystemMetadata;
        }
        field(50003; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DataClassification = SystemMetadata;
        }
        field(50006; "Vendor Invoice Branch"; Code[20])
        {
            Caption = 'Vendor Invoice Branch';
            DataClassification = SystemMetadata;
        }
        field(50007; "Cust/Vend Bank Acc. Code"; Code[10])
        {
            Caption = 'Cust/Vend Bank Acc. Code';
            DataClassification = SystemMetadata;
        }
        field(50008; "Cust/Vend Bank Acc. Name"; Text[100])
        {
            Caption = 'Cust/Vend Bank Acc. Name';
            DataClassification = SystemMetadata;
        }
        field(50010; "Currency Amount 2"; Decimal)
        {
            Caption = 'Currency Amount';
            DataClassification = SystemMetadata;
        }
        field(51112; "PIB/PEB No"; Text[100])
        {
            Caption = 'PIB/PEB No';
        }
    }
}
