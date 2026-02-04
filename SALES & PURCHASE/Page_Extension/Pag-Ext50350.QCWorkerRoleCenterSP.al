pageextension 50350 QCWorkerRoleCenter_SP extends QCWorkerRoleCenter_PQ
{
    layout
    {
        addafter(QCActivities)
        {
            part(Control44; ShipmentLineCOAQCActivities_SP)
            {
                ApplicationArea = All;
                Visible = true;
            }
        }

    }
}
