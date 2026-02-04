report 50503 "Upd Posted Invt Shipment WE"
{
    Caption = 'Upd Posted Invt Shipment';
    Permissions = TableData "Invt. Shipment Header" = m;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Invt. Shipment Header"; "Invt. Shipment Header")
        {
            DataItemTableView = sorting("No.");

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                //initiate data item
                SetRange("No.", v_documentNo);
            end;

            trigger OnPostDataItem()
            var
                myInt: Integer;
            begin
                updInfoInvtShipmentHeader();
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    Caption = 'Options';
                    field(v_documentNo; v_documentNo)
                    {
                        Caption = 'No.';
                        Enabled = false;
                        ApplicationArea = Basic, Suite;
                    }
                    field(v_preparedbyNO; v_preparedbyNO)
                    {
                        Caption = 'Prepared By';
                        ApplicationArea = Basic, Suite;
                        TableRelation = Employee."No.";
                        trigger OnValidate()
                        var
                            myInt: Integer;
                            employee: Record Employee;
                        begin
                            if v_preparedbyNO <> '' then begin
                                Clear(employee);
                                employee.Reset();
                                employee.SetRange("No.", v_preparedbyNO);
                                if employee.Find('-') then begin
                                    v_preparedbyName := employee.FullName();
                                end;
                            end;
                        end;
                    }
                    field(v_preparedbyName; v_preparedbyName)
                    {
                        Caption = 'Prepared By Name';
                        Enabled = false;
                        ApplicationArea = Basic, Suite;
                    }
                    field(v_checkedbyNO; v_checkedbyNO)
                    {
                        Caption = 'Checked By';
                        ApplicationArea = Basic, Suite;
                        TableRelation = Employee."No.";
                        trigger OnValidate()
                        var
                            myInt: Integer;
                            employee: Record Employee;
                        begin
                            if v_checkedbyNO <> '' then begin
                                Clear(employee);
                                employee.Reset();
                                employee.SetRange("No.", v_checkedbyNO);
                                if employee.Find('-') then begin
                                    v_checkedbyName := employee.FullName();
                                end;
                            end;
                        end;
                    }
                    field(v_checkedbyName; v_checkedbyName)
                    {
                        Caption = 'Checked By Name';
                        ApplicationArea = Basic, Suite;
                        Enabled = false;
                    }
                    field(v_WarehousePersonbyNO; v_WarehousePersonbyNO)
                    {
                        Caption = 'Warehouse Person By';
                        ApplicationArea = Basic, Suite;
                        TableRelation = Employee."No.";
                        trigger OnValidate()
                        var
                            myInt: Integer;
                            employee: Record Employee;
                        begin
                            if v_WarehousePersonbyNO <> '' then begin
                                Clear(employee);
                                employee.Reset();
                                employee.SetRange("No.", v_WarehousePersonbyNO);
                                if employee.Find('-') then begin
                                    v_WarehousePersonbyName := employee.FullName();
                                end;
                            end;
                        end;
                    }
                    field(v_WarehousePersonbyName; v_WarehousePersonbyName)
                    {
                        Caption = 'Warehous Person Name';
                        Enabled = false;
                        ApplicationArea = Basic, Suite;
                    }
                    field(v_vendorNo; v_vendorNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Vendor No.';
                        TableRelation = Vendor."No.";
                        trigger OnValidate()
                        var
                            myInt: Integer;
                            vendor: Record Vendor;
                        begin
                            Clear(vendor);
                            Clear(v_vendorName);
                            vendor.SetRange("No.", v_vendorNo);
                            if vendor.Find('-') then
                                v_vendorName := vendor.Name;
                        end;
                    }
                    field(v_vendorName; v_vendorName)
                    {
                        ApplicationArea = All;
                        Caption = 'Vendor Name';
                        Enabled = false;
                    }

                }
            }
        }
        actions
        {
            area(Processing)
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


    local procedure updInfoInvtShipmentHeader()
    var
        invtShipmentHeader: Record "Invt. Shipment Header";
    begin
        Clear(invtShipmentHeader);
        invtShipmentHeader.Reset();
        invtShipmentHeader.SetRange("No.", v_documentNo);
        if invtShipmentHeader.Find('-') then begin
            v_OripreparedbyNO := invtShipmentHeader."Prepared By";
            v_OricheckedbyNO := invtShipmentHeader."Checked By";
            v_OriWarehousePersonbyNO := invtShipmentHeader."Warehouse Person";
            v_oriVendorNo := invtShipmentHeader."Vendor No.";
            invtShipmentHeader."Prepared By" := v_preparedbyNO;
            invtShipmentHeader."Checked By" := v_checkedbyNO;
            invtShipmentHeader."Warehouse Person" := v_WarehousePersonbyNO;
            invtShipmentHeader."Prepared By Name" := v_preparedbyName;
            invtShipmentHeader."Checked By Name" := v_checkedbyName;
            invtShipmentHeader."Warehouse Person Name" := v_WarehousePersonbyName;
            invtShipmentHeader."Vendor No." := v_vendorNo;
            invtShipmentHeader."Vendor Name" := v_vendorName;
            if (v_OripreparedbyNO <> v_preparedbyNO) OR (v_checkedbyNO <> v_OricheckedbyNO) OR (v_WarehousePersonbyNO <> v_OriWarehousePersonbyNO) OR (v_vendorNo <> v_oriVendorNo) then begin
                invtShipmentHeader.Modify();
                Commit();
            end
        end
    end;

    procedure setParam(var iInvtShipmentHeader: Record "Invt. Shipment Header")
    var
        myInt: Integer;
    begin

        if iInvtShipmentHeader."No." <> '' then begin
            v_documentNo := iInvtShipmentHeader."No.";
            v_preparedbyNO := iInvtShipmentHeader."Prepared By";
            v_checkedbyNO := iInvtShipmentHeader."Checked By";
            v_WarehousePersonbyNO := iInvtShipmentHeader."Warehouse Person";
            v_preparedbyName := iInvtShipmentHeader."Prepared By Name";
            v_checkedbyName := iInvtShipmentHeader."Checked By Name";
            v_WarehousePersonbyName := iInvtShipmentHeader."Warehouse Person Name";
            v_vendorNo := iInvtShipmentHeader."Vendor No.";
            v_vendorName := iInvtShipmentHeader."Vendor Name";
        end
    end;

    var
        v_vendorNo: Code[20];
        v_oriVendorNo: Code[20];
        v_vendorName: Text[150];
        v_documentNo: Text;
        v_preparedbyNO: Code[20];
        v_OripreparedbyNO: Code[20];
        v_WarehousePersonbyNO: Code[20];
        v_OriWarehousePersonbyNO: Code[20];
        v_checkedbyNO: Code[20];
        v_OricheckedbyNO: Code[20];
        v_preparedbyName: Text[100];
        v_WarehousePersonbyName: Text[100];
        v_checkedbyName: Text[100];

}
