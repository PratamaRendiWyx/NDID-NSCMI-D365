table 50306 "BOPManualHeader_SP"
{
    Caption = 'Manual BOP Document Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    QCSetup.Get();
                    NoSeries.TestManual(QCSetup."Manual BOP Document No Series");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestField("Status Approval", "Status Approval"::Open);
            end;
        }
        field(3; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                Cust: Record Customer;
            begin
                TestField("Status Approval", "Status Approval"::Open);
                if Cust.Get("Customer No.") then
                    "Customer Name" := Cust.Name
                else
                    "Customer Name" := '';
            end;
        }
        field(4; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(5; "Status Approval"; Enum "Status Approval Shipment Lines")
        {
            Caption = 'Status Approval';
            DataClassification = CustomerContent;
        }
        field(6; "QC By"; Code[50])
        {
            Caption = 'QC By';
            TableRelation = "User Setup";
            DataClassification = EndUserIdentifiableInformation;
        }
        field(7; "Approval By"; Code[50])
        {
            Caption = 'Approval By';
            TableRelation = "User Setup";
            DataClassification = EndUserIdentifiableInformation;
        }
        field(8; "Comment QC Worker"; Text[250])
        {
            Caption = 'Comment QC Worker';
            DataClassification = CustomerContent;
        }
        field(9; "Comment (Approver)"; Text[250])
        {
            Caption = 'Comment (Approver)';
            DataClassification = CustomerContent;
        }
        field(10; "QC Date"; Date)
        {
            Caption = 'QC Date';
            DataClassification = CustomerContent;
        }
        field(11; "Approval Date"; Date)
        {
            Caption = 'Approval Date';
            DataClassification = CustomerContent;
        }
        field(12; "Customer PO No."; Code[50])
        {
            Caption = 'Customer PO No.';
            DataClassification = CustomerContent;
        }
        field(13; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    var
        QCSetup: Record "QCSetup_PQ";
        NoSeries: Codeunit "No. Series"; // Tetap pakai modul baru

    trigger OnInsert()
    begin
        if "No." = '' then begin
            QCSetup.Get();
            QCSetup.TestField("Manual BOP Document No Series");
            if NoSeries.AreRelated(QCSetup."Manual BOP Document No Series", xRec."No. Series") then
                "No. Series" := xRec."No. Series"
            else
                "No. Series" := QCSetup."Manual BOP Document No Series";
            "No." := NoSeries.GetNextNo("No. Series");
        end;
    end;
}