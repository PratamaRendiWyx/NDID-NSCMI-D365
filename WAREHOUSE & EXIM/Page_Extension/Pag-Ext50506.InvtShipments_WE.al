pageextension 50506 InvtShipments_WE extends "Invt. Shipments"
{
    layout
    {
        // Add changes to page layout here

        addafter("Posting Description")
        {
            field("Gen. Bus. Posting Group";Rec."Gen. Bus. Posting Group")
            {
                Caption ='Process Type';
                ApplicationArea = All;
                
            }
        }

        addafter ("Location Code")
        {
            field(Remarks;Rec.Remarks)
            {
                ApplicationArea = All;
            }
        }


    }
    
    actions
    {
        // Add changes to page actions here
    }
    

}