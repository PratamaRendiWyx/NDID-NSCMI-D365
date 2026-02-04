tableextension 50515 InvtShipmentHeader_WE extends "Invt. Shipment Header"
{
    fields
    {
        field(50502; "Prepared By"; Code[20])
        {
            TableRelation = Employee."No.";
        }
        field(50503; "Prepared By Name"; Text[100])
        {
        }
        field(50504; "Checked By"; Code[20])
        {
            TableRelation = Employee."No.";
        }
        field(50505; "Checked By Name"; Text[100])
        {
        }
        field(50506; "Warehouse Person"; Code[20])
        {
            TableRelation = Employee."No.";
        }
        field(50507; "Warehouse Person Name"; Text[100])
        {
        }
        field(50500; Remarks; Text[250])
        {
        }
        field(50509; "Vendor No."; Code[20])
        {
        }
        field(50510; "Vendor Name"; Text[150])
        {
        }
        field(50501; IsSubcon; Boolean)
        {
            trigger OnValidate()
            begin
                if IsSubcon then begin
                    "Vendor No." := '';
                    "Vendor Name" := '';
                end;
            end;
        }

    }
}
