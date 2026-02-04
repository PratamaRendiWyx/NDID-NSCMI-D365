tableextension 50709 RoutingLine_PQ extends "Routing Line"
{
    fields
    {
        field(50700; "CCS Spec. Type ID"; Code[20])
        {
            Caption = 'Specification No.';
            DataClassification = CustomerContent;
            TableRelation = QCSpecificationHeader_PQ.Type where(Status = filter(Certified));

            trigger OnValidate()
            var
                WorkCenter: Record "Work Center";
            begin
                if WorkCenter.Get("No.") then begin
                    if WorkCenter."CCS Quality" = false then
                        Error(Err001, "No.");
                end;
            end;
        }
        field(50701; "Fix Run Time"; Boolean)
        {
            Caption = 'Fix Run Time';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                "Run Time" := 0;
            end;
        }
        field(50702; "Fix Time"; Decimal)
        {
        }
  
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                WorkCenter: Record "Work Center";
            begin
                if Type = Type::"Work Center" then begin
                    if WorkCenter.Get("No.") then begin
                        "CCS Spec. Type ID" := WorkCenter."CCS Spec. Type ID";
                    end;
                end;
            end;
        }
    }


    var
        Err001: Label 'You cannot assign a Quality Specification because Work Center %1 is not defined as Quality Work Center.';
}