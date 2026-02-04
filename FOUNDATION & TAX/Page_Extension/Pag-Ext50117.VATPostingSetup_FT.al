pageextension 50117 VATPostingSetup_FT extends "VAT Posting Setup"
{
    layout
    {
        addafter("VAT %")
        {
            field("E-Faktur KB"; Rec."E-Faktur KB")
            {
                ApplicationArea = All;
            }
        }
    }
}
