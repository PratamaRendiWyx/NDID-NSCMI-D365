page 50708 QCSpecificationList_PQ
{
    // version QC13.02

    // //QC7.2
    //   - Added New Promoted Actions Category, "Setup"
    //   - Moved "Description" next to "Item No."
    //   - Changed "Status" Style to 'Strong'
    //   - Indented the "Item No." Column, based on non-blank "Customer No."
    //
    // QC7.3 
    //   - Changed "Type" Field to NON-Visible
    //
    // QC71.1 
    //   - Added "Tests on File" and "Last Used" FlowFields from Specification Header
    //
    // QC10.2  
    //   - Changed Promoted Action Category "Catagory6" to "Setup"
    //   - Added Action Group "Setup" and placed "QC Setup" Action under it
    //
    // QC11.01 
    //   - Added FlowField "Active Tests"
    //   - Removed FieldGroup "Setup", and "QC Setup" Action Thereunder
    //
    // QC13.02
    //      - Added "UsageCategory" and "ApplicationArea" to make Page Searchable

    Caption = 'Quality Specifications';
    CardPageID = QCSpecificationHeader_PQ;
    DeleteAllowed = false;
    Editable = false;
    //InsertAllowed = false;
    //ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Setup';
    SourceTable = QCSpecificationHeader_PQ;
    UsageCategory = Lists;
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                IndentationColumn = Level;
                IndentationControls = "Item No.";
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }

                field("Test Description"; Rec."Test Description")
                {
                    ApplicationArea = All;
                }
                field("Category Code"; Rec."Category Code")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    //Style = Strong;
                    //StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Tests on File"; Rec."Tests on File")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Active Tests"; Rec."Active Tests")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Last Used"; Rec."Last Used")
                {
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }

        area(factboxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(14004591),
                              "No." = FIELD(Type);
            }
            part(AMHistoryFactBox; HistoryFactBox_PQ)
            {
                ApplicationArea = All;
                Caption = 'History';
                SubPageLink = Type = FIELD(Type);
            }
            part(ItemPicture; "Item Picture")
            {
                Caption = 'Picture';
                Editable = false;
                SubPageLink = "No." = FIELD("Item No.");
                ApplicationArea = All;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Quality Spec")
            {
                Caption = '&Quality Spec';
                Visible = false;
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page QCHeaderComments_PQ;
                    RunPageLink = "Item No." = FIELD("Item No."),
                                  "Customer No." = FIELD("Customer No."),
                                  Type = FIELD(Type),
                                  "Version Code" = CONST('');
                    RunPageView = SORTING("Table Name", "Item No.", "Customer No.", Type, "Version Code", "Line No.")
                                  WHERE("Table Name" = CONST("QC Header"));
                    ToolTip = 'Edit Comments';
                    ApplicationArea = All;
                    Visible = false;
                }
                action("Versions")
                {
                    Caption = 'Versions';
                    Image = Versions;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page QCSpecVersionList_PQ;
                    RunPageLink = "Item No." = FIELD("Item No."),
                                  "Customer No." = FIELD("Customer No."),
                                  Type = FIELD(Type);
                    RunPageView = SORTING("Item No.", "Customer No.", Type, "Version Code");
                    ToolTip = 'Open Version List';
                    ApplicationArea = All;
                    Visible = false;
                }
            }
            action("Comm&ents")
            {
                Caption = 'Co&mments';
                Image = ViewComments;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page QCHeaderComments_PQ;
                RunPageLink = "Item No." = FIELD("Item No."),
                                "Customer No." = FIELD("Customer No."),
                                Type = FIELD(Type),
                                "Version Code" = CONST('');
                RunPageView = SORTING("Table Name", "Item No.", "Customer No.", Type, "Version Code", "Line No.")
                                WHERE("Table Name" = CONST("QC Header"));
                ToolTip = 'Edit Comments';
                ApplicationArea = All;
            }
            group("&Report")
            {
                //Caption = '&Report';
            }
        }

        area(Reporting)
        {
        }
    }

    trigger OnAfterGetRecord();
    begin
        //QC7.2 Added
        Level := 0;
        //if "Customer No." <> '' then
        //    Level := 2; //Indent "Customer Specs"
    end;

    var
        Level: Integer;
}
