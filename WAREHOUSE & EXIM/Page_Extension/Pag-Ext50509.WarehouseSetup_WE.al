pageextension 50509 WarehouseSetup_WE extends "Warehouse Setup"
{
    layout
    {
        addafter("Whse. Internal Pick Nos.")
        {
            field("Packing Nos."; Rec."Packing Nos.")
            {
                ApplicationArea = All;
            }
            field("Ship Mark Nos."; Rec."Ship Mark Nos.")
            {
                ApplicationArea = All;
            }
        }
    }
}
