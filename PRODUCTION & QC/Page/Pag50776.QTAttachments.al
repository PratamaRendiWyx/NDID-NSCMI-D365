page 50776 "QT Attachments"
{
    ApplicationArea = All;
    Caption = 'Attachments';
    SourceTable = "Document Attachment";
    PageType = List;
    SourceTableView = order(descending);
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = All;
                    Editable = false;

                    // Logic for import/export the file when user click on the filename 
                    trigger OnDrillDown()
                    var
                        FromRecRef: RecordRef;
                        FileName: Text;
                        cu_FileManagement: Codeunit "File Management";
                        TempBlob: Codeunit "Temp Blob";
                        ImportTxt: Label 'Attach a document.';
                        FileDialogTxt: Label 'Tab Attachments (%1)|%1';
                        FilterTxt: Label '*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*';
                    begin
                        QTHeaderRecs.SetRange("Test No.", Rec."No.");
                        if QTHeaderRecs.FindFirst() then;
                        FromRecRef.GetTable(QTHeaderRecs);
                        if Rec."Document Reference ID".HasValue then
                            ExportFile(true)
                        else begin
                            FileName := cu_FileManagement.BLOBImportWithFilter(TempBlob, ImportTxt, FileName, STRSUBSTNO(FileDialogTxt, FilterTxt), FilterTxt);
                            // Now Call SaveAttachment method to save the selected file
                            importFileAsAttachment(FromRecRef, FileName, TempBlob, QTHeaderRecs."Test No."); // Change 3
                            CurrPage.Update(false);
                        end;
                    end;
                }
                field("File Type"; Rec."File Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("File Extension"; Rec."File Extension")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(User; Rec.User)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Attached Date"; Rec."Attached Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        //Message('Any pop-up for the user.');
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
    begin
        // Any default values when attachment list page shown
        Rec."File Name" := SelectFileText;
        //Rec."Document Type" := Rec."Document Type"::Order;
    end;

    // Method: Export attached documents
    procedure ExportFile(ShowFileDialog: Boolean): Text
    var
        FullFileName: Text;
        TempBlob: Codeunit "Temp Blob";
        DocOutStream: OutStream;
        cu_FileManagement: Codeunit "File Management";
    begin
        if Rec.ID = 0 then
            exit;
        // Ensure document has value in DB
        if not Rec."Document Reference ID".HasValue then
            exit;

        // Get Complete File name including it's extension
        FullFileName := Rec."File Name" + '.' + Rec."File Extension";

        // Now use Tempblob to export this file
        TempBlob.CreateOutStream(DocOutStream);
        Rec."Document Reference ID".ExportStream(DocOutStream);

        // export the file
        exit(cu_FileManagement.BLOBExport(TempBlob, FullFileName, ShowFileDialog));
    end;



    // Method: Attach a document
    procedure importFileAsAttachment(RecRef: RecordRef; FileName: Text; TempBlob: Codeunit "Temp Blob"; QTHeaderID: Code[20])
    var
        IncomingFileName2: Text;
        DocStream2: Instream;
        EmptyFileNameErr: Label 'No content';
        FileManagement: Codeunit "File Management";
        NoDocumentAttachedErr: Label 'No document attached';
        FieldRef: FieldRef;
        LineNo: Integer;
        Rec_Document: Record "Document Attachment";
        Rec_Attachment: Record "Document Attachment";
    begin
        IF FileName = '' THEN
            ERROR(EmptyFileNameErr);
        // Validate file/media is not empty
        IF NOT TempBlob.HasValue THEN
            ERROR(EmptyFileNameErr);
        IncomingFileName2 := FileName;
        Clear(Rec_Attachment);
        Rec_Attachment.Reset();
        Rec_Attachment.INIT;
        Rec_Attachment.VALIDATE("File Extension", FileManagement.GetExtension(IncomingFileName2));
        Rec_Attachment.VALIDATE("File Name", COPYSTR(FileManagement.GetFileNameWithoutExtension(IncomingFileName2), 1, MAXSTRLEN(Rec."File Name")));
        // My Custom Field Codes
        /*
        Rec_Attachment.Validate("You custom field name", ValueForCustomField);        
        */
        Rec_Attachment.VALIDATE("Table ID", RecRef.NUMBER);
        Rec_Attachment.Validate("No.", QTHeaderRecs."Test No."); // Give your table field by which you are attaching documents [table unique field]
        TempBlob.CREATEINSTREAM(DocStream2);
        Rec_Attachment."Document Reference ID".IMPORTSTREAM(DocStream2, '', IncomingFileName2);
        IF NOT Rec_Attachment."Document Reference ID".HASVALUE THEN
            ERROR(NoDocumentAttachedErr);
        CASE RecRef.NUMBER OF
            DATABASE::QualityTestHeader_PQ: // Give your table name here for which you are attaching a document
                BEGIN
                    //FieldRef := RecRef.FIELD(1);                    
                    FieldRef := RecRef.FIELD(2); // Give your field No.
                    // Question: Why 2 Here? [Answer: Because I am using ID field of QTHeader table and field id for this field is 3 in my QTHeader table]
                    Clear(Rec_Document);
                    Rec_Document.SetRange("Table ID", RecRef.Number);
                    Rec_Document.SetRange("No.", QTHeaderRecs."Test No."); // YOur custom table field name
                    IF Rec_Document.FindLast() then begin
                        Rec_Attachment.Validate("Line No.", Rec_Document."Line No." + 1000);
                    end
                    else begin
                        Rec_Attachment.Validate("Line No.", 1000);
                    end;

                END;
        END;
        Rec_Attachment.INSERT(TRUE);
    end;

    var
        QTHeaderRecs: Record QualityTestHeader_PQ;
        SelectFileText: Label 'Select File...';
}
