tableextension 50102 Item_FT extends "Item"
{
    fields
    {
        field(50100; "WHT Product Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'WHT Product Posting Group';
            TableRelation = WHTProductPostingGroup_FT."Code";
        }

        modify("Common Item No.")
        {
            Caption = 'Part No.';
        }

        modify("Description 2")
        {
            Caption = 'Part Name';
        }

        field(50101; "Reff. No."; Code[35])
        {
            Caption = 'Reference No.';
            //Caption = 'Accounting Number';
        }
    }


    fieldgroups
    {
        addlast(DropDown; "No.", Description, "Common Item No.", "Description 2")
        {
        }
    }
}