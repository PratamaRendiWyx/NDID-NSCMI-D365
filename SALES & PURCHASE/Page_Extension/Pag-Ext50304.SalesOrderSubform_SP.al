pageextension 50304 SalesOrderSubform_SP extends "Sales Order Subform"
{

    layout
    {
        addlast(Control1)
        {
            field("Planning Status"; Rec."Planning Status")
            {
                Enabled = FinishEnable;
                Visible = FinishEnable;
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the line planning status.';
            }
        }
        modify("No.")
        {
            trigger OnBeforeValidate()
            var
                myInt: Integer;
                Item: Record Item;
            begin
                if Rec.Type = Rec.Type::Item then begin
                    Clear(Item);
                    if Item.Get(Rec."No.") then begin
                        Rec."Part Name" := Item."Description 2";
                        Rec."Part Number" := Item."Common Item No.";
                    end;
                end;
            end;
        }
        addafter(Description)
        {
            field("Part Number"; Rec."Part Number")
            {
                ApplicationArea = All;
                // Editable = false;
            }
            field("Part Name"; Rec."Part Name")
            {
                ApplicationArea = All;
                // Editable = false;
            }
        }
    }

    trigger OnOpenPage()
    var
        EnableOrderCompletion: Codeunit EnableOrderCompletion_SP;
    begin
        FinishEnable := EnableOrderCompletion.FinishOrdersSalesEnabled();
    end;

    var
        FinishEnable: Boolean;
}