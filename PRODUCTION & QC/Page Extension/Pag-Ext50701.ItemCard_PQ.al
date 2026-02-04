pageextension 50701 ItemCard_PQ extends "Item Card"
{
    layout
    {
        addafter("Item Category Code")
        {
            field("BOP Type"; Rec."BOP Type")
            {
                ApplicationArea = All;
            }
            field("Product Type"; Rec."Product Type")
            {
                ApplicationArea = All;
            }
            field("Is Subcon (?)"; Rec."Is Subcon (?)")
            {
                ApplicationArea = All;
            }
        }
        addbefore(Blocked)
        {
            field("Specification No."; Rec."Specification No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Expiration Calculation")
        {
            field("Has Quality Specifications"; Rec."Has Quality Specifications")
            {
                ToolTip = '"Indicates if this item has Quality Specifications "';
                ApplicationArea = All;
            }
            field("CCS Auto Enter Ser No. Master"; Rec."CCS Auto Enter Ser No. Master")
            {
                ToolTip = 'Indicates whether a master serial number should be entered for this item automatically';
                ApplicationArea = All;
            }
        }

        addafter("Unit Cost")
        {
            field("Last Unit Cost Calc. Date"; Rec."Last Unit Cost Calc. Date")
            {
                Caption = 'Last Unit Cost Calc. Date';
                ApplicationArea = All;
                ToolTip = 'This is the last date the Unit Cost was Calculated.';
            }
        }

        addfirst(FactBoxes)
        {
            part(ItemProductionDesign; ItemProdDesignFactbox_PQ)
            {
                Caption = 'Item Prod. Design Factbox';
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No.");
            }
        }

    }

    actions
    {
        addafter(Attributes)
        {
            action("AdditionalOutput")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Additional Output';
                Image = Costs;
                ToolTip = 'View or edit Additional Output.';
                trigger OnAction()
                var
                    myInt: Integer;
                    AdditionalOutput: page "Additional Item Outputs";
                    additionalItemOutput: Record "Additional Item Output";
                begin
                    Clear(additionalItemOutput);
                    additionalItemOutput.Reset();
                    additionalItemOutput.SetRange("Item No.", Rec."No.");
                    if not additionalItemOutput.FindSet() then;
                    AdditionalOutput.SetTableView(additionalItemOutput);
                    AdditionalOutput.RunModal();
                    CurrPage.Update();
                end;
            }
            action("ProductionLines")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Production Lines';
                Image = MachineCenter;
                ToolTip = 'View or edit Production Lines.';
                trigger OnAction()
                var
                    myInt: Integer;
                    ProductionLines: page "Production Lines";
                    ProductionLine: Record "Production Line";
                begin
                    Clear(ProductionLine);
                    ProductionLine.Reset();
                    ProductionLine.SetRange("Item No.", Rec."No.");
                    if not ProductionLine.FindSet() then;
                    ProductionLines.SetTableView(ProductionLine);
                    ProductionLines.RunModal();
                    CurrPage.Update();
                end;
            }

        }
        addafter(Navigation_Item)
        {
            group("Quality")
            {
                Caption = 'Quality';
                Image = InventoryPick;
                action("AM Quality Requirements")
                {
                    ApplicationArea = All;
                    Caption = 'Quality Requirements';
                    Image = InventoryPick;
                    RunObject = Page ItemQualityRequirement_PQ;
                    RunPageLink = "Item No." = FIELD("No.");
                    ToolTip = 'Specifies quality requirements lists for the item.';
                }
            }
        }

        addafter(Action5)
        {
            action("Cost Change &Log")
            {
                ApplicationArea = All;
                Caption = 'Cost Change &Log';
                RunObject = Page CostChangeLog_PQ;
                RunPageLink = "Item No." = FIELD("No.");
            }
        }

        addafter(Action78)
        {
            action("PQ Where-Used")
            {
                AccessByPermission = TableData "Production BOM Header" = R;
                ApplicationArea = Manufacturing;
                Caption = 'Where-Used';
                Image = "Where-Used";
                ToolTip = 'View a list of BOMs in which the item is used.';

                trigger OnAction()
                var
                    ProdBOMWhereUsed: Page ProdBOMWhereUsed_PQ;
                begin
                    ProdBOMWhereUsed.SetItem(Rec, WorkDate);
                    ProdBOMWhereUsed.RunModal;
                end;
            }
        }

    }
}

