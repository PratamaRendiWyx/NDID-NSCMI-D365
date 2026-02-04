page 50721 QCRequirements_PQ
{
    // version QC10.1

    // QC80.1
    //   - Added Fields "Description" and "Name"

    Caption = 'Quality Requirements';
    PageType = List;
    SourceTable = QCRequirements_PQ;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Displays the Item Number for this Quality Requirement';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Description for the Item on this requirement';
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Customer Number for this Quality Requirement';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Customer Name for the Customer on the Requirement';
                    ApplicationArea = All;
                }
                field("Quality Testing Required"; Rec."Quality Testing Required")
                {
                    ToolTip = 'Indicates if Quality Testing is required';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Specifications")
            {
                Caption = '&Specifications';
                Image = RoutingVersions;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Lists the Specifications for this Requirement';
                ApplicationArea = All;

                trigger OnAction();
                begin
                    if Rec."Customer No." = '' then begin
                        QSpecHeaderT.SETRANGE("Item No.", Rec."Item No.");
                        if QSpecHeaderT.FIND('-') then
                            PAGE.RUN(PAGE::QCSpecificationList_PQ, QSpecHeaderT);
                    end else begin
                        QSpecHeaderT.SETRANGE("Item No.", Rec."Item No.");
                        QSpecHeaderT.SETRANGE("Customer No.", Rec."Customer No.");
                        QSpecHeaderT.SETRANGE(Type, '');
                        if QSpecHeaderT.FIND('-') then
                            PAGE.RUN(PAGE::QCSpecificationList_PQ, QSpecHeaderT);
                    end;
                    CLEAR(QSpecHeaderT);
                end;
            }
        }
    }

    var
        QSpecHeaderT: Record QCSpecificationHeader_PQ;
}

