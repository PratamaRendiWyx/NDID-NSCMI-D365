reportextension 50101 CarryOutActionMsgPlan_FT extends "Carry Out Action Msg. - Plan."
{
    // Add new data items, columns, or modify existing ones here
  

    requestpage
    {
        // Modify the request page layout here
        layout
        {
            
            modify("Production Order")
            {
             Caption = 'Subcon Production Order';

            }
        }
    }
}