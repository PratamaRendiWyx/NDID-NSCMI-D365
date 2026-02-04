table 50101 PenampungDetail_FT
{
    DataClassification = ToBeClassified;

    fields
    {
        field(10;RecId;Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(11;LineNo;Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(20;InvoiceNo;Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(30;"Type";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(40;ItemID;Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50;Description;Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(60;VatBusPostGroup;Code[15])
        {
            DataClassification = ToBeClassified;
        }
        field(70;VatProdPostGroup;Code[15])
        {
            DataClassification = ToBeClassified;
        }
        field(80;VatIdentifier;Code[15])
        {
            DataClassification = ToBeClassified;
        }
        field(90;Price;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(100;QtyDecimal;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(110;TotAmt;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(120;DiscAmt;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(130;DPPAmt;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(140;VatAmt;Decimal)
        {
            DataClassification = ToBeClassified;
        }

    }

    
    procedure getNextRecIdPenampungDtl(): Text var myInt: Integer;
    _RecPnpmgDtl: Record PenampungDetail_FT;
    begin
        _RecPnpmgDtl.Reset();
        if(_RecPnpmgDtl.find('+'))then begin
        //exit(IncStr(_RecPnpmgDtl.RecID));
        end
        else
        begin
            exit('123456789012345678901234');
        end;
    end;
}
