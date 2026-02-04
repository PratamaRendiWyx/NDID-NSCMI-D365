namespace PRODUCTIONQC.PRODUCTIONQC;

enum 50707 "Production Status"
{
    Extensible = true;

    value(0; "In Process")
    {
        Caption = 'In Process';
    }
    value(1; "Ready for Review")
    {
        Caption = 'Ready for Review';
    }
    value(2; Completed)
    {
        Caption = 'Completed';
    }
}
