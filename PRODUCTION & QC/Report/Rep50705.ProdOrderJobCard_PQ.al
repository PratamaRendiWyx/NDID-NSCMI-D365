using Microsoft.Manufacturing.Capacity;
using System.Text;
using Microsoft.Manufacturing.WorkCenter;
using System.Utilities;

report 50705 "Prod. Order - Job Card PQ"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/ProdOrderJobCard.rdlc';
    AdditionalSearchTerms = 'production order - job card,work order job card';
    ApplicationArea = Manufacturing;
    Caption = 'Prod. Order - Job Card (Custom)';
    UsageCategory = ReportsAndAnalysis;
    WordMergeDataItem = "Production Order";

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = sorting(Status, "No.");
            RequestFilterFields = Status, "No.", "Source Type", "Source No.";
            column(Status_ProdOrder; Status)
            {
            }
            column(No_ProdOrder; "No.")
            {
            }
            column(QRCode; QRCode) { }
            column(Code1281; EncodeText1Code128)
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(TodayFormatted; Format(Today, 0, 4))
                {
                }
                column(CompanyName; COMPANYPROPERTY.DisplayName())
                {
                }
                column(ProdOrderTableCaptionFilt; "Production Order".TableCaption + ':' + ProdOrderFilter)
                {
                }
                column(ProdOrderFilter; ProdOrderFilter)
                {
                }
                column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
                {
                }
                column(ProdOrderJobCardCaption; ProdOrderJobCardCaptionLbl)
                {
                }
            }
            dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
            {
                DataItemLink = Status = field(Status), "Prod. Order No." = field("No.");
                DataItemTableView = sorting(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.");
                column(RtngNo_ProdOrderRtngLine; "Routing No.")
                {
                    IncludeCaption = true;
                }
                column(OPNo_ProdOrderRtngLine; "Operation No.")
                {
                    IncludeCaption = true;
                }
                column(Type_ProdOrderRtngLine; Type)
                {
                    IncludeCaption = true;
                }
                column(No_ProdOrderRtngLine; "No.")
                {
                    IncludeCaption = true;
                }
                column(StrtTim_ProdOrderRtngLine; "Starting Time")
                {
                    IncludeCaption = true;
                }
                column(StrtDt_ProdOrderRtngLine; Format("Starting Date"))
                {
                }
                column(EndTime_ProdOrderRtngLine; "Ending Time")
                {
                    IncludeCaption = true;
                }
                column(EndDate_ProdOrderRtngLine; Format("Ending Date"))
                {
                }
                column(ExpCapNd_ProdOrderRtngLine; "Expected Capacity Need")
                {
                }
                column(Desc_ProdOrder; "Production Order".Description)
                {
                }
                column(SourceNo_ProdOrder; "Production Order"."Source No.")
                {
                }
                column(ProdOrdrRtngLineRTUOMCode; CapacityUoM)
                {
                }
                column(PrdOrdNo_ProdOrderRtngLine; "Prod. Order No.")
                {
                    IncludeCaption = true;
                }
                column(ProdOrderRtngLnStrtDtCapt; ProdOrderRtngLnStrtDtCaptLbl)
                {
                }
                column(ProdOrdRtngLnEndDatCapt; ProdOrdRtngLnEndDatCaptLbl)
                {
                }
                column(ProdOrdRtngLnExpcCapNdCpt; ProdOrdRtngLnExpcCapNdCptLbl)
                {
                }
                column(PrecalcTimesCaption; PrecalcTimesCaptionLbl)
                {
                }
                column(ProdOrderSourceNoCapt; ProdOrderSourceNoCaptLbl)
                {
                }
                column(OutputCaption; OutputCaptionLbl)
                {
                }
                column(ScrapCaption; ScrapCaptionLbl)
                {
                }
                column(DateCaption; DateCaptionLbl)
                {
                }
                column(ByCaption; ByCaptionLbl)
                {
                }
                column(EmptyStringCaption; EmptyStringCaptionLbl)
                {
                }
                column(Code128; EncodeTextCode128)
                {
                }
                dataitem("Prod. Order Component"; "Prod. Order Component")
                {
                    DataItemLink = Status = field(Status), "Prod. Order No." = field("Prod. Order No."), "Routing Link Code" = field("Routing Link Code");
                    DataItemTableView = sorting(Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.");
                    column(Position_ProdOrderComp; Position)
                    {
                        IncludeCaption = true;
                    }
                    column(Position2_ProdOrderComp; "Position 2")
                    {
                        IncludeCaption = true;
                    }
                    column(LdTimOffset_ProdOrderComp; "Lead-Time Offset")
                    {
                        IncludeCaption = true;
                    }
                    column(ExpectedQty_ProdOrderComp; "Expected Quantity")
                    {
                        IncludeCaption = true;
                    }
                    column(ItemNo_ProdOrderComp; "Item No.")
                    {
                        IncludeCaption = true;
                    }
                    column(OrderNo_ProdOrderComp; "Prod. Order No.")
                    {
                    }
                    column(MaterialRequirementsCapt; MaterialRequirementsCaptLbl)
                    {
                    }
                }

                trigger OnAfterGetRecord()
                var
                    WorkCenter: Record "Work Center";
                    CalendarMgt: Codeunit "Shop Calendar Management";
                begin
                    GenerateCode128();
                    WorkCenter.Get("Work Center No.");
                    CapacityUoM := WorkCenter."Unit of Measure Code";
                    "Expected Capacity Need" := "Expected Capacity Need" / CalendarMgt.TimeFactor(CapacityUoM);
                end;
            }

            trigger OnAfterGetRecord()
            var
                ProdOrderRoutingLine: Record "Prod. Order Routing Line";
            begin
                ProdOrderRoutingLine.SetRange(Status, Status);
                ProdOrderRoutingLine.SetRange("Prod. Order No.", "No.");
                if not ProdOrderRoutingLine.FindFirst() then
                    CurrReport.Skip();
                //Generate QR Code
                BarcodeKey := "Production Order"."No.";
                GenerateCodePN();
                GenerateQRCode();
                //
            end;

            trigger OnPreDataItem()
            begin
                ProdOrderFilter := GetFilters();
            end;
        }
    }

    requestpage
    {
        AboutTitle = 'About Prod. Order - Job Card';
        AboutText = 'Details out the components and capacity required to fulfil a Production Order. Use it to provide a printable report that your team can use to execute the manufacturing job.';

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

    var
        QRCode: Text;
        BarcodeKey: Text;
        CustomerNo: Code[20];
        CustomerName: Text[100];

    local procedure GenerateCode128()
    var
        BarcodeSymbology: Enum "Barcode Symbology";
        BarcodeFontProvider: Interface "Barcode Font Provider";
        BarcodeString: Text;
        BarcodeString1: Text;
    begin
        BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
        BarcodeSymbology := Enum::"Barcode Symbology"::Code128;
        BarcodeString := '2#' + "Production Order"."No." + '#' + Format("Prod. Order Routing Line"."Routing Reference No.");
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
        ProdOrderFilter: Text;
        CapacityUoM: Code[10];
        CurrReportPageNoCaptionLbl: Label 'Page';
        ProdOrderJobCardCaptionLbl: Label 'Prod. Order - Job Card';
        ProdOrderRtngLnStrtDtCaptLbl: Label 'Starting Date';
        ProdOrdRtngLnEndDatCaptLbl: Label 'Ending Date';
        ProdOrdRtngLnExpcCapNdCptLbl: Label 'Time Needed';
        PrecalcTimesCaptionLbl: Label 'Precalc. Times';
        ProdOrderSourceNoCaptLbl: Label 'Item No.';
        OutputCaptionLbl: Label 'Output';
        ScrapCaptionLbl: Label 'Scrap';
        DateCaptionLbl: Label 'Date';
        ByCaptionLbl: Label 'By';
        EmptyStringCaptionLbl: Label '___________';
        MaterialRequirementsCaptLbl: Label 'Material Requirements';
}

