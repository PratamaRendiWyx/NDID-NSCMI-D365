page 50720 QCPostedComplianceView_PQ
{
    // version QC13.00

    // QC80.1
    //   - Added Field "Test Line Complete"

    // QC13.00
    //  - Made Field "Test No." Drillable
    //      = Added Local Vars. and Code to OnDrillDown Trigger
    //      -   Changed Style to "StandardAccent" to suggest Drillability

    Caption = 'Quality Posted Compliance View';
    Editable = false;
    PageType = List;
    SourceTable = QCPostedCompliance_PQ;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Version Code"; Rec."Version Code")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Lot/Serial No."; Rec."Lot/Serial No.")
                {
                    ApplicationArea = All;
                }
                field("Test No."; Rec."Test No.")
                {
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    var
                        AMQCTestHeader: Record QualityTestHeader_PQ;
                        AMQCTestPage: Page QCLotTestHeader_PQ;
                    begin
                        //QC13.00 Start
                        Clear(AMQCTestPage);
                        AMQCTestPage.Editable(false);
                        AMQCTestHeader.SetRange("Test No.", Rec."Test No.");
                        AMQCTestPage.SetTableView(AMQCTestHeader);
                        AMQCTestPage.RunModal;
                        //QC13.00 Finish
                    end;
                }
                field("Quality Measure"; Rec."Quality Measure")
                {
                    ApplicationArea = All;
                }
                field("Result Type"; Rec."Result Type")
                {
                    ApplicationArea = All;
                }
                field("Measure Description"; Rec."Measure Description")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Lower Limit"; Rec."Lower Limit")
                {
                    ApplicationArea = All;
                }
                field("Upper Limit"; Rec."Upper Limit")
                {
                    ApplicationArea = All;
                }
                field("Nominal Value"; Rec."Nominal Value")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Actual Value"; Rec."Actual Value")
                {
                    ApplicationArea = All;
                }
                field(Result; Rec.Result)
                {
                    ApplicationArea = All;
                }
                field("Test Line Complete"; Rec."Test Line Complete")
                {
                    ApplicationArea = All;
                }
                field("Non Compliance"; Rec."Non Compliance")
                {
                    ApplicationArea = All;
                }
                field("Item Entry No."; Rec."Item Entry No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

