page 50719 QualityControlActivities_PQ
{
    Caption = 'Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = QCCue_PQ;
    ApplicationArea = All;
    // version QC11.01

    // QC11.01
    //   - Removed "Related" CueGroup, and all Activities thereunder
    //   - Removed "Obsolete QC Tests" CueGroup, and all Activities Thereunder
    layout
    {
        area(content)
        {
            cuegroup("Specifications")
            {
                Caption = 'Specifications';
                field("Specification New"; Rec."Specification New")
                {
                    Caption = 'New';
                    ToolTip = 'Number Specifications New';
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = QCSpecificationList_PQ;
                }
                field("Specification Certified"; Rec."Specification Certified")
                {
                    DrillDownPageID = QCSpecificationList_PQ;
                    Caption = 'Certified';
                    ToolTip = 'Number Specifications Certified';
                    ApplicationArea = All;
                }
                field("Specification UnderDevelopment"; Rec."Specification UnderDevelopment")
                {
                    DrillDownPageID = QCSpecificationList_PQ;
                    Caption = 'Under Development';
                    ToolTip = 'Number Specifications Under Development';
                    ApplicationArea = All;
                }
            }

            cuegroup("Active QC Tests")
            {
                Caption = 'Active Quality Tests';
                field("Ready For Testing"; Rec."Ready For Testing")
                {
                    DrillDownPageID = QCTestList_PQ;
                    ToolTip = 'Quality Tests ready to start';
                    ApplicationArea = All;
                }
                field("In-Process"; Rec."In-Process")
                {
                    DrillDownPageID = QCTestList_PQ;
                    ToolTip = 'Quality Tests in process';
                    ApplicationArea = All;
                }
                field("Ready For Review"; Rec."Ready For Review")
                {
                    DrillDownPageID = QCTestList_PQ;
                    ToolTip = 'Number of Tests ready for Review';
                    ApplicationArea = All;
                }

                actions
                {
                    action("New QC Lot/SN Test")
                    {
                        Caption = 'New Quality Test';
                        RunObject = Page QCLotTestHeader_PQ;
                        RunPageMode = Create;
                        ApplicationArea = All;
                    }
                }
            }
            cuegroup("Certified QC Tests")
            {
                Caption = 'Certified Quality Tests';
                field(Certified; Rec.Certified)
                {
                    DrillDownPageID = QCTestList_PQ;
                    ToolTip = 'Number Certified';
                    ApplicationArea = All;
                }
                /*field("Certified Final"; Rec."Certified Final")
                {
                    DrillDownPageID = QCTestList_PQ;
                    ToolTip = 'Number Certified Final';
                    ApplicationArea = All;
                }
                */
            }
            cuegroup("Archived Quality Tests")
            {
                Caption = 'Archived Quality Tests';
                field(Rejected; Rec.Rejected)
                {
                    DrillDownPageID = QCTestList_PQ;
                    ToolTip = 'Number Rejected';
                    ApplicationArea = All;
                }
                field("Closed Quality Tests"; Rec."Closed Quality Tests")
                {
                    DrillDownPageID = QCTestList_PQ;
                    ToolTip = 'Number Closed Quality Tests';
                    ApplicationArea = All;
                    Caption = 'Closed';
                }
            }

            cuegroup(General)
            {
                Caption = 'General';
                Visible = false;
                field("PO Lines with QC Required"; Rec."PO Lines with QC Required")
                {
                    ToolTip = 'Number of PO Lines with Quality Control Required';
                    ApplicationArea = All;
                }
                field("Purch Receipt Lines QC Req"; Rec."Purch Receipt Lines QC Req")
                {
                    ToolTip = 'Number of Purchase Receipt Line with Quality Control Required';
                    ApplicationArea = All;
                }
                field("Items in QC Quarantine"; Rec."Items in QC Quarantine")
                {
                    ToolTip = 'Number of items in Quality Control Quarantine Location';
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    var
                        ItemList: Page "Item List";
                    begin
                        //CalcItemsInQCQuarantine(Item);
                        CLEAR(ItemList);
                        ItemList.SETTABLEVIEW(Item);
                        ItemList.RUNMODAL;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        //CalcItemsInQCQuarantine(Item);
        //TestNumber := 10;
    end;

    trigger OnOpenPage();
    begin
        /*         RESET;
                if not GET then begin
                    INIT;
                    INSERT;
                end; */

        if QCSetup.GET then begin
            Rec."QC Location" := QCSetup."Default QC Location"; //Used in 'Items in QC Quarantine' FlowField Def.
        end;

        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;

    end;

    var
        QCSetup: Record QCSetup_PQ;
        Item: Record Item;

}
