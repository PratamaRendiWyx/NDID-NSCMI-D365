page 50501 "Packing Shipment"
{
    ApplicationArea = All;
    Caption = 'Packing Shipment Order';
    PageType = Document;
    SourceTable = "Pack. Header";
    RefreshOnActivate = true;
    // InsertAllowed = false;
    // DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = Warehouse;
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Warehouse;
                    Editable = Rec.IsManual;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Warehouse;
                    Editable = Rec.IsManual;
                }
                field("Zone Code"; Rec."Zone Code")
                {
                    ApplicationArea = Warehouse;
                    Editable = Rec.IsManual;
                }
                field("Sorting Method"; Rec."Sorting Method")
                {
                    ApplicationArea = Warehouse;
                    Editable = Rec.IsManual;
                }
                field("Delivery Type"; Rec."Delivery Type")
                {
                    ApplicationArea = Warehouse;
                }
                field(Consignee; Rec.Consignee)
                {
                    ApplicationArea = Warehouse;
                }
                field("Consignee Name"; Rec."Consignee Name")
                {
                    ApplicationArea = Warehouse;
                }
                field("Consignee Address"; Rec."Consignee Address")
                {
                    ApplicationArea = Warehouse;
                }
                field("Consignee Address2"; Rec."Consignee Address2")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Consignee Address 2';
                }
                field("Consignee Phone"; Rec."Consignee Phone")
                {
                    ApplicationArea = Warehouse;
                }
                field("Consignee Phone2"; Rec."Consignee Phone2")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Consignee Phone 2';
                }
                // Additional
                field("Port of Loading"; Rec."Port of Loading")
                {
                    ApplicationArea = Warehouse;
                }
                field("Port of Discharge"; Rec."Port of Discharge")
                {
                    ApplicationArea = Warehouse;
                }
                field("Name of Vessel"; Rec."Name of Vessel")
                {
                    ApplicationArea = Warehouse;
                }
                field(ETD; Rec.ETD)
                {
                    ApplicationArea = Warehouse;
                }
                field(ETA; Rec.ETA)
                {
                    ApplicationArea = Warehouse;
                }
                field("PO No."; Rec."PO No.")
                {
                    ApplicationArea = Warehouse;
                    MultiLine = true;
                }
                field(Invoice; Rec.Invoice)
                {
                    ApplicationArea = Warehouse;
                }
                field(Terms; Rec.Terms)
                {
                    ApplicationArea = Warehouse;
                }
                field("Country of Origin"; Rec."Country of Origin")
                {
                    ApplicationArea = Warehouse;
                }
            }
            part(PackingSubform; "Packing Shipment Subform")
            {
                ApplicationArea = Warehouse;
                Caption = 'Lines';
                SubPageLink = "No." = FIELD("No.");
                SubPageView = SORTING("No.", "Source Document", "Source No.", "Line No.")
                              ORDER(Ascending);
                Editable = Rec.IsManual;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("P&osting")
            {
                action(Cancel)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel';
                    Ellipsis = true;
                    Image = CancelAllLines;
                    ShortCutKey = 'F9';
                    ToolTip = 'Cancel Packing Order';
                    Enabled = (not Rec."IsCancel");
                    trigger OnAction()
                    var
                        myInt: Integer;
                        PackingMgmnt: Codeunit "Packing List Mgmnt.";
                    begin
                        // do cancel 
                        Clear(PackingMgmnt);
                        PackingMgmnt.cancelPackingListOrder(Rec."No.");
                        CurrPage.Update();
                    end;
                }
            }
            action(Print)
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                ToolTip = 'Print document.';
                trigger OnAction()
                var
                    PackHeader: Record "Pack. Header";
                begin
                    CurrPage.SetSelectionFilter(PackHeader);
                    REPORT.Run(REPORT::"Packing Shipment", true, false, PackHeader);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(Print_Promoted; Print)
                {
                }
                actionref(CancelPromoted; Cancel)
                {

                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        myInt: Integer;
    begin
        Rec.IsManual := true;
        Rec."Posting Date" := WorkDate();
        Rec.Status := Rec.Status::Released;
    end;
}
