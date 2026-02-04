tableextension 51105 FixedAsset_AF extends "Fixed Asset"
{
    fields
    {
        field(51100; "Asset Type"; Code[10])
        {
            Caption = 'Asset Type';
            TableRelation = "Asset Type".Code;
        }
        field(51101; "Asset Group"; Code[10])
        {
            Caption = 'Asset Group';
            TableRelation = "Asset Group".Code;
        }
        field(51102; "FA Location Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location.Name where(Code = field("FA Location Code")));
            Editable = false;
        }
        field(51103; "Responsible Employee Name"; Code[250])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."Search Name" where("No." = field("Responsible Employee")));
            Editable = false;
        }
        field(51104; "Expiration Calibration"; Date)
        {
            Caption = 'Expiration Calibration';
            AllowInCustomizations = Always;
        }
    }
}
