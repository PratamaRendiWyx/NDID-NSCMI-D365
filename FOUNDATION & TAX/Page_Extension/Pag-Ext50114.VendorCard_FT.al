pageextension 50114 VendorCard_FT extends "Vendor Card"
{
    layout
    {
        addafter(Invoicing)
        {
            group("Indonesian Tax")
            {
                field("NPWP No.";Rec."NPWP No_FT")
                {
                    ApplicationArea = All;
                    CharAllowed = '09';
                }
                field("NPWP Nama";Rec."NPWP Nama_FT")
                {
                    ApplicationArea = All;
                }
                field("NPWP Alamat";Rec."NPWP Alamat_FT")
                {
                    ApplicationArea = All;
                }
            }
        }

        modify("Foreign Trade")
        {
            Visible = false;
        }


        addafter("VAT Bus. Posting Group")
        {
            field("WHT Business Posting Group"; Rec."WHT Business Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a WHT business posting group.';
            }
        }

        addafter("Balance Due (LCY)")
        {

            field("Category Asset";Rec."Category Asset")
            {
                ApplicationArea = All;
            }
            field("Industrial Classification";Rec."Industrial Classification")
            {
                ApplicationArea = All;
                MultiLine = true;
            }
        }

        
    }
}
