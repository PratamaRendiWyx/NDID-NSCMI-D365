pageextension 50703 CustomerCard_PQ extends "Customer Card" 
{

    layout
    {
        addafter(Reserve)
        {
            field("Has Quality Specifications";Rec."Has Quality Specifications")
            {
                ToolTip = 'Indicates if this Customer has specifications for Quality Control';
                ApplicationArea = All;
            }
        }
    }

}

