tableextension 50702 Customer_PQ extends Customer
{

    fields
    {
        field(50700; "Has Quality Specifications"; Boolean)
        {
            CalcFormula = Exist(QCSpecificationHeader_PQ WHERE("Customer No." = FIELD("No.")));
            Caption = 'Has Quality Specifications';
            Description = 'Triggered when Cust. No. is entered on a item spec';
            Editable = false;
            FieldClass = FlowField;
        }
    }


}

