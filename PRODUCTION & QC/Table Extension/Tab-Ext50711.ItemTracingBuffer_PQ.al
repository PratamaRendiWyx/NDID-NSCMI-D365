tableextension 50711 ItemTracingBuffer_PQ extends "Item Tracing Buffer"
{
    fields
    {
        field(50700; "Quality Test"; Code[20])
        {
          CalcFormula = Lookup("Item Ledger Entry"."CCS Quality Test"  WHERE("Entry No." = FIELD("Item Ledger Entry No.")));
          Caption = 'Quality Test';
          Editable = false;
          FieldClass = FlowField;
        }
    }
}