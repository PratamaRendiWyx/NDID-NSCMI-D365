page 50703 QCSpecificationHeader_PQ
{

    Caption = 'Quality Specification';
    PageType = ListPlus;
    PromotedActionCategories = 'New,Process,Report,Process,Navigate,Setup';
    SourceTable = QCSpecificationHeader_PQ;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Typefield; Rec.Type)
                {
                    ApplicationArea = All;
                    //Editable = false;
                    trigger OnAssistEdit();
                    begin
                        Rec.AssistEdit(xRec);
                        //CurrPage.UPDATE;
                    end;
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Fill in the Item No. related to this quality specification';
                    ApplicationArea = All;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ToolTip = 'Displays the Item Description for this Quality Specification';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Fill this in if this is a Customer-Specific Specification. Otherwise, leave Blank';
                    ApplicationArea = All;
                    Visible = false;

                    trigger OnValidate();
                    begin
                        if ActiveVersionCode = '' then ActiveVersionCode := 'Original'
                    end;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Indicates the Customer Name for this Quality Specification';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Test Description"; Rec."Test Description")
                {
                    ToolTip = 'Displays the Test Description for this Quality Specification';
                    ApplicationArea = All;
                }
                field("Category Code"; Rec."Category Code")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ToolTip = 'Specify the Unit of Measure for the Item in this Quality Spec';
                    ApplicationArea = All;
                }
                field("QC Required"; Rec."QC Required")
                {
                    ToolTip = 'This box is checked if QC is required for this item';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    ToolTip = 'Indicates the Status of the Quality Specification:  New,Certified,Under Development,Closed';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = '"Enter a code related to the Quality Spec "';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Version Nos."; Rec."Version Nos.")
                {
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Indicates the version numbers for this Quality Specification';
                    Visible = false;
                    ApplicationArea = All;
                }
                field(ActiveVersionCode; ActiveVersionCode)
                {
                    Caption = 'Active Version';
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Displays the Active Version for this Quality Specification';
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean;
                    var
                        ProdBOMVersion: Record "Production BOM Version";
                    begin
                        VersionT.SETRANGE("Item No.", Rec."Item No.");
                        VersionT.SETRANGE("Customer No.", Rec."Customer No.");
                        VersionT.SETRANGE(Type, Rec.Type);
                        VersionT.SETRANGE("Version Code", ActiveVersionCode);
                        if VersionT.FIND('-') then
                            PAGE.RUNMODAL(PAGE::QCSpecificationVersion_PQ, VersionT)
                        else
                            ERROR(Text000);
                    end;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ToolTip = 'Indicates the last date this Quality Spec was modified';
                    ApplicationArea = All;
                }
                field("Versions Exist"; Rec."Versions Exist")
                {
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Indicates if multiple versions exist for this Quality Specification';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Check Sum. Value"; Rec."Check Sum. Value")
                {
                    ApplicationArea = All;
                }
            }
            part(QCLine; QCSpecificationLines_PQ)
            {
                SubPageLink = "Item No." = FIELD("Item No."),
                              "Customer No." = FIELD("Customer No."),
                              Type = FIELD(Type),
                              "Version Code" = FILTER('');
                SubPageView = SORTING("Item No.", "Customer No.", Type, "Version Code", "Line No.");
                ApplicationArea = All;
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
                Caption = '&Specification';
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page QCHeaderComments_PQ;
                    RunPageLink = "Item No." = FIELD("Item No."),
                                  "Customer No." = FIELD("Customer No."),
                                  Type = FIELD(Type),
                                  "Version Code" = CONST('');
                    RunPageView = SORTING("Table Name", "Item No.", "Customer No.", Type, "Version Code", "Line No.")
                                  WHERE("Table Name" = CONST("QC Header"));
                    ToolTip = 'Enter Comments';
                    ApplicationArea = All;
                }
                action("Versions")
                {
                    Caption = 'Versions';
                    Image = Versions;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page QCSpecVersionList_PQ;
                    RunPageLink = "Item No." = FIELD("Item No."),
                                  "Customer No." = FIELD("Customer No."),
                                  Type = FIELD(Type);
                    ToolTip = 'Click to open Version List';
                    ApplicationArea = All;
                    Visible = false;
                }
                action("View Item Ledger Entries")
                {
                    Caption = 'Item Ledger Entries';
                    Image = ReviewWorksheet;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page "Item Ledger Entries";
                    RunPageLink = "Item No." = FIELD(FILTER("Item No."));
                    RunPageMode = View;
                    ApplicationArea = All;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Copy &Specifications")
                {
                    Caption = 'Copy &Specifications';
                    Image = Copy;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Click to copy your testing specifications';
                    ApplicationArea = All;

                    trigger OnAction();
                    var
                        CopyPrompt: Label 'Do you want to permanently replace this Specification?';
                    begin
                        Rec.TESTFIELD("Item No.");
                        Rec.TestStatus;
                        if CONFIRM('%1', false, CopyPrompt) then
                            if PAGE.RUNMODAL(0, QCHeader) = ACTION::LookupOK then
                                QualitySpecsCopy.CopyQCSpecs(QCHeader, '', Rec, ''); //SelectedRec,FromVersionCode,OnCurrentRec,ToVersionCode
                    end;
                }
            }
            group("&Report")
            {
            }
        }

        area(Reporting)
        {
        }
    }


    trigger OnAfterGetRecord();
    var
        TestHeader: Record QualityTestHeader_PQ;
    begin
        ActiveVersionCode := QualitySpecsCopy.GetQCVersion(Rec."Item No.", Rec."Customer No.", Rec.Type, WORKDATE, 1);  //Origin=1=PrimarySpecCard
    end;

    trigger OnInit();
    begin
        //QC7.2 Added
        CRChar := 13;
        CR := FORMAT(CRChar);
    end;

    var
        QCHeader: Record QCSpecificationHeader_PQ;
        QualitySpecsCopy: Codeunit QCFunctionLibrary_PQ;
        VersionMgt: Codeunit VersionManagement;
        ActiveVersionCode: Code[20];
        VersionT: Record QCSpecificationVersions_PQ;
        Text000: Label 'There is no record to view.';
        RequirementT: Record QCRequirements_PQ;
        Text001: Label 'NOTE: If you are CREATING a New CUSTOMER Specification';
        CRChar: Char;
        CR: Text;
        Text002: Label '"you must Enter the Customer No. FIRST"';
}
