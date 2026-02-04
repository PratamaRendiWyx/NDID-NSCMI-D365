pageextension 50758 PPICRoleCenter_PQ extends PPICRoleCenter_FT
{
    layout
    {
        // Add changes to page layout here
        addafter(Control1905113808)
        {
            part(SFA; ShopFloorActivities_FT)
            {
                ApplicationArea = Manufacturing;
            }
        }

    }
    
    actions
    {
        // Add changes to page actions here
    }
    

}