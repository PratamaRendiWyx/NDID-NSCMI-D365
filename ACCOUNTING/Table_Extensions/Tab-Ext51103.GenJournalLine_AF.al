tableextension 51103 GenJournalLine_AF extends "Gen. Journal Line"
{
    fields
    {
        modify("Document No.")
        {
            trigger OnAfterValidate()
            begin
                "Document No. Before Posted" := "Document No.";
            end;
        }
        field(50000; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            DataClassification = SystemMetadata;
        }
        field(50018; "Cheque Date"; Date)
        {
            Caption = 'Cheque Date';
            DataClassification = CustomerContent;
        }
        field(50019; "Document No. Before Posted"; Code[20])
        {
            Caption = 'Document No. Before Posted';
            DataClassification = SystemMetadata;

        }
        field(50020; "Cheque No."; Code[10])
        {
            Caption = 'Cheque No.';
            DataClassification = CustomerContent;
        }
        field(50041; "Cust/Vend Bank Acc. Code"; Code[10])
        {
            Caption = 'Cust/Vend Bank Acc. Code';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CASE "Account Type" OF
                    "Account Type"::Customer:
                        IF CustBankAcc.GET("Account No.", "Cust/Vend Bank Acc. Code") THEN
                            "Cust/Vend Bank Acc. Name" := CustBankAcc.Name;
                    "Account Type"::Vendor:
                        IF VendBankAcc.GET("Account No.", "Cust/Vend Bank Acc. Code") THEN
                            "Cust/Vend Bank Acc. Name" := VendBankAcc.Name;
                END;
            end;
        }
        field(50042; "Cust/Vend Bank Acc. Name"; Text[100])
        {
            Caption = 'Cust/Vend Bank Acc. Name';
            DataClassification = CustomerContent;
        }
        // LOCBC 24.05.19 NG +
        field(50046; "Amount before post"; Decimal)
        {
            Caption = 'Amount before post';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        modify("Posting Group")
        {
            Caption = 'Posting Group';
            TableRelation = if ("Account Type" = const(Customer)) "Customer Posting Group"
            else
            if ("Account Type" = const(Vendor)) "Vendor Posting Group"
            else
            if ("Account Type" = const(Employee)) "Employee Posting Group"
            else
            if ("Account Type" = const("Fixed Asset")) "FA Posting Group";
        }
        field(51100; "Payee"; Code[20])
        {
            Caption = 'Payee';
            TableRelation = Employee."No.";
            trigger OnValidate()
            var
                myInt: Integer;
                employee: Record Employee;
            begin
                if Payee <> '' then begin
                    Clear(employee);
                    employee.Reset();
                    employee.SetRange("No.", Payee);
                    if employee.Find('-') then
                        "Payee Name" := employee.FullName();
                end;
            end;
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
        field(51108; "Check Balancing"; Boolean)
        {
            Caption = 'Check Balancing';
            DataClassification = SystemMetadata;
        }
        field(51109; "Account Name 2"; Text[100])
        {
            Caption = 'Account Name 2';
        }
        field(51110; "Is Detail"; Boolean)
        {
            Caption = 'Is Detail (?)';
            DataClassification = SystemMetadata;
        }
        field(51111; "FA Posting Group"; Code[20])
        {
            Caption = 'FA Posting Group';
            FieldClass = FlowField;
            CalcFormula = lookup("Fixed Asset"."FA Posting Group" where("No." = field("Account No.")));

        }
        field(51112; "PIB/PEB No"; Text[100])
        {
            Caption = 'PIB/PEB No';
        }
    }

    var
        CustBankAcc: Record "Customer Bank Account";
        VendBankAcc: Record "Vendor Bank Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        GLSetup: Record "General Ledger Setup";
        BankLedgEntry: Record "Bank Account Ledger Entry";
        Text50000: Label 'Vendor or Customer No. must be %1', MaxLength = 1024, Locked = true;
        GenJnlTemplate: Record "Gen. Journal Template";
}
