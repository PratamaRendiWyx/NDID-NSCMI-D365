table 50738 "New Detail NG QT PQ"
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
            FieldClass = FlowField;
            CalcFormula = sum("Detail Sub NG QT PQ".Quantity where("Detail Entry No." = field("Entry No."), Code = field(Code)));
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
        field(9; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
    }

    keys
    {
        key(Key1; "QT No.", "Code", Date, "Order No.", "Order Line No.")
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

    trigger OnDelete()
    var
        myInt: Integer;
    begin
        deleteRelationSub();
    end;

    local procedure deleteRelationSub()
    var
        SubDetailNG: Record "Detail Sub NG QT PQ";
    begin
        Clear(SubDetailNG);
        SubDetailNG.SetRange("Detail Entry No.", Rec."Entry No.");
        if SubDetailNG.FindSet() then begin
            SubDetailNG.DeleteAll();
        end;
    end;

    local procedure NextEntryNo(): Integer
    var
        DetailNGQTPQ: Record "New Detail NG QT PQ";
    begin
        DetailNGQTPQ.Reset();
        DetailNGQTPQ.SetCurrentKey("Entry No.");
        if DetailNGQTPQ.FindLast() then
            exit(DetailNGQTPQ."Entry No." + 1);
        exit(1);
    end;

}
