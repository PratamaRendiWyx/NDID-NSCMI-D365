page 50118 TaxSetupList_FT
{
    PageType = List;
    SourceTable = TaxIndoParameter_FT;
    CardPageId = TaxSetupCard_FT;
    UsageCategory = Lists;
    AccessByPermission = page TaxSetupList_FT=X;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(TAX)
            {
                field(TaxIN;Rec.TaxIN)
                {
                    ApplicationArea = All;
                }
                field(TaxOut;Rec.TaxOut)
                {
                    ApplicationArea = All;
                }
                field(Signer;Rec.Signer)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
