tableextension 50732 ManufacturingSetup_PQ extends "Manufacturing Setup"
{
    fields
    {
        field(50700; "Default Source Location Comp."; Code[20])
        {
            TableRelation = Location.Code;
            Caption = 'Default Source Location Comp.';
            DataClassification = ToBeClassified;
        }
        field(50701; "Always Create BOM Versions"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Always Create BOM with Versions';
        }
        field(50702; "Always Create Router Versions"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Always Create Routing with Versions';
        }
        field(50703; "Upd Plned Shpt Date on ReSched"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Update Planned Shipment Date on Reschedule';
        }
        field(50704; "Buffer Qty. Transfer"; Decimal)
        {
            Caption = 'Buffer Qty. Transfer (%)';
        }
        field(50705; "Default Flushing Method Comp."; enum "Flushing Method")
        {
            Caption = 'Default Flushing Method Comp.';
        }
        field(50706; "Finish Goods Location"; Code[30])
        {
            TableRelation = Location.Code;
        }
        field(50707; "Buffer Qty. Planning Worksheet"; Decimal)
        {
            Caption = 'Buffer Qty. Planning Worksheet (%)';
        }
        field(50708; "Validation Check Finish Order"; Boolean)
        {
            Caption = 'Validation Check Finish Order';
        }
        field(50709; "Diff. Tolerance"; Decimal)
        {

        }
        field(50710; "Use Diff Tolerance"; Boolean)
        {

        }

    }
}