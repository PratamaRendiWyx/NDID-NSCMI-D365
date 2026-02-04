report 51107 "Update Data Posted Journal"
{
    Caption = 'Update Data Posted Gen. Journal';
    Permissions = TableData "Posted Gen. Journal Line" = rm,
    tabledata "G/L Entry" = rm,
    tabledata "Vendor Ledger Entry" = rm,
    tabledata "Cust. Ledger Entry" = rm;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Posted Gen. Journal Line"; "Posted Gen. Journal Line")
        {
            DataItemTableView = sorting("Document No.", "Posting Date");

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                if v_No <> '' then
                    SetFilter("Document No.", v_No)
                else
                    SetRange("Document No.", v_No);
            end;

            trigger OnPostDataItem()
            var
                myInt: Integer;
            begin
                if Confirm('Are you sure want to update the document ?') then
                    UpdateDocumentInfo();
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
                    Caption = 'Options';
                    field(v_No; v_No)
                    {
                        Caption = 'Document No.';
                        ApplicationArea = Basic, Suite;
                    }
                    field(v_PIBorPEB; v_PIBorPEB)
                    {
                        Caption = 'PIB/PEB No.';
                        ApplicationArea = Basic, Suite;
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

    local procedure UpdateDocumentInfo()
    var
        PostedGenJournalLine: Record "Posted Gen. Journal Line";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        CustomerLedgerEntry: Record "Cust. Ledger Entry";
        GlEntry: Record "G/L Entry";
        TempData: Text;
        CurrData: Text;
    begin
        //start action
        Clear(TempData);
        Clear(CurrData);
        Clear(PostedGenJournalLine);
        PostedGenJournalLine.SetFilter("Document No.", v_No);
        if PostedGenJournalLine.FindSet() then begin
            repeat
                //update per line 
                PostedGenJournalLine."PIB/PEB No" := v_PIBorPEB;
                PostedGenJournalLine.Modify();
                //-
                CurrData := PostedGenJournalLine."Document No.";
                if TempData <> CurrData then begin
                    //Vend
                    Clear(VendorLedgerEntry);
                    VendorLedgerEntry.SetRange("Document No.", PostedGenJournalLine."Document No.");
                    VendorLedgerEntry.ModifyAll("PIB/PEB No", v_PIBorPEB);
                    //Cust
                    Clear(CustomerLedgerEntry);
                    CustomerLedgerEntry.SetRange("Document No.", PostedGenJournalLine."Document No.");
                    CustomerLedgerEntry.ModifyAll("PIB/PEB No", v_PIBorPEB);
                    //GL
                    Clear(GlEntry);
                    GlEntry.SetRange("Document No.", PostedGenJournalLine."Document No.");
                    GlEntry.ModifyAll("PIB/PEB No", v_PIBorPEB);
                end;
                TempData := CurrData;
            until PostedGenJournalLine.Next() = 0;
        end;
    end;

    procedure setParam(var iPostedGenJourLine: Record "Posted Gen. Journal Line")
    var
        myInt: Integer;
        WHTAmount: Decimal;
    begin
        if iPostedGenJourLine.Find('-') then begin
            v_No := iPostedGenJourLine."Document No.";
        end
    end;

    var
        v_No: Text;
        v_PIBorPEB: Text;
}
