pageextension 50349 QCRoleCenter_SP extends QCRoleCenter_PQ
{
    layout
    {
        addafter(QCActivities)
        {
            part(Control45; ShipmentLineCOAActivities_SP)
            {
                ApplicationArea = All;
                Visible = true;
            }
        }

    }
}
