table 50739 "New Detail NG QT V1 PQ"
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
        field(2; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(3; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(4; Type; enum TypeNGDetails)
        {
            Caption = 'Type';
        }
        field(5; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            NotBlank = true;
            TableRelation = "Production Order"."No." where(Status = const(Released));
        }
        field(6; "Order Line No."; Integer)
        {
            Caption = 'Order Line No.';
        }
        field(7; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(8; "Sub. Quantity"; Decimal)
        {
            Caption = 'Sub. Quantity';
            FieldClass = FlowField;
            CalcFormula = sum("Detail Sub NG QT PQ".Quantity where("Detail Entry No." = field("Entry No.")));
        }
        field(9; Code; Code[20])
        {
            Caption = 'NG Code';
            TableRelation = "NG Code".Code;
            trigger OnValidate()
            var
                myInt: Integer;
                ngcodes: Record "NG Code";
            begin
                Clear(Description);
                Clear(ngcodes);
                ngcodes.Reset();
                ngcodes.SetRange(code, Code);
                if ngcodes.Find('-') then
                    Description := ngcodes.Description;
            end;
        }
        field(10; Description; Text[150])
        {

        }
    }

    keys
    {
        key(Key1; "QT No.", Date, "Order No.", "Order Line No.", Code)
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
        DetailNGQTPQ: Record "New Detail NG QT V1 PQ";
    begin
        DetailNGQTPQ.Reset();
        DetailNGQTPQ.SetCurrentKey("Entry No.");
        if DetailNGQTPQ.FindLast() then
            exit(DetailNGQTPQ."Entry No." + 1);
        exit(1);
    end;

}
