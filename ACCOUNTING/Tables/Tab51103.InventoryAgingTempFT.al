table 51103 "Inventory Aging Temp FT"
{
    Caption = 'Inventory Aging Temp FT';
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; "RowID"; Integer)
        {
            Caption = 'Row ID';
        }
        field(2; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; ItemNo_; Code[20])
        {
            Caption = 'Item No.';
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(6; Balance; Decimal)
        {
            Caption = 'Balance';
        }
        field(7; Type; Text[100])
        {
            Caption = 'Entry Type';
        }
        field(8; Aging1; Decimal)
        {
            AutoFormatType = 1;
        }
        field(9; Aging2; Decimal)
        {
            AutoFormatType = 1;
        }
        field(10; Aging3; Decimal)
        {
            AutoFormatType = 1;
        }
        field(11; Aging4; Decimal)
        {
            AutoFormatType = 1;
        }
        field(12; Aging5; Decimal)
        {
            AutoFormatType = 1;
        }
        field(13; InventoryPostingGroup; Text[100])
        {

        }
        field(14; "Lot No"; Text[50])
        {

        }
        field(15; "Orig Doc. No"; Code[30])
        {

        }
        field(16; "Item Ledger Entry No."; Integer)
        {

        }
        field(17; "Inbound Entry No."; Integer)
        {

        }
        field(18; "Document Reff No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(19; "Date Doc. Reff"; Date)
        {
            Caption = 'Date Doc. Reff';
        }
        field(20; "Is Tracking Code (?)"; Boolean)
        {
            Caption = 'Is Tracking Code (?)';
        }
    }
    keys
    {
        key(PK; RowID)
        {
            Clustered = true;
        }
        key(AK; "Posting Date")
        {
            IncludedFields = "Document No.";
        }
        key(AK2; ItemNo_, "Posting Date", "Document No.")
        {

        }
    }
}
