table 50740 "Work Shift Vacum Cycle"
{
    Caption = 'Work Shift Vacum Cycle';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Shift Code"; Code[20])
        {
            Caption = 'Shift Code';
        }
        field(2; Cycle; Code[20])
        {
            Caption = 'Cycle';
        }
        field(3; "Starting Time"; Time)
        {
            Caption = 'Starting Time';
        }
        field(4; "Ending Time"; Time)
        {
            Caption = 'Ending Time';
        }
        field(5; "Default Run Time"; Decimal)
        {
            Caption = 'Default Run-Time';
        }
    }
    keys
    {
        key(PK; "Shift Code", Cycle)
        {
            Clustered = true;
        }
    }
}
