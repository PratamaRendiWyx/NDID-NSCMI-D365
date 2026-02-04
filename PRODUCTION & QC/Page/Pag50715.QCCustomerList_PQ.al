page 50715 QCCustomerList_PQ
{
    // version QC10.1

    // //QC3.7   Filters Customer by Has Item Specifications = TRUE
    // 
    // //QC7.2 08/20/13 Doug McIntosh, Cost Control Software
    //   - Removed several Actions
    //   - Promoted certain Actions
    //   - Added Subform to show Items with Customer's Specs

    Caption = 'Customer List';
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Quality Specs,Customer';
    ShowFilter = true;
    SourceTable = Customer;
    SourceTableView = WHERE("Has Quality Specifications" = CONST(true));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Has Quality Specifications"; Rec."Has Quality Specifications")
                {
                    ApplicationArea = All;
                }
                field("Spec.""Tests on File"""; Spec."Tests on File")
                {
                    Caption = 'Tests on File';
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Post Code"; Rec."Post Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Fax No."; Rec."Fax No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Contact; Rec.Contact)
                {
                    ApplicationArea = All;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Customer Price Group"; Rec."Customer Price Group")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Customer Disc. Group"; Rec."Customer Disc. Group")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Reminder Terms Code"; Rec."Reminder Terms Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Fin. Charge Terms Code"; Rec."Fin. Charge Terms Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Language Code"; Rec."Language Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Search Name"; Rec."Search Name")
                {
                    ApplicationArea = All;
                }
            }
            part(Control1240070001; QCSpecificationCustSub_PQ)
            {
                SubPageLink = "Customer No." = FIELD(FILTER("No."));
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Customer")
            {
                Caption = '&Customer';
                Image = Customer;
                action("Card")
                {
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No." = FIELD("No."),
                                  "Date Filter" = FIELD("Date Filter"),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                    ShortCutKey = 'Shift+Ctrl+C';
                    ToolTip = 'Edit Customer Card';
                    ApplicationArea = All;
                }
            }
            group("S&ales")
            {
                Caption = 'S&ales';
                Image = Sales;
                action("Blanket Orders")
                {
                    Caption = 'Blanket Orders';
                    Image = BlanketOrder;
                    RunObject = Page "Blanket Sales Orders";
                    RunPageLink = "Sell-to Customer No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", "Sell-to Customer No.");
                    ToolTip = 'Edit Blanket Sales Orders';
                    ApplicationArea = All;
                }
                action("Orders")
                {
                    Caption = 'Orders';
                    Image = Document;
                    RunObject = Page "Sales Order List";
                    RunPageLink = "Sell-to Customer No." = FIELD("No.");
                    RunPageView = SORTING("Sell-to Customer No.");
                    ToolTip = 'View Sales Order List';
                    ApplicationArea = All;
                }
            }
            group("&Reports")
            {
                Caption = '&Reports';
            }
        }
    }

    var
        Spec: Record QCSpecificationHeader_PQ;

    procedure GetSelectionFilter(): Code[80];
    var
        Cust: Record Customer;
        FirstCust: Code[30];
        LastCust: Code[30];
        SelectionFilter: Code[250];
        CustCount: Integer;
        More: Boolean;
    begin
        CurrPage.SETSELECTIONFILTER(Cust);
        CustCount := Cust.COUNT;
        if CustCount > 0 then begin
            Cust.FIND('-');
            while CustCount > 0 do begin
                CustCount := CustCount - 1;
                Cust.MARKEDONLY(false);
                FirstCust := Cust."No.";
                LastCust := FirstCust;
                More := (CustCount > 0);
                while More do
                    if Cust.NEXT = 0 then
                        More := false
                    else
                        if not Cust.MARK then
                            More := false
                        else begin
                            LastCust := Cust."No.";
                            CustCount := CustCount - 1;
                            if CustCount = 0 then
                                More := false;
                        end;
                if SelectionFilter <> '' then
                    SelectionFilter := SelectionFilter + '|';
                if FirstCust = LastCust then
                    SelectionFilter := SelectionFilter + FirstCust
                else
                    SelectionFilter := SelectionFilter + FirstCust + '..' + LastCust;
                if CustCount > 0 then begin
                    Cust.MARKEDONLY(true);
                    Cust.NEXT;
                end;
            end;
        end;
        exit(SelectionFilter);
    end;
}

