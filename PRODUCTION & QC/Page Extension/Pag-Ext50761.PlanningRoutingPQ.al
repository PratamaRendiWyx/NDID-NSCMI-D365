namespace PRODUCTIONQC.PRODUCTIONQC;

using Microsoft.Manufacturing.Routing;

pageextension 50761 PlanningRouting_PQ extends "Planning Routing"
{
    layout
    {
        modify("Starting Date-Time")
        {
            Caption = 'Starting Date-Time (Estimation)';
        }
        modify("Ending Date-Time")
        {
            Caption = 'Ending Date-Time (Estimation)';
        }
    }
}
