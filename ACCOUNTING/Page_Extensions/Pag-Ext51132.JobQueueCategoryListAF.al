pageextension 51132 "Job Queue Category List_AF" extends "Job Queue Category List"
{
    layout
    {
        addafter(Description)
        {
            field(Parameters; Rec.Parameters)
            {
                ApplicationArea = All;
            }
        }
    }
}
