page 50763 "Production Lines"
{
    ApplicationArea = All;
    Caption = 'Production Lines';
    PageType = List;
    SourceTable = "Production Line";

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
                field(Code; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Capacity Line"; Rec."Capacity Line")
                {
                    ApplicationArea = All;
                }
                field("Capacity Mix"; Rec."Capacity Mix")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
