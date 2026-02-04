pageextension 50314 SalesPriceList_SP extends "Sales Price List"
{
    layout
    {
        addafter(CurrencyCode)
        {
            field("Shipment Method"; Rec."Shipment Method")
            {
                ApplicationArea = All;
            }
        }
    }

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
                    ToolTip = 'Import from Excel (Sales Price Line).';
                    trigger OnAction()
                    var
                        SalesPriceManagement: Codeunit SalesPriceManagement_SP;
                    begin
                        Clear(SalesPriceManagement);
                        SalesPriceManagement.importSalesPrice(Rec.Code);
                    end;
                }
                action(ZYEditInExcel)
                {
                    Caption = 'Edit in Excel (Lines)';
                    Image = Excel;
                    ToolTip = 'Send the data to an Excel file for analysis or editing.';
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        EditInExcel: Codeunit "Edit in Excel";
                        EditInExcelEdmType: Enum "Edit in Excel Edm Type";
                        EditinExcelFilters: Codeunit "Edit in Excel Filters";
                        EditInExcelFilterType: Enum "Edit in Excel Filter Type";
                    begin
                        Clear(EditinExcelFilters);
                        EditinExcelFilters.AddField('Price_List_Code', EditInExcelFilterType::Equal, Rec.Code, EditInExcelEdmType::"Edm.String");
                        EditInExcel.EditPageInExcel(CurrPage.Lines.Page.ObjectId(true), 7001, EditinExcelFilters);
                    end;
                }
            }
        }
    }
}
