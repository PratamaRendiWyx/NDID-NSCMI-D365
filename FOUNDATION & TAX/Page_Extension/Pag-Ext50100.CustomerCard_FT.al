pageextension 50100 CustomerCard_FT extends "Customer Card"
{
    layout
    {
        addafter(Invoicing)
        {
            group("Indonesian Tax")
            {
                field("Identity Type"; Rec."Identity Type")
                {
                    ApplicationArea = All;
                }
                field("Country Code"; Rec."Country Code")
                {
                    ApplicationArea = All;
                }
                field("NPWP No_FT"; Rec."NPWP No_FT")
                {
                    ApplicationArea = All;
                }
                field("NPWP Nama_FT"; Rec."NPWP Nama_FT")
                {
                    ApplicationArea = All;
                }
                field("NPWP Alamat_FT"; Rec."NPWP Alamat_FT")
                {
                    ApplicationArea = All;
                }
                field("NPWP IsWapu_FT"; Rec."NPWP IsWapu_FT")
                {
                    ApplicationArea = All;
                }
                field("NPWP PrefixWapu"; Rec."NPWP PrefixWapu_FT")
                {
                    ApplicationArea = All;
                }
                field("NPWP TaxDigunggung"; Rec."NPWP TaxDigunggung_FT")
                {
                    ApplicationArea = All;
                    Visible = false;
                }

            }
        }

        modify("Name 2")
        {
            Caption = 'Short Name';
            ApplicationArea = All;
        }

    }
}
