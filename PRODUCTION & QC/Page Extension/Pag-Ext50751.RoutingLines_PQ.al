pageextension 50751 RoutingLines_PQ extends "Routing Lines"
{
    layout
    {
        addbefore(Description)
        {
            field("Spec. Type ID"; Rec."CCS Spec. Type ID")
            {
                ApplicationArea = All;
            }

            field(Comment; Rec.Comment)
            {
                Caption = 'Comment';
                ApplicationArea = All;
            }
        }

        modify("Run Time Unit of Meas. Code")
        {
            Visible = true;
        }

        addbefore("Run Time")
        {
            field("Fix Run Time"; Rec."Fix Run Time")
            {
                ApplicationArea = All;
            }
            field("Fix Time"; Rec."Fix Time")
            {
                ApplicationArea = All;
                Enabled = Rec."Fix Run Time";
            }
        }

        modify("Run Time")
        {
            Enabled = Not Rec."Fix Run Time";
        }
    }

    actions
    {
        addafter("&Quality Measures")
        {
            action("Create Specification")
            {
                Caption = '&Create Specification';
                Image = CreateInteraction;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Create a quality specification header for the selected routing line';
                ApplicationArea = All;

                trigger OnAction()
                var
                    QCSetup: Record QCSetup_PQ;
                    SpecHeader: Record QCSpecificationHeader_PQ;
                    //AMTransactionArea: Record "AM Transaction Area";
                    NoSeriesMgt: Codeunit "No. Series";
                    NullValue: Code[10];
                    ItemQualityRequirement: Record ItemQualityRequirement_PQ;
                begin
                    QCSetup.Get;
                    QCSetup.TestField("Specification Type Nos.");
                    //AMSpecHeader.VerifyOutputTransactionArea(AMTransactionArea);

                    if Rec."CCS Spec. Type ID" <> '' then
                        error(Text001);

                    SpecHeader.Init;
                    SpecHeader.Validate("Item No.", Rec."Routing No.");
                    // NoSeriesMgt.InitSeries(QCSetup."Specification Type Nos.", NullValue, 0D, SpecHeader.Type, NullValue);
                    // NoSeriesMgt.InitSeries(QCSetup."Specification Type Nos.", NullValue, 0D, NewNo, NullValue);
                    SpecHeader.Type := NoSeriesMgt.GetNextNo(QCSetup."Specification Type Nos.", 0D, true);
                    SpecHeader."QC Required" := true;
                    SpecHeader.Insert(true);
                    Rec."CCS Spec. Type ID" := SpecHeader.Type;
                    //Modify(true);
                end;
            }
        }
    }

    /*
    trigger OnAfterGetCurrRecord()
    begin
        if Type = Type::"Work Center" then
            Rec.CalcFields("Work Center Quality");
    end;
    */

    local procedure getInfoItemLotSize(iNo: Code[20]): Decimal
    var
        Item: Record Item;
    begin
        Clear(Item);
        Item.Reset();
        Item.SetRange("No.", iNo);
        if Item.Find('-') then
            exit(Item."Lot Size");
        exit(0);
    end;


    var
        Text001: Label 'Current line has already an specification assigned.';
        Text002: Label 'A transaction area of type Output must exist before creating an Output specification.';
}