codeunit 50101 PPNDetail_FT
{
    trigger OnRun()begin
    end;
    procedure GetIncrementPPNLine(): Integer;
    var _RecPPNDet: record PPNDetail_FT;
    begin
        _RecPPNDet.Reset();
        if _RecPPNDet.Find('+')then begin
            exit(_RecPPNDet.LineNo + 1);
        end
        else
        begin
            exit(1);
        end;
    end;
}
