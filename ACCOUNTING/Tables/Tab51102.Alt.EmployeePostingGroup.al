/*table 51102 "Alt. Employee Posting Group"
{
    Caption = 'Alternative Employee Posting Group';
    ReplicateData = true;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Employee Posting Group"; Code[20])
        {
            Caption = 'Employee Posting Group';
            TableRelation = "Employee Posting Group";
        }
        field(2; "Alt. Employee Posting Group"; Code[20])
        {
            Caption = 'Alternative Employee Posting Group';
            TableRelation = "Employee Posting Group";

            trigger OnValidate()
            begin
                if "Employee Posting Group" = "Alt. Employee Posting Group" then
                    Error(PostingGroupReplaceErr);
            end;
        }
    }

    keys
    {
        key(Key1; "Employee Posting Group", "Alt. Employee Posting Group")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        PostingGroupReplaceErr: Label 'Posting Group cannot replace itself.';
}
*/
