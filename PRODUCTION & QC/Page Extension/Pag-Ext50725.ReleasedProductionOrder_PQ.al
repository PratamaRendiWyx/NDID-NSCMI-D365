pageextension 50725 ReleasedProductionOrder_PQ extends "Released Production Order"
{
    layout
    {
        modify("Source No.")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                restrictLine();
            end;
        }
        addafter(Quantity)
        {
            field("Is Subcon (?)"; Rec."Is Subcon (?)")
            {
                ApplicationArea = All;
            }
        }
        addfirst(FactBoxes)
        {
            part(Control1240070002; QualityTestFactbox_PQ)
            {
                Caption = 'Quality Test';
                ApplicationArea = All;
                SubPageLink = "Item No." = field("Source No."),
                          "Source No." = field("No."),
                          "Source Type" = const("Production Order");
            }
        }

        addlast(General)
        {
            field("Creation Date"; Rec."Creation Date")
            {
                Caption = 'Creation Date';
                ApplicationArea = All;
            }
            field(Status; Rec.Status)
            {
                Caption = 'Status';
                ApplicationArea = All;
                Editable = false;
                Style = Strong;
                StyleExpr = TRUE;
            }
        }
        addafter(Status)
        {
            field("Is Substitute (?)"; Rec."Is Substitute (?)")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Production Status"; Rec."Production Status")
            {
                ApplicationArea = All;
                Enabled = glbRestric;
            }
            field(Shift; Rec.Shift)
            {
                ApplicationArea = All;
                Caption = 'Shift Code';
                Enabled = glbRestric;
                trigger OnValidate()
                var
                    myInt: Integer;
                    workShift: Record "Work Shift";
                    startDate: Date;
                    StartDateTime: DateTime;
                    TempDate: Date;
                begin
                    Clear(TempDate);
                    Clear(startDate);
                    Clear(workShift);
                    Clear(ProdOrderManagement);
                    workShift.SetRange(Code, Rec.Shift);
                    if workShift.Find('-') then begin
                        if Rec."Start Date-Time (Production)" = 0DT then begin
                            startDate := WorkDate();
                        end else begin
                            startDate := DT2Date(Rec."Start Date-Time (Production)");
                        end;
                        //set time
                        StartDateTime := CreateDateTime(startDate, workShift."Starting Time");
                        Rec."Start Date-Time (Production)" := StartDateTime;
                        if workShift."Starting Time" > workShift."Ending Time" then begin
                            TempDate := ProdOrderManagement.findCurrWorkDate(startDate) + 1;
                            Rec."End Date-Time (Production)" := CreateDateTime(TempDate, workShift."Ending Time");
                        end else begin
                            Rec."End Date-Time (Production)" := CreateDateTime(startDate, workShift."Ending Time");
                        end;
                        //-
                    end;
                end;
            }
            field("Production Line"; Rec."Production Line")
            {
                ApplicationArea = All;
                Caption = 'Production Line';
                Enabled = glbRestric;
            }
            field("Capacity Line"; Rec."Capacity Line")
            {
                ApplicationArea = All;
                Caption = 'Capacity Line';
                Enabled = glbRestric;
            }
        }
        //Add mod 19 Feb 2025
        modify("Due Date")
        {
            Visible = false;
        }
        modify("Starting Date-Time")
        {
            Visible = false;
        }
        modify("Ending Date-Time")
        {
            Visible = false;
        }
        addafter("Due Date")
        {
            field("Start Date-Time (Production)"; Rec."Start Date-Time (Production)")
            {
                ApplicationArea = All;
                trigger OnValidate()
                var
                    myInt: Integer;
                    myDateTime: DateTime;
                    newDateTime: DateTime;
                    inputHours: Decimal;
                    hours: Integer;
                    minutes: Integer;
                    totalMinutes: Decimal;
                    WorkShiftVacumCycle: Record "Work Shift Vacum Cycle";
                begin
                    if Rec."Vacum Cycle" <> '' then begin
                        Clear(WorkShiftVacumCycle);
                        WorkShiftVacumCycle.Reset();
                        WorkShiftVacumCycle.SetRange("Shift Code", Rec.Shift);
                        WorkShiftVacumCycle.SetRange(Cycle, Rec."Vacum Cycle");
                        if WorkShiftVacumCycle.Find('-') then begin
                            // Assign the current DateTime value
                            myDateTime := Rec."Start Date-Time (Production)";
                            // Input value (6.5 hours)
                            inputHours := WorkShiftVacumCycle."Default Run Time";
                            // Convert the decimal hours to integer hours and minutes
                            hours := inputHours Div 1;
                            minutes := Round((inputHours Mod 1) * 60);
                            // Add the hours and minutes to the DateTime
                            totalMinutes := (hours * 60) + minutes;
                            // Add the total minutes to the DateTime
                            newDateTime := myDateTime + (totalMinutes * 60000); // 60000 ms in a minute
                            Rec."End Date-Time (Production)" := newDateTime;
                        end;
                    end;
                end;
            }
            field("End Date-Time (Production)"; Rec."End Date-Time (Production)")
            {
                ApplicationArea = All;
            }
            field("Vacum Cycle"; Rec."Vacum Cycle")
            {
                ApplicationArea = All;
            }

            field(Remarks; Rec.Remarks)
            {
                ApplicationArea = All;
                MultiLine = true;
            }
        }
        modify(Schedule)
        {
            Visible = false;
        }
        //-
    }

    actions
    {
        addlast(Navigation)
        {
            action(ProdCompRouting)
            {
                ApplicationArea = All;
                Caption = 'Prod Comp. Routing';
                Image = PrintAcknowledgement;
                ToolTip = 'Print Production Component Routing.';
                trigger OnAction()
                var
                    prodOrder: Record "Production Order";
                begin
                    prodOrder.SetFilter("No.", Rec."No.");
                    prodOrder.SetRange(Status, Rec.Status);
                    REPORT.Run(REPORT::"Prod. Order Comp. and Rtg.", true, false, prodOrder);
                end;
            }

        }
        modify("Item Ledger E&ntries")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Process;
        }
        modify("Capacity Ledger Entries")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Process;
        }

    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        restrictLine();
    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        restrictLine();
    end;

    local procedure restrictLine()
    begin
        glbRestric := true;
        // Rec.CalcFields("Is Subcon (?)");
        // if Rec."Is Subcon (?)" then
        //     glbRestric := false;
    end;

    var
        ProdOrderManagement: Codeunit ProdOrderManagement_PQ;
        glbRestric: Boolean;
}

