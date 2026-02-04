tableextension 50311 SalesInvoiceHeader_SP extends "Sales Invoice Header"
{
    fields
    {
        field(50307; "BL No"; Code[30])
        {

        }
        field(50308; "PEB No"; Code[30])
        {

        }
        field(50309; "Request No"; Code[30])
        {
            Caption = 'No AJU';
        }
        field(50310; "Invoice Type"; Enum InvoiceType_SP)
        {
        }
        field(50500; "Packing No."; Code[150])
        {

        }
        field(50501; "Tax No."; Code[40])
        {
        }
        field(50313; "Contract No."; Text[30]) { }
        field(50314; "Additional Notes"; Text[500])
        {
            Caption = 'Additional Notes';
        }
        field(50315; "Approved By"; Text[30])
        {
            Caption = 'Approved By';
            TableRelation = Employee."No." where("No." = field("Approved By"));
            trigger OnValidate()
            var
                myInt: Integer;
                employee: Record Employee;
            begin
                employee.Reset();
                if employee.Get("Approved By") then
                    "Approver Name" := employee.FullName();
            end;
        }
        field(50316; "Approver Name"; Text[100])
        {
            Caption = 'Approver Name';
            Editable = false;
        }
        field(50317; "Checked By"; Text[30])
        {
            Caption = 'Checked By';
            TableRelation = Employee."No." where("No." = field("Checked By"));
            trigger OnValidate()
            var
                myInt: Integer;
                employee: Record Employee;
            begin
                employee.Reset();
                if employee.Get("Checked By") then
                    "Checker Name" := employee.FullName();
            end;
        }
        field(50318; "Checker Name"; Text[100])
        {
            Caption = 'Checker Name';
            Editable = false;
        }
        field(50319; "Delivery By"; Enum "Delivery By")
        {
            Caption = 'Delivery By';
        }
        field(50320; "FOB"; Decimal)
        {
            Caption = 'FOB';
        }
        field(50321; "Freight"; Decimal)
        {
            Caption = 'Freight & Insurance';
        }
        field(50322; "CIF"; Decimal)
        {
            Caption = 'CIF';
        }
        field(50323; "Shipment No."; Text[250])
        {
            Caption = 'Shipment No.';
        }
    }
}
