namespace PRODUCTIONQC.PRODUCTIONQC;

using Microsoft.Manufacturing.Setup;

pageextension 50760 ManufacturingSetup_PQ extends "Manufacturing Setup"
{
    layout
    {
        addafter("Show Capacity In")
        {
            field("Buffer Qty. Transfer"; Rec."Buffer Qty. Transfer")
            {
                ApplicationArea = All;
            }
            field("Buffer Qty. Planning Worksheet"; Rec."Buffer Qty. Planning Worksheet")
            {
                ApplicationArea = All;
            }
            field("Use Diff Tolerance"; Rec."Use Diff Tolerance")
            {
                Caption = 'Use Diff. Tolerance';
                ApplicationArea = All;
                trigger OnValidate()
                var
                    myInt: Integer;
                begin
                    if Not Rec."Use Diff Tolerance" then begin
                        Rec."Diff. Tolerance" := 0;
                    end;
                end;
            }
            field("Diff. Tolerance"; Rec."Diff. Tolerance")
            {
                DecimalPlaces = 0 : 5;
                ApplicationArea = All;
                Editable = Rec."Use Diff Tolerance";
                Caption = 'Diff. Tolerance Consumption';
            }
            field("Default Source Location Comp."; Rec."Default Source Location Comp.")
            {
                ApplicationArea = All;
            }
            field("Default Flushing Method Comp."; Rec."Default Flushing Method Comp.")
            {
                ApplicationArea = All;
            }
            field("Finish Goods Location"; Rec."Finish Goods Location")
            {
                ApplicationArea = All;
            }
            field("Validation Check Finish Order"; Rec."Validation Check Finish Order")
            {
                ApplicationArea = All;
            }
        }
    }
}
