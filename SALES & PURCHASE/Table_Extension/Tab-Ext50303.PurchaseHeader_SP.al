tableextension 50303 PurchaseHeader_SP extends "Purchase Header"
{
    fields
    {
        field(50300; IsClose; Boolean)
        {
            Caption = 'Closed (?)';
        }


        field(50301; "PIC Goods Receipt"; Text[100])
        {
            Caption = 'PIC Goods Receipt';
            TableRelation = Employee."No.";
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
                employee: Record Employee;
            begin
                if Rec."PIC Goods Receipt" <> '' then begin
                    Clear(employee);
                    employee.Reset();
                    employee.SetRange("No.", "PIC Goods Receipt");
                    if employee.Find('-') then begin
                        Rec."PIC Goods Receipt Name" := employee.FullName();
                    end;
                end
            end;
        }
        field(50302; "PIC Goods Receipt Name"; Text[100])
        {
            Caption = 'PIC Goods Receipt Name';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50303; "Order Type"; enum "Order Type")
        {
            Caption = 'Repeat Order';
        }
        field(50304; "Same Price"; Boolean)
        {
            Caption = 'Same Price';
        }
        field(50305; "GM Approval Only"; Boolean)
        {
            Caption = 'GM Approval Only';
        }
        field(50201; "Notes"; Text[500])
        {
        }
        field(50306; "Service"; Boolean)
        {
            Caption = 'Service';
        }
        field(50307; "Already Done"; Boolean)
        {
            Caption = 'Already Done';
        }
        field(50308; "Purpose"; Text[100])
        {
            Caption = 'Purpose';
        }
        field(50309; "Reason"; Text[100])
        {
            Caption = 'Reason';
        }
        field(50310; "PO No."; Code[20])
        {
            Caption = 'PO No.';
        }
        field(50311; "PO Type"; enum "PO Type")
        {
            Caption = 'PO Type';
        }
        field(50312; "Application"; Text[30])
        {
            Caption = 'Application';
        }
        field(50313; "Acknowledged by"; Text[30])
        {
            Caption = 'Acknowledged by';
            TableRelation = Employee."No." where("No." = field("Acknowledged by"));
            trigger OnValidate()
            var
                myInt: Integer;
                employee: Record Employee;
            begin
                employee.Reset();
                if employee.Get("Acknowledged by") then
                    "Acknowledger Name" := employee.FullName();
            end;
        }
        field(50314; "Acknowledger Name"; Text[100])
        {
            Caption = 'Acknowledger Name';
            Editable = false;
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
        field(50319; "Issued By"; Text[30])
        {
            Caption = 'Issued By';
            TableRelation = Employee."No." where("No." = field("Issued By"));
            trigger OnValidate()
            var
                myInt: Integer;
                employee: Record Employee;
            begin
                employee.Reset();
                if employee.Get("Issued By") then
                    "Issuer Name" := employee.FullName();
            end;
        }
        field(50320; "Issuer Name"; Text[100])
        {
            Caption = 'Issuer Name';
            Editable = false;
        }
        field(50322; "Rev"; Text[100])
        {
            Caption = 'Note Rev.';
        }
        field(50323; "Last Posting Date"; Date)
        {
        }
        modify("Posting Date")
        {
            trigger OnBeforeValidate()
            var
                myInt: Integer;
            begin
                "Last Posting Date" := xRec."Posting Date";
            end;
        }
        field(50324; "Approved By 2"; Text[30])
        {
            Caption = 'Accounting Mgr.';
            TableRelation = Employee."No." where("No." = field("Approved By 2"));
            trigger OnValidate()
            var
                myInt: Integer;
                employee: Record Employee;
            begin
                employee.Reset();
                if employee.Get("Approved By 2") then
                    "Accounting Mgr. Name" := employee.FullName();
            end;
        }
        field(50325; "Accounting Mgr. Name"; Text[100])
        {
            Caption = 'Accounting Mgr. Name';
            Editable = false;
        }
    }
    /// Finish the purchase order.
    procedure Finish()
    begin
        Finish(false);
    end;

    /// Finish the purchase order.
    /// <param name="HideDialog">Indicator whether the dialog should be avoided.</param>
    procedure Finish(HideDialog: Boolean)
    var
        FinishPurchaseOrder: Codeunit FinishPurchaseOrder_SP;
    begin
        FinishPurchaseOrder.FinishPurchaseOrder(Rec, HideDialog);
    end;

    procedure SetClosed(iStatusClose: Boolean)
    begin
        IsClose := iStatusClose;
        Modify();
    end;

    trigger OnDelete()
    var
        myInt: Integer;
        PurchaseReq: Record "Purchase Header";
    begin
        if (Rec.Status = Rec.Status::Released) AND (Rec."Document Type" = Rec."Document Type"::Order) then
            Error('Error, Can''t delete this order, cause status already released.');
        //Update PO on PR
        Clear(PurchaseReq);
        PurchaseReq.Reset();
        PurchaseReq.SetRange("No.", "Quote No.");
        PurchaseReq.SetRange("Document Type", PurchaseReq."Document Type"::Quote);
        if PurchaseReq.FindSet() then begin
            PurchaseReq."PO No." := '';
            PurchaseReq.Modify();
        end;
        //-
    end;

}