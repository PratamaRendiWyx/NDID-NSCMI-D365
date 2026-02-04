namespace ACCOUNTING.ACCOUNTING;

using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Finance.GeneralLedger.Account;

tableextension 51108 PostedGenJournalLine_AF extends "Posted Gen. Journal Line"
{
    fields
    {
        field(51100; "Payee"; Code[20])
        {
            Caption = 'Payee';
        }
        field(51101; "Payee Name"; Text[100])
        {
            Caption = 'Payee Name';
        }
        field(51103; "Account Name"; Text[100])
        {
            Caption = 'Account Name';
            FieldClass = FlowField;
            CalcFormula = lookup("G/L Account".Name where("No." = field("Account No.")));
        }
        field(51104; Owing; Decimal)
        {
            Caption = 'Owing';
        }
        field(51105; "Payment Amount"; Decimal)
        {
            Caption = 'Payment Amount';
        }
        field(51106; "Discount Amount"; Decimal)
        {
            Caption = 'Payment Amount';
        }
        field(51107; "Document No. Before Posted"; Code[20])
        {
            Caption = 'Document No. Before Posted';
            DataClassification = SystemMetadata;
        }
        field(51108; "Check Balancing"; Boolean)
        {
            Caption = 'Check Balancing';
            DataClassification = SystemMetadata;
        }
        field(51110; "Is Detail"; Boolean)
        {
            Caption = 'Is Detail (?)';
            DataClassification = SystemMetadata;
        }
        field(51109; "Account Name 2"; Text[100])
        {
            Caption = 'Account Name 2';
        }
        field(51112; "PIB/PEB No"; Text[100])
        {
            Caption = 'PIB/PEB No';
        }
    }
}
