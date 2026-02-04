codeunit 50100 CodeUnitPPN_FT
{
    trigger OnRun()
    begin
    end;

    var 
    _RecPPN: record PPN_FT;
    procedure GetIncrementRecIDPPN(): Text;
    begin
        _RecPPN.Reset();
        if(_RecPPN.find('+'))then begin
        //exit(IncStr(_RecPPN.RecID));
        end
        else
        begin
            exit('1');
        end;
    end;
}
