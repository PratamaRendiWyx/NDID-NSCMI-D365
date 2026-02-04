tableextension 50302 SalesHeader_SP extends "Sales Header"
{
    fields
    {
        field(50300; IsClose; Boolean)
        {
            Caption = 'Closed (?)';
        }
        field(50301; "Delivery To"; Text[100])
        {
        }
        field(50302; "Delivery Date"; Text[100])
        {
        }
        field(50303; "Price Component"; Text[100])
        {
        }
        field(50304; "Term Payment"; Text[100])
        {
        }
        field(50305; "Term By"; Text[100])
        {
        }
        field(50306; "Sales Type"; Enum "Sales Type")
        {
        }
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
        field(50311; "Validity Date"; Text[50])
        {

        }
        field(50312; "Quotation Type"; enum "Quotation Type")
        {

        }
        field(50313; "Contract No."; Text[30])
        {
        }
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
    trigger OnAfterModify()
    var
        myInt: Integer;
        checkCreditLimit: Boolean;
    begin
        if (Rec."Document Type" = Rec."Document Type"::Order) AND (Rec.Status = Rec.Status::Released) then begin
            checkCreditLimit := true;
            if (validation.checkCreditLimit(Rec."No.", Rec."Document Type") = false) then begin
                rec.Status := enum::"Sales Document Status"::"Pending Credit Limit";
                checkCreditLimit := false;
            end;
            if (checkCreditLimit = true) then begin
                if (validation.checkOverdueBalance(Rec."No.", Rec."Document Type") = false) then begin
                    rec.Status := enum::"Sales Document Status"::"Pending Overdue";
                    checkCreditLimit := false;
                end;
            end;
            if (checkCreditLimit = true) then begin
                rec.Status := enum::"Sales Document Status"::Released;
            end;
        end;
    end;
    /// Complete the sales order
    procedure Finish()
    begin
        Finish(false);
    end;

    /// Complete the sales order
    /// <param name="HideDialog">Indicator on whether to avoid the dialog</param>
    procedure Finish(HideDialog: Boolean)
    var
        FinishSalesOrder: Codeunit FinishSalesOrder_SP;
    begin
        FinishSalesOrder.FinishSalesOrder(Rec, HideDialog);
    end;

    procedure SetClosed(iStatusClose: Boolean)
    begin
        IsClose := iStatusClose;
        Modify();
    end;

    trigger OnDelete()
    var
        myInt: Integer;
    begin
        if (Rec.Status = Rec.Status::Released) AND (Rec."Document Type" = Rec."Document Type"::Order) then
            Error('Error, Can''t delete this order, cause status already released.');
    end;

    var
        validation: Codeunit CLODValidation_SP;
}