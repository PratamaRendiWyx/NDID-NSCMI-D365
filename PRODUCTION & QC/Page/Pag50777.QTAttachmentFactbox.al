page 50777 "QT Attachment Factbox"
{
    Caption = 'QT Attachment Factbox';
    PageType = CardPart;
    SourceTable = QualityTestHeader_PQ;

    layout
    {
        area(Content)
        {
            field(Attachments; NoOfAttachments)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'No. of Attached Documents';

                trigger OnDrillDown()
                var
                    Recs_DocAtch: Record "Document Attachment";
                begin
                    Clear(Page_StudentAttachment);
                    Clear(Recs_DocAtch);
                    Recs_DocAtch.Reset();
                    Recs_DocAtch.SetRange("No.", Rec."Test No.");
                    if Recs_DocAtch.FindFirst() then;
                    Page_StudentAttachment.SetRecord(Recs_DocAtch);
                    Page_StudentAttachment.SetTableView(Recs_DocAtch);
                    Page_StudentAttachment.RunModal();
                    Clear(Rec_DocumentAttachment);
                    Clear(NoOfAttachments);
                    Rec_DocumentAttachment.Reset();
                    Rec_DocumentAttachment.SetRange("No.", Rec."Test No.");
                    if Rec_DocumentAttachment.FindSet() then
                        NoOfAttachments := Rec_DocumentAttachment.Count;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Clear(NoOfAttachments);
        Clear(Rec_DocumentAttachment);
        Rec_DocumentAttachment.Reset();
        Rec_DocumentAttachment.SetRange("No.", Rec."Test No.");
        if Rec_DocumentAttachment.FindSet() then
            NoOfAttachments := Rec_DocumentAttachment.Count;
    end;

    var
        NoOfAttachments: Integer;
        Rec_DocumentAttachment: Record "Document Attachment";
        Page_StudentAttachment: Page "QT Attachments"; // Your Page Name Here
}
