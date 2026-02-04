tableextension 50323 UserSetup_SP extends "User Setup"
{
    fields
    {
        field(50300; "Is Approver COA"; Boolean)
        {
            Caption = 'Is Approver BOP';
            DataClassification = ToBeClassified;
        }
        field(50301; "QC Worker"; Boolean)
        {
            Caption = 'QC Worker';
            DataClassification = ToBeClassified;
        }
        field(50302; "Re-Open Shipment Line"; Boolean)
        {
            Caption = 'Can Re-Open Shipment Line (?)';
            DataClassification = ToBeClassified;
        }
    }
}
