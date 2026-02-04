page 50713 QCControlMethods_PQ
{
    // version QC10.1

    Caption = 'Quality Control Methods';
    DataCaptionFields = "No.", Description;
    PageType = List;
    SourceTable = QualityControlMethods_PQ;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Provides the Method number for the Quality Control Method';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Displays the description of the Quality Control Method';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

