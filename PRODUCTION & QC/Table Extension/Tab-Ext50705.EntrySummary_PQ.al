tableextension 50705 EntrySummary_PQ extends "Entry Summary"
{

    fields
    {
        field(50700; "QC Non Compliance"; Boolean)
        {
            Caption = 'Quality Control Non Compliance';
            Description = 'QC';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50701; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            Description = 'QC';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50702; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            Description = 'QC';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50703; "QC Option"; Option)
        {
            Caption = 'Quality Option';
            Description = 'QC';
            Editable = false;
            OptionMembers = " ",Company,Customer;
            DataClassification = CustomerContent;
        }
        field(50704; "Version Code"; Code[20])
        {
            Caption = 'Version Code';
            Description = 'QC';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50705; "QC Test Exists"; Boolean)
        {
            Caption = 'Quality Test Exists';
            Description = 'QC';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50706; "QC Compliance"; Code[20])
        {
            Caption = 'Quality Control Compliance';
            Description = 'QC';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50707; "QC Specs Exist"; Boolean)
        {
            Caption = 'Quality Specifications Exist';
            Description = 'QC';
            DataClassification = CustomerContent;
        }
        field(50708; "Cust Specs Exist"; Boolean)
        {
            Caption = 'Cust Specs Exist';
            Description = 'QC7.7';
            DataClassification = CustomerContent;
        }
        field(50709; "Cust Test Exists"; Boolean)
        {
            Caption = 'Cust Test Exists';
            Description = 'QC7.7';
            DataClassification = CustomerContent;
        }
        field(50710; "Item Test Non Compliant"; Boolean)
        {
            Caption = 'Item Test Non Compliant';
            Description = 'QC7.7';
            DataClassification = CustomerContent;
        }
        field(50711; "Cust Test Non Compliant"; Boolean)
        {
            Caption = 'Cust Test Non Compliant';
            Description = 'QC7.7';
            DataClassification = CustomerContent;
        }
    }
}

