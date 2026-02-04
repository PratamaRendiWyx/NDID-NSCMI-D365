tableextension 50516 "Phys. Invt. Order Header_WE" extends "Phys. Invt. Order Header"
{
    fields
    {
        field(50500; "Person Responsible Name"; Code[250])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."Search Name" where("No." = field("Person Responsible")));
        }
    }
}
