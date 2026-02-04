page 50502 "Packing Shipment Subform"
{
    ApplicationArea = All;
    Caption = 'Packing Shipment Subform';
    PageType = ListPart;
    SaveValues = true;
    SourceTable = "Pack. Lines";
    DataCaptionFields = "No.";
    // InsertAllowed = false;
    // DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Source Document"; Rec."Source Document")
                {
                    ApplicationArea = Warehouse;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = Warehouse;
                    Editable = glbManual Or Rec.Ismanual;
                    trigger OnLookup(Var Text: Text): Boolean
                    var
                        SalesLine: Record "Sales Line";
                        SalesLines: page "Sales Lines";
                        XData: Record "Sales Line";
                        Items: Record Item;
                    begin
                        if Rec."Source Document" = Rec."Source Document"::"Sales Order" then begin
                            Clear(SalesLines);
                            Clear(SalesLine);
                            Rec.CalcFields("Consignee Header");
                            SalesLines.SetRecord(SalesLine);
                            SalesLine.SetRange(Type, SalesLine.Type::Item);
                            SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                            SalesLine.SetRange("Sell-to Customer No.", Rec."Consignee Header");
                            SalesLines.SetTableView(SalesLine);
                            SalesLines.LookupMode := true;
                            if SalesLines.RunModal() = Action::LookupOK then begin
                                SalesLines.SetSelectionFilter(SalesLine);
                                if SalesLine.FindSet() then begin
                                    Rec."Source No." := SalesLine."Document No.";
                                    Rec."Source Line No." := SalesLine."Line No.";
                                    Rec."Item No." := SalesLine."No.";
                                    Rec.Description := SalesLine.Description;
                                    // Rec.Quantity := SalesLine.Quantity;
                                end;
                            end;
                        end;
                    end;
                }
                field("Source Line No."; Rec."Source Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Warehouse;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Warehouse;
                    Editable = Rec.Ismanual;
                }
                field("Package No."; Rec."Package No.")
                {
                    ApplicationArea = All;
                }
                field("Shipping Mark"; Rec."Shipping Mark")
                {
                    ApplicationArea = All;
                }
                field("Box Qty."; Rec."Box Qty.")
                {
                    ApplicationArea = All;
                }
                field("Qty to Handle"; Rec."Qty to Handle")
                {
                    ApplicationArea = All;
                }
                field("Customer PO No."; Rec."Customer PO No.")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Warehouse;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Warehouse;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Warehouse;
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    ApplicationArea = Warehouse;
                }
                //Addiional
                field("Nett Weight"; Rec."Nett Weight") { ApplicationArea = Warehouse; }
                field("Gross Weight"; Rec."Gross Weight")
                {
                    ApplicationArea = Warehouse;
                }
                field(Measurement; Rec.Measurement)
                {
                    ApplicationArea = Warehouse;
                }
                field(Ismanual; Rec.Ismanual)
                {
                    Caption = 'Is Manual (?)';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        Rec.CalcFields(Ismanual);
    end;

    trigger OnModifyRecord(): Boolean
    var
        myInt: Integer;
    begin
        Rec."Source Document" := Rec."Source Document"::"Sales Order";
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        myInt: Integer;
        PackHeader: Record "Pack. Header";
        PackLines: Record "Pack. Lines";
    begin
        Rec."Source Document" := Rec."Source Document"::"Sales Order";
        PackHeader.Reset();
        PackHeader.SetRange("No.", Rec."No.");
        if PackHeader.Find('-') then begin
            if PackHeader.IsManual then begin
                glbManual := true;
                PackLines.SetRange("No.", Rec."No.");
                if PackLines.FindLast() then;
                Rec."Line No." := PackLines."Line No." + 1;
            end;
        end;
    end;

    trigger OnDeleteRecord(): Boolean
    var
        myInt: Integer;
    begin
        Rec.CalcFields(Ismanual);
        if Not Rec.IsManual then
            Error('Can''t delete this document line cause not create by manual process.');
    end;

    var
        glbManual: Boolean;
}
