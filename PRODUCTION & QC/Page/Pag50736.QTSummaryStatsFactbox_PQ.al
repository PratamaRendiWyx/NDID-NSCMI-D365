page 50736 QTSummaryStatsFactbox_PQ
{
    Caption = 'Quality Test Details';
    Editable = false;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = QualityTestHeader_PQ;

    layout
    {
        area(content)
        {
          group("General Information")
          {
            ShowCaption = false;
            field(Blank; Blank)
            {
              ApplicationArea = All;
              Caption = '';
            }
            field("Item No."; Rec."Item No.")
            {
                ApplicationArea = All;
                Caption = 'Item No.';
                ToolTip = 'Specifies the item no.';
            }
            field("Test Description"; Rec."Test Description")
            {
                ApplicationArea = All;
                Caption = 'Test Description';
                ToolTip = 'Specifies the test description.';
            }
            field("Source Type"; Rec."Source Type")
            {
                ApplicationArea = All;
                Caption = 'Source Type';
                ToolTip = 'Specifies the source type.';
            }
            field("Source No"; Rec."Source No.")
            {
                ApplicationArea = All;
                Caption = 'Source No';
                ToolTip = 'Specifies the source no.';

                trigger OnDrillDown()
                begin
                  OpenSource();
                end;
            }
            field("Vendor No"; Rec."Vendor No.")
            {
                ApplicationArea = All;
                Caption = 'Vendor No';
                ToolTip = 'Specifies the vendor no.';
            }
          }

          group("Status")
          {
            ShowCaption = false;
            field(Blank2; Blank)
            {
              ApplicationArea = All;
              Caption = '';
            }
            field("Test Status"; Rec."Test Status")
            {
                ApplicationArea = All;
                Caption = 'Test Status';
                ToolTip = 'Specifies the test status.';
            }
            field("Test Start Date"; Rec."Test Start Date")
            {
                ApplicationArea = All;
                Caption = 'Test Start Date';
                ToolTip = 'Specifies the test start date.';
            }
            field("Test Start Time"; Rec."Test Start Time")
            {
                ApplicationArea = All;
                Caption = 'Test Start Time';
                ToolTip = 'Specifies the test start time.';
            }
            field("Tested By"; Rec."Tested By")
            {
                ApplicationArea = All;
                Caption = 'Tested By';
                ToolTip = 'Specifies the tested by.';
            }
          }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
    begin

    end;

    var
      Blank: Text[10];
        

    local procedure OpenSource()
    var
      PurchHdrRc: Record "Purchase Header";
      PurchOrderP: Page "Purchase Order";
      SalesHdrRc: Record "Sales Header";
      SalesOrderP: Page "Sales Order";
      ProdOrderRoutingLine: Record "Prod. Order Routing Line";
      ProdOrderRouting: Page "Prod. Order Routing";
    begin
        if Rec."Source Type" = Rec."Source Type"::"Purchase Order" then begin
            PurchHdrRc.Reset();
            PurchHdrRc.SetRange("Document Type", PurchHdrRc."Document Type"::Order);
            PurchHdrRc.SetRange("No.", Rec."Source No.");
            if PurchHdrRc.FindSet() then begin
              PurchOrderP.SetTableView(PurchHdrRc);
              PurchOrderP.Editable(false);
              PurchOrderP.Run();
            end;
        end;

        if Rec."Source Type" = Rec."Source Type"::"Sales Order" then begin
          SalesHdrRc.Reset();
          SalesHdrRc.SetRange("Document Type", SalesHdrRc."Document Type"::Order);
          SalesHdrRc.SetRange("No.", Rec."Source No.");
          if SalesHdrRc.FindSet() then begin
            SalesOrderP.SetTableView(SalesHdrRc);
            SalesOrderP.Editable(false);
            SalesOrderP.Run();
          end;
        end;

        if Rec."Source Type" = Rec."Source Type"::"Production Order" then begin
            ProdOrderRoutingLine.Reset;
            ProdOrderRoutingLine.SetRange("CCS Quality Test No.", Rec."Test No.");
            if ProdOrderRoutingLine.FindSet then begin
                ProdOrderRouting.SetTableView(ProdOrderRoutingLine);
                ProdOrderRouting.Editable(false);
                ProdOrderRouting.RunModal;
            end;
        end;
    end;
}

