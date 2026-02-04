table 50303 "Link Shipping Mark Information"
{
    Caption = 'Link Shipping Mark Information';
    DataCaptionFields = "Lot No.", "Package No.", "Shipping Mark No.";
    DrillDownPageID = "Link Shipping Mark Information";
    LookupPageID = "Link Shipping Mark Information";

    fields
    {
        field(12; "Entry No"; Integer)
        {
            Caption = 'Entry No.';
        }
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(2; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
        }
        field(3; "Source Type"; Integer)
        {
            Caption = 'Source Type';
        }
        field(4; "Source Subtype"; Option)
        {
            Caption = 'Source Subtype';
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
        }
        field(5; "Source ID"; Code[20])
        {
            Caption = 'Source ID';
        }
        field(6; "Source Ref. No."; Integer)
        {
            Caption = 'Source Ref. No.';
        }
        field(7; "Package No."; Code[50])
        {
            Caption = 'Package No.';
        }
        field(8; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
        }
        field(9; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(10; "Shipping Mark No."; Code[20])
        {
            Caption = 'Shipping Mark No.';
        }
        field(11; IsPosted; Boolean)
        {
            Caption = 'Is Posted (?)';
        }
        field(13; IsCancel; Boolean)
        {
            Caption = 'Is Cancel (?)';
        }
    }
    keys
    {
        key(PK; "Entry No")
        {
            Clustered = true;
        }
        key(Ke0; "Item No.", "Lot No.", "Location Code", "Package No.", "Source ID", "Source Ref. No.") { }
        key(Key1; "Source ID", "Source Ref. No.", "Lot No.") { }
    }

    trigger OnDelete()
    var
        myInt: Integer;
    begin
        if Rec.IsPosted then
            Error('Can''t delete, cause data already procssed.');
    end;
}
