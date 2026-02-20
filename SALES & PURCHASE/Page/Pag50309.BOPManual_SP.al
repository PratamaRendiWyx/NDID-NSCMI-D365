page 50309 BOPManual_SP
{
    PageType = Document;
    SourceTable = "BOPManualHeader_SP";
    Caption = 'Manual BOP Document';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Editable = DocEditable;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Editable = DocEditable;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Customer PO No."; Rec."Customer PO No.")
                {
                    ApplicationArea = All;
                    Editable = DocEditable;
                }
                field("Status Approval"; Rec."Status Approval")
                {
                    ApplicationArea = All;
                }

                field("QC By"; Rec."QC By")
                {
                    ApplicationArea = All;
                    Editable = DocEditable;
                }
                field("QC Date"; Rec."QC Date")
                {
                    ApplicationArea = All;
                    Editable = DocEditable;
                }
                field("Comment QC Worker"; Rec."Comment QC Worker")
                {
                    ApplicationArea = All;
                    Editable = DocEditable;
                    MultiLine = true;
                }

                field("Approval By"; Rec."Approval By")
                {
                    ApplicationArea = All;
                    Editable = DocEditable;
                }
                field("Approval Date"; Rec."Approval Date")
                {
                    ApplicationArea = All;
                    Editable = DocEditable;
                }
                field("Comment (Approver)"; Rec."Comment (Approver)")
                {
                    ApplicationArea = All;
                    Editable = DocEditable;
                    MultiLine = true;
                }
            }

            part(BOPLines; "BOPManualSubform_SP")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both;
                Editable = DocEditable;
            }




        }
    }



    var
        DocEditable: Boolean;
        StatusStyleTxt: Text;

    trigger OnAfterGetRecord()
    begin
        SetDocEditable();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetDocEditable();
    end;

    local procedure SetDocEditable()
    begin
        DocEditable := Rec."Status Approval" = Rec."Status Approval"::Open;
    end;
}