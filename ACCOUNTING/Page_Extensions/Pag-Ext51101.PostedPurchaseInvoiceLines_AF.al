pageextension 51101 PostedPurchaseInvoiceLines_AF extends "Posted Purchase Invoice Lines"
{
    layout
    {
        addafter("Appl.-to Item Entry")
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
            }
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
            }
            field("WHT Business Posting Group"; Rec."WHT Business Posting Group")
            {
                ApplicationArea = All;
            }
            field("WHT Product Posting Group"; Rec."WHT Product Posting Group")
            {
                ApplicationArea = All;
            }
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = All;
            }
            field("Currency Factor"; Rec."Currency Factor")
            {
                ApplicationArea = All;
            }
            field("Receipt No."; Rec."Receipt No.")
            {
                ApplicationArea = All;
            }
            field("Tax Number"; Rec."Tax Number")
            {
                ApplicationArea = All;
            }
            field(Budget; checkDimCodeValue(Rec."Dimension Set ID", 'BUDGET'))
            {
                Caption = 'Budget Code';
                ApplicationArea = All;
            }
        }
        addafter("Document No.")
        {
            field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
        }
    }

    procedure checkDimValue(iDimEntryID: Integer; iDimCode: Code[20]): Text
    var
        Dimentry: Record "Dimension Set Entry";
    begin
        Dimentry.Reset();
        Dimentry.SetRange("Dimension Set ID", iDimEntryID);
        Dimentry.SetRange("Dimension Code", iDimCode);
        if Dimentry.Find('-') then
            exit(Dimentry."Dimension Value Name");
    end;

    procedure checkDimCodeValue(iDimEntryID: Integer; iDimCode: Code[20]): Text
    var
        Dimentry: Record "Dimension Set Entry";
    begin
        Dimentry.Reset();
        Dimentry.SetRange("Dimension Set ID", iDimEntryID);
        Dimentry.SetRange("Dimension Code", iDimCode);
        if Dimentry.Find('-') then
            exit(Dimentry."Dimension Value Code");
    end;
}
