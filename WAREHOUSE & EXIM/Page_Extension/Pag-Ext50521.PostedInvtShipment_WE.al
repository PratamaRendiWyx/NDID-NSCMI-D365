pageextension 50521 PostedInvtShipment_WE extends "Posted Invt. Shipment"
{
    layout
    {
        addafter("External Document No.")
        {
            //Additional information 
            field("Vendor No."; Rec."Vendor No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
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
            //-
            field(Remarks; Rec.Remarks)
            {
                ApplicationArea = All;
                Editable = false;
                MultiLine = true;
            }
        }
    }
    actions
    {
        addafter("&Print")
        {
            action(UpdateRemarksLine)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update Posted Document';
                Image = Edit;
                ToolTip = 'Update info Invt. Posted Shipment.';
                Scope = Repeater;

                trigger OnAction()
                var
                    invtShipmentHeader: Report "Upd Posted Invt Shipment WE";
                begin
                    if Rec."No." <> '' then begin
                        invtShipmentHeader.UseRequestPage(true);
                        invtShipmentHeader.setParam(Rec);
                        invtShipmentHeader.RunModal();
                        CurrPage.Update(false);
                    end;
                end;
            }
            action("&Print1")
            {
                ApplicationArea = All;
                Caption = '&Surat Jalan (Posted)';
                Ellipsis = true;
                Image = Print;
                ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    IntShipmentHeader: Record "Invt. Shipment Header";
                    ReportLayoutSelection: Record "Report Layout Selection";
                begin
                    CurrPage.SetSelectionFilter(IntShipmentHeader);
                    REPORT.Run(REPORT::"Surat Jalan (Invt. ship)", true, false, IntShipmentHeader);
                end;
            }
        }
    }
}
