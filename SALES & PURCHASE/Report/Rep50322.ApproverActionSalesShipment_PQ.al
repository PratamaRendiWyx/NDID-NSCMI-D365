report 50322 ApproverActionSalesShipment_PQ
{
    Caption = 'Approver Action - Sales Shipment (BOP)';
    ProcessingOnly = true;
    Permissions = Tabledata "Sales Shipment Line" = rmid;

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
                if Confirm(label1) then begin
                    if SalesShipmentLines.FindSet() then
                        UpdateDocumentSalesShipmentLines(SalesShipmentLines);
                end;
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
                    //list field name
                    field(TotalRowAffected; TotalRowAffected)
                    {
                        ApplicationArea = All;
                        Caption = 'Total Row Affected';
                        Enabled = false;
                    }
                    field(ApproverAction; ApproverAction)
                    {
                        ApplicationArea = All;
                        Caption = 'Approval Status';
                    }
                    field(GlbCOmment; GlbCOmment)
                    {
                        ApplicationArea = All;
                        Caption = 'Comment';
                        MultiLine = true;
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

    local procedure UpdateDocumentSalesShipmentLines(var iSalesShipmentLines: Record "Sales Shipment Line")
    begin
        //action here
        repeat
            if ApproverAction = ApproverAction::Approve then begin
                iSalesShipmentLines."Status Approval" := iSalesShipmentLines."Status Approval"::Approved;
            end else begin
                iSalesShipmentLines."Status Approval" := iSalesShipmentLines."Status Approval"::Rejected;
            end;
            iSalesShipmentLines."Approval By" := UserId;
            iSalesShipmentLines."Approval Date" := CurrentDateTime;
            iSalesShipmentLines."Comment Line" := GlbCOmment;
            iSalesShipmentLines.Modify();
        until iSalesShipmentLines.Next() = 0;
        //-
    end;

    procedure setParameter(var iSalesShipmentLines: Record "Sales Shipment Line")
    begin
        SalesShipmentLines.Copy(iSalesShipmentLines);
        TotalRowAffected := SalesShipmentLines.Count();
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

    end;

    var
        GlbCOmment: Text[250];
        //New
        TotalRowAffected: Integer;
        ApproverAction: enum "Approver QC Status";
        //-
        label1: Label 'Are you sure want to do this action ?';
        SalesShipmentLines: Record "Sales Shipment Line";


}
