tableextension 50308 PriceListHeader_SP extends "Price List Header"
{
    fields
    {
        field(50300; "Shipment Method"; Code[20])
        {
            Caption = 'Shipment Method';
            DataClassification = ToBeClassified;
            TableRelation = "Shipment Method".Code;
        }
    }
}
