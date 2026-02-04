tableextension 50707 ItemEntryRelation_PQ extends "Item Entry Relation"
{

    fields
    {
        field(50700; "CCS Quantity"; Decimal)
        {
            Caption = 'Quantity';
            Description = 'QC used on Shipment Doc';
            DataClassification = CustomerContent;
        }
    }

}