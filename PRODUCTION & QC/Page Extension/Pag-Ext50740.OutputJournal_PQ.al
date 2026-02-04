
namespace PRODUCTIONQC.PRODUCTIONQC;

using Microsoft.Manufacturing.Journal;
using Microsoft.Manufacturing.Document;
pageextension 50740 OutputJournal_PQ extends "Output Journal"
{
    layout
    {
        modify("Order No.")
        {
            Visible = false;
        }
        addbefore("Order No.")
        {
            field("Order No. 2"; Rec."Order No. 2")
            {
                ApplicationArea = All;
                ExtendedDatatype = Barcode;
                trigger OnValidate()
                var
                    myInt: Integer;
                begin
                    if Rec."Order No. 2" <> '' then
                        Rec.Validate(Rec."Order No.", Rec."Order No. 2");
                end;
            }
        }
        addafter("External Document No.")
        {
            field("Unit Amount"; Rec."Unit Amount")
            {
                Caption = 'Unit Amount';
                ApplicationArea = All;
            }
            field(Amount; Rec.Amount)
            {
                Caption = 'Amount';
                ApplicationArea = All;
            }
        }
        addafter(Control1905767507)
        {
            part(OutputJournalTotals; OutputJnlFactbox_PQ)
            {
                Caption = 'Output Jnl Factbox';
                ApplicationArea = All;
                SubPageLink = "Journal Template Name" = FIELD("Journal Template Name"),
                              "Journal Batch Name" = FIELD("Journal Batch Name"),
                              "Line No." = FIELD("Line No.");
            }
        }

        addbefore("Run Time")
        {
            field("Runtime (Planning)"; calculateRuntimePlanning())
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    local procedure calculateRuntimePlanning(): Decimal
    var
        prodRoutingLine: Record "Prod. Order Routing Line";
        o_result: Decimal;
    begin
        Clear(prodRoutingLine);
        prodRoutingLine.Reset();
        prodRoutingLine.SetRange(Type, Rec.Type);
        prodRoutingLine.SetRange("Operation No.", Rec."Operation No.");
        prodRoutingLine.SetRange("No.", Rec."No.");
        prodRoutingLine.SetRange("Routing Reference No.", Rec."Order Line No.");
        prodRoutingLine.SetRange("Prod. Order No.", Rec."Order No.");
        if prodRoutingLine.Find('-') then begin
            o_result := Rec."Output Quantity" * prodRoutingLine."Run Time";
            if prodRoutingLine."Fixed Run Time" then
                o_result := prodRoutingLine."Run Time";
        end;
        exit(o_result);
    end;
}

