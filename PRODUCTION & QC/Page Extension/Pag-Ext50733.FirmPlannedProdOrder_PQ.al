pageextension 50733 FirmPlannedProdOrder_PQ extends "Firm Planned Prod. Order"
{

    PromotedActionCategories = 'New,Process,Report,Order,Functions,Print,Reports';
    layout
    {
        modify("Source No.")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                restrictVisible();
            end;
        }
        addafter(Quantity)
        {
            field("Is Subcon (?)"; Rec."Is Subcon (?)")
            {
                ApplicationArea = All;
            }
        }

        addafter("Last Date Modified")
        {
            field(Status; Rec.Status)
            {
                Caption = 'Status';
                ApplicationArea = All;
                Editable = false;
                Style = Strong;
                StyleExpr = TRUE;
            }
            field("Preparing Status"; Rec."Preparing Status")
            {
                ApplicationArea = All;
                Enabled = glbRestric;
            }

            field(Remarks; Rec.Remarks)
            {
                ApplicationArea = All;
                MultiLine = true;
            }


        }

        addafter(Status)
        {
            field("Is Substitute (?)"; Rec."Is Substitute (?)")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Production Line"; Rec."Production Line")
            {
                ApplicationArea = All;
                Caption = 'Production Line';
            }
            field("Capacity Line"; Rec."Capacity Line")
            {
                ApplicationArea = All;
                Caption = 'Capacity Line';
            }
        }

        addfirst(FactBoxes)
        {
            // part("Attached Documents"; "Document Attachment Factbox")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Attachments';
            //     SubPageLink = "Table ID" = CONST(5405),
            //                   "No." = FIELD("No."),
            //                   "Production Order Status" = FIELD(Status);
            // }
            part(Control1240070000; ExpectedCostFactbox_PQ)
            {
                Caption = 'Expected Cost Factbox';
                ApplicationArea = All;
                SubPageLink = Status = FIELD(Status),
                              "No." = FIELD("No.");
            }
            part(Control1240070003; ActualCostFactbox_PQ)
            {
                Caption = 'Actual Cost Factbox';
                ApplicationArea = All;
                SubPageLink = Status = FIELD(Status),
                              "No." = FIELD("No.");
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

            field(Shift; Rec.Shift)
            {
                ApplicationArea = All;
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
        }
        modify(Schedule)
        {
            Visible = false;
        }
        //-
    }
    actions
    {
        modify("Co&mments")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Category4;
        }
        modify(Dimensions)
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Category4;
        }
        modify(Statistics)
        {
            Promoted = true;
            PromotedCategory = Category4;
            PromotedIsBig = true;
        }
        modify("Plannin&g")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Category4;
        }
        modify("Re&fresh Production Order")
        {
            Promoted = true;
            PromotedCategory = Category5;
            PromotedIsBig = true;
        }
        modify("Re&plan")
        {
            Promoted = true;
            PromotedCategory = Category5;
            PromotedIsBig = true;
        }
        modify("Change &Status")
        {
            Promoted = true;
            PromotedCategory = Category5;
            PromotedIsBig = true;
        }
        modify("&Update Unit Cost")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Category5;
        }
        modify("C&opy Prod. Order Document")
        {
            Promoted = true;
            PromotedCategory = Category5;
            PromotedIsBig = true;
        }
        modify("Job Card")
        {
            Promoted = true;
            PromotedCategory = Category6;
            PromotedIsBig = true;
        }
        modify("Mat. &Requisition")
        {
            Promoted = true;
            PromotedCategory = Category6;
            PromotedIsBig = true;
        }
        modify("Shortage List")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Category6;
        }
        modify("Subcontractor - Dispatch List")
        {
            Promoted = true;
            PromotedCategory = Category7;
            PromotedIsBig = true;
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        restrictVisible();
    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        restrictVisible();
    end;

    local procedure restrictVisible()
    begin
        glbRestric := true;
        Rec.CalcFields("Is Subcon (?)");
        if Rec."Is Subcon (?)" then
            glbRestric := false;
    end;

    var
        ProdOrderManagement: Codeunit ProdOrderManagement_PQ;
        glbRestric: Boolean;
}

