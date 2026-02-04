pageextension 50755 ProdOrderComponents_PQ extends "Prod. Order Components"
{
    layout
    {
        addafter("Expected Quantity")
        {
            field("Act. Consumption (Qty)"; Rec."Act. Consumption (Qty)")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        modify("Substitution Available")
        {
            Visible = true;
        }
        addafter("Routing Link Code")
        {
            field("Item Prod. Line"; Rec."Item Prod. Line")
            {
                ApplicationArea = All;
            }
            field("Item Prod. Line Desc"; Rec."Item Prod. Line Desc")
            {
                ApplicationArea = All;
            }
            field("Item Category Prod Line"; getItemCategory(Rec."Item Prod. Line"))
            {
                Caption = 'Item Category Prod Line';
                ApplicationArea = All;
            }
            field("Production BOM No."; Rec."Production BOM No.")
            {
                ApplicationArea = All;
            }
            field("Production Line"; Rec."Production Line")
            {
                ApplicationArea = All;
            }
            field("Finished Qty."; Rec."Finished Qty.")
            {
                ApplicationArea = All;
            }
            field("Start Date Time Prod. Line"; getStartDateProdOrder(1, Rec."Prod. Order No."))
            {
                ApplicationArea = All;
            }
            field("End Date Time Prod. Line"; getStartDateProdOrder(2, Rec."Prod. Order No."))
            {
                ApplicationArea = All;
            }
        }
        // Add changes to page layout here
        addafter("Remaining Quantity")
        {
            field("Qty TO."; Rec."Qty TO.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Inventory Posting Group"; Rec."Inventory Posting Group")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("Put-away/Pick Lines/Movement Lines")
        {
            action("Create Transfer Order")
            {
                ApplicationArea = Warehouse;
                Caption = 'Create Transfer Order';
                Image = CreateInteraction;
                ToolTip = 'Create transfer order from prod. order component.';
                trigger OnAction()
                var
                    myInt: Integer;
                    CreatetransferOrder: Report CreateTransferOrder_PQ;
                    prodOrderComponent: Record "Prod. Order Component";
                    glbTest: Integer;
                begin
                    // CurrPage.SetSelectionFilter(prodOrderComponent);
                    prodOrderComponent.Copy(Rec);
                    // prodOrderComponent.SetFilter("Inventory Posting Group", 'RM|WIP');
                    glbTest := prodOrderComponent.Count();
                    if prodOrderComponent.FindSet() then begin
                        if (Rec.Status = Rec.Status::"Firm Planned") OR (Rec.Status = Rec.Status::Released) then begin
                            CreatetransferOrder.UseRequestPage(true);
                            CreatetransferOrder.setParameter(prodOrderComponent, Rec."Prod. Order No.");
                            CreatetransferOrder.RunModal();
                        end else begin
                            Error('Status production order must be Firm Prod. | Release Prod.');
                        end;
                    end else begin
                        Message('Nothing to handle.');
                    end;
                end;
            }
        }
    }

    local procedure getStartDateProdOrder(iOption: Integer; iProdOrderNo: Code[20]): Date
    var
        prodOrder: Record "Production Order";
    begin
        Clear(prodOrder);
        prodOrder.Reset();
        prodOrder.SetRange("No.", iProdOrderNo);
        if prodOrder.Find('-') then begin
            case iOption of
                1:
                    begin
                        exit(DT2Date(prodOrder."Start Date-Time (Production)"))
                    end;
                else
                    exit(DT2Date(prodOrder."End Date-Time (Production)"))
            end;
        end;
    end;

    local procedure getItemCategory(iItemNo: Code[20]): Code[20]
    var
        Item: Record Item;
    begin
        Clear(Item);
        Item.Reset();
        Item.SetRange("No.", iItemNo);
        if Item.Find('-') then
            exit(Item."Item Category Code");
        exit('');
    end;

}