pageextension 50712 ItemTrackingLines_PQ extends "Item Tracking Lines"
{

  procedure GetTempTrackingSpec(var TempTrackingSpec: Record "Tracking Specification" temporary)
  begin
      TempTrackingSpec.COPY(Rec,TRUE);
  end;

}
