table 50742 "BOP Refference Document"
{
    Caption = 'BOP Refference Document';
    LookupPageID = QCControlMethods_PQ;

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
            trigger OnValidate()
            var
                myInt: Integer;
                Item: Record Item;
            begin
                Clear(Description);
                Item.Reset();
                Item.SetRange("No.", "Item No.");
                if Item.Find('-') then
                    Description := Item.Description;
            end;
        }
        field(3; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(4; "Document No."; Code[50])
        {
            Caption = 'Document No.';
        }
        field(5; Revision; Code[4])
        {
            Caption = 'Revision';
        }
        field(6; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field("Customer No.")));
            Editable = false;
        }
        field(7; "Description"; Text[100])
        {
            Caption = 'Description';
        }
        field(8; "Code"; Code[20])
        {
            Caption = 'Code';
        }
    }
    keys
    {
        key(PK; "Customer No.", "Item No.")
        {
            Clustered = true;
        }
    }
}
