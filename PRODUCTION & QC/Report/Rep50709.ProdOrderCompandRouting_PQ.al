using Microsoft.Manufacturing.Document;
using System.Text;
using Microsoft.Manufacturing.Journal;

report 50709 "Prod. Order Comp. and Rtg."
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/ProdOrderCompandRouting.rdlc';
    ApplicationArea = Manufacturing;
    Caption = 'Prod. Order Comp. and Routing';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = sorting(Status, "No.");
            RequestFilterFields = Status, "No.";
            column(Shift; Shift) { }
            column(Capacity_Line; "Capacity Line") { }
            column(Production_Line; "Production Line")
            {

            }
            column(Start_Date_Production_; Format("Start Date-Time (Production)", 0, '<Day,2>-<Month,2>-<Year4>'))
            {

            }
            column(End_Date_Production_; Format("End Date-Time (Production)", 0, '<Day,2>-<Month,2>-<Year4>'))
            {

            }
            column(Start_Time_Production_; Format("Start Date-Time (Production)", 0, '<Hours24>:<Minutes,2>'))
            {

            }
            column(End_Time_Production_; Format("End Date-Time (Production)", 0, '<Hours24>:<Minutes,2>'))
            {

            }
            column(Code1281; EncodeText1Code128)
            {
            }
            column(Code128; EncodeTextCode128)
            {
            }
            column(TodayFormatted; Format(Today, 0, 4))
            {
            }
            column(CompanyName; COMPANYPROPERTY.DisplayName())
            {
            }
            column(Status_ProductionOrder; Status)
            {
                IncludeCaption = true;
            }
            column(No_ProductionOrder; "No.")
            {
                IncludeCaption = true;
            }
            column(CurrReportPageNoCapt; CurrReportPageNoCaptLbl)
            {
            }
            column(PrdOdrCmptsandRtngLinsCpt; PrdOdrCmptsandRtngLinsCptLbl)
            {
            }
            column(ProductionOrderDescCapt; ProductionOrderDescCaptLbl)
            {
            }
            dataitem("Prod. Order Line"; "Prod. Order Line")
            {
                DataItemLink = Status = field(Status), "Prod. Order No." = field("No.");
                DataItemTableView = sorting(Status, "Prod. Order No.", "Line No.");
                RequestFilterFields = "Item No.", "Line No.";
                column(No1_ProductionOrder; "Production Order"."No.")
                {
                }
                column(Desc_ProductionOrder; "Production Order".Description)
                {
                }
                column(Desc_ProdOrderLine; Description)
                {
                }
                column(Quantity_ProdOrderLine; Quantity)
                {
                    IncludeCaption = true;
                }
                column(ItemNo_ProdOrderLine; "Item No.")
                {
                }
                column(StartgDate_ProdOrderLine; Format("Starting Date"))
                {
                }
                column(StartgTime_ProdOrderLine; "Starting Time")
                {
                    IncludeCaption = true;
                }
                column(EndingDate_ProdOrderLine; Format("Ending Date"))
                {
                }
                column(EndingTime_ProdOrderLine; "Ending Time")
                {
                    IncludeCaption = true;
                }
                column(DueDate_ProdOrderLine; Format("Due Date"))
                {
                }
                column(LineNo_ProdOrderLine; "Line No.")
                {
                }
                column(ProdOdrLineStrtngDteCapt; ProdOdrLineStrtngDteCaptLbl)
                {
                }
                column(ProdOrderLineEndgDteCapt; ProdOrderLineEndgDteCaptLbl)
                {
                }
                column(ProdOrderLineDueDateCapt; ProdOrderLineDueDateCaptLbl)
                {
                }
                dataitem("Prod. Order Component"; "Prod. Order Component")
                {
                    DataItemLink = Status = field(Status), "Prod. Order No." = field("Prod. Order No."), "Prod. Order Line No." = field("Line No.");
                    DataItemTableView = sorting(Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.");
                    column(ItemNo_PrdOrdrComp; "Item No.")
                    {
                    }
                    column(ItemNo_PrdOrdrCompCaption; FieldCaption("Item No."))
                    {
                    }
                    column(Description_ProdOrderComp; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(Quantityper_ProdOrderComp; "Quantity per")
                    {
                        IncludeCaption = true;
                    }
                    column(UntofMesrCode_PrdOrdrComp; "Unit of Measure Code")
                    {
                        IncludeCaption = true;
                    }
                    column(RemainingQty_PrdOrdrComp; "Remaining Quantity")
                    {
                        IncludeCaption = true;
                    }
                    column(DueDate_PrdOrdrComp; Format("Due Date"))
                    {
                    }
                    column(ProdOrdrLinNo_PrdOrdrComp; "Prod. Order Line No.")
                    {
                    }
                    column(LineNo_PrdOrdrComp; "Line No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        // if ProductionJrnlMgt.RoutingLinkValid("Prod. Order Component", "Prod. Order Line") then
                        //     CurrReport.Skip();
                    end;
                }
                dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
                {
                    DataItemLink = "Routing No." = field("Routing No."), "Routing Reference No." = field("Routing Reference No."), "Prod. Order No." = field("Prod. Order No."), Status = field(Status);
                    DataItemTableView = sorting(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.");
                    column(OprNo_ProdOrderRtngLine; "Operation No.")
                    {
                    }
                    column(OprNo_ProdOrderRtngLineCaption; FieldCaption("Operation No."))
                    {
                    }
                    column(Type_PrdOrdRtngLin; Type)
                    {
                        IncludeCaption = true;
                    }
                    column(No_ProdOrderRoutingLine; "No.")
                    {
                        IncludeCaption = true;
                    }
                    column(LinDesc_ProdOrderRtngLine; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(StrgDt_ProdOrderRtngLine; Format("Starting Date"))
                    {
                    }
                    column(LinStrgTime_PrdOrdRtngLin; "Starting Time")
                    {
                        IncludeCaption = true;
                    }
                    column(EndgDte_ProdOrdrRtngLine; Format("Ending Date"))
                    {
                    }
                    column(EndgTime_ProdOrdrRtngLin; "Ending Time")
                    {
                        IncludeCaption = true;
                    }
                    column(RoutgNo_ProdOrdrRtngLine; "Routing No.")
                    {
                    }
                    dataitem(CompLink; "Prod. Order Component")
                    {
                        DataItemLink = Status = field(Status), "Prod. Order No." = field("Prod. Order No."), "Prod. Order Line No." = field("Routing Reference No."), "Routing Link Code" = field("Routing Link Code");
                        DataItemTableView = sorting(Status, "Prod. Order No.", "Routing Link Code", "Flushing Method") where("Routing Link Code" = filter(<> ''));
                        column(ItemNo_CompLink; "Item No.")
                        {
                        }
                        column(Description_CompLink; Description)
                        {
                        }
                        column(Quantityper_CompLink; "Quantity per")
                        {
                        }
                        column(UntofMeasureCode_CompLink; "Unit of Measure Code")
                        {
                        }
                        column(DueDate_CompLink; Format("Due Date"))
                        {
                        }
                        column(RemainingQty_CompLink; "Remaining Quantity")
                        {
                        }
                        column(LineNo_CompLink; "Line No.")
                        {
                        }
                        column(RoutingLinkCode_CompLink; "Routing Link Code")
                        {
                        }
                    }
                }
            }
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                //Generate QR Code
                BarcodeKey := "Production Order"."No.";
                GenerateCodePN();
                GenerateQRCode();
                GenerateCode128();
                //
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    local procedure GenerateCode128()
    var
        BarcodeSymbology: Enum "Barcode Symbology";
        BarcodeFontProvider: Interface "Barcode Font Provider";
        BarcodeString: Text;
        BarcodeString1: Text;
    begin
        BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
        BarcodeSymbology := Enum::"Barcode Symbology"::Code128;
        BarcodeString := '2#' + "Production Order"."No." + '#' + Format(0);
        BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
        EncodeTextCode128 := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
    end;

    local procedure GenerateCodePN()
    var
        BarcodeSymbology: Enum "Barcode Symbology";
        BarcodeFontProvider: Interface "Barcode Font Provider";
        BarcodeString1: Text;
    begin
        //Show Prod Order
        BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
        BarcodeSymbology := Enum::"Barcode Symbology"::Code128;
        BarcodeString1 := '1#' + "Production Order"."No.";
        BarcodeFontProvider.ValidateInput(BarcodeString1, BarcodeSymbology);
        EncodeText1Code128 := BarcodeFontProvider.EncodeFont(BarcodeString1, BarcodeSymbology);
    end;

    local procedure GenerateQRCode()
    var
        BarcodeSymbology2D: Enum "Barcode Symbology 2D";
        BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
    begin
        BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
        BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
        QRCode := BarcodeFontProvider2D.EncodeFont(BarcodeKey, BarcodeSymbology2D);
    end;

    var
        BarcodeString: Text;
        EncodeTextCode128: Text;
        EncodeText1Code128: Text;
        QRCode: Text;
        BarcodeKey: Text;

    var
        ProductionJrnlMgt: Codeunit "Production Journal Mgt";
        CurrReportPageNoCaptLbl: Label 'Page';
        PrdOdrCmptsandRtngLinsCptLbl: Label 'Prod. Order - Components and Routing Lines';
        ProductionOrderDescCaptLbl: Label 'Description';
        ProdOdrLineStrtngDteCaptLbl: Label 'Starting Date';
        ProdOrderLineEndgDteCaptLbl: Label 'Ending Date';
        ProdOrderLineDueDateCaptLbl: Label 'Due Date';
}

