enum 50701 LotSerialStatus_PQ
{
    Extensible = true;

    value(0; "Unrestricted")
    {
        Caption = 'Unrestricted';
    }
    value(1; "In Quality Inspection")
    {
        Caption = 'In Quality Inspection';
    }
    value(2; "Restricted")
    {
        Caption = 'Restricted';
    }
    /*value(3; "Blocked")
    {
        Caption = 'Blocked';
    }*/
    value(3; "Hold")
    {
        Caption = 'Hold';
    }
}