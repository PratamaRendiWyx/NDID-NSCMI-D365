report 50323 QCActionSalesShipment_PQ
{
    Caption = 'QC Action - Sales Shipment (BOP)';
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
                    field(QcWorkerAction; QcWorkerAction)
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
            if QcWorkerAction = QcWorkerAction::"In Process" then begin
                iSalesShipmentLines."Status Approval" := iSalesShipmentLines."Status Approval"::"In Process";
            end else if QcWorkerAction = QcWorkerAction::"Re-Open" then begin
                iSalesShipmentLines."Status Approval" := iSalesShipmentLines."Status Approval"::Open;
                if Not GlbUserSetup."Re-Open Shipment Line" then
                    Error('Can''t re-open the lines, cause you don''t have permission.');
            end else begin
                iSalesShipmentLines."Status Approval" := iSalesShipmentLines."Status Approval"::"Ready for Review";
            end;
            iSalesShipmentLines."QC By" := UserId;
            iSalesShipmentLines."QC Date" := CurrentDateTime;
            iSalesShipmentLines."Comment Line QC Worker" := GlbCOmment;
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
        Clear(GlbUserSetup);
        GlbUserSetup.Get(UserId);
    end;

    var
        GlbCOmment: Text[250];
        //New
        TotalRowAffected: Integer;
        QcWorkerAction: enum "QC Worker Status";
        //-
        label1: Label 'Are you sure want to do this action ?';
        SalesShipmentLines: Record "Sales Shipment Line";

        GlbUserSetup: Record "User Setup";

}
