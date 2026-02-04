table 50729 ReservationEntryBuffer_PQ
{
    Caption = 'Reservation Entry Buffer';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            DataClassification = CustomerContent;
        }
        field(3; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
            DataClassification = CustomerContent;
        }
        field(4; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(5; "Reservation Status"; Enum "Reservation Status")
        {
            Caption = 'Reservation Status';
            DataClassification = CustomerContent;
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(8; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            DataClassification = CustomerContent;
        }
        field(9; "Transferred from Entry No."; Integer)
        {
            Caption = 'Transferred from Entry No.';
            TableRelation = "Reservation Entry";
            DataClassification = CustomerContent;
        }
        field(10; "Source Type"; Integer)
        {
            Caption = 'Source Type';
            DataClassification = CustomerContent;
        }
        field(11; "Source Subtype"; Option)
        {
            Caption = 'Source Subtype';
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
            DataClassification = CustomerContent;
        }
        field(12; "Source ID"; Code[20])
        {
            Caption = 'Source ID';
            DataClassification = CustomerContent;
        }
        field(13; "Source Batch Name"; Code[10])
        {
            Caption = 'Source Batch Name';
            DataClassification = CustomerContent;
        }
        field(14; "Source Prod. Order Line"; Integer)
        {
            Caption = 'Source Prod. Order Line';
            DataClassification = CustomerContent;
        }
        field(15; "Source Ref. No."; Integer)
        {
            Caption = 'Source Ref. No.';
            DataClassification = CustomerContent;
        }
        field(16; "Item Ledger Entry No."; Integer)
        {
            Caption = 'Item Ledger Entry No.';
            Editable = false;
            TableRelation = "Item Ledger Entry";
            DataClassification = CustomerContent;
        }
        field(22; "Expected Receipt Date"; Date)
        {
            Caption = 'Expected Receipt Date';
            DataClassification = CustomerContent;
        }
        field(23; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
            DataClassification = CustomerContent;
        }
        field(24; "Serial No."; Code[50])
        {
            Caption = 'Serial No.';
            DataClassification = CustomerContent;
        }
        field(25; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(27; "Changed By"; Code[50])
        {
            Caption = 'Changed By';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(28; Positive; Boolean)
        {
            Caption = 'Positive';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(29; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
            DataClassification = CustomerContent;
        }
        field(30; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(31; "Action Message Adjustment"; Decimal)
        {
            CalcFormula = Sum("Action Message Entry".Quantity WHERE("Reservation Entry" = FIELD("Entry No."),
                                                                     Calculation = CONST(Sum)));
            Caption = 'Action Message Adjustment';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(32; Binding; Enum "Reservation Binding")
        {
            Caption = 'Binding';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(33; "Suppressed Action Msg."; Boolean)
        {
            Caption = 'Suppressed Action Msg.';
            DataClassification = CustomerContent;
        }
        field(34; "Planning Flexibility"; Enum "Reservation Planning Flexibility")
        {
            Caption = 'Planning Flexibility';
            DataClassification = CustomerContent;
        }
        field(38; "Appl.-to Item Entry"; Integer)
        {
            Caption = 'Appl.-to Item Entry';
            DataClassification = CustomerContent;
        }
        field(40; "Warranty Date"; Date)
        {
            Caption = 'Warranty Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(41; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50; "Qty. to Handle (Base)"; Decimal)
        {
            Caption = 'Qty. to Handle (Base)';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(51; "Qty. to Invoice (Base)"; Decimal)
        {
            Caption = 'Qty. to Invoice (Base)';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(53; "Quantity Invoiced (Base)"; Decimal)
        {
            Caption = 'Quantity Invoiced (Base)';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(80; "New Serial No."; Code[50])
        {
            Caption = 'New Serial No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(81; "New Lot No."; Code[50])
        {
            Caption = 'New Lot No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(900; "Disallow Cancellation"; Boolean)
        {
            Caption = 'Disallow Cancellation';
            DataClassification = CustomerContent;
        }
        field(5400; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
            DataClassification = CustomerContent;
        }
        field(5401; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
            DataClassification = CustomerContent;
        }
        field(5811; "Appl.-from Item Entry"; Integer)
        {
            Caption = 'Appl.-from Item Entry';
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(5817; Correction; Boolean)
        {
            Caption = 'Correction';
            DataClassification = CustomerContent;
        }
        field(6505; "New Expiration Date"; Date)
        {
            Caption = 'New Expiration Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(6510; "Item Tracking"; Enum "Item Tracking Entry Type")
        {
            Caption = 'Item Tracking';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(6511; "Untracked Surplus"; Boolean)
        {
            Caption = 'Untracked Surplus';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Entry No.", Positive)
        {
            Clustered = true;
        }
        key(Key2; "Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Reservation Status", "Shipment Date", "Expected Receipt Date")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Quantity (Base)", Quantity, "Qty. to Handle (Base)", "Qty. to Invoice (Base)";
        }
        key(Key3; "Item No.", "Variant Code", "Location Code")
        {
            MaintainSIFTIndex = false;
        }
        key(Key4; "Item No.", "Variant Code", "Location Code", "Reservation Status", "Shipment Date", "Expected Receipt Date", "Serial No.", "Lot No.")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Quantity (Base)";
        }
        key(Key5; "Item No.", "Source Type", "Source Subtype", "Reservation Status", "Location Code", "Variant Code", "Shipment Date", "Expected Receipt Date", "Serial No.", "Lot No.")
        {
            MaintainSIFTIndex = false;
            MaintainSQLIndex = false;
            SumIndexFields = "Quantity (Base)", Quantity;
        }
        key(Key6; "Item No.", "Variant Code", "Location Code", "Item Tracking", "Reservation Status", "Lot No.", "Serial No.")
        {
            MaintainSIFTIndex = false;
            MaintainSQLIndex = false;
            SumIndexFields = "Quantity (Base)";
        }
        key(Key7; "Lot No.")
        {
            Enabled = false;
        }
        key(Key8; "Serial No.")
        {
            Enabled = false;
        }
        key(Key9; "Source Type", "Source Subtype", "Source ID", "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.")
        {
        }
        key(Key10; "Reservation Status", "Item No.", "Variant Code", "Location Code", "Expected Receipt Date")
        {
            SumIndexFields = "Quantity (Base)";
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", Positive, "Item No.", Description, Quantity)
        {
        }
    } 
}

