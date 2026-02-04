report 50702 ProdOrderExpectActual_PQ
{

    // //MP4 Changed Key on Item Ledger Entry DateItem, Sort Property to speed up report
    //       Old key:  Entry No.
    //       New key:  SORTING(Prod. Order No.,Prod. Order Line No.,Entry Type,Prod. Order Comp. Line No.)
    // 
    // MP6.01  Changed the Capacity Ledger link filters from Document No. = Prod. Order No.    to     Prod. Order No. = Prod. Order No.
    //         Printed from the Production Order Statistics
    // 
    // MP8.0.10
    //   - Added Code in OnInitReport to set "PrintDetail" to TRUE
    // 
    // MP13.0.0
    //   - Layout modification: rebuilt the SetData section
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/CCS Prod.Order - Expect Actual.rdlc';

    Caption = 'Prod. Order - Expect Actual';

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = SORTING(Status, "No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = Status, "No.", "Source Type", "Source No.";
            column(PrintDetail; PrintDetail)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(TIME; Time)
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Production_Order__TABLECAPTION_________ProdOrderFilter; "Production Order".TableCaption + ':' + ProdOrderFilter)
            {
            }
            column(ReportID; ReportID)
            {
            }
            column(ReportNum; ReportNum)
            {
            }
            column(Time_VS; Format(Time))
            {
            }
            column(Production_Order__No__; "No.")
            {
                IncludeCaption = true;
            }
            column(Production_Order_Description; Description)
            {
                IncludeCaption = true;
            }
            column(Production_Order__Source_No__; "Source No.")
            {
            }
            column(Production_Order_Quantity; Quantity)
            {
            }
            column(Production_Order__Starting_Date_; DT2Date("Starting Date-Time"))
            {
            }
            column(Production_Order__Ending_Date_; DT2Date("Ending Date-Time"))
            {
            }
            column(Production_Order__Due_Date_; "Due Date")
            {
            }
            column(Production_Order_Status; Status)
            {
            }
            column(Production_Order___Expected_and_Actual_Cost_DetailsCaption; Production_Order___Expected_and_Actual_Cost_DetailsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Production_Order__Source_No__Caption; FieldCaption("Source No."))
            {
            }
            column(Production_Order_QuantityCaption; FieldCaption(Quantity))
            {
            }
            column(Production_Order__Starting_Date_Caption; FieldCaption("Starting Date-Time"))
            {
            }
            column(Production_Order__Ending_Date_Caption; FieldCaption("Ending Date-Time"))
            {
            }
            column(Production_Order__Due_Date_Caption; FieldCaption("Due Date"))
            {
            }
            column(Production_Order_StatusCaption; FieldCaption(Status))
            {
            }
            dataitem("Prod. Order Line"; "Prod. Order Line")
            {
                DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("No.");
                DataItemTableView = SORTING(Status, "Prod. Order No.", "Line No.");
                column(Prod__Order_Line__Line_No__; "Line No.")
                {
                }
                column(Prod__Order_Line__Item_No__; "Item No.")
                {
                }
                column(Prod__Order_Line_Description; Description)
                {
                }
                column(Prod__Order_Line_Quantity; Quantity)
                {
                }
                column(Prod__Order_Line__Finished_Quantity_; "Finished Quantity")
                {
                }
                column(Prod__Order_Line__Remaining_Quantity_; "Remaining Quantity")
                {
                }
                column(Prod__Order_Line__Indirect_Cost___; "Indirect Cost %")
                {
                }
                column(Prod__Order_Line__Overhead_Rate_; "Overhead Rate")
                {
                }
                column(Prod__Order_Line__Line_No__Caption; FieldCaption("Line No."))
                {
                }
                column(Prod__Order_Line__Item_No__Caption; FieldCaption("Item No."))
                {
                }
                column(Prod__Order_Line_DescriptionCaption; FieldCaption(Description))
                {
                }
                column(Prod__Order_Line_QuantityCaption; FieldCaption(Quantity))
                {
                }
                column(Prod__Order_Line__Finished_Quantity_Caption; FieldCaption("Finished Quantity"))
                {
                }
                column(Prod__Order_Line__Remaining_Quantity_Caption; FieldCaption("Remaining Quantity"))
                {
                }
                column(Prod__Order_Line__Indirect_Cost___Caption; FieldCaption("Indirect Cost %"))
                {
                }
                column(Prod__Order_Line__Overhead_Rate_Caption; FieldCaption("Overhead Rate"))
                {
                }
                column(Prod__Order_Line_Status; Status)
                {
                }
                column(Prod__Order_Line_Prod__Order_No_; "Prod. Order No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ExpectedQty := 0;
                    ActualQty := 0;

                    ExpectedQty := "Prod. Order Line".Quantity;
                    ActualQty := "Prod. Order Line"."Finished Quantity";

                    IndirectCostPct := "Indirect Cost %";
                    OHRate := "Overhead Rate";
                end;
            }
            dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
            {
                DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("No.");
                DataItemTableView = SORTING(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.");
                column(Prod__Order_Routing_Line__Operation_No__; "Operation No.")
                {
                }
                column(Prod__Order_Routing_Line_Type; Type)
                {
                }
                column(Prod__Order_Routing_Line__No__; "No.")
                {
                }
                column(Prod__Order_Routing_Line_Description; Description)
                {
                }
                column(Prod__Order_Routing_Line__Expected_Operation_Cost_Amt__; "Expected Operation Cost Amt.")
                {
                }
                column(Prod__Order_Routing_Line__Expected_Capacity_Need_; "Expected Capacity Need")
                {
                }
                column(Prod__Order_Routing_Line__Run_Time_; "Run Time")
                {
                }
                column(Prod__Order_Routing_Line__Setup_Time_; "Setup Time")
                {
                }
                column(Prod__Order_Routing_Line__Routing_Link_Code_; "Routing Link Code")
                {
                }
                column(Prod__Order_Routing_Line__Starting_Date_; "Starting Date")
                {
                }
                column(Prod__Order_Routing_Line__Overhead_Rate_; "Overhead Rate")
                {
                }
                column(Prod__Order_Routing_Line__Unit_Cost_per_; "Unit Cost per")
                {
                }
                column(ExpSubDirCost; ExpSubDirCost)
                {
                }
                column(ExpCapDirCost; ExpCapDirCost)
                {
                }
                column(ExpCapOHDirCost; ExpCapOHDirCost)
                {
                }
                column(ActLaborCost; ActLaborCost)
                {
                }
                column(ActLaborHrs; ActLaborHrs)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(ActSubCost; ActSubCost)
                {
                }
                column(ActCapOHDirCost; ActCapOHDirCost)
                {
                }
                column(Prod__Order_Routing_Line__Expected_Operation_Cost_Amt___Control1240070052; "Expected Operation Cost Amt.")
                {
                }
                column(Prod__Order_Routing_Line__Expected_Capacity_Need__Control1240070151; "Expected Capacity Need")
                {
                }
                column(ExpSubDirCost_Control1240070153; ExpSubDirCost)
                {
                }
                column(ExpSubDirCost_Control1240070154; ExpSubDirCost)
                {
                }
                column(Prod__Order_Routing_Line__Expected_Capacity_Need__Control1240070156; "Expected Capacity Need")
                {
                }
                column(ExpCapDirCost_Control1240070158; ExpCapDirCost)
                {
                }
                column(ExpCapOHDirCost_Control1240070160; ExpCapOHDirCost)
                {
                }
                column(ExpCapDirCost_Control1240070144; ExpCapDirCost)
                {
                }
                column(ExpCapOHDirCost_Control1240070131; ExpCapOHDirCost)
                {
                }
                column(Prod__Order_Routing_Line__Operation_No__Caption; FieldCaption("Operation No."))
                {
                }
                column(Prod__Order_Routing_Line_TypeCaption; FieldCaption(Type))
                {
                }
                column(Prod__Order_Routing_Line__No__Caption; FieldCaption("No."))
                {
                }
                column(Prod__Order_Routing_Line_DescriptionCaption; FieldCaption(Description))
                {
                }
                column(Prod__Order_Routing_Line__Expected_Operation_Cost_Amt__Caption; Prod__Order_Routing_Line__Expected_Operation_Cost_Amt__CaptionLbl)
                {
                }
                column(Prod__Order_Routing_Line__Expected_Capacity_Need_Caption; FieldCaption("Expected Capacity Need"))
                {
                }
                column(Prod__Order_Routing_Line__Run_Time_Caption; FieldCaption("Run Time"))
                {
                }
                column(Prod__Order_Routing_Line__Setup_Time_Caption; FieldCaption("Setup Time"))
                {
                }
                column(Prod__Order_Routing_Line__Routing_Link_Code_Caption; FieldCaption("Routing Link Code"))
                {
                }
                column(Prod__Order_Routing_Line__Starting_Date_Caption; FieldCaption("Starting Date"))
                {
                }
                column(Expected_Capacity_OHCaption; Expected_Capacity_OHCaptionLbl)
                {
                }
                column(Prod__Order_Routing_Line__Overhead_Rate_Caption; FieldCaption("Overhead Rate"))
                {
                }
                column(Prod__Order_Routing_Line__Unit_Cost_per_Caption; FieldCaption("Unit Cost per"))
                {
                }
                column(Expected_Sub_Contractor_CostCaption; Expected_Sub_Contractor_CostCaptionLbl)
                {
                }
                column(Expected_CapacityCaption; Expected_CapacityCaptionLbl)
                {
                }
                column(ExpectedCaption; ExpectedCaptionLbl)
                {
                }
                column(Capacity_CostCaption; Capacity_CostCaptionLbl)
                {
                }
                column(SubcontractCaption; SubcontractCaptionLbl)
                {
                }
                column(Capacity_OHCaption; Capacity_OHCaptionLbl)
                {
                }
                column(ActualCaption; ActualCaptionLbl)
                {
                }
                column(TimeCaption; TimeCaptionLbl)
                {
                }
                column(ExpectedCaption_Control1240070100; ExpectedCaption_Control1240070100Lbl)
                {
                }
                column(Prod__Order_Routing_Line_Status; Status)
                {
                }
                column(Prod__Order_Routing_Line_Prod__Order_No_; "Prod. Order No.")
                {
                }
                column(Prod__Order_Routing_Line_Routing_Reference_No_; "Routing Reference No.")
                {
                }
                column(Prod__Order_Routing_Line_Routing_No_; "Routing No.")
                {
                }
                dataitem("Capacity Ledger Entry"; "Capacity Ledger Entry")
                {
                    DataItemLink = "Order No." = FIELD("Prod. Order No."), "Operation No." = FIELD("Operation No.");
                    DataItemTableView = SORTING("Document No.", "Posting Date") WHERE("Order Type" = CONST(Production));
                    column(Capacity_Ledger_Entry__No__; "No.")
                    {
                    }
                    column(Capacity_Ledger_Entry__Posting_Date_; "Posting Date")
                    {
                    }
                    column(Capacity_Ledger_Entry_Type; Type)
                    {
                    }
                    column(Capacity_Ledger_Entry__Document_No__; "Document No.")
                    {
                    }
                    column(Capacity_Ledger_Entry_Description; Description)
                    {
                    }
                    column(Capacity_Ledger_Entry__Operation_No__; "Operation No.")
                    {
                    }
                    column(Capacity_Ledger_Entry_Quantity; Quantity)
                    {
                    }
                    column(Capacity_Ledger_Entry__Setup_Time_; "Setup Time")
                    {
                    }
                    column(Capacity_Ledger_Entry__Run_Time_; "Run Time")
                    {
                    }
                    column(Capacity_Ledger_Entry__Direct_Cost_; "Direct Cost")
                    {
                    }
                    column(Capacity_Ledger_Entry__Output_Quantity_; "Output Quantity")
                    {
                    }
                    column(Capacity_Ledger_Entry_Subcontracting; Subcontracting)
                    {
                    }
                    column(Capacity_Ledger_Entry__Overhead_Cost_; "Overhead Cost")
                    {
                    }
                    column(Capacity_Ledger_Entry__Direct_Cost__Control1240070048; "Direct Cost")
                    {
                    }
                    column(Capacity_Ledger_Entry_Quantity_Control1240070107; Quantity)
                    {
                    }
                    column(Capacity_Ledger_Entry__Overhead_Cost__Control1240070075; "Overhead Cost")
                    {
                    }
                    column(Capacity_Ledger_Entry__No__Caption; FieldCaption("No."))
                    {
                    }
                    column(Capacity_Ledger_Entry__Posting_Date_Caption; FieldCaption("Posting Date"))
                    {
                    }
                    column(Capacity_Ledger_Entry_TypeCaption; FieldCaption(Type))
                    {
                    }
                    column(Capacity_Ledger_Entry__Document_No__Caption; FieldCaption("Document No."))
                    {
                    }
                    column(Capacity_Ledger_Entry_DescriptionCaption; FieldCaption(Description))
                    {
                    }
                    column(Capacity_Ledger_Entry__Operation_No__Caption; FieldCaption("Operation No."))
                    {
                    }
                    column(Capacity_Ledger_Entry_QuantityCaption; FieldCaption(Quantity))
                    {
                    }
                    column(Capacity_Ledger_Entry__Setup_Time_Caption; FieldCaption("Setup Time"))
                    {
                    }
                    column(Capacity_Ledger_Entry__Run_Time_Caption; FieldCaption("Run Time"))
                    {
                    }
                    column(Capacity_Ledger_Entry__Direct_Cost_Caption; FieldCaption("Direct Cost"))
                    {
                    }
                    column(Capacity_Ledger_Entry__Output_Quantity_Caption; FieldCaption("Output Quantity"))
                    {
                    }
                    column(Capacity_Ledger_Entry_SubcontractingCaption; Capacity_Ledger_Entry_SubcontractingCaptionLbl)
                    {
                    }
                    column(Capacity_Ledger_Entry__Overhead_Cost_Caption; FieldCaption("Overhead Cost"))
                    {
                    }
                    column(ActualCaption_Control1240070099; ActualCaption_Control1240070099Lbl)
                    {
                    }
                    column(Sub_TotalCaption; Sub_TotalCaptionLbl)
                    {
                    }
                    column(Capacity_Ledger_Entry_Entry_No_; "Entry No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        loop := loop + 1;

                        if not "Capacity Ledger Entry".Subcontracting then
                            ActLaborCost := ActLaborCost + "Direct Cost" else
                            ActSubCost := ActSubCost + "Direct Cost";

                        if not "Capacity Ledger Entry".Subcontracting then
                            ActLaborHrs := ActLaborHrs + Quantity;

                        ActCapOHDirCost := ActCapOHDirCost + "Overhead Cost";

                        if loop > 1 then begin
                            "Prod. Order Routing Line"."Expected Capacity Need" := 0;
                            "Prod. Order Routing Line"."Expected Operation Cost Amt." := 0;
                            ExpCapDirCost := 0;
                            ExpSubDirCost := 0;
                            ExpCapOHDirCost := 0;

                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        loop := 0;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    ExpSubDirCost := 0;
                    ExpCapDirCost := 0;
                    ExpCapOHDirCost := 0;

                    ExpCapOHDirCost := "Expected Capacity Ovhd. Cost";     //pulls Navi OH into a Variable.

                    //Now compare for Subcontract Work Center.
                    if "Prod. Order Routing Line".Type = "Prod. Order Routing Line".Type::"Work Center" then begin
                        if WorkCenter.Get("Prod. Order Routing Line"."No.") then
                            if WorkCenter."Subcontractor No." <> '' then
                                ExpSubDirCost := "Prod. Order Routing Line"."Expected Operation Cost Amt."
                            else
                                ExpCapDirCost := "Expected Operation Cost Amt." - "Expected Capacity Ovhd. Cost";
                    end else
                        ExpCapDirCost := "Expected Operation Cost Amt." - "Expected Capacity Ovhd. Cost";


                    //oli
                    ExpOperCostAmt_VS += "Expected Operation Cost Amt.";
                end;

                trigger OnPostDataItem()
                begin
                    InRouting := false;
                end;

                trigger OnPreDataItem()
                begin
                    // CurrReport.CreateTotals("Expected Operation Cost Amt.","Expected Capacity Ovhd. Cost");
                    // CurrReport.CreateTotals(ExpSubDirCost,ExpCapDirCost,ExpCapOHDirCost);

                    InRouting := true;

                    //oli
                    loop := 0;
                end;
            }
            dataitem("Prod. Order Component"; "Prod. Order Component")
            {
                DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("No.");
                DataItemTableView = SORTING(Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.");
                column(Prod__Order_Component__Item_No__; "Item No.")
                {
                }
                column(Prod__Order_Component_Description; Description)
                {
                }
                column(Prod__Order_Component__Routing_Link_Code_; "Routing Link Code")
                {
                }
                column(Prod__Order_Component__Expected_Quantity_; "Expected Quantity")
                {
                }
                column(Prod__Order_Component__Cost_Amount_; "Cost Amount")
                {
                }
                column(Prod__Order_Component__Unit_Cost_; "Unit Cost")
                {
                }
                column(Prod__Order_Component__Flushing_Method_; "Flushing Method")
                {
                }
                column(Prod__Order_Component__Cost_Amount__Control48; "Cost Amount")
                {
                }
                column(Prod__Order_Component__Item_No__Caption; FieldCaption("Item No."))
                {
                }
                column(Prod__Order_Component_DescriptionCaption; FieldCaption(Description))
                {
                }
                column(Prod__Order_Component__Routing_Link_Code_Caption; FieldCaption("Routing Link Code"))
                {
                }
                column(Prod__Order_Component__Expected_Quantity_Caption; FieldCaption("Expected Quantity"))
                {
                }
                column(Expected_Cost_AmountCaption; Expected_Cost_AmountCaptionLbl)
                {
                }
                column(Prod__Order_Component__Unit_Cost_Caption; FieldCaption("Unit Cost"))
                {
                }
                column(Prod__Order_Component__Flushing_Method_Caption; FieldCaption("Flushing Method"))
                {
                }
                column(Expected_ItemsCaption; Expected_ItemsCaptionLbl)
                {
                }
                column(Total_Expected_Material_CostCaption; Total_Expected_Material_CostCaptionLbl)
                {
                }
                column(Prod__Order_Component_Status; Status)
                {
                }
                column(Prod__Order_Component_Prod__Order_No_; "Prod. Order No.")
                {
                }
                column(Prod__Order_Component_Prod__Order_Line_No_; "Prod. Order Line No.")
                {
                }
                column(Prod__Order_Component_Line_No_; "Line No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CostAmt_VS += "Cost Amount";
                    ExpectedMaterials := "Cost Amount";
                end;

                trigger OnPostDataItem()
                begin
                    InBOM := false;
                end;

                trigger OnPreDataItem()
                begin
                    // CurrReport.CreateTotals("Cost Amount");

                    InBOM := true;
                end;
            }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Order No." = FIELD("No.");
                DataItemTableView = SORTING("Order Type", "Order No.", "Order Line No.", "Entry Type", "Prod. Order Comp. Line No.") WHERE("Entry Type" = CONST(Consumption));
                column(Item_Ledger_Entry__Item_No__; "Item No.")
                {
                }
                column(Item_Ledger_Entry__Posting_Date_; "Posting Date")
                {
                }
                column(Item_Ledger_Entry__Entry_Type_; "Entry Type")
                {
                }
                column(Item_Ledger_Entry__Source_No__; "Source No.")
                {
                }
                column(Item_Ledger_Entry__Document_No__; "Document No.")
                {
                }
                column(Item_Ledger_Entry_Quantity; Quantity)
                {
                }
                column(Item_Ledger_Entry__Cost_Amount__Actual__; "Cost Amount (Actual)")
                {
                }
                column(ItemT_Description; ItemT.Description)
                {
                }
                column(CostAmt_VS; CostAmt_VS)
                {
                }
                column(MaterialVariance; -MaterialVariance)
                {
                }
                column(Item_Ledger_Entry__Cost_Amount__Actual___Control1240070067; "Cost Amount (Actual)")
                {
                }
                column(Item_Ledger_Entry__Item_No__Caption; FieldCaption("Item No."))
                {
                }
                column(Item_Ledger_Entry__Posting_Date_Caption; FieldCaption("Posting Date"))
                {
                }
                column(Item_Ledger_Entry__Entry_Type_Caption; FieldCaption("Entry Type"))
                {
                }
                column(Item_Ledger_Entry__Source_No__Caption; FieldCaption("Source No."))
                {
                }
                column(Item_Ledger_Entry__Document_No__Caption; FieldCaption("Document No."))
                {
                }
                column(DescriptionCaption; DescriptionCaptionLbl)
                {
                }
                column(Item_Ledger_Entry_QuantityCaption; FieldCaption(Quantity))
                {
                }
                column(Item_Ledger_Entry__Cost_Amount__Actual__Caption; FieldCaption("Cost Amount (Actual)"))
                {
                }
                column(ActualCaption_Control1240070083; ActualCaption_Control1240070083Lbl)
                {
                }
                column(Total_Actual_Material_CostCaption; Total_Actual_Material_CostCaptionLbl)
                {
                }
                column(Item_Ledger_Entry_Entry_No_; "Entry No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ItemT.Get("Item No.");
                    MaterialVariance := ExpectedMaterials + "Cost Amount (Actual)";
                end;
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number);
                MaxIteration = 1;
                column(Prod__Order_Routing_Line___Expected_Operation_Cost_Amt__; "Prod. Order Routing Line"."Expected Operation Cost Amt.")
                {
                }
                column(Prod__Order_Component___Cost_Amount_; "Prod. Order Component"."Cost Amount")
                {
                }
                column(Prod__Order_Component___Cost_Amount_____Prod__Order_Routing_Line___Expected_Operation_Cost_Amt__; "Prod. Order Component"."Cost Amount" + "Prod. Order Routing Line"."Expected Operation Cost Amt.")
                {
                    AutoFormatType = 1;
                }
                column(ActMatrlCost; -ActMatrlCost)
                {
                }
                column(ActualEach; ActualEach)
                {
                }
                column(ExpectedQty; ExpectedQty)
                {
                }
                column(ActualQty; ActualQty)
                {
                }
                column(ExpMfgOH; ExpMfgOH)
                {
                }
                column(ActLaborCost_Control1240070120; ActLaborCost)
                {
                }
                column(ActLaborHrs_Control1240070125; ActLaborHrs)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(ActProdOrderEach; ActProdOrderEach)
                {
                }
                column(ExpProdOrderEach; ExpProdOrderEach)
                {
                }
                column(ActSubCost_Control1240070133; ActSubCost)
                {
                }
                column(ExpectedEach; ExpectedEach)
                {
                }
                column(IndirectCostPct; IndirectCostPct)
                {
                }
                column(OHRate; OHRate)
                {
                }
                column(ExpSubDirCost_Control1240070129; ExpSubDirCost)
                {
                }
                column(ExpCapDirCost_Control1240070106; ExpCapDirCost)
                {
                }
                column(ExpCapOHDirCost_Control1240070146; ExpCapOHDirCost)
                {
                }
                column(TotalExpectedCost; TotalExpectedCost)
                {
                }
                column(Prod__Order_Component___Cost_Amount_____Prod__Order_Routing_Line___Expected_Operation_Cost_Amt___Control1240070152; "Prod. Order Component"."Cost Amount" + "Prod. Order Routing Line"."Expected Operation Cost Amt.")
                {
                    AutoFormatType = 1;
                }
                column(ActCapOHDirCost_Control1240070164; ActCapOHDirCost)
                {
                }
                column(STActCost; STActCost)
                {
                }
                column(ExpectedQty_Control1240070166; ExpectedQty)
                {
                }
                column(ActualQty_Control1240070167; ActualQty)
                {
                }
                column(OHRate_Control1240070168; OHRate)
                {
                }
                column(IndirectCostPct_Control1240070170; IndirectCostPct)
                {
                }
                column(STActCost_Control1240070172; STActCost)
                {
                }
                column(ActMfgOH; ActMfgOH)
                {
                }
                column(TotalActualCost; TotalActualCost)
                {
                }
                column(TotalExpectedCost___TotalActualCost; TotalExpectedCost - TotalActualCost)
                {
                }
                column(ExpProdOrderEach___ActProdOrderEach; ExpProdOrderEach - ActProdOrderEach)
                {
                }
                column(ExpOperCostAmt_VS; ExpOperCostAmt_VS)
                {
                }
                column(CostAmt_VS_Int; CostAmt_VS)
                {
                }
                column(QuantityCaption; QuantityCaptionLbl)
                {
                }
                column(Production_Order_Totals_Caption; Production_Order_Totals_CaptionLbl)
                {
                }
                column(ExpectedCaption_Control1240070113; ExpectedCaption_Control1240070113Lbl)
                {
                }
                column(Capacity_CostCaption_Control1240070121; Capacity_CostCaption_Control1240070121Lbl)
                {
                }
                column(SubcontractCaption_Control1240070122; SubcontractCaption_Control1240070122Lbl)
                {
                }
                column(Capacity_OHCaption_Control1240070123; Capacity_OHCaption_Control1240070123Lbl)
                {
                }
                column(MaterialsCaption; MaterialsCaptionLbl)
                {
                }
                column(Manufacturing_OHCaption; Manufacturing_OHCaptionLbl)
                {
                }
                column(XCaption; XCaptionLbl)
                {
                }
                column(EmptyStringCaption; EmptyStringCaptionLbl)
                {
                }
                column(Sub_TotalCaption_Control1240070076; Sub_TotalCaption_Control1240070076Lbl)
                {
                }
                column(Exp_Operation_CostCaption; Exp_Operation_CostCaptionLbl)
                {
                }
                column(SubTotal_ExpCaption; SubTotal_ExpCaptionLbl)
                {
                }
                column(EachCaption; EachCaptionLbl)
                {
                }
                column(IC__Caption; IC__CaptionLbl)
                {
                }
                column(OH_RateCaption; OH_RateCaptionLbl)
                {
                }
                column(Production_Order_TotalCaption; Production_Order_TotalCaptionLbl)
                {
                }
                column(EachCaption_Control1240070163; EachCaption_Control1240070163Lbl)
                {
                }
                column(EmptyStringCaption_Control1240070169; EmptyStringCaption_Control1240070169Lbl)
                {
                }
                column(XCaption_Control1240070171; XCaption_Control1240070171Lbl)
                {
                }
                column(SubTotal_ActCaption; SubTotal_ActCaptionLbl)
                {
                }
                column(Manufacturing_OHCaption_Control1240070074; Manufacturing_OHCaption_Control1240070074Lbl)
                {
                }
                column(Note__Actual_Cost_Values_are_improved_with_a_partial_FG_production_or_more_Caption; Note__Actual_Cost_Values_are_improved_with_a_partial_FG_production_or_more_CaptionLbl)
                {
                }
                column(Note__Avoid_using_FPPO_and_RPO_Number_the_same_as_the_FPO___Wrong_Ledgers_may_get_picked_up__Caption; Note__Avoid_using_FPPO_and_RPO_Number_the_same_as_the_FPO___Wrong_Ledgers_may_get_picked_up__CaptionLbl)
                {
                }
                column(Act_HrsCaption; Act_HrsCaptionLbl)
                {
                }
                column(ActualCaption_Control1100768003; ActualCaption_Control1100768003Lbl)
                {
                }
                column(VarianceCaption; VarianceCaptionLbl)
                {
                }
                column(Integer_Number; Number)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //EXPECTED DATA BELOW

                    ExpectedEach := 0;
                    if ExpectedQty <> 0 then
                        ExpectedEach := ("Prod. Order Routing Line"."Expected Operation Cost Amt." +
                                          "Prod. Order Component"."Cost Amount") / ExpectedQty;

                    ExpMfgOH := ((ExpectedEach * IndirectCostPct / 100) + OHRate) * ExpectedQty;
                    TotalExpectedCost := "Prod. Order Component"."Cost Amount" + ExpCapDirCost + ExpSubDirCost + ExpCapOHDirCost + ExpMfgOH;

                    if ExpectedQty <> 0 then
                        ExpProdOrderEach := TotalExpectedCost / ExpectedQty;

                    //ACTUAL DATA BELOW

                    STActCost := -ActMatrlCost + ActLaborCost + ActSubCost + ActCapOHDirCost;

                    ActualEach := 0;
                    if ActualQty <> 0 then
                        ActualEach := STActCost / ActualQty;
                    ActMfgOH := ((ActualEach * IndirectCostPct / 100) + OHRate) * ActualQty;

                    TotalActualCost := STActCost + ActMfgOH;

                    if ActualQty <> 0 then
                        ActProdOrderEach := TotalActualCost / ActualQty;
                end;
            }

            trigger OnAfterGetRecord()
            begin

                ActLaborCost := 0;
                ActLaborHrs := 0;

                ActSubCost := 0;
                ActCapOHDirCost := 0;
            end;

            trigger OnPreDataItem()
            begin
                ProdOrderFilter := GetFilters;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintDetail; PrintDetail)
                    {
                        ApplicationArea = All;
                        Caption = 'Print Detail';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        PrintDetail := true; //MP8.0.10 Added
    end;

    trigger OnPreReport()
    begin
        CompanyInformation.Get;
        ReportID := CurrReport.ObjectId;
        ReportNum := REPORT::ProdOrderExpectActual_PQ;
    end;

    var
        CompanyInformation: Record "Company Information";
        ProdOrderFilter: Text[250];
        InRouting: Boolean;
        InBOM: Boolean;
        TotalCost: Decimal;
        ReportID: Text[50];
        ReportNum: Integer;
        ExpectedMaterials: Decimal;
        ActLaborCost: Decimal;
        ActSubCost: Decimal;
        ActLaborHrs: Decimal;
        ActMatrlCost: Decimal;
        LaborVariance: Decimal;
        MaterialVariance: Decimal;
        ProdOrdVariance: Decimal;
        ExpectedEach: Decimal;
        ActualEach: Decimal;
        ExpectedQty: Decimal;
        ActualQty: Decimal;
        ProdOrderT: Record "Production Order";
        ItemT: Record Item;
        IndirectCostPct: Decimal;
        OHRate: Decimal;
        ExpMfgOH: Decimal;
        ActMfgOH: Decimal;
        ExpCapDirCost: Decimal;
        ExpSubDirCost: Decimal;
        ExpCapOHDirCost: Decimal;
        ActCapOHDirCost: Decimal;
        WorkCenter: Record "Work Center";
        TotalExpectedCost: Decimal;
        TotalActualCost: Decimal;
        ExpProdOrderEach: Decimal;
        ActProdOrderEach: Decimal;
        STActCost: Decimal;
        loop: Integer;
        CostAmt_VS: Decimal;
        ExpOperCostAmt_VS: Decimal;
        Production_Order___Expected_and_Actual_Cost_DetailsCaptionLbl: Label 'Production Order - Expected and Actual Cost Details';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Prod__Order_Routing_Line__Expected_Operation_Cost_Amt__CaptionLbl: Label 'Expected Operation Cost';
        Expected_Capacity_OHCaptionLbl: Label 'Expected Cap OH';
        Expected_Sub_Contractor_CostCaptionLbl: Label 'Expected Sub Cost';
        Expected_CapacityCaptionLbl: Label 'Expected Capacity';
        ExpectedCaptionLbl: Label 'Expected';
        Capacity_CostCaptionLbl: Label 'Capacity Cost';
        SubcontractCaptionLbl: Label 'Subcontract';
        Capacity_OHCaptionLbl: Label 'Capacity OH';
        ActualCaptionLbl: Label 'Actual';
        TimeCaptionLbl: Label 'Time';
        ExpectedCaption_Control1240070100Lbl: Label 'Expected';
        Capacity_Ledger_Entry_SubcontractingCaptionLbl: Label 'Subcontracting';
        ActualCaption_Control1240070099Lbl: Label 'Actual';
        Sub_TotalCaptionLbl: Label 'Sub Total';
        Expected_Cost_AmountCaptionLbl: Label 'Expected Cost Amount';
        Expected_ItemsCaptionLbl: Label 'Expected Items';
        Total_Expected_Material_CostCaptionLbl: Label 'Total Expected Material Cost';
        DescriptionCaptionLbl: Label 'Description';
        ActualCaption_Control1240070083Lbl: Label 'Actual';
        Total_Actual_Material_CostCaptionLbl: Label 'Total Actual Material Cost';
        QuantityCaptionLbl: Label 'Quantity';
        Production_Order_Totals_CaptionLbl: Label 'Production Order Totals:';
        ExpectedCaption_Control1240070113Lbl: Label 'Expected';
        Capacity_CostCaption_Control1240070121Lbl: Label 'Capacity Cost';
        SubcontractCaption_Control1240070122Lbl: Label 'Subcontract';
        Capacity_OHCaption_Control1240070123Lbl: Label 'Capacity OH';
        MaterialsCaptionLbl: Label 'Materials';
        Manufacturing_OHCaptionLbl: Label 'Manufacturing OH';
        XCaptionLbl: Label 'X';
        EmptyStringCaptionLbl: Label '+';
        Sub_TotalCaption_Control1240070076Lbl: Label 'Sub-Total';
        Exp_Operation_CostCaptionLbl: Label 'Exp Operation Cost';
        SubTotal_ExpCaptionLbl: Label 'SubTotal Exp';
        EachCaptionLbl: Label 'Each';
        IC__CaptionLbl: Label 'IC %';
        OH_RateCaptionLbl: Label 'OH Rate';
        Production_Order_TotalCaptionLbl: Label 'Production Order Total';
        EachCaption_Control1240070163Lbl: Label 'Each';
        EmptyStringCaption_Control1240070169Lbl: Label '+';
        XCaption_Control1240070171Lbl: Label 'X';
        SubTotal_ActCaptionLbl: Label 'SubTotal Act';
        Manufacturing_OHCaption_Control1240070074Lbl: Label 'Manufacturing OH';
        Note__Actual_Cost_Values_are_improved_with_a_partial_FG_production_or_more_CaptionLbl: Label 'Note: Actual Cost Values are improved with a partial FG production or more.';
        Note__Avoid_using_FPPO_and_RPO_Number_the_same_as_the_FPO___Wrong_Ledgers_may_get_picked_up__CaptionLbl: Label 'Note: Avoid using FPPO and RPO Number the same as the FPO. (Wrong Ledgers may get picked up.)';
        Act_HrsCaptionLbl: Label 'Act Time';
        ActualCaption_Control1100768003Lbl: Label 'Actual';
        VarianceCaptionLbl: Label 'Variance';
        PrintDetail: Boolean;
}

