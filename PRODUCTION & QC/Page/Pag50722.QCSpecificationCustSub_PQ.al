page 50722 QCSpecificationCustSub_PQ
{
    // version QC10.1

    // //QC7.2
    //   - Added New Promoted Actions Category, "Setup"
    //   - Moved "Description" next to "Item No."
    //   - Changed "Status" Style to 'Strong'
    // 
    // QC7.3
    //   - Changed "Type" Field to NON-Visible
    // 
    // QC71.1
    //   - Added "Tests on File" FlowField

    Caption = 'Quality Specification Cust Sub';
    CardPageID = QCSpecificationHeader_PQ;
    Editable = false;
    PageType = ListPart;
    PromotedActionCategories = 'New,Process,Report,Setup';
    SourceTable = QCSpecificationHeader_PQ;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Displays the Item Number';
                    ApplicationArea = All;
                }
                field("Test Description"; Rec."Test Description")
                {
                    ToolTip = 'Displays the Test Description for this Spec';
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Displays the applicable Customer Number';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Indicates the specification type';
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    ToolTip = 'Indicates the stastus of the test';
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ToolTip = 'Displays the Unit of Measure code for the item';
                    ApplicationArea = All;
                }
                field("Tests on File"; Rec."Tests on File")
                {
                    ToolTip = 'Indicates if there are tests on file for this item';
                    ApplicationArea = All;
                }
                field("Last Used"; Rec."Last Used")
                {
                    ToolTip = 'Displays the last date this specification was used';
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Displays any comments related to this quality specification';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Item Specifications")
            {
                Caption = 'Item Specifications';
                Description = 'Displays the list of Item Specifications';
                Image = Design;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page QCSpecificationHeader_PQ;
                RunPageLink = "Customer No." = FIELD("Customer No."),
                              "Item No." = FIELD("Item No."),
                              Type = filter('');
                RunPageView = SORTING("Customer No.");
                ToolTip = 'View Customer Quality Specification List';
                ApplicationArea = All;
            }
            separator(Separator14004590)
            {
            }
        }
    }
}

