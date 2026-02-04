pageextension 50312 PurchasePriceList_SP extends "Purchase Price List"
{
    actions
    {
        addafter(SuggestLines)
        {
            group(ImportsGroupExcel)
            {
                Caption = 'Manage Data in Excel';
                Image = Excel;
                action("&ImportExcel")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Import from Excel';
                    Ellipsis = true;
                    Image = ImportExcel;
                    ToolTip = 'Import from Excel (Purchase Price Line).';
                    trigger OnAction()
                    var
                        PurchasePriceManagement: Codeunit PurchasePriceManagement_SP;
                    begin
                        Clear(PurchasePriceManagement);
                        PurchasePriceManagement.importPurchPrice(Rec.Code);
                    end;
                }
            }
        }
    }

}
