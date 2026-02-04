pageextension 50747 ProductionBOMLines_PQ extends "Production BOM Lines"
{

    layout
    {
        addafter(Description)
        {
            field(PQComment; Rec.Comment)
            {
                Caption = 'Comment';
                ApplicationArea = All;
            }
        }
        addafter("Ending Date")
        {
            field("BOM Number"; Rec."BOM Number")
            {
                ApplicationArea = All;
                Caption = 'BOM Number';
                DrillDownPageID = "Production BOM";
                ToolTip = 'Displays the BOM No. you the lines are for';
            }
            field("Routing Number"; Rec."Routing Number")
            {
                ApplicationArea = All;
                Caption = 'Routing Number';
                DrillDownPageID = Routing;
                ToolTip = 'Displays the current Routing No.';
            }
            field("Item Flushing Method"; Rec."Item Flushing Method")
            {
                ApplicationArea = All;
                Caption = 'Item Flushing Method';
                ToolTip = 'How do you want the Item to be sent to usage';
            }
            field("Replenishment System"; Rec."Replenishment System")
            {
                ApplicationArea = All;
                Caption = 'Replenishment System';
                Editable = false;
                ToolTip = 'How the item is set to be replenished in the system';
            }
            field("Manufacturing Policy"; Rec."Manufacturing Policy")
            {
                ApplicationArea = All;
                Caption = 'Manufacturing Policy';
                Editable = false;
                ToolTip = 'Displays the Items Manufactuirng Policy';
            }
        }

        modify("No.")
        {
            trigger OnAfterValidate()
            var
                Item: Record Item;
                ItemVariant: Record "Item Variant";
                ItemBOM: Code [20];
                ItemRouter: Code[20];
            begin
                if Rec.Type = Rec.Type::"Production BOM" then begin
                    Rec.SetFilter("No. Filter", '%1', Rec."No.");
                    Rec.SetFilter("No. Filter Router", '%1', Rec."No.");
                end else if Rec.Type = Rec.Type::Item then begin
                    if Rec."Variant Code" = '' then begin
                        if Item.Get(Rec."No.") then begin
                            ItemBOM := Item."Production BOM No.";
                            ItemRouter := Item."Routing No.";
                            Rec.SetFilter("No. Filter", '%1', ItemBOM);
                            Rec.SetFilter("No. Filter Router", '%1', ItemRouter);
                        end;
                    end else begin
                        if ItemVariant.Get(Rec."No.", Rec."Variant Code") then begin
                            ItemBOM := ItemVariant."Production BOM No.";
                            ItemRouter := ItemVariant."Routing No.";
                            Rec.SetFilter("No. Filter", '%1', ItemBOM);
                            Rec.SetFilter("No. Filter Router", '%1', ItemRouter);
                        end;
                    end;
                end;
                Rec.CalcFields("Routing Number", "BOM Number");
            end;
        }

    }

    actions
    {
        addafter("&Component")
        {
            action(ViewBOM)
            {
                ApplicationArea = All;
                Caption = 'View &BOM';
                Image = ViewDetails;
                Promoted = true;
                PromotedCategory = New;
            }
            action(ViewRouting)
            {
                ApplicationArea = All;
                Caption = 'View &Routing';
                Image = ViewDetails;
            }
        }
    }

trigger OnAfterGetRecord()
    var
        Item: Record Item;
        ItemVariant: Record "Item Variant";
        ItemBOM: Code [20];
        ItemRouter: Code[20];
    begin
        if Rec.Type = Rec.Type::"Production BOM" then begin
            Rec.SetFilter("No. Filter", '%1', Rec."No.");
            Rec.SetFilter("No. Filter Router", '%1', Rec."No.");
        end else if Rec.Type = Rec.Type::Item then begin
            if Rec."Variant Code" = '' then begin
                if Item.Get(Rec."No.") then begin
                    ItemBOM := Item."Production BOM No.";
                    ItemRouter := Item."Routing No.";
                    Rec.SetFilter("No. Filter", '%1', ItemBOM);
                    Rec.SetFilter("No. Filter Router", '%1', ItemRouter);
                end;
            end else begin
                if ItemVariant.Get(Rec."No.", Rec."Variant Code") then begin
                    ItemBOM := ItemVariant."Production BOM No.";
                    ItemRouter := ItemVariant."Routing No.";
                    Rec.SetFilter("No. Filter", '%1', ItemBOM);
                    Rec.SetFilter("No. Filter Router", '%1', ItemRouter);
                end;
            end;
        end;
        Rec.CalcFields("Routing Number", "BOM Number");
    end;

}

