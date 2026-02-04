table 50737 "Detail Sub NG QT PQ"
{
    Caption = 'Detail Sub NG QT/PRODUCTION';
    DrillDownPageID = "Detail Sub NG List";
    LookupPageID = "Detail Sub NG List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[10])
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
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(4; "Detail Entry No."; Integer)
        {
            Caption = 'Detail Entry No.';
        }
        field(5; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(6; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            NotBlank = true;
            TableRelation = "Production Order"."No." where(Status = const(Released));
        }
        field(7; "Order Line No."; Integer)
        {
            Caption = 'Order Line No.';
        }
        field(8; "QT No."; Code[20])
        {
            Caption = 'Quality Test No.';
            NotBlank = true;
        }
        field(9; "Remark"; Text[250])
        {
            Caption = 'Remark';
            NotBlank = true;
        }
    }

    keys
    {
        key(Key1; "Entry No.", "Detail Entry No.", Code, "QT No.", "Order No.", "Order Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        myInt: Integer;
    begin
        "Entry No." := NextEntryNo();
    end;

    local procedure NextEntryNo(): Integer
    var
        DetailSUbNGQTPQ: Record "Detail Sub NG QT PQ";
    begin
        DetailSUbNGQTPQ.Reset();
        DetailSUbNGQTPQ.SetRange(Code, Rec.Code);
        DetailSUbNGQTPQ.SetCurrentKey("Entry No.");
        if DetailSUbNGQTPQ.FindLast() then
            exit(DetailSUbNGQTPQ."Entry No." + 1);
        exit(1);
    end;

}

