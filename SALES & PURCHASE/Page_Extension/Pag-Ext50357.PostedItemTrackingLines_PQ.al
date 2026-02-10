pageextension 50357 PostedItemTrackingLines_PQ extends "Posted Item Tracking Lines"
{
    actions
    {
        addfirst(Processing)
        {
            action("View QC Results")
            {
                Caption = '&View Quality Results';
                Image = ViewDetails;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page QCPostedComplianceView_PQ;
                RunPageLink = "Item Entry No." = FIELD("Entry No.");
                ToolTip = 'View results of Quality testing for the item';
                ApplicationArea = All;
            }
            action("PrintCertofAnalysis")
            {
                Caption = '&Print BOP';
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ToolTip = 'Print Certificate for the item';
                ApplicationArea = All;
                trigger OnAction()
                var
                    ILE: Record "Item Ledger Entry";
                    Item: Record Item;
                begin
                    Clear(ILE);
                    ILE.Reset();
                    ILE.SetRange("Document No.", Rec."Document No.");
                    ILE.SetRange("Document Line No.", Rec."Document Line No.");
                    ILE.SetRange("Item No.", Rec."Item No.");

                    Item.Reset();
                    Item.SetRange("No.", Rec."Item No.");
                    if Item.Find('-') then begin
                        if Item."BOP Type" = Item."BOP Type"::" " then
                            Error('Please set BOP Type for this item %1', Rec."Item No.");
                        case
                            Item."BOP Type" of
                            Item."BOP Type"::"1":
                                begin
                                    REPORT.Run(REPORT::"BOP Type 1", true, false, ILE);
                                end;
                            Item."BOP Type"::"2":
                                begin
                                    REPORT.Run(REPORT::"BOP Type 2", true, false, ILE);
                                end;
                            Item."BOP Type"::"3":
                                begin
                                    REPORT.Run(REPORT::"BOP Type 3", true, false, ILE);
                                end;
                            Item."BOP Type"::"4":
                                begin
                                    REPORT.Run(REPORT::"BOP Type 4", true, false, ILE);
                                end;
                        end;
                    end;
                end;
            }

            action("PrintCertofAnalysis Multiple")
            {
                Caption = '&Print BOP Multiple';
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ToolTip = 'Print Certificate for the item';
                ApplicationArea = All;
                trigger OnAction()
                var
                    ILE: Record "Item Ledger Entry";
                    Item: Record Item;
                begin
                    Clear(ILE);
                    ILE.Reset();
                    ILE.SetRange("Document No.", Rec."Document No.");
                    ILE.SetRange("Document Line No.", Rec."Document Line No.");
                    ILE.SetRange("Item No.", Rec."Item No.");

                    Item.Reset();
                    Item.SetRange("No.", Rec."Item No.");
                    if Item.Find('-') then begin
                        if Item."BOP Type" = Item."BOP Type"::" " then
                            Error('Please set BOP Type for this item %1', Rec."Item No.");
                        case
                            Item."BOP Type" of
                            Item."BOP Type"::"1":
                                begin
                                    REPORT.Run(REPORT::"BOP Type 1 New", true, false, ILE);
                                end;
                            Item."BOP Type"::"2":
                                begin
                                    REPORT.Run(REPORT::"BOP Type 2 New", true, false, ILE);
                                end;
                            Item."BOP Type"::"3":
                                begin
                                    REPORT.Run(REPORT::"BOP Type 3 New", true, false, ILE);
                                end;
                            Item."BOP Type"::"4":
                                begin
                                    REPORT.Run(REPORT::"BOP Type 4 New", true, false, ILE);
                                end;
                        end;
                    end;
                end;
            }
        }
    }
}

