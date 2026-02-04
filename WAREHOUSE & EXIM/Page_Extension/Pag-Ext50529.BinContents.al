pageextension 50529 "Bin Contents" extends "Bin Contents"
{
    layout
    {
        addafter("Item No.")
        {
            field("Item Description1"; Rec."Item Description")
            {
                ApplicationArea = All;
            }
        }
    }
}
