tableextension 50520 "Warehouse Activity Header" extends "Warehouse Activity Header"
{
    fields
    {
        field(50520; "Operator"; Code[20])
        {
            TableRelation = Employee."No.";
            trigger OnValidate()
            var
                myInt: Integer;
                employee: Record Employee;
            begin
                Clear(employee);
                employee.Reset();
                employee.SetRange("No.", Operator);
                if employee.Find('-') then
                    "Operator Name" := employee.FullName()
                else
                    "Operator Name" := '';
            end;
        }
        field(50521; "Operator Name"; Code[250])
        {
            Editable = false;
        }
    }
}
