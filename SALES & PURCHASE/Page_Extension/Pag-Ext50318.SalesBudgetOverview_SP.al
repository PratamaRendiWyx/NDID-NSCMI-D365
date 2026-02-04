pageextension 50318 SalesBudgetOverview_SP extends "Sales Budget Overview"
{
    actions
    {
        addafter("Update Existing Document")
        {
            action("&ExportItemVariant")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Export Item Budget.';
                Ellipsis = true;
                Image = ExportToExcel;
                ToolTip = 'Export Item Budget.';
                trigger OnAction()
                var
                    salesBudgetEntries: Report "Sales Budget Entry";
                begin
                    salesBudgetEntries.SetParameters(CurrentBudgetName);
                    salesBudgetEntries.RunModal();
                end;
            }
        }
        addafter("Import from Excel")
        {
            group(ImportsGroupExcel)
            {
                Caption = 'Import from Excel.';
                Image = ImportExcel;
                action("&ImportItemVariant")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Import Item Budget.';
                    Ellipsis = true;
                    Image = ImportExcel;
                    ToolTip = 'Import Item Budget with info.';
                    trigger OnAction()
                    var
                        SalesBudgetMangmnt: Codeunit SalesBudgetManagements_SP;
                    begin
                        Clear(SalesBudgetMangmnt);
                        SalesBudgetMangmnt.importItemBudgetEntries(CurrentBudgetName);
                    end;
                }
            }
        }
    }
}
