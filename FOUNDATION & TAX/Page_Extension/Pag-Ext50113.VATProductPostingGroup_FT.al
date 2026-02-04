pageextension 50113 VATProductPostingGroups_FT extends "VAT Product Posting Groups"
{
    layout
    {
        addafter(Description)
        {
            field("Is Forwarder";Rec."Is Forwarder_FT")
            {
                ApplicationArea = All;
            }
            field(Percentage;Rec.Percentage_FT)
            {
                ApplicationArea = All;
                Caption = 'DPP Percentage %';
            }
        }
    }
    
    trigger OnInsertRecord(bool: Boolean): Boolean var myInt: Integer;
    begin
        //Message('testoninsertrec');
         Rec.Percentage_FT :=100;
    end;

    trigger OnModifyRecord(): Boolean var myInt: Integer;
    begin
        if Rec."Is Forwarder_FT" then begin
            Rec.Percentage_FT:=10;
        end;
    end;
}