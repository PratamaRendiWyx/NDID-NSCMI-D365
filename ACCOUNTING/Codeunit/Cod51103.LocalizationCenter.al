namespace ACCOUNTING.ACCOUNTING;
using Microsoft.Finance.Currency;
using Microsoft.Finance.GeneralLedger.Setup;

codeunit 51103 "Localization Center"
{
    procedure RupiahInteger(var NoText: Text[250]; No: Decimal)
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        Onestext: array[19] of Text[30];
        Tenstext: array[9] of Text[30];
        Exponenttext: array[4] of Text[30];
    begin
        Onestext[1] := 'SATU';
        Onestext[2] := 'DUA';
        Onestext[3] := 'TIGA';
        Onestext[4] := 'EMPAT';
        Onestext[5] := 'LIMA';
        Onestext[6] := 'ENAM';
        Onestext[7] := 'TUJUH';
        Onestext[8] := 'DELAPAN';
        Onestext[9] := 'SEMBILAN';
        Onestext[10] := 'SEPULUH';
        Onestext[11] := 'SEBELAS';
        Onestext[12] := 'DUA BELAS';
        Onestext[13] := 'TIGA BELAS';
        Onestext[14] := 'EMPAT BELAS';
        Onestext[15] := 'LIMA BELAS';
        Onestext[16] := 'ENAM BELAS';
        Onestext[17] := 'TUJUH BELAS';
        Onestext[18] := 'DELAPAN BELAS';
        Onestext[19] := 'SEMBILAN BELAS';

        Tenstext[1] := 'SEPULUH';
        Tenstext[2] := 'DUA PULUH';
        Tenstext[3] := 'TIGA PULUH';
        Tenstext[4] := 'EMPAT PULUH';
        Tenstext[5] := 'LIMA PULUH';
        Tenstext[6] := 'ENAM PULUH';
        Tenstext[7] := 'TUJUH PULUH';
        Tenstext[8] := 'DELAPAN PULUH';
        Tenstext[9] := 'SEMBILAN PULUH';

        Exponenttext[1] := '';
        Exponenttext[2] := 'RIBU';
        Exponenttext[3] := 'JUTA';
        Exponenttext[4] := 'MILYAR';

        CLEAR(NoText);
        NoTextIndex := 1;
        NoText := '';

        IF No < 1 THEN
            NoText := ''
        ELSE BEGIN
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                Ones := No DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds > 0 THEN BEGIN
                    PrintExponent := TRUE;
                    NoText := DELCHR(NoText + ' ' + Onestext[Hundreds], '<');
                    NoText := DELCHR(NoText + ' ' + 'RATUS', '<');

                END;

                IF Tens >= 2 THEN BEGIN
                    PrintExponent := TRUE;
                    NoText := DELCHR(NoText + ' ' + Tenstext[Tens], '<');

                    IF Ones > 0 THEN BEGIN
                        PrintExponent := TRUE;
                        NoText := DELCHR(NoText + ' ' + Onestext[Ones], '<');
                    END;
                END ELSE
                    IF (Tens * 10 + Ones) > 0 THEN BEGIN
                        PrintExponent := TRUE;
                        NoText := DELCHR(NoText + ' ' + Onestext[Tens * 10 + Ones], '<');
                    END;

                IF PrintExponent AND (Exponent > 1) THEN BEGIN
                    PrintExponent := TRUE;
                    NoText := DELCHR(NoText + ' ' + Exponenttext[Exponent], '<');
                END;
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;
        END;

        if NoText.Contains('SATU RATUS') then
            NoText := NoText.Replace('SATU RATUS', 'SERATUS');

        if NoText.Contains('SATU RIBU') then begin
            if StrPos(NoText, 'SATU RIBU') = 1 then
                NoText := NoText.Replace('SATU RIBU', 'SERIBU');
        end;
    end;

    procedure TxtRupiah(TDecimal: Decimal) TText: Text[250]
    var
        THigh: Decimal;
        TLow: Decimal;
    begin
        TLow := (TDecimal - ROUND(TDecimal, 1, '<')) * 100;
        THigh := ROUND(TDecimal, 1, '<');
        IF THigh <> 0 THEN BEGIN
            RupiahInteger(TText, THigh);
            // TText := TText + ' RUPIAH'; 
            TText := TText;
        END;
        IF TLow <> 0 THEN BEGIN
            RupiahInteger(txt, TLow);
            // TText := TText + ' KOMA ' + txt + ' RUPIAH'; 
            TText := TText + ' KOMA ' + txt;
        END
        ELSE
            IF THigh <> 0 THEN
                // TText := TText + ' SAJA'; 
                TText := TText;
        //+
        TText := TText + ' RUPIAH';
    end;

    procedure TxtRupiah(TDecimal: Decimal; Cur: Code[10]) TText: Text[250]
    var
        THigh: Decimal;
        TLow: Decimal;
        Currency: Record Currency;
        CurrText: Text[30];
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        if Cur = '' then begin
            GeneralLedgerSetup.Get();
            Cur := GeneralLedgerSetup."Local Currency Symbol";
        end;

        Currency.Reset();
        Currency.SetFilter(Code, Cur);
        if Currency.FindFirst() then begin
            if Currency.Description2 <> '' then
                CurrText := UpperCase(Currency.Description2)
            else
                CurrText := Currency.Code;
        end;

        TLow := (TDecimal - ROUND(TDecimal, 1, '<')) * 100;
        THigh := ROUND(TDecimal, 1, '<');
        IF THigh <> 0 THEN BEGIN
            RupiahInteger(TText, THigh);
            // TText := TText + ' ' + CurrText; 
            TText := TText;
        END;
        IF TLow <> 0 THEN BEGIN
            RupiahInteger(txt, TLow);
            // TText := TText + ' KOMA ' + txt + ' ' + CurrText;
            TText := TText + ' KOMA ' + txt;
        END
        ELSE
            IF THigh <> 0 THEN
                TText := TText;

        TText := TText + ' ' + CurrText;

    end;

    procedure EngInteger(var NoText: Text[250]; No: Decimal)
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        Onestext: array[19] of Text[30];
        Tenstext: array[9] of Text[30];
        Exponenttext: array[4] of Text[30];
    begin
        //SONE-PING 201114
        Onestext[1] := 'ONE';
        Onestext[2] := 'TWO';
        Onestext[3] := 'THREE';
        Onestext[4] := 'FOUR';
        Onestext[5] := 'FIVE';
        Onestext[6] := 'SIX';
        Onestext[7] := 'SEVEN';
        Onestext[8] := 'EIGHT';
        Onestext[9] := 'NINE';
        Onestext[10] := 'TEN';
        Onestext[11] := 'ELEVEN';
        Onestext[12] := 'TWELVE';
        Onestext[13] := 'THIRTEEN';
        Onestext[14] := 'FOURTEEN';
        Onestext[15] := 'FIFTEEN';
        Onestext[16] := 'SIXTEEN';
        Onestext[17] := 'SEVENTEEN';
        Onestext[18] := 'EIGHTEEN';
        Onestext[19] := 'NINETEEN';

        Tenstext[1] := '';
        Tenstext[2] := 'TWENTY';
        Tenstext[3] := 'THIRTY';
        Tenstext[4] := 'FORTY';
        Tenstext[5] := 'FIFTY';
        Tenstext[6] := 'SIXTY';
        Tenstext[7] := 'SEVENTY';
        Tenstext[8] := 'EIGHTY';
        Tenstext[9] := 'NINETY';

        Exponenttext[1] := '';
        Exponenttext[2] := 'THOUSAND';
        Exponenttext[3] := 'MILLION';
        Exponenttext[4] := 'BILLION';



        CLEAR(NoText);
        NoTextIndex := 1;
        NoText := '';

        IF No < 1 THEN
            NoText := ''
        ELSE BEGIN
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                Ones := No DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds > 0 THEN BEGIN
                    PrintExponent := TRUE;
                    NoText := DELCHR(NoText + ' ' + Onestext[Hundreds], '<');
                    NoText := DELCHR(NoText + ' ' + 'HUNDRED', '<');

                END;

                IF Tens >= 2 THEN BEGIN
                    PrintExponent := TRUE;
                    NoText := DELCHR(NoText + ' ' + Tenstext[Tens], '<');

                    IF Ones > 0 THEN BEGIN
                        PrintExponent := TRUE;
                        NoText := DELCHR(NoText + ' ' + Onestext[Ones], '<');
                    END;
                END ELSE
                    IF (Tens * 10 + Ones) > 0 THEN BEGIN
                        PrintExponent := TRUE;
                        NoText := DELCHR(NoText + ' ' + Onestext[Tens * 10 + Ones], '<');
                    END;

                IF PrintExponent AND (Exponent > 1) THEN BEGIN
                    PrintExponent := TRUE;
                    NoText := DELCHR(NoText + ' ' + Exponenttext[Exponent], '<');
                END;
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;
        END;
    end;

    procedure EngTxt(TDecimal: Decimal) TText: Text[250]
    begin
        EngInteger(TText, TDecimal);
    end;

    procedure EngUSD(TDecimal: Decimal) TText: Text[250]
    var
        THigh: Decimal;
        TLow: Decimal;
    begin
        //SONE-PING 201114
        TLow := (TDecimal - ROUND(TDecimal, 1, '<')) * 100;
        THigh := ROUND(TDecimal, 1, '<');
        IF THigh <> 0 THEN BEGIN
            EngInteger(TText, THigh);
            TText := TText + ' DOLLAR';
        END;
        IF TLow <> 0 THEN BEGIN
            EngInteger(txt, TLow);
            TText := TText + ' AND ' + txt + ' CENT';
        END
        ELSE
            IF THigh <> 0 THEN
                TText := TText + ' ONLY';
        //+
    end;

    procedure FormatFirstCharacterUppercase(inputText: Text): Text
    var
        formattedText: Text;
    begin
        if StrLen(inputText) > 0 then
            formattedText := UpperCase(CopyStr(inputText, 1, 1)) + LowerCase(CopyStr(inputText, 2));
        exit(formattedText);
    end;

    procedure EngText(TDecimal: Decimal; Cur: Code[10]) TText: Text[250]
    var
        THigh: Decimal;
        TLow: Decimal;
    begin
        //SONE-PING 201114
        TLow := (TDecimal - ROUND(TDecimal, 1, '<')) * 100;
        THigh := ROUND(TDecimal, 1, '<');
        IF THigh <> 0 THEN BEGIN
            EngInteger(TText, THigh);
            TText := TText;
        END;
        IF TLow <> 0 THEN BEGIN
            EngInteger(txt, TLow);
            TText := TText + ' AND ' + txt;
        END
        ELSE
            IF THigh <> 0 THEN
                TText := TText;
        //+
        // final output
        TText := FormatFirstCharacterUppercase(TText);
    end;

    var
        txt: Text[250];
}
