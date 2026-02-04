pageextension 50353 "Posted Return Shipment_SP" extends "Posted Return Shipment"
{
    actions
    {
        addafter("&Print")
        {
            action("&Print2")
            {
                ApplicationArea = All;
                Caption = '&Surat Jalan (Posted)';
                Ellipsis = true;
                Image = Print;
                ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    ReturnShipmentHeader: Record "Return Shipment Header";
                    ReportLayoutSelection: Record "Report Layout Selection";
                begin
                    CurrPage.SetSelectionFilter(ReturnShipmentHeader);
                    REPORT.Run(REPORT::"Surat Jalan (Return Ship) New", true, false, ReturnShipmentHeader);
                end;
            }
        }
    }
}
