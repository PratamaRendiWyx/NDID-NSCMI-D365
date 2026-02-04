namespace ACCOUNTING.ACCOUNTING;

using Microsoft.HumanResources.Setup;
using Microsoft.Finance.ReceivablesPayables;
using System.Environment.Configuration;
using System.Telemetry;

tableextension 51107 HumanResourcesSetup_AF extends "Human Resources Setup"
{
    fields
    {
        // field(51101; "Allow Multiple Posting Groups"; Boolean)
        // {
        //     Caption = 'Allow Multiple Posting Groups';
        // }
        // field(51102; "Check Multiple Posting Groups"; enum "Posting Group Change Method")
        // {
        //     Caption = 'Check Multiple Posting Groups';
        //     DataClassification = SystemMetadata;
        // }
    }
}
