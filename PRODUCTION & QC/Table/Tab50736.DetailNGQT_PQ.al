table 50736 "Detail NG QT PQ"
{
    Caption = 'Detail NG QT/PRODUCTION';
    DrillDownPageID = "Detail NG List";
    LookupPageID = "Detail NG List";
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
            TableRelation = "NG Code".Code;
            trigger OnValidate()
            var
                myInt: Integer;
                NGCodes: Record "NG Code";
            begin
                Clear(NGCodes);
                NGCodes.SetRange(Code, Code);
                if NGCodes.Find('-') then
                    Description := NGCodes.Description;
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
        field(6; Type; enum TypeNGDetails)
        {
            Caption = 'Type';
        }
        field(7; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            NotBlank = true;
            TableRelation = "Production Order"."No." where(Status = const(Released));
        }
        field(8; "Order Line No."; Integer)
        {
            Caption = 'Order Line No.';
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
