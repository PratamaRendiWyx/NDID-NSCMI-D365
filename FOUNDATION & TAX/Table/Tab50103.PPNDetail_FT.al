table 50103 PPNDetail_FT
{
    DataClassification = ToBeClassified;

    fields
    {
        field(10; RecId; Integer)

        {
            DataClassification = ToBeClassified;
            Caption = 'RecId';
            AutoIncrement = true;
        }

        field(11; LineNo; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Line No';
        }
        field(20; InvoiceNo; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Invoice No';
        }
        field(30; "Type"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Type';

        }
        field(40; ItemID; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'ItemId';
        }
        field(50; Description; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
        }
        field(60; VatBusPostGroup; Code[15])
        {
            DataClassification = ToBeClassified;
            Numeric = true;
            CharAllowed = '19'; // // char that allowed 1 to 9
        }
        field(70; VatProdPostGroup; Code[15])
        {
            DataClassification = ToBeClassified;
            CharAllowed = '19'; // char that allowed 1 to 9
        }
        field(80; VatIdentifier; Code[15])
        {
            DataClassification = ToBeClassified;
            CharAllowed = '19'; // char that allowed 1 to 9
        }
        field(90; Price; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(100; QtyDecimal; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(110; TotAmt; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(120; DiscAmt; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(130; DPPAmt; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(140; VatAmt; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(141; "UOM Code"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Invoice Line"."Unit of Measure Code" where("Line No." = field(LineNo), "Document No." = field(InvoiceNo)));
        }
    }

    procedure GetIncrementPPNRecId(): Text;
    var
        _RecPPNDet: record PPNDetail_FT;
    begin
        _RecPPNDet.Reset();
        if _RecPPNDet.Find('+') then begin
            //exit(IncStr(_RecPPNDet.RecId));
        end
        else begin
            exit('123456789012345678901234');
        end;
    end;

    var
        CUnit: Codeunit PPNDetail_FT;
}
