pageextension 51103 PostedPurchaseCrMemoLines_AF extends "Posted Purchase Cr. Memo Lines"
{
    layout
    {
        addafter("Appl.-to Item Entry")
        {
            // field("WHT Business Posting Group"; Rec."WHT Business Posting Group")
            // {
            //     ApplicationArea = All;
            // }
            // field("WHT Product Posting Group"; Rec."WHT Product Posting Group")
            // {
            //     ApplicationArea = All;
            // }
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = All;
            }
            field("Currency Factor"; Rec."Currency Factor")
            {
                ApplicationArea = All;
            }
        }
        addafter("Document No.")
        {
            field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
        }
    }
}
