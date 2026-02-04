table 50100 Penampung_FT
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; RecID; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'RecID';
            AutoIncrement = true;
        }
        field(10; FlagTaxType; Enum EnumInOut_FT)
        {
            DataClassification = ToBeClassified;
            Caption = 'FlagTaxType';
        }
        field(20; InvoiceNo; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'InvoiceNo';
        }
        field(30; FPPengganti; Enum EnumYN_FT)
        {
            Caption = 'FPPengganti';
        }
        field(40; FlagRetur; Enum EnumYN_FT)
        {
            DataClassification = ToBeClassified;
            Caption = 'FlagRetur';
        }
        field(50; TaxNumber; Code[40])
        {
            DataClassification = ToBeClassified;
            Caption = 'RecID';
        }
        field(60; TaxDate; Date)
        {
            Caption = 'TaxDate';
        }
        field(70; ReturnTaxNo; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'RecID';
        }
        field(80; ReturnDocNo; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'ReturnDocNo';
        }
        field(90; ReturnDate; Date)
        {
            Caption = 'ReturnDate';
        }
        field(100; AccountNo; Code[15])
        {
            DataClassification = ToBeClassified;
            Caption = 'AccountNo';
        }
        field(110; NPWP; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'NPWP';
        }
        field(120; Nama; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Nama';
        }
        field(130; Address; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Address';
        }
        field(140; Currency; Code[3])
        {
            DataClassification = ToBeClassified;
            Caption = 'Currency';
        }
        field(150; InvoiceAmt; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'InvoiceAmt';

        }
        field(160; DPP; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'DPP';
        }
        field(170; VAT; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'VAT';
        }
        field(180; VatBusPostGroup; Code[15])
        {
            DataClassification = ToBeClassified;
            Caption = 'VATBusPostGroup';
        }
        field(190; VatProdPostGroup; Code[15])
        {
            DataClassification = ToBeClassified;
            Caption = 'VatProdPostGroup';
        }
        field(200; VatCalType; Code[15])
        {
            DataClassification = ToBeClassified;
            Caption = 'VatCalType';
        }
        field(210; FlagTransfer; enum EnumYN_FT)
        {
            DataClassification = ToBeClassified;
            Caption = 'Flag Transfer';
        }
        field(220; InvoiceDate; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(221; "Source Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; RecID)
        {
            Clustered = true;
        }
    }


    procedure getNextRecIdPenampung(): Text
    var
        myInt: Integer;
        _RecPnmpg: Record Penampung_FT;
    begin
        _RecPnmpg.Reset();
        if (_RecPnmpg.find('+')) then begin
            //exit(IncStr(_RecPnmpg.RecID));
        end
        else begin
            exit('1');
        end;
    end;
    //var _CodeUnit: Codeunit Penampung_FT;
}
