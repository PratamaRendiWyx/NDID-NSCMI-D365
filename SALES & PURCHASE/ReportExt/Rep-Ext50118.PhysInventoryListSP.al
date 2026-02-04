reportextension 50300 "Phys. Inventory List_SP" extends "Phys. Inventory List"
{
    RDLCLayout = './ReportDesign/PhysInventoryList.rdlc';
    dataset
    {
        add("Item Journal Line")
        {
            column(USDFS_Code; "USDFS Code")
            {

            }
        }
    }
}
