codeunit 50502 "Warehouse Management"
{
    procedure getInfoEmployeeWseshipment(iSJNo: Code[20]; iOption: Integer): Text
    var
        postedWarehouseShipment: Record "Posted Whse. Shipment Header";
        postedWarehouseShipmentLine: Record "Posted Whse. Shipment Line";
    begin
        Clear(postedWarehouseShipmentLine);
        postedWarehouseShipmentLine.SetRange("Posted Source No.", iSJNo);
        postedWarehouseShipmentLine.SetRange("Posted Source Document", postedWarehouseShipmentLine."Posted Source Document"::"Posted Shipment");
        if postedWarehouseShipmentLine.Find('-') then begin
            Clear(postedWarehouseShipment);
            postedWarehouseShipment.SetRange("No.", postedWarehouseShipmentLine."No.");
            if postedWarehouseShipment.Find('-') then begin
                case iOption of
                    0:
                        begin
                            exit(postedWarehouseShipment."Prepared By");
                        end;
                    1:
                        begin
                            exit(postedWarehouseShipment."Checked By");
                        end;
                    2:
                        begin
                            exit(postedWarehouseShipment."Warehouse Person");
                        end;
                end;
            end;
        end;
    end;

    procedure getInfoGenWseshipment(iSJNo: Code[20]; iOption: Integer): Text
    var
        postedWarehouseShipment: Record "Posted Whse. Shipment Header";
        postedWarehouseShipmentLine: Record "Posted Whse. Shipment Line";
    begin
        Clear(postedWarehouseShipmentLine);
        postedWarehouseShipmentLine.SetRange("Posted Source No.", iSJNo);
        postedWarehouseShipmentLine.SetRange("Posted Source Document", postedWarehouseShipmentLine."Posted Source Document"::"Posted Shipment");
        if postedWarehouseShipmentLine.Find('-') then begin
            Clear(postedWarehouseShipment);
            postedWarehouseShipment.SetRange("No.", postedWarehouseShipmentLine."No.");
            if postedWarehouseShipment.Find('-') then begin
                case iOption of
                    0:
                        begin
                            exit(postedWarehouseShipment."Trucking No.");
                        end;
                end;
            end;
        end;
    end;

    procedure getinfoEmployeeName(iNo: Code[20]): Text
    var
        employee: Record Employee;
    begin
        Clear(employee);
        employee.SetRange("No.", iNo);
        if employee.Find('-') then
            exit(employee.FullName());
        exit('');
    end;
}
