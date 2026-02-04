table 50714 QCRequirements_PQ
{
    // version QC80.1

    // //QC5  Added Customer No. to Primary Key
    // 
    // QC80.1
    //   - Added Fields "Description" and "Name"

    Caption = 'Quality Requirements';

    fields
    {
        field(1; "Item No."; Code[20])
        {
            NotBlank = true;
            TableRelation = Item."No." WHERE("Item Tracking Code" = FILTER(<> ''));
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //QC4
                if Item.GET("Item No.") then
                    if Item."Item Tracking Code" = '' then
                        ERROR(QCText000);
            end;
        }
        field(2; "Customer No."; Code[20])
        {
            TableRelation = Customer;
            DataClassification = CustomerContent;
        }
        field(3; "Quality Testing Required"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Description"; Text[100])
        {
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item No.")));
            Description = 'QC80.1 - FlowField';
            FieldClass = FlowField;
        }
        field(5; "Name"; Text[100])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Customer No.")));
            Description = 'QC80.1 - FlowField';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Item No.", "Customer No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Item: Record Item;
        QCText000: Label 'Items that require QC tests must be setup with Item Tracking Codes.';
}

    