codeunit 50707 QualityHeadlineManager_PQ
{
    trigger OnRun()
    var
        HeadlineQualityManager: Record QualityHeadline_PQ;
    begin
        HeadlineQualityManager.GET;
        WORKDATE := HeadlineQualityManager."Workdate for computations";
        OnComputeHeadlines;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnComputeHeadlines()
    begin

    end;

}