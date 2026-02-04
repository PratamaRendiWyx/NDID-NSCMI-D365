tableextension 50717 TrackingSpecification_PQ extends "Tracking Specification"
{
    fields
    {
        field(50700; "Test Status"; Option)
        {
            Caption = 'Test Status';
            OptionCaption = 'New,Ready for Testing,In-Process,Ready for Review,Certified,Certified Final,,,,,,,Rejected,Closed';
            OptionMembers = New,"Ready for Testing","In-Process","Ready for Review",Certified,"Certified Final",,,,,,,Rejected,Closed;

            FieldClass = FlowField;
            CalcFormula = lookup(QualityTestHeader_PQ."Test Status"
                            where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Lot No./Serial No." = field("Lot No.")));
            Editable = false;
        }
    }
}
