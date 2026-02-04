pageextension 50507 InvtReceipt_WE extends "Invt. Receipt"
{

    Caption = 'Inventory Output';
    
    layout
    {
        // Add changes to page layout here

    
      modify(Control1900309501)
      {
        Visible=false;
      }

     modify("Gen. Bus. Posting Group")
      {
        Caption ='Process Type';
      }
      
      addbefore(Status)
      {
        field(Remarks;Rec.Remarks)
        {
            ApplicationArea =ALL;
            MultiLine = true;
        }
      }

      addafter("No.")
      {
          field(IsSubcon;Rec.IsSubcon)
          {
                ApplicationArea = All;
          }
          field("Vendor No.";Rec."Vendor No.")
          {
              ApplicationArea = All;
              Enabled = Rec.IsSubcon;
          }
          field("Vendor Name";Rec."Vendor Name")
          {
              ApplicationArea = All;
              Enabled = false;
          }
      }
    }
    
    actions
    {
        // Add changes to page actions here
    }
    
}