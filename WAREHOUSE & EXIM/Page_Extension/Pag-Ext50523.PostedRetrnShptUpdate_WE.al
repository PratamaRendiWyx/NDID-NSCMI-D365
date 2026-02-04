pageextension 50523 PostedRetrnShptUpdate_WE extends "Posted Return Shpt. - Update"
{
    layout
    {
        addafter("Posting Date")
        {
            //Additional information 
            field("Prepared By"; Rec."Prepared By")
            {
                ApplicationArea = All;
            }
            field("Prepared By Name"; Rec."Prepared By Name")
            {
                ApplicationArea = All;
                Enabled = false;
            }
            field("Checked By"; Rec."Checked By")
            {
                ApplicationArea = All;
            }
            field("Checked By Name"; Rec."Checked By Name")
            {
                ApplicationArea = All;
                Enabled = false;
            }
            field("Warehouse Person"; Rec."Warehouse Person")
            {
                ApplicationArea = All;
            }
            field("Warehouse Person Name"; Rec."Warehouse Person Name")
            {
                ApplicationArea = All;
                Enabled = false;
            }
            //-
        }
    }
}
