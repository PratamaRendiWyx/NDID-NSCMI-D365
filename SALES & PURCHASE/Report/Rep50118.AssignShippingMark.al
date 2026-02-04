report 50317 "Assign Shipping Mark"
{
    Caption = 'Assign Shipping Mark';
    ProcessingOnly = true;

    dataset
    {
        dataitem(CreateNew; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnPostDataItem()
            var
                myInt: Integer;
            begin
                //Action Here
                assignShippingMarkNo();
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    ShowCaption = false;
                    field(OptionShippingMark; OptionShippingMark)
                    {
                        Caption = 'Options';
                        ApplicationArea = All;
                    }
                    field(ManualNos; ManualNos)
                    {
                        Caption = 'Manual Nos.';
                        ToolTip = 'Manual Shipping Mark No. Series';
                        ApplicationArea = All;
                        Visible = (OptionShippingMark = OptionShippingMark::Manual);
                        Enabled = (OptionShippingMark = OptionShippingMark::Manual);
                        ShowMandatory = (OptionShippingMark = OptionShippingMark::Manual);
                    }
                    field(glbLastSequence; glbLastSequence)
                    {
                        ApplicationArea = All;
                        Caption = 'Last No Used';
                        Enabled = false;
                    }
                }
            }

        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    local procedure assignShippingMarkNo()
    var
        LinkShippingMark: Record "Link Shipping Mark Information";
        LinkShippingMark1: Record "Link Shipping Mark Information";
        varShippingMarkNo: Code[20];
    begin
        if OptionShippingMark = OptionShippingMark::Manual then
            if ManualNos = '' then
                Error('Nothing to handle, please fill shipping mark number.');
        repeat
            Clear(LinkShippingMark);
            LinkShippingMark.SetRange("Source ID", glbItemTrackingSpesification."Source ID");
            LinkShippingMark.SetRange("Source Ref. No.", glbItemTrackingSpesification."Source Ref. No.");
            LinkShippingMark.SetRange("Lot No.", glbItemTrackingSpesification."Lot No.");
            LinkShippingMark.SetRange("Item No.", glbItemTrackingSpesification."Item No.");
            LinkShippingMark.SetRange("Package No.", glbItemTrackingSpesification."Package No.");
            LinkShippingMark.SetRange("Location Code", glbItemTrackingSpesification."Location Code");
            if LinkShippingMark.Find('-') then begin
                Clear(LinkShippingMark1);
                LinkShippingMark1.SetRange("Entry No", LinkShippingMark."Entry No");
                if LinkShippingMark1.FindSet() then begin
                    LinkShippingMark1."Shipping Mark No." := getShippingMark();
                    if LinkShippingMark."Shipping Mark No." <> LinkShippingMark1."Shipping Mark No." then begin
                        LinkShippingMark1.Modify();
                    end;
                end;
            end else begin
                Clear(LinkShippingMark1);
                LinkShippingMark1.Init();
                LinkShippingMark1."Entry No" := NextEntryNo();
                LinkShippingMark1."Item No." := glbItemTrackingSpesification."Item No.";
                LinkShippingMark1."Location Code" := glbItemTrackingSpesification."Location Code";
                LinkShippingMark1."Source Type" := glbItemTrackingSpesification."Source Type";
                LinkShippingMark1."Source Subtype" := glbItemTrackingSpesification."Source Subtype";
                LinkShippingMark1."Source ID" := glbItemTrackingSpesification."Source ID";
                LinkShippingMark1."Source Ref. No." := glbItemTrackingSpesification."Source Ref. No.";
                LinkShippingMark1."Package No." := glbItemTrackingSpesification."Package No.";
                LinkShippingMark1."Lot No." := glbItemTrackingSpesification."Lot No.";
                LinkShippingMark1."Shipping Mark No." := getShippingMark();
                LinkShippingMark1.Insert();
            end;
        until glbItemTrackingSpesification.Next() = 0;
    end;

    local procedure NextEntryNo(): Integer
    var
        linkShippingMark: Record "Link Shipping Mark Information";
    begin
        if linkShippingMark.FindLast() then
            exit(linkShippingMark."Entry No" + 1);
        exit(1);
    end;

    local procedure getShippingMark(): Code[20]
    var
        o_result: Code[20];
    begin
        Clear(o_result);
        case OptionShippingMark of
            OptionShippingMark::Manual:
                begin
                    o_result := ManualNos;
                end;
            OptionShippingMark::"Last Sequence":
                begin
                    o_result := glbLastSequence;
                end;
            OptionShippingMark::"Next Sequence":
                begin
                    Clear(NoSeriesMgt);
                    o_result := NoSeriesMgt.GetNextNo(warehouseSetup."Ship Mark Nos.", WorkDate());
                end;
        end;
        exit(o_result);
    end;

    trigger OnPreReport()
    var
        myInt: Integer;
    begin
        CurrReport.UseRequestPage(true);
    end;

    trigger OnInitReport()
    var
        myInt: Integer;
    begin
        Clear(glbItemTrackingSpesification);
        warehouseSetup.Get();
        glbLastSequence := NoSeriesMgt.GetLastNoUsed(warehouseSetup."Ship Mark Nos.");
    end;

    procedure setParameter(var iItemTrackingSpesification: Record "Tracking Specification")
    var
        myInt: Integer;
    begin
        glbItemTrackingSpesification.Copy(iItemTrackingSpesification, true);
    end;


    var
        warehouseSetup: Record "Warehouse Setup";
        glbItemTrackingSpesification: Record "Tracking Specification" temporary;
        NoSeriesMgt: Codeunit "No. Series";
        ManualNos: Code[20];
        OptionShippingMark: enum "Option Shipping Mark";
        glbLastSequence: Code[20];
}
