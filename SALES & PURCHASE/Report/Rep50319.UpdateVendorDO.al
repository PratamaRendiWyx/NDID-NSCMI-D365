report 50319 "Update Vendo DO"
{
    Caption = 'Update Document - Vendor DO';
    Permissions = TableData "Posted DO Header" = rm;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Posted DO Header"; "Posted DO Header")
        {
            DataItemTableView = sorting("No.");

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                SetRange("No.", v_No);
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
                        Caption = 'No.';
                        Editable = false;
                        ApplicationArea = Basic, Suite;
                    }
                    field(v_PreparedBy; v_PreparedBy)
                    {
                        Caption = 'Prepared By';
                        ApplicationArea = Basic, Suite;
                        TableRelation = Employee."No.";
                        trigger OnValidate()
                        var
                            myInt: Integer;
                            employee: Record Employee;
                        begin
                            if v_PreparedBy <> '' then begin
                                Clear(employee);
                                employee.Reset();
                                employee.SetRange("No.", v_PreparedBy);
                                if employee.Find('-') then begin
                                    v_PreparedByName := employee.FullName();
                                end;
                            end;
                        end;
                    }
                    field(v_PreparedByName; v_PreparedByName)
                    {
                        Caption = 'Prepared By Name';
                        Editable = false;
                        ApplicationArea = Basic, Suite;
                    }
                    field(v_CheckedBy; v_CheckedBy)
                    {
                        Caption = 'Checked By';
                        ApplicationArea = Basic, Suite;
                        TableRelation = Employee."No.";
                        trigger OnValidate()
                        var
                            myInt: Integer;
                            employee: Record Employee;
                        begin
                            if v_CheckedBy <> '' then begin
                                Clear(employee);
                                employee.Reset();
                                employee.SetRange("No.", v_CheckedBy);
                                if employee.Find('-') then begin
                                    v_CheckedByName := employee.FullName();
                                end;
                            end;
                        end;
                    }
                    field(v_CheckedByName; v_CheckedByName)
                    {
                        Caption = 'Checked By Name';
                        Editable = false;
                        ApplicationArea = Basic, Suite;
                    }
                    field(v_WarehousePersonBy; v_WarehousePersonBy)
                    {
                        Caption = 'Warehouse Person';
                        ApplicationArea = Basic, Suite;
                        TableRelation = Employee."No.";
                        trigger OnValidate()
                        var
                            myInt: Integer;
                            employee: Record Employee;
                        begin
                            if v_WarehousePersonBy <> '' then begin
                                Clear(employee);
                                employee.Reset();
                                employee.SetRange("No.", v_WarehousePersonBy);
                                if employee.Find('-') then begin
                                    v_WarehousePersonName := employee.FullName();
                                end;
                            end;
                        end;
                    }
                    field(v_WarehousePersonName; v_WarehousePersonName)
                    {
                        Caption = 'Warehouse Person Name';
                        Editable = false;
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
        postedDOHeader.SetRange("No.", v_No);
        if postedDOHeader.FindSet() then begin
            postedDOHeader."Prepared By" := v_PreparedBy;
            postedDOHeader."Prepared By Name" := v_PreparedByName;
            postedDOHeader."Checked By" := v_CheckedBy;
            postedDOHeader."Checked By Name" := v_CheckedByName;
            postedDOHeader."Warehouse Person" := v_WarehousePersonBy;
            postedDOHeader."Warehouse Person Name" := v_WarehousePersonName;
            postedDOHeader.Modify();
        end;
    end;

    procedure setParam(var PostedDOHeader: Record "Posted DO Header")
    var
        myInt: Integer;
        WHTAmount: Decimal;
    begin
        if PostedDOHeader.Find('-') then begin
            if PostedDOHeader."No." <> '' then begin
                if PostedDOHeader.FindSet() then begin
                    v_No := PostedDOHeader."No.";
                    v_PreparedBy := PostedDOHeader."Prepared By";
                    v_PreparedByName := PostedDOHeader."Prepared By Name";
                    v_CheckedBy := PostedDOHeader."Checked By";
                    v_CheckedByName := PostedDOHeader."Checked By Name";
                    v_WarehousePersonBy := PostedDOHeader."Warehouse Person";
                    v_WarehousePersonName := PostedDOHeader."Warehouse Person Name";
                end;
            end
        end
    end;

    var
        v_remarks: Text[25];
        v_No: Code[20];
        v_PreparedBy: Text;
        v_PreparedByName: Text;
        v_CheckedBy: Text;
        v_CheckedByName: Text;
        v_WarehousePersonBy: Text;
        v_WarehousePersonName: Text;

}
