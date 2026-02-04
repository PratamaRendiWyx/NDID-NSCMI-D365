table 50724 ItemQualityRequirement_PQ
{
    DataClassification = ToBeClassified;
    Caption = 'Item Quality Requirement';

    fields
    {
        field(1; Type; Enum ItemQualityRequirement_PQ)
        {
            DataClassification = CustomerContent;
            Caption = 'Type';

            // trigger OnValidate()
            // begin
            //     CheckValidationNewLine(Type, "Item No.", "Variant Code", "Location Code", "Starting Date");
            // end;
        }
        field(2; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.';
            TableRelation = Item;

            trigger OnValidate()
            begin
                CheckValidationNewLine(Type, "Item No.", "Variant Code", "Location Code", "Starting Date");
            end;
        }
        field(3; "Specification No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Specification No.';
            TableRelation = QCSpecificationHeader_PQ.Type WHERE("Item No." = field("Item No."), Status = filter(Certified));
        }
        field(4; "Starting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                CheckValidationNewLine(Type, "Item No.", "Variant Code", "Location Code", "Starting Date");
            end;
        }
        field(5; "Ending Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Ending Date';
        }
        field(6; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CheckValidationNewLine(Type, "Item No.", "Variant Code", "Location Code", "Starting Date");
            end;
        }
        field(7; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CheckValidationNewLine(Type, "Item No.", "Variant Code", "Location Code", "Starting Date");
            end;
        }
    }

    keys
    {
        key(Key1; Type, "Item No.", "Specification No.")
        {
            Clustered = true;
        }
        key(Key2; Type, "Item No.", "Variant Code", "Specification No.")
        {
        }
        key(Key3; Type, "Item No.", "Variant Code", "Location Code", "Specification No.")
        {
        }
    }

    local procedure CheckValidationNewLine(NewType: Enum ItemQualityRequirement_PQ; NewItemNo: Code[20]; NewVariantCode: Code[20]; NewLocationCode: Code[20]; NewStartingDate: Date)
    var
        ItemQualityRequirement: Record ItemQualityRequirement_PQ;
        Err001: Label 'The record in table Item Quality Requirement already exists. Identification fields and values: Type = ''%1'', Item No. = ''%2'', Variant Code = ''%3'', Location Code = ''%4'', Starting Date = ''%5''';
    begin
        ItemQualityRequirement.Reset();
        ItemQualityRequirement.SetRange(Type, NewType);
        ItemQualityRequirement.SetRange("Item No.", NewItemNo);
        ItemQualityRequirement.SetRange("Variant Code", NewVariantCode);
        ItemQualityRequirement.SetRange("Location Code", NewLocationCode);
        ItemQualityRequirement.SetRange("Starting Date", NewStartingDate);
        if ItemQualityRequirement.FindFirst() then
            Error(Err001, NewType, NewItemNo, NewVariantCode, NewLocationCode, NewStartingDate);
    end;
}