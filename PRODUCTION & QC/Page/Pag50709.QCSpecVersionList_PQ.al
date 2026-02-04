page 50709 QCSpecVersionList_PQ
{
    // version QC10.1

    // QC7.3
    //   - Changed "Type" Field to NON-Visible

    Caption = 'Quality Spec Version List';
    CardPageID = QCSpecificationVersion_PQ;
    Editable = false;
    PageType = List;
    SourceTable = QCSpecificationVersions_PQ;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Version Code"; Rec."Version Code")
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
                }
                field(Type; Rec.Type)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                }
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
                action("&Card")
                {
                    Caption = '&Card';
                    Image = EditLines;
                    RunObject = Page QCSpecVersionList_PQ;
                    RunPageLink = "Item No." = FIELD("Item No."),
                                  "Customer No." = FIELD("Customer No."),
                                  Type = FIELD(Type),
                                  "Version Code" = FIELD("Version Code");
                    RunPageView = SORTING("Item No.", "Customer No.", Type, "Version Code");
                    ShortCutKey = 'Shift+Ctrl+L';
                    ToolTip = 'Open Version List';
                    ApplicationArea = All;
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page QCHeaderComments_PQ;
                    RunPageLink = "Item No." = FIELD("Item No."),
                                  "Customer No." = FIELD("Customer No."),
                                  Type = FIELD(Type),
                                  "Version Code" = FIELD("Version Code");
                    RunPageView = SORTING("Table Name", "Item No.", "Customer No.", Type, "Version Code", "Line No.")
                                  WHERE("Table Name" = CONST("QC Version"));
                    ToolTip = 'Edit Comments';
                    ApplicationArea = All;
                }
            }
        }
    }
}

