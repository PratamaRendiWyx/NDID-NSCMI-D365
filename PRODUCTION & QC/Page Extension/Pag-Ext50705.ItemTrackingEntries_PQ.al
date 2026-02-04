pageextension 50705 ItemTrackingEntries_PQ extends "Item Tracking Entries"
{

    actions
    {
        addafter("Lot No. Information Card")
        {
            action("AMQC Lot No. Information")
            {
                Caption = 'Quality Lot No. Information';
                Image = LotInfo;
                RunObject = Page LotNoList_PQ;
                RunPageLink = "Item No." = FIELD("Item No."),
                              "Lot No." = FIELD("Lot No."),
                              "Variant Code" = FIELD("Variant Code");
                ApplicationArea = All;
            }
        }
    }

}

