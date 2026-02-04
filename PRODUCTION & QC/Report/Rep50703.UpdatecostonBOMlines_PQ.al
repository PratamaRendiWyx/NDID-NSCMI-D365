report 50703 UpdatecostonBOMlines_PQ
{

    Caption = 'Update cost on BOM lines';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Production BOM Header"; "Production BOM Header")
        {

            trigger OnAfterGetRecord()
            begin
                StoreStatus := "Production BOM Header".Status;
                "Production BOM Header".Status := "Production BOM Header".Status::"Under Development";
                Modify;
                ProductionBOMLineT.SetRange(ProductionBOMLineT."Production BOM No.", "Production BOM Header"."No.");
                if ProductionBOMLineT.Find('-') then    //main and all versions
                    repeat
                        ProductionBOMLineT.Validate(ProductionBOMLineT."Unit of Measure Code");
                        ProductionBOMLineT.Modify;
                    until ProductionBOMLineT.Next = 0;
                "Production BOM Header".Status := StoreStatus;
                Modify;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        ProductionBOMLineT: Record "Production BOM Line";
        StoreStatusOld: Option Open,"Under Development",Certified;
        StoreStatus: Enum "BOM Status";
}

