table 50735 "Detail Repair QT PQ"
{
    Caption = 'Detail Repair QT';
    DrillDownPageID = "Detail Repair QT";
    LookupPageID = "Detail Repair QT";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "QT No."; Code[20])
        {
            Caption = 'Quality Test No.';
            NotBlank = true;
        }
        field(2; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
            TableRelation = "Repair Code".Code;
            trigger OnValidate()
            var
                myInt: Integer;
                RepairCodes: Record "Repair Code";
            begin
                Clear(RepairCodes);
                RepairCodes.SetRange(Code, Code);
                if RepairCodes.Find('-') then
                    Description := RepairCodes.Description;
            end;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(4; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(5; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
    }

    keys
    {
        key(Key1; "QT No.", "Code", Date)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

