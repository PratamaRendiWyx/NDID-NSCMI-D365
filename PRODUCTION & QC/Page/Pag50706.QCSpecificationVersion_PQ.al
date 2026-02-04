page 50706 QCSpecificationVersion_PQ
{
    // version QC10.1

    // //QC5.01  Added code OnNewRecord to blank out the Version Code No. for Insert
    // 
    // QC7.3 
    //   - Changed "Type" Field to NON-Visible

    Caption = 'Quality Specification Version';
    PageType = Document;
    SourceTable = QCSpecificationVersions_PQ;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Version Code"; Rec."Version Code")
                {
                    ToolTip = 'Version Code for the Quality Spec Version';
                    ApplicationArea = All;

                    trigger OnAssistEdit();
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.UPDATE;
                    end; 
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Description of the Quality Specifications';
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ToolTip = 'Specifies the Unit of Measure for this Quality Specification Version';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Indicates the Quality Specification Status';
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    Caption = 'Item No.';
                    Editable = false;
                    ToolTip = 'Displays the Item No. that this Quality Specification is for';
                    ApplicationArea = All;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ToolTip = 'Displays the Item Description for the Item on the Quality Specification';
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Caption = 'Customer No.';
                    Editable = false;
                    ToolTip = 'Displays the Customer No. , if this Quality Spec is specific to a customer';
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Displays the Customer Name, if this Quality Spec is specific to a customer';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    Caption = 'Type';
                    Editable = false;
                    ToolTip = 'Code field indicating the type of quality specification';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ToolTip = 'Date the this Quality Specification is effective';
                    ApplicationArea = All;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    Editable = false;
                    ToolTip = 'Indicates the last date that the Specification was changed';
                    ApplicationArea = All;
                }
            }
            part(QCLine; QualityVersionLines_PQ)
            {
                SubPageLink = "Item No." = FIELD("Item No."),
                              "Customer No." = FIELD("Customer No."),
                              Type = FIELD(Type),
                              "Version Code" = FIELD("Version Code");
                SubPageView = SORTING("Item No.", "Customer No.", Type, "Version Code", "Line No.");
                ApplicationArea = All;
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
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Copy Specs &Header")
                {
                    Caption = 'Copy Specs &Header';
                    ToolTip = 'Click to copy your specification header info';
                    ApplicationArea = All;
 
                    trigger OnAction();
                    begin
                        Rec.TestStatus;

                        if not CONFIRM(Text000, false) then
                            exit;

                        QCHeader.GET(Rec."Item No.", Rec."Customer No.", Rec.Type);
                        QualitySpecsCopy.CopyQCHeader(Rec, '', QCHeader, Rec."Version Code");
                    end; 
                }
                action("Copy Spec &Version")
                {
                    Caption = 'Copy Spec &Version';
                    ToolTip = 'Click to copy your Specification Version';
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        Rec.TestStatus;
                        QualitySpecsCopy.CopyFromVersion(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
         if Rec."Version Code" = 'BASE' then
            Rec."Version Code" := '';
        Rec.SETRANGE("Version Code");
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        //QC5.01 begin
        Rec."Version Code" := '';
        //QC5.01 end
    end;

    var
        QCHeader: Record QCSpecificationHeader_PQ;
        QualitySpecsCopy: Codeunit QCFunctionLibrary_PQ;
        VersionMgt: Codeunit VersionManagement;
        ActiveVersionCode: Code[20];
        Text000: Label 'Copy from Quality Specification Header?';
}

