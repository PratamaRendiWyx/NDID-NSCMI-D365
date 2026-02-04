page 50117 TaxSetupCard_FT
{
    PageType = StandardDialog;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = TaxIndoParameter_FT;
    Caption = 'Tax Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;

    layout
    {
        area(Content)
        {
            group("Tax Setup")
            {
                Editable = true;

                field(TaxIN;Rec.TaxIN)
                {
                    Caption = 'Enable PPn Pajak Masukan';
                    ApplicationArea = All;
                }
                field(TaxOut;Rec.TaxOut)
                {
                    Caption = 'Enable PPn Pajak Keluaran';
                    ApplicationArea = All;
                }
                field(Signer;Rec.Signer)
                {
                    ApplicationArea = Basic;
                }
                field("Remain Tax Number Warning";Rec."Remain Tax Number Warning")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
    actions
    {
    }

    trigger OnOpenPage()
    var 
    TaxIndoParameter : Record TaxIndoParameter_FT;
    begin
        if TaxIndoParameter.FindFirst then begin
            CurrPage.SetRecord(TaxIndoParameter);
        end
        else
            begin
                TaxIndoParameter.TaxIndoParamID:=1;
                TaxIndoParameter.Signer:='Change Signer';
                TaxIndoParameter.TaxIN:=true;
                TaxIndoParameter.TaxOut:=true;
                TaxIndoParameter."Remain Tax Number Warning":=15;
                TaxIndoParameter.Insert();
            end;
    end;
}
