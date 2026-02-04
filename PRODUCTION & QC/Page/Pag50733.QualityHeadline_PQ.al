page 50733 QualityHeadline_PQ
{
    // NOTE: If you are making changes to this page you might want to make changes to all the other Headline RC pages

    Caption = 'Headline';
    PageType = HeadlinePart;
    RefreshOnActivate = true;
    SourceTable = QualityHeadline_PQ;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                Visible = UserGreetingVisible;
                field(GreetingText; GreetingText)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Greeting headline';
                    Editable = false;
                }
            }
            group(Control2)
            {
                ShowCaption = false;
                Visible = DefaultFieldsVisible;
                field(DocumentationText; DocumentationText)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Documentation headline';
                    DrillDown = true;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        Page.RunModal(Page::QualityControlSetup_PQ);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        Uninitialized: Boolean;
    begin
         if not Rec.Get() then
            if Rec.WritePermission() then begin
                Rec.Init();
                Rec.Insert();
            end else 
                Uninitialized := true;

        if not Uninitialized and Rec.WritePermission then begin
            Rec."Workdate for computations" := WorkDate();
            Rec.Modify();
            //HeadlineManagement.ScheduleTask(Codeunit::"AM Quality Headline Manager");
        end; 

        GreetingText := HeadlineManagement.GetUserGreetingText();
        DocumentationText := DocumentationTxt;

        IF Uninitialized THEN
            // table is uninitialized because of permission issues. OnAfterGetRecord won't be called
            ComputeDefaultFieldsVisibility;

        Commit; // not to mess up the other page parts that may do IF CODEUNIT.RUN()
    end;

    trigger OnAfterGetRecord()
    begin
        ComputeDefaultFieldsVisibility;
    end;

    local procedure ComputeDefaultFieldsVisibility()
    var
        ExtensionHeadlinesVisible: Boolean;
    begin
        OnIsAnyExtensionHeadlineVisible(ExtensionHeadlinesVisible);
        DefaultFieldsVisible := not ExtensionHeadlinesVisible;
        UserGreetingVisible := HeadlineManagement.ShouldUserGreetingBeVisible;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnIsAnyExtensionHeadlineVisible(var ExtensionHeadlinesVisible: Boolean)
    begin

    end;

    var
        [InDataSet]
        DefaultFieldsVisible: Boolean;
        [InDataSet]
        GreetingText: Text[250];
        DocumentationText: Text[250];
        UserGreetingVisible: Boolean;
        HeadlineManagement: Codeunit Headlines;
        DocumentationTxt: Label 'Thank you for installing Quality Control. Now let''s set it up.';
}