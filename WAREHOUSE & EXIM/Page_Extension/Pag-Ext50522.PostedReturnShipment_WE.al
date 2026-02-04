pageextension 50522 PostedReturnShipment_WE extends "Posted Return Shipment"
{
    layout
    {
        addafter("Posting Date")
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
                Enabled = false;
            }
            field("Checked By"; Rec."Checked By")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Checked By Name"; Rec."Checked By Name")
            {
                ApplicationArea = All;
                Enabled = false;
            }
            field("Warehouse Person"; Rec."Warehouse Person")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Warehouse Person Name"; Rec."Warehouse Person Name")
            {
                ApplicationArea = All;
                Enabled = false;
            }
            field("Additional Notes"; Rec."Additional Notes")
            {
                ApplicationArea = All;
                Editable = false;
                MultiLine = true;
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
                ApplicationArea = All;
                Caption = '&Surat Jalan (Posted)';
                Ellipsis = true;
                Visible = false;
                Image = Print;
                ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    ReturnShipmentHeader: Record "Return Shipment Header";
                    ReportLayoutSelection: Record "Report Layout Selection";
                begin
                    CurrPage.SetSelectionFilter(ReturnShipmentHeader);
                    REPORT.Run(REPORT::"Surat Jalan (Return Ship)", true, false, ReturnShipmentHeader);
                end;
            }
        }
    }
}
