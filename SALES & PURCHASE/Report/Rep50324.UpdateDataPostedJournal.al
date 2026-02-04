/*report 50324 "Update Data Posted Journal"
{
    Caption = 'Update Data Posted Gen. Journal';
    Permissions = TableData "Posted Gen. Journal Line" = rm;
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
                    SetFilter("Document No.", '%1', v_No)
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
                        Editable = false;
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
        postedDOHeader: Record "Posted DO Header";
    begin
        //start action
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
        v_No: Code[20];
        v_PIBorPEB: Text;
}
*/