tableextension 50517 "Phys. Invt. Record Header_WE" extends "Phys. Invt. Record Header"
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
