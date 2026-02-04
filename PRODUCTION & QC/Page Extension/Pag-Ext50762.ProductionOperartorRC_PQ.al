namespace PRODUCTIONQC.PRODUCTIONQC;

pageextension 50762 ProductionOperator_PQ extends ProductionOperatorRC_FT
{
    actions
    {
        modify("Prod. Order - &Job Card")
        {
            Visible = false;
        }
        addafter("Prod. Order - &Job Card")
        {
            action("Prod. Order - &Job Card1")
            {
                ApplicationArea = Manufacturing;
                Caption = 'Prod. Order - &Job Card';
                Image = "Report";
                RunObject = Report "Prod. Order - Job Card PQ";
                ToolTip = 'View a list of the work in progress of a production order. Output, Scrapped Quantity and Production Lead Time are shown or printed depending on the operation.';
            }
        }

        addbefore("Released Production Orders")
        {
            action(FindDocument)
            {
                ApplicationArea = Manufacturing;
                Caption = 'Scan Barcode/QC Code';
                RunObject = report "Find Show Document Prod. Order";
                ToolTip = 'Find & Show Document Prod. Orders by search box or barcode scanner.';
            }
        }
    }
}
