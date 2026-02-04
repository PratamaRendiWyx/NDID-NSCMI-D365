report 50704 "Find Show Document Prod. Order"
{
    ApplicationArea = All;
    Caption = 'Find & Show Document Prod. Order';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(FIndShow; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnPostDataItem()
            var
                myInt: Integer;
            begin
                //Action Here
                findDocument();
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    ShowCaption = false;
                    field(glbProdOrderNo; glbProdOrderNo)
                    {
                        ApplicationArea = All;
                        Caption = 'No.';
                        ExtendedDatatype = Barcode;
                        trigger OnValidate()
                        var
                            myInt: Integer;
                            ProductionOrder: Record "Production Order";
                            Delimiter: Text;
                            Substrings: List of [Text];
                            Substring: Text;
                            SourceText: Text;
                            CountData: Integer;
                        begin
                            Delimiter := '#';
                            SourceText := glbProdOrderNo;
                            Substrings := SourceText.Split(Delimiter);
                            CountData := Substrings.Count();
                            if CountData > 0 then begin
                                case
                                    Substrings.Get(1) of
                                    '1':
                                        begin
                                            Clear(ProductionOrder);
                                            Clear(glbProdOrderNo);
                                            glbProdOrderNo := Substrings.Get(2);
                                            ProductionOrder.SetRange("No.", glbProdOrderNo);
                                            if ProductionOrder.Find('-') then begin
                                                //initiate order
                                                Clear(glbProdOrder);
                                                glbProdOrder.Reset();
                                                glbProdOrder.Copy(ProductionOrder);
                                                //-
                                                Clear(PopupCard);
                                                PopupCard.OpenProdOrderCard(1, ProductionOrder);
                                            end else begin
                                                Error('Production Order does not exists.');
                                            end;
                                        end;
                                    '2':
                                        begin
                                            Evaluate(myInt, Substrings.Get(3));
                                            ShowProductionJournal(Substrings.Get(2),
                                            myInt);
                                        end;
                                    else begin
                                        Error('Nothing to handle.');
                                    end;
                                end;
                            end;
                        end;
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    var
        myInt: Integer;
    begin
        CurrReport.UseRequestPage(true);
    end;

    local procedure ShowProductionJournal(iProdOrderNo: Code[20]; iProdLineNo: Integer)
    var
        ProdOrder: Record "Production Order";
        ProductionJrnlMgt: Codeunit "Production Journal Mgt";
        ProdOrderLine: Record "Prod. Order Line";
    begin
        ProdOrder.Reset();
        ProdOrder.SetRange("No.", iProdOrderNo);
        ProdOrder.SetRange(Status, ProdOrder.Status::Released);
        if ProdOrder.FindSet() then begin
            Clear(ProdOrderLine);
            ProdOrderLine.Reset();
            ProdOrderLine.SetRange("Prod. Order No.", ProdOrder."No.");
            if ProdOrderLine.FindSet() then
                iProdLineNo := ProdOrderLine."Line No.";
            Clear(ProductionJrnlMgt);
            ProductionJrnlMgt.Handling(ProdOrder, iProdLineNo);
        end else begin
            Error('Production Order No. does not exists.');
        end;
    end;

    procedure getProdOrder(): Record "Production Order"
    begin
        exit(glbProdOrder);
    end;

    local procedure findDocument()
    var
        myInt: Integer;
        ProductionOrder: Record "Production Order";
    begin
        Clear(ProductionOrder);
        ProductionOrder.SetRange("No.", glbProdOrderNo);
        if ProductionOrder.Find('-') then begin
            //initiate order
            Clear(glbProdOrder);
            glbProdOrder.Reset();
            glbProdOrder.Copy(ProductionOrder);
            //-
            Clear(PopupCard);
            PopupCard.OpenProdOrderCard(1, ProductionOrder);
        end else begin
            Error('Production Order does not exists.');
        end;
    end;

    var
        glbProdOrderNo: Code[20];
        PopupCard: Codeunit "Pop-up Cards";
        glbProdOrder: Record "Production Order";
}
