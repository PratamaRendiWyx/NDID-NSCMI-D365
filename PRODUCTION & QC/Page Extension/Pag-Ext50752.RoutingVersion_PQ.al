pageextension 50752 RoutingVersion_PQ extends "Routing Version"
{
    layout
    {
        addafter(Description)
        {
            field("Base Routing Comments"; Rec."Base Routing Comments")
            {
                Caption = 'Base Routing Comments';
                ApplicationArea = All;
            }
        }
    }
}

