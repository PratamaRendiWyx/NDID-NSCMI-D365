report 50701 CreateTransferOrder_PQ
{
    Caption = 'Create Transfer Order';
    ProcessingOnly = true;

    dataset
    {
        dataitem(CreateNew; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnPostDataItem()
            var
                myInt: Integer;
            begin
                //Action Here
                if Confirm(label1) then begin
                    if ProdOrderComponent.FindSet() then
                        createtransferOrder(ProdOrderComponent);
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    ShowCaption = false;
                    //list field name
                    field(ProductionOrderNo; ProductionOrderNo)
                    {
                        Caption = 'Production Order No.';
                        ApplicationArea = All;
                        Enabled = false;
                        Editable = false;
                        ExtendedDatatype = Barcode;
                    }
                    field(TransferFromCode; TransferFromCode)
                    {
                        Caption = 'Transfer-from Code';
                        ApplicationArea = All;
                        TableRelation = Location.Code;
                        Editable = true;
                        Enabled = true;
                        ExtendedDatatype = Barcode;
                    }
                    field(TransferToCode; getLocationTo())
                    {
                        Caption = 'Transfer-to Code';
                        ApplicationArea = All;
                        Enabled = false;
                        Editable = false;
                    }
                    field(DirectTransfer; DirectTransfer)
                    {
                        Caption = 'Direct Transfer';
                        ApplicationArea = All;
                        Visible = false;
                        trigger OnValidate()
                        var
                            myInt: Integer;
                        begin
                            Clear(CodeProductionOrderMgt);
                            CodeProductionOrderMgt.VerifyNoOutboundWhseHandlingOnLocation(TransferFromCode);
                            CodeProductionOrderMgt.VerifyNoInboundWhseHandlingOnLocation(TransferToCode);
                        end;
                    }
                    field(IntransitLocationCode; IntransitLocationCode)
                    {
                        ApplicationArea = All;
                        Caption = 'In-Transit Location';
                        TableRelation = Location.Code;
                        Enabled = not DirectTransfer;
                        Editable = not DirectTransfer;
                        Visible = false;
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    local procedure createtransferOrder(var iProductionOrderComponent: Record "Prod. Order Component")
    begin
        //validationStock(iProductionOrderComponent);
        Clear(CodeProductionOrderMgt);
        CodeProductionOrderMgt.createTransferOrderFromProdComponent(iProductionOrderComponent, ProductionOrderNo, DirectTransfer, IntransitLocationCode, TransferFromCode);
    end;

    local procedure validationStock(var iProductionOrderComponent: Record "Prod. Order Component")
    var
        Itemledgerentry: Record "Item Ledger Entry";
        locationfrom: Text;
        vStock: Decimal;
    begin
        locationfrom := getLocationFroManfSetup();
        repeat
            Clear(vStock);
            Clear(Itemledgerentry);
            Itemledgerentry.Reset();
            Itemledgerentry.SetRange("Item No.", ProdOrderComponent."Item No.");
            Itemledgerentry.SetRange("Location Code", locationfrom);
            if Itemledgerentry.FindSet() then begin
                Itemledgerentry.CalcSums("Remaining Quantity");
                vStock := Itemledgerentry."Remaining Quantity";
            end;
            //validation stock
            if vStock < ProdOrderComponent."Expected Quantity" then
                Error('Stock item [%3] not enough for create Transfer Order, Expected (%1), Actual (%2)',
                    ProdOrderComponent."Expected Quantity", vStock, ProdOrderComponent."Item No.");
        until iProductionOrderComponent.Next() = 0;
    end;

    procedure setParameter(var iProductionOrderComponent: Record "Prod. Order Component"; iProductionOrderNo: Code[20])
    begin
        ProdOrderComponent.Copy(iProductionOrderComponent);
        ProductionOrderNo := iProductionOrderNo;
    end;

    local procedure getLocationTo(): Text
    var
        ProductionOrder: Record "Production Order";
    begin
        Clear(ProductionOrder);
        ProductionOrder.Reset();
        ProductionOrder.SetRange("No.", ProductionOrderNo);
        if ProductionOrder.Find('-') then
            exit(ProductionOrder."Location Code");
        exit('');
    end;

    local procedure getLocationFroManfSetup(): Text
    var
        ManufacturingSetup: Record "Manufacturing Setup";
        locationFrom: Text;
    begin
        if ManufacturingSetup.Get() then begin
            locationFrom := ManufacturingSetup."Default Source Location Comp.";
            exit(locationFrom);
        end;
        exit('');
    end;

    trigger OnPreReport()
    var
        myInt: Integer;
    begin
        CurrReport.UseRequestPage(true);
    end;

    trigger OnInitReport()
    var
        myInt: Integer;
    begin
        TransferFromCode := getLocationFroManfSetup();
    end;

    //var refresh production order
    var
        Item: Record Item;
        CalcMethod: Option "One Level","All Levels";
        UpdateReservations: Boolean;

    var
        label1: Label 'Are you sure want to create transfer order ?';

        CodeProductionOrderMgt: Codeunit ProdOrderManagement_PQ;

        //create transfer Order
        IntransitLocationCode: Text;
        TransferFromCode: Text;
        TransferToCode: Text;
        ProductionOrderNo: Code[20];
        DirectTransfer: Boolean;
        ProdOrderComponent: Record "Prod. Order Component";


}
