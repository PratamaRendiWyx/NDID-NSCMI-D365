tableextension 50518 "Phys. Invt. Tracking_WE" extends "Phys. Invt. Tracking"
{
    fields
    {
        field(50518; "Lot No. 1"; Code[50])
        {
            Caption = 'Lot No.';
            OptimizeForTextSearch = true;
            DataClassification = ToBeClassified;
        }
        field(50302; "USDFS Code"; Text[100])
        {
            // AllowInCustomizations = Always;
            Editable = false;
        }
        field(50303; "Package No."; Code[50])
        {
            Caption = 'Package No.';
            CaptionClass = '6,1';
        }
    }
}
