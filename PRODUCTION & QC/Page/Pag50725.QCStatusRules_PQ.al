page 50725 QCStatusRules_PQ
{
    // version QC10.1

    Caption = 'Quality Control Status Rules';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = QCStatusRules_PQ;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Quality Status Code';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Quality Status Description';
                    ApplicationArea = All;
                }
                field("Non-Mgr Default"; Rec."Non-Mgr Default")
                {
                    ToolTip = '"Flags options for default requirements for certification of Quality Control "';
                    ApplicationArea = All;
                }
                field("Mgr Default"; Rec."Mgr Default")
                {
                    ToolTip = '"Flags options for default requirements for certification of Quality Control "';
                    ApplicationArea = All;
                }
                field("Non-Mgr In Process"; Rec."Non-Mgr In Process")
                {
                    ToolTip = '"Flags options for default requirements for certification of Quality Control "';
                    ApplicationArea = All;
                }
                field("Mgr In Process"; Rec."Mgr In Process")
                {
                    ToolTip = '"Flags options for default requirements for certification of Quality Control "';
                    ApplicationArea = All;
                }
                field("Non-Mgr Ready for Review"; Rec."Non-Mgr Ready for Review")
                {
                    ToolTip = '"Flags options for default requirements for certification of Quality Control "';
                    ApplicationArea = All;
                }
                field("Mgr Ready for Review"; Rec."Mgr Ready for Review")
                {
                    ToolTip = '"Flags options for default requirements for certification of Quality Control "';
                    ApplicationArea = All;
                }
                field("Non-Mgr Certified"; Rec."Non-Mgr Certified")
                {
                    ToolTip = '"Flags options for default requirements for certification of Quality Control "';
                    ApplicationArea = All;
                }
                field("Mgr Certified"; Rec."Mgr Certified")
                {
                    ToolTip = '"Flags options for default requirements for certification of Quality Control "';
                    ApplicationArea = All;
                }
                field("Non-Mgr Certified With Waiver"; Rec."Non-Mgr Certified With Waiver")
                {
                    ToolTip = '"Flags options for default requirements for certification of Quality Control "';
                    ApplicationArea = All;
                }
                field("Mgr Certified With Waiver"; Rec."Mgr Certified With Waiver")
                {
                    ToolTip = '"Flags options for default requirements for certification of Quality Control "';
                    ApplicationArea = All;
                }
                field("Non-Mgr Certified Final"; Rec."Non-Mgr Certified Final")
                {
                    ToolTip = '"Flags options for default requirements for certification of Quality Control "';
                    ApplicationArea = All;
                }
                field("Mgr Certified Final"; Rec."Mgr Certified Final")
                {
                    ToolTip = '"Flags options for default requirements for certification of Quality Control "';
                    ApplicationArea = All;
                }
                field("Non-Mgr Rejected"; Rec."Non-Mgr Rejected")
                {
                    ToolTip = '"Flags options for default requirements for certification of Quality Control "';
                    ApplicationArea = All;
                }
                field("Mgr Rejected"; Rec."Mgr Rejected")
                {
                    ToolTip = '"Flags options for default requirements for certification of Quality Control "';
                    ApplicationArea = All;
                }
                field("Non-Mgr Closed"; Rec."Non-Mgr Closed")
                {
                    ToolTip = '"Flags options for default requirements for certification of Quality Control "';
                    ApplicationArea = All;
                }
                field("Mgr Closed"; Rec."Mgr Closed")
                {
                    ToolTip = '"Flags options for default requirements for certification of Quality Control "';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
         if not Rec.FINDFIRST then
            Rec.InitStatusRules;
    end;
}

