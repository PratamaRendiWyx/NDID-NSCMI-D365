tableextension 50503 ReturnShipmentHeader_WE extends "Return Shipment Header"
{
    fields
    {
        field(50502; "Prepared By"; Code[20])
        {
            TableRelation = Employee."No.";
            trigger OnValidate()
            var
                myInt: Integer;
                employee: Record Employee;
            begin
                if "Prepared By" <> '' then begin
                    Clear(employee);
                    employee.Reset();
                    employee.SetRange("No.", "Prepared By");
                    if employee.Find('-') then begin
                        "Prepared By Name" := employee.FullName();
                    end;
                end;
            end;
        }
        field(50503; "Prepared By Name"; Text[100])
        {
        }
        field(50504; "Checked By"; Code[20])
        {
            TableRelation = Employee."No.";
            trigger OnValidate()
            var
                myInt: Integer;
                employee: Record Employee;
            begin
                if "Checked By" <> '' then begin
                    Clear(employee);
                    employee.Reset();
                    employee.SetRange("No.", "Checked By");
                    if employee.Find('-') then begin
                        "Checked By Name" := employee.FullName();
                    end;
                end;
            end;
        }
        field(50505; "Checked By Name"; Text[100])
        {
        }
        field(50506; "Warehouse Person"; Code[20])
        {
            TableRelation = Employee."No.";
            trigger OnValidate()
            var
                myInt: Integer;
                employee: Record Employee;
            begin
                if "Warehouse Person" <> '' then begin
                    Clear(employee);
                    employee.Reset();
                    employee.SetRange("No.", "Warehouse Person");
                    if employee.Find('-') then begin
                        "Warehouse Person Name" := employee.FullName();
                    end;
                end;
            end;
        }
        field(50507; "Warehouse Person Name"; Text[100])
        {
        }
        field(50501; "Additional Notes"; Text[250])
        {
            Caption = 'Additional Notes';
            DataClassification = ToBeClassified;
        }
    }
}
