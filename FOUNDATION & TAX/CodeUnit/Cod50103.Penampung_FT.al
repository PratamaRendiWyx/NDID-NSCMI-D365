codeunit 50103 Penampung_FT
{
    trigger OnRun()begin
    end;
    var _Rec: Record Penampung_FT;
    procedure GetIncrementRecIDPenampung(): Text;
    begin
        _Rec.Reset();
        if _Rec.Find('+')then begin
        //exit(IncStr(_Rec.RecID))
        end
        else
        begin
            exit('1');
        end;
    end;
}
