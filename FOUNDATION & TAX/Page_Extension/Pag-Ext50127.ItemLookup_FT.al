pageextension 50127 ItemLookup_FT extends "Item Lookup"
{
    layout
    {
        // Add changes to page layout here
        modify("Common Item No.")
        {
            Caption = 'Part No.';
        }

        addafter(Description)
        {
            // field("Common Item No.";Rec."Common Item No.")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Part No.';
            // }

            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = All;
                Caption = 'Part Name';
            }
        }
    }
    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}