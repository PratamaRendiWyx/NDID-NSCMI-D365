page 50700 QualityControlSetup_PQ
{
    // version QC13.02

    // QC7.3
    //   - Added CONFIRM to "Create Security Role" Action
    //
    // //QC71.1 
    //   - Added Fields:
    //     - "Update [using] Actual Last Test Dates"
    //     - "Default Value for Ignore"
    //     - "Update [Last Test Date] on Certified"(Status)
    //     - "Update [Last Test Date] on Certified with Waiver"(Status)
    //     - "Update [Last Test Date] on Certified Final"(Status)
    //     - "Auto [create] Test Line Comments"
    //   - Added ToolTips on many Fields
    //
    // QC80 
    //   -Added Code to OnOpenPage to Initialize QC Status Rules
    //
    // QC80.4
    //   - Added Field "QCMgr Non Mand" (See QC Test Header Page, "Get Specification" Action)
    //
    // QC10.2  
    //   - Added Function "InitCues" and "WriteQCCue" to Create Role Center "Cue Setup" Records, and placed Call in OnOpenPage
    //
    // QC13.0
    //  - Removed Cue Setups for Fields 31, 42 anbd 43. Added Cue Setups for Fields 40 and 41
    //
    // QC13.92
    //  - Changed Version No. for AppSource Version

    Caption = 'Quality Control Setup';
    PageType = Card;
    SourceTable = QCSetup_PQ;
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("Quality Control")
            {
                Caption = 'Quality Control';
                Visible = false;
                field("Current Version"; VersionNoTxt)
                {
                    Caption = 'Current Version';
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Displays the Current Version';
                    ApplicationArea = All;
                }
            }
            group(General)
            {
                Caption = 'General';
                field("Autom. Create Quality Test"; Rec."Autom. Create Quality Test")
                {
                    ToolTip = 'When this box is checked, when items are received it will create a Quality Test.';
                    ApplicationArea = All;
                }
                field("Default QC Location"; Rec."Default QC Location")
                {
                    ToolTip = 'Sets the default location for QC if defined';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Auto Test Line Comments"; Rec."Auto Test Line Comments")
                {
                    ToolTip = 'When Checked, Test Line Comments are created automatically when certain fields are edited';
                    ApplicationArea = All;
                }
                field("Default Value for Ignore"; Rec."Default Value for Ignore")
                {
                    ToolTip = 'Default Value for the "Ignore" Field for newly-created Custom Test Lines';
                    ApplicationArea = All;
                }
                field("Update Actual Last Test Dates"; Rec."Update Actual Last Test Dates")
                {
                    ToolTip = 'When Checked, "Last Test Date" on Specification Lines will be Updated using the "Date Inspected" Field on the corresponding Test Line. Otherwise, the "Creation Date" for the Test (Header) will be used';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Update on Certified"; Rec."Update on Certified")
                {
                    ToolTip = 'When Checked, Specification Line "Last Test Date" will be Updated when Test (Header) is placed in the "Certified" Status';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Update on Cert with Waiver"; Rec."Update on Cert with Waiver")
                {
                    ToolTip = 'When Checked, Specification Line "Last Test Date" will be Updated when Test (Header) is placed in the "Certified with Waiver" Status';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Update on Certified Final"; Rec."Update on Certified Final")
                {
                    ToolTip = 'When Checked, Specification Line "Last Test Date" will be Updated when Test (Header) is placed in the "Certified Final" Status';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("QCMgr Non Mand"; Rec."QCMgr Non Mand")
                {
                    ToolTip = 'When this box is checked, only the Users identified as QCMgr will receive non-mandatory test results';
                    ApplicationArea = All;
                }
                field("Dont update Routing Status"; Rec."Dont update Routing Status")
                {
                    ToolTip = 'When this is checked, the Routing Status should never be changed by the Quality Test.';
                    ApplicationArea = All;
                }
                field("Create QT per Item Tracking"; Rec."Create QT per Item Tracking")
                {
                    ToolTip = 'Create Quality Test per Item Tracking.';
                    ApplicationArea = All;
                }
                field("Qty. to Test Editable"; Rec."Qty. to Test Editable")
                {
                    ApplicationArea = All;
                    ToolTip = 'When this box is checked, the Quantity to Test field is editable.';
                }
                field("Item Jnl Template for Scrap"; Rec."Item Jnl Template for Scrap")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Journal Template for Scrap field.';
                }
                field("Item Jnl Batch for Scrap"; Rec."Item Jnl Batch for Scrap")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Journal Batch for Scrap field.';
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transfer-to Code field.';
                }
            }
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Specification Type Nos."; Rec."Specification Type Nos.")
                {
                    Caption = 'Specification No. Series';
                    ToolTip = 'Specifies the series used when creating specifications from the routings for the production process.';
                    ApplicationArea = All;
                }
                field("QC Test No. Series"; Rec."QC Test No. Series")
                {
                    ToolTip = 'Specifies the Number Series for Quality Control Tests';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Setup")
            {
                Caption = '&Setup';
                action("Quality Measurements")
                {
                    Caption = 'Quality Measures';
                    Image = Design;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page QCControlMeasures_PQ;
                    ToolTip = 'Click to enter the Quality Measures';
                    ApplicationArea = All;
                }
                action("Quality &Methods")
                {
                    Caption = 'Quality &Methods';
                    Image = TaskQualityMeasure;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page QCControlMethods_PQ;
                    ToolTip = 'Click to enter the Quality Methods';
                    ApplicationArea = All;
                }
                action("Quality Categories")
                {
                    Caption = 'Categories';
                    Image = Category;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page SpecificationCategories_PQ;
                    ToolTip = 'Click to enter the Specifications Categories';
                    ApplicationArea = All;
                }

            }
            group("Actions")
            {
                Caption = 'Actions';
                action("Renumber Quality Specifications")
                {
                    Caption = 'Renumber Quality Specifications';
                    Image = NumberGroup;
                    Promoted = false;
                    ToolTip = 'Click to Renumber Quality Specifications';
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        QCSetup: Record QCSetup_PQ;
                        SpecificationHeaderTemp: Record QCSpecificationHeader_PQ temporary;
                        SpecificationHeader: Record QCSpecificationHeader_PQ;
                        SpecificationHeader2: Record QCSpecificationHeader_PQ;
                        SpecificationHeader3: Record QCSpecificationHeader_PQ;
                        NullValue: Code[10];
                        NewNo: Code[20];
                        NoSeriesMgt: Codeunit "No. Series";
                        QualityRequirement: Record ItemQualityRequirement_PQ;
                        xType: Code[20];
                        TestHeader: Record QualityTestHeader_PQ;
                        IsInsert: Boolean;
                        QCLine: Record QCSpecificationLine_PQ;
                        QCLine2: Record QCSpecificationLine_PQ;
                    begin
                        QCSetup.Get();
                        QCSetup.TestField("Specification Type Nos.");

                        SpecificationHeader.Reset();
                        SpecificationHeader.SetRange(Type, '');
                        if SpecificationHeader.Find('-') then
                            repeat
                                xType := SpecificationHeader.Type;
                                NewNo := '';
                                // NoSeriesMgt.InitSeries(QCSetup."Specification Type Nos.", NullValue, 0D, NewNo, NullValue);
                                NewNo := NoSeriesMgt.GetNextNo(QCSetup."Specification Type Nos.", 0D, true);

                                SpecificationHeader2.TransferFields(SpecificationHeader);
                                SpecificationHeader2.Type := NewNo;
                                SpecificationHeader2.Insert();

                                SpecificationHeader3 := SpecificationHeader;
                                SpecificationHeader3.Validate(Type, NewNo);

                                TestHeader.Reset();
                                TestHeader.SetRange("Specification Type", xType);
                                if TestHeader.FindSet() then
                                    TestHeader.ModifyAll("Specification Type", SpecificationHeader2.Type, false);

                                if SpecificationHeader2.Status = SpecificationHeader2.Status::Certified then begin
                                    QualityRequirement.Init();
                                    QualityRequirement.Type := QualityRequirement.Type::"Purchase Receipt";
                                    QualityRequirement."Item No." := SpecificationHeader2."Item No.";
                                    QualityRequirement."Specification No." := SpecificationHeader2.Type;
                                    if QualityRequirement.Insert() then;
                                end;

                            until SpecificationHeader.Next() = 0;

                        SpecificationHeader.Reset();
                        SpecificationHeader.SetRange(Type, '');
                        if SpecificationHeader.Find('-') then
                            SpecificationHeader.DeleteAll(false);

                        Message(Lbl001);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage();
    begin

        Rec.RESET;

        if not Rec.GET then begin
            Rec.INIT;
            Rec.INSERT;
        end;

        //QC80 Start
        StatusRules.RESET;
        if not StatusRules.FINDFIRST then
            StatusRules.InitStatusRules();
        //QC80 Finish
    end;

    var
        StatusRules: Record QCStatusRules_PQ;
        VersionNoTxt: text;
        Lbl001: Label 'The quality specifications have been renumbered.';
}
