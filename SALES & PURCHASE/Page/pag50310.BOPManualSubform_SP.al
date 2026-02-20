page 50310 BOPManualSubform_SP
{
    PageType = ListPart;
    SourceTable = "BOPManualLines_SP";
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Item Desc"; Rec."Item Desc")
                {
                    ApplicationArea = All;
                }
                field("Item Reference No."; Rec."Item Reference No.")
                {
                    ApplicationArea = All;
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                }
                field("Quantity"; Rec."Quantity")
                {
                    ApplicationArea = All;
                }
                field("UOM"; Rec."UOM")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(LineGroup)
            {
                Caption = 'Line';

                action(ItemTrackingLines)
                {
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ApplicationArea = All;
                    ToolTip = 'Open the item tracking lines to assign lot numbers.';

                    trigger OnAction()
                    var
                        TrackingRec: Record "BOPManualTracking_SP";
                        TrackingPage: Page "BOPManualTrackingLines_SP";
                    begin
                        Rec.TestField("Item No.");

                        TrackingRec.Reset();
                        TrackingRec.SetRange("Document No.", Rec."Document No.");
                        TrackingRec.SetRange("Line No.", Rec."Line No.");
                        TrackingRec.SetRange("Item No.", Rec."Item No.");
                        TrackingPage.SetTableView(TrackingRec);
                        TrackingPage.RunModal();
                    end;
                }
                action("PrintCertofAnalysis")
                {
                    Caption = '&Print BOP (Single)';
                    Image = Print;
                    ToolTip = 'Print Certificate for the item';
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        BOPHeader: Record "BOPManualHeader_SP";
                        Item: Record Item;
                        RepType1: Report BOPManualType1;
                        RepType2: Report BOPManualType2;
                        RepType3: Report BOPManualType3;
                        RepType4: Report BOPManualType4;
                    begin
                        Clear(BOPHeader);
                        if BOPHeader.Get(Rec."Document No.") then
                            BOPHeader.SetRecFilter();

                        if Item.Get(Rec."Item No.") then begin
                            if Item."BOP Type" = Item."BOP Type"::" " then
                                Error('Please set BOP Type for this item %1', Rec."Item No.");

                            case Item."BOP Type" of
                                Item."BOP Type"::"1":
                                    begin
                                        Clear(RepType1);
                                        RepType1.SetTableView(BOPHeader);
                                        RepType1.SetLineFilter(Rec."Line No.");
                                        RepType1.RunModal();
                                    end;
                                Item."BOP Type"::"2":
                                    begin
                                        Clear(RepType2);
                                        RepType2.SetTableView(BOPHeader);
                                        RepType2.SetLineFilter(Rec."Line No.");
                                        RepType2.RunModal();
                                    end;
                                Item."BOP Type"::"3":
                                    begin
                                        Clear(RepType3);
                                        RepType3.SetTableView(BOPHeader);
                                        RepType3.SetLineFilter(Rec."Line No.");
                                        RepType3.RunModal();
                                    end;
                                Item."BOP Type"::"4":
                                    begin
                                        Clear(RepType4);
                                        RepType4.SetTableView(BOPHeader);
                                        RepType4.SetLineFilter(Rec."Line No.");
                                        RepType4.RunModal();
                                    end;

                            end;
                        end;
                    end;
                }

                action("PrintCertofAnalysis2")
                {
                    Caption = '&Print BOP (Multiple)';
                    Image = Print;
                    ToolTip = 'Print Certificate for the item';
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        BOPHeader: Record "BOPManualHeader_SP";
                        Item: Record Item;
                        RepType1: Report BOPManualMultipleType1;
                        RepType2: Report BOPManualMultipleType2;
                        RepType3: Report BOPManualMultipleType3;
                        RepType4: Report BOPManualMultipleType4;
                    begin
                        Clear(BOPHeader);
                        if BOPHeader.Get(Rec."Document No.") then
                            BOPHeader.SetRecFilter();

                        if Item.Get(Rec."Item No.") then begin
                            if Item."BOP Type" = Item."BOP Type"::" " then
                                Error('Please set BOP Type for this item %1', Rec."Item No.");

                            case Item."BOP Type" of
                                Item."BOP Type"::"1":
                                    begin
                                        Clear(RepType1);
                                        RepType1.SetTableView(BOPHeader);
                                        RepType1.SetLineFilter(Rec."Line No.");
                                        RepType1.RunModal();
                                    end;
                                Item."BOP Type"::"2":
                                    begin
                                        Clear(RepType2);
                                        RepType2.SetTableView(BOPHeader);
                                        RepType2.SetLineFilter(Rec."Line No.");
                                        RepType2.RunModal();
                                    end;
                                Item."BOP Type"::"3":
                                    begin
                                        Clear(RepType3);
                                        RepType3.SetTableView(BOPHeader);
                                        RepType3.SetLineFilter(Rec."Line No.");
                                        RepType3.RunModal();
                                    end;
                                Item."BOP Type"::"4":
                                    begin
                                        Clear(RepType4);
                                        RepType4.SetTableView(BOPHeader);
                                        RepType4.SetLineFilter(Rec."Line No.");
                                        RepType4.RunModal();
                                    end;

                            end;
                        end;
                    end;
                }
            }



        }
    }
}