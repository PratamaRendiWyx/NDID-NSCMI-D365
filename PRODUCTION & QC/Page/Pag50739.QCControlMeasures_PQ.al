page 50739 QCControlMeasures_PQ
{
    // version QC10.1

    // //QC4.30  Added the field Result Type

    Caption = 'Quality Control Measures';
    DataCaptionFields = "No.",Description;
    PageType = List;
    SourceTable = QualityControlMeasures_PQ;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description;Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Result Type";Rec."Result Type")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Result List")
            {
                Caption = 'Result List';
                Image = SetupList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;                
                ToolTip = 'View Quality Measure Results';
                ApplicationArea = All;

                trigger OnAction()
                var
                    ResultPage : Page QualityMeasureResults_PQ;
                    Results: Record QCQualityMeasureOptions_PQ;
                begin
                    if Rec."Result Type" = Rec."Result Type"::List then begin
                        Results.SetRange("Quality Measure Code", Rec."No.");
                        ResultPage.SetTableView(Results);
                        ResultPage.Run();
                    end else
                        ERROR(QCText000);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        //Registration();
    end; 


    
/*  local procedure Registration()
    var
        RegistrationPage: Page "AM Registration";
        Registration: Codeunit "AM QC Registration";
        RegisteredModules: Text;
        ResultCode: Integer;
        ResultText: Text;
        EnvironmentInfo: Codeunit "Environment Information";
        QCType: Option "Quality Control","Quality Control in-process";
    begin
        Clear(Registration);
        Clear(RegistrationPage);
        Clear(RegisteredModules);
        Clear(ResultCode);
        Clear(ResultText);

        //Skip registration for OnPremise installation
        if EnvironmentInfo.IsOnPrem() then
        exit;
        
        Registration.GetProductRegistered('Quality Control', RegisteredModules, ResultCode, ResultText);
        if (ResultCode <> 1) then begin
            if (ResultCode = 98) or (ResultCode = 96) then begin
                RegistrationPage.SetProperties(QCType::"Quality Control");
                RegistrationPage.RunModal();
                if Registration.GetRegisteredResult() <> 10 then
                    CurrPage.Editable := false;
            end
            else begin
                if (ResultCode = 11) or (ResultCode = 12) then
                    message(ResultText);
                CurrPage.Editable := false;
            end;
        end
        else begin
            CurrPage.Editable := true;
        end;
    end;  */

    var
        QCText000 : Label 'The Quality Measure must be a Result Type of List.';
}

