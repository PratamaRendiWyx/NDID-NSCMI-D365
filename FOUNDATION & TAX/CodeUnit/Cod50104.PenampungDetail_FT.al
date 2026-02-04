codeunit 50104 PenampungDetail_FT
{
    trigger OnRun()begin
    end;
    var _Rec: Record PenampungDetail_FT;
    procedure GetIncrementRecId(): Text;
    begin
        if _Rec.Find('+')then begin
        //exit(IncStr(_Rec.LineNo))
        end
        else
        begin
            exit('1');
        end;
    end;
}
