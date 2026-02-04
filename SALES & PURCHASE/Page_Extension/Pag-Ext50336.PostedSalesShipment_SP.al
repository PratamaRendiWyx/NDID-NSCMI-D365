pageextension 50336 "Posted Sales Shipment_SP" extends "Posted Sales Shipment"
{
    layout
    {
        addafter("External Document No.")
        {
            //Additional information 
            field("Prepared By"; Rec."Prepared By")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Prepared By Name"; Rec."Prepared By Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Checked By"; Rec."Checked By")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Checked By Name"; Rec."Checked By Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Warehouse Person"; Rec."Warehouse Person")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Warehouse Person Name"; Rec."Warehouse Person Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Trucking No."; Rec."Trucking No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            //-
        }
    }
    actions
    {
        addafter("&Print")
        {
            action("&Print1")
            {
                ApplicationArea = Suite;
                Caption = '&Surat Jalan (Posted)';
                Ellipsis = true;
                Image = Print;
                ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    salesShipmentHeader: Record "Sales Shipment Header";
                    ReportLayoutSelection: Record "Report Layout Selection";
                begin
                    CurrPage.SetSelectionFilter(salesShipmentHeader);
                    REPORT.Run(REPORT::"Surat Jalan (Posted)", true, false, salesShipmentHeader);
                end;
            }
            action("&Print3")
            {
                ApplicationArea = Suite;
                Caption = '&Surat Jalan (Scrap)';
                Ellipsis = true;
                Image = Print;
                ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    salesShipmentHeader: Record "Sales Shipment Header";
                    ReportLayoutSelection: Record "Report Layout Selection";
                begin
                    CurrPage.SetSelectionFilter(salesShipmentHeader);
                    REPORT.Run(REPORT::"Surat Jalan (Scrap)", true, false, salesShipmentHeader);
                end;
            }
            action("&Print2")
            {
                ApplicationArea = Suite;
                Caption = '&Delivery Packing (Posted)';
                Ellipsis = true;
                Image = Print;
                ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    salesShipmentHeader: Record "Sales Shipment Header";
                    ReportLayoutSelection: Record "Report Layout Selection";
                begin
                    CurrPage.SetSelectionFilter(salesShipmentHeader);
                    REPORT.Run(REPORT::"Delivery Packing List", true, false, salesShipmentHeader);
                end;
            }
            action("&Print4")
            {
                ApplicationArea = Suite;
                Caption = '&Print Shipping Mark (Posted)';
                Ellipsis = true;
                Image = Print;
                ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    salesShipmentHeader: Record "Sales Shipment Header";
                    ReportLayoutSelection: Record "Report Layout Selection";
                begin
                    CurrPage.SetSelectionFilter(salesShipmentHeader);
                    REPORT.Run(REPORT::"Print Shipping Mark", true, false, salesShipmentHeader);
                end;
            }
        }
    }


    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
    end;

    var
        warehouseMgnt: Codeunit "Warehouse Management";
}
