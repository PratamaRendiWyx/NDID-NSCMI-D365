page 50735 HistoryFactBox_PQ
{
    Caption = 'History';
    PageType = CardPart;
    SourceTable = QCSpecificationHeader_PQ;

    layout
    {
        area(content)
        {
            field(Type; Rec.Type)
            {
                ApplicationArea = All;
                Caption = 'Specification No.';
                ToolTip = 'Specifies the number of the Specification. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.';

                trigger OnDrillDown()
                begin
                    ShowDetails;
                end;
            }

            cuegroup(Control2)
            {
                ShowCaption = false;
                field(CountActiveQC; CountActiveQC)
                {
                    ApplicationArea = All;
                    Caption = 'Active Quality Tests';
                    ToolTip = 'Specifies the number of Active Quality Tests that have been registered for the Specification.';

                    trigger OnDrillDown()
                    begin
                        Clear(QCTestHdr);
                        Clear(QCTestList);

                        QCTestHdr.Reset;
                        QCTestHdr.SetRange("Item No.", Rec."Item No.");
                        QCTestHdr.SetRange("Customer No.", Rec."Customer No.");
                        QCTestHdr.SetRange("Specification Type", Rec.Type);
                        QCTestHdr.SetFilter("Test Status", '%1|%2|%3', QCTestHdr."Test Status"::"Ready for Testing", QCTestHdr."Test Status"::"In-Process", QCTestHdr."Test Status"::"Ready for Review");
                        if QCTestHdr.FindSet then begin
                            QCTestList.SetTableView(QCTestHdr);
                            QCTestList.Editable(false);
                            QCTestList.RunModal;
                        end;
                    end;
                }
                field(CountCertifiedQC; CountCertifiedQC)
                {
                    ApplicationArea = All;
                    Caption = 'Certified Quality Tests';
                    ToolTip = 'Specifies the number of Certified Quality Tests that have been registered for the Specification.';

                    trigger OnDrillDown()
                    begin
                        Clear(QCTestHdr);
                        Clear(QCTestList);

                        QCTestHdr.Reset;
                        QCTestHdr.SetRange("Item No.", Rec."Item No.");
                        QCTestHdr.SetRange("Customer No.", Rec."Customer No.");
                        QCTestHdr.SetRange("Specification Type", Rec.Type);
                        QCTestHdr.SetFilter("Test Status", '%1|%2|%3', QCTestHdr."Test Status"::Certified);
                        if QCTestHdr.FindSet then begin
                            QCTestList.SetTableView(QCTestHdr);
                            QCTestList.Editable(false);
                            QCTestList.RunModal;
                        end;
                    end;
                }
                field(CountArchivedQC; CountArchivedQC)
                {
                    ApplicationArea = All;
                    Caption = 'Archived Quality Tests';
                    ToolTip = 'Specifies the number of Archived Quality Tests Tests that have been registered for the Specification.';

                    trigger OnDrillDown()
                    begin
                        Clear(QCTestHdr);
                        Clear(QCTestList);

                        QCTestHdr.Reset;
                        QCTestHdr.SetRange("Item No.", Rec."Item No.");
                        QCTestHdr.SetRange("Customer No.", Rec."Customer No.");
                        QCTestHdr.SetRange("Specification Type", Rec.Type);
                        QCTestHdr.SetFilter("Test Status", '%1|%2', QCTestHdr."Test Status"::Rejected, QCTestHdr."Test Status"::Closed);
                        if QCTestHdr.FindSet then begin
                            QCTestList.SetTableView(QCTestHdr);
                            QCTestList.Editable(false);
                            QCTestList.RunModal;
                        end;
                    end;
                }
                field(CountPurchaseLines; CountPurchaseLines)
                {
                    ApplicationArea = Suite;
                    Caption = 'Purchase Lines';
                    ToolTip = 'Specifies the number of Purchase Lines that have been registered for the Specification.';

                    trigger OnDrillDown()
                    begin
                        Clear(gPurchLine);
                        Clear(POLinePage);

                        gPurchLine.Reset;
                        gPurchLine.SetRange(Type, gPurchLine.Type::Item);
                        gPurchLine.SetRange("No.", Rec."Item No.");
                        if gPurchLine.FindSet then begin
                            POLinePage.SetTableView(gPurchLine);
                            POLinePage.Editable(false);
                            POLinePage.RunModal;
                        end;
                    end;
                }
                field(CountSalesLines; CountSalesLines)
                {
                    ApplicationArea = Suite;
                    Caption = 'Sales Lines';
                    ToolTip = 'Specifies the number of Sales Lines that have been registered for the Specification.';

                    trigger OnDrillDown()
                    begin
                        Clear(gSalesLine);
                        Clear(SOLinePage);

                        gSalesLine.Reset;
                        gSalesLine.SetRange(Type, gSalesLine.Type::Item);
                        gSalesLine.SetRange("No.", Rec."Item No.");
                        if gSalesLine.FindSet then begin
                            SOLinePage.SetTableView(gSalesLine);
                            SOLinePage.Editable(false);
                            SOLinePage.RunModal;
                        end;
                    end;
                }
                field(CountOperations; CountOperations)
                {
                    ApplicationArea = Suite;
                    Caption = 'Operations';
                    ToolTip = 'Specifies the number of Operations that have been registered for the Specification.';

                    trigger OnDrillDown()
                    begin
                        Clear(ProdOrderRoutingLine);
                        Clear(ProdOrderRouting);

                        ProdOrderRoutingLine.Reset;
                        ProdOrderRoutingLine.SetRange("CCS Spec. Type ID", Rec.Type);
                        if ProdOrderRoutingLine.FindSet then begin
                            ProdOrderRouting.SetTableView(ProdOrderRoutingLine);
                            ProdOrderRouting.Editable(false);
                            ProdOrderRouting.RunModal;
                        end;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        CountActiveQC := 0;
        CountCertifiedQC := 0;
        CountArchivedQC := 0;
        CountPurchaseLines := 0;
        CountSalesLines := 0;
        CountOperations := 0;

        Rec.CalcFields("Active Quality Tests", "Certified Quality Tests", "Archived Quality Tests", "Purchase Lines", "Sales Lines", Operations);

        CountActiveQC := Rec."Active Quality Tests";
        CountCertifiedQC := Rec."Certified Quality Tests";
        CountArchivedQC := Rec."Archived Quality Tests";
        CountPurchaseLines := Rec."Purchase Lines";
        CountSalesLines := Rec."Sales Lines";
        CountOperations := Rec.Operations;

    end;

    var
        CountPurchaseLines: Integer;
        CountSalesLines: Integer;
        CountActiveQC: Integer;
        CountCertifiedQC: Integer;
        CountArchivedQC: Integer;
        CountOperations: Integer;
        gPurchLine: Record "Purchase Line";
        gSalesLine: Record "Sales Line";
        QCTestHdr: Record QualityTestHeader_PQ;
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        POLinePage: Page "Purchase Lines";
        SOLinePage: Page "Sales Lines";
        QCTestList: Page QCTestList_PQ;
        ProdOrderRouting: Page "Prod. Order Routing";

    local procedure ShowDetails()
    begin
        PAGE.Run(PAGE::QCSpecificationHeader_PQ, Rec);
    end;
}

