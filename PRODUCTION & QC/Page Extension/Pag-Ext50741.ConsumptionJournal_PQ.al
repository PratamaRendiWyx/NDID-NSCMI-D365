pageextension 50741 ConsumptionJournal_PQ extends "Consumption Journal"
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
        addafter("Applies-from Entry")
        {
            field(AMAmount; Rec.Amount)
            {
                Caption = 'Amount';
                ApplicationArea = All;
            }
        }
        addfirst(FactBoxes)
        {
            part(ItemJnlTotals; ItemJnlTotalsFactbox_PQ)
            {
                Caption = 'Item Jnl. Totals Factbox';
                ApplicationArea = All;
                SubPageLink = "Journal Template Name" = FIELD("Journal Template Name"),
                              "Journal Batch Name" = FIELD("Journal Batch Name"),
                              "Line No." = FIELD("Line No.");
            }
            part(ItemSupply; ItemSupplyFactbox_PQ)
            {
                Caption = 'Item Supply Factbox';
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("Item No."),
                              "Location Filter" = FIELD("Location Code");
            }
            part(ItemDemand; ItemDemandFactbox_PQ)
            {
                Caption = 'Item Demand Factbox';
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("Item No."),
                              "Location Filter" = FIELD("Location Code");
            }
        }
    }

    actions
    {
        addafter("Calc. Co&nsumption")
        {
            action("Calc. Co&nsumption 2")
            {
                ApplicationArea = Manufacturing;
                Caption = 'Calc. Co&nsumption (Cstm)';
                Ellipsis = true;
                Image = CalculateConsumption;
                ToolTip = 'Use a batch job to help you fill the consumption journal with actual or expected consumption figures.';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    CalcConsumption: Report "Calc. Consumption Cstm";
                begin
                    CalcConsumption.SetTemplateAndBatchName(Rec."Journal Template Name", Rec."Journal Batch Name");

                    CalcConsumption.RunModal();
                end;
            }
        }
        addafter("Bin Contents")
        {
            action(ItemsByLocation)
            {
                ApplicationArea = All;
                Caption = 'Items b&y Location';
                Image = ItemAvailbyLoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
            }
        }
    }

    var
        ItemJnlMgt: Codeunit ItemJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        ItemJournalErrorsMgt: Codeunit "Item Journal Errors Mgt.";
        ProdOrderDescription: Text[100];
}

