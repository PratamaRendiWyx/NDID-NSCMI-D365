enum 50310 "Status Approval Shipment Lines"
{
    Extensible = true;
    
    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; "In Process")
    {
        Caption = 'In Process';
    }
    value(2; "Ready for Review")
    {
        Caption = 'Ready for Review';
    }
    value(3; Approved)
    {
        Caption = 'Approved';
    }
    value(4; Rejected)
    {
        Caption = 'Rejected';
    }
}
