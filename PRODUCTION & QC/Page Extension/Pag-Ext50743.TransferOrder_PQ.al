pageextension 50743 TransferOrder_PQ extends "Transfer Order"
{
    layout
    {
        // Add changes to page layout here

        modify("Foreign Trade")
        {
            Visible = false;
        }
        modify(Shipment)
        {
            Visible = false;
        }

        modify(Control19)
        {
            Visible = false;
        }

        modify("Transfer-from")
        {
            Visible = false;
        }
        modify("Transfer-to")
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        modify("Re&lease")
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                //getCalRemainQty();
            end;
        }
    }

    local procedure getCalRemainQty()
    var
        transferLine: Record "Transfer Line";
    begin
        Clear(transferLine);
        transferLine.reset();
        transferLine.SetRange("Document No.", Rec."No.");
        if transferLine.FindSet() then begin
            transferLine.CalcSums("Remaining Qty.");
            if transferLine."Remaining Qty." <> 0 then
                Error('Error, Please check remaing qty on TO Lines, must be 0.');
        end;
    end;

    var
    //myInt: Integer;
}