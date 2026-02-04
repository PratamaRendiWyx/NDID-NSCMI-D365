pageextension 51100 BankAccountCard_AF extends "Bank Account Card"
{
    layout
    {
        addafter("Bank Branch No.")
        {
            field(Branch; Rec.Branch)
            {
                Caption = 'Bank Branch';
                ApplicationArea = All;
            }
        }

        addafter(Name)
        {
            field("Name 2"; Rec."Name 2")
            {
                ApplicationArea = All;
            }
        }
        addbefore(Contact)
        {
            field("Primary Contact No."; Rec."Primary Contact No.")
            {
                ApplicationArea = All;
                trigger OnValidate()
                var
                    myInt: Integer;
                begin
                    ActivateFields();
                end;
            }
        }
        modify(Contact)
        {
            ApplicationArea = Basic, Suite;
            Editable = ContactEditable;
            Importance = Promoted;
            Visible = false;
            ToolTip = 'Specifies the name of the person you regularly contact when you do business with this Bank Account.';

            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                ContactOnAfterValidate();
            end;
        }
        addafter(Contact)
        {
            field(Contact2; Rec.Contact2)
            {
                ApplicationArea = Basic, Suite;
                Editable = ContactEditable;
                Importance = Promoted;
                ToolTip = 'Specifies the name of the person you regularly contact when you do business with this Bank Account.';

                trigger OnValidate()
                var
                    myInt: Integer;
                begin
                    ContactOnAfterValidate();
                end;
            }
        }
    }

    local procedure ActivateFields()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeActivateFields(IsCountyVisible, FormatAddress, IsHandled);
        if IsHandled then
            exit;
        ContactEditable := Rec."Primary Contact No." = '';
    end;


    local procedure ContactOnAfterValidate()
    begin
        ActivateFields();
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeActivateFields(var IsCountyVisible: Boolean; var FormatAddress: Codeunit "Format Address"; var IsHandled: Boolean)
    begin
    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        ActivateFields();
    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        ContactEditable := true;
    end;

    var
        IsCountyVisible: Boolean;
        FormatAddress: Codeunit "Format Address";
        OfficeMgt: Codeunit "Office Management";

    protected var
        ContactEditable: Boolean;
}
