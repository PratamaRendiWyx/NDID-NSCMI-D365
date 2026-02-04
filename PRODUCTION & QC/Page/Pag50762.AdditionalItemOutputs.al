page 50762 "Additional Item Outputs"
{
    ApplicationArea = All;
    Caption = 'Additional Outputs';
    PageType = List;
    SourceTable = "Additional Item Output";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                ShowCaption = false;
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    TableRelation = Item."No.";
                    Editable = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Quantity (Base) Per"; Rec."Quantity (Base) Per")
                {
                    ApplicationArea = All;
                }
                // field("Percentage Add. Output"; Rec."Percentage Add. Output")
                // {
                //     ApplicationArea = All;
                // }
                field("Production BOM No."; Rec."Production BOM No.")
                {
                    ApplicationArea = All;
                }
                field("Routing No."; Rec."Routing No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
