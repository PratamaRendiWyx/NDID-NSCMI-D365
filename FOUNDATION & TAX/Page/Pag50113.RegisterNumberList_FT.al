page 50113 RegisterNumberList_FT
{
    PageType = List;
    Caption = 'Register Tax Number';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    SourceTable = RegTaxNumHeader_FT;
    CardPageId = RegisterTaxNumberDocument_FT;
    DeleteAllowed = true;
    ModifyAllowed = true;
    InsertAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(RegTaxNumID;Rec.RegTaxNumID)
                {
                    ApplicationArea = All;
                }
                field(FromDate;Rec.FromDate)
                {
                    ApplicationArea = All;
                }
                field(ToDate;Rec.ToDate)
                {
                    ApplicationArea = All;
                }
                field(Prefix;Rec.Prefix)
                {
                    ApplicationArea = All;
                }
                field(NoFrom;Rec.NoFrom)
                {
                    ApplicationArea = All;
                }
                field(NoTo;Rec.NoTo)
                {
                    ApplicationArea = All;
                }
                field(Status;Rec.Status)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {
        }
    }
    actions
    {
        area(Processing)
        {

            group(Manage)
            {
                action(Cancel)
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    //Visible = btnCancel;
                    Image = Cancel;

                    trigger OnAction()var _line: Record RegTaxNumLine_FT;
                    _header: Record RegTaxNumHeader_FT;
                    begin
                        CurrPage.SetSelectionFilter(_header);
                        if _header.FindSet()then begin
                            repeat begin
                                _header.Status:=TaxStatus_FT::Cancel;
                                if _header.Modify()then begin
                                    _line.SetFilter(RegTaxNumId, Format(_header.RegTaxNumId));
                                    if _line.FindSet()then begin
                                        repeat begin
                                            if _line.Status = TaxLineStatus_FT::Free then begin
                                                _line.Status:=TaxLineStatus_FT::Cancel;
                                                _line.Modify();
                                            end;
                                        end until _line.Next = 0;
                                    end;
                                //CurrPage.Close();
                                end;
                            end until _header.Next = 0;
                        end;
                        Message('Success, %1 header processed', _header.Count());
                    end;
                }
                action(Edit)
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    Image = Edit;

                    trigger OnAction()var _header: Record RegTaxNumHeader_FT;
                    _page: Page RegisterTaxNumberDocument_FT;
                    begin
                        CurrPage.SetSelectionFilter(_header);
                        if _header.Count() > 1 then Message('must select one row')
                        else
                        begin
                            _page.SetRecord(Rec);
                            _page.Run();
                        end;
                    end;
                }
 
            }
        }
    }
    var 
    _GlobalParmId: Code[20];
    _RTND: Page RegisterTaxNumberDocument_FT;
    //_RTNL: Page RegisterNumberList_FT;
    _RTNH: Record RegTaxNumHeader_FT;
    
    trigger OnDeleteRecord(): Boolean var myInt: Integer;
    _Line: Record RegTaxNumLine_FT;
    begin
        if Rec.Status = TaxStatus_FT::ReadyToUse then begin
            //if Status = TaxStatus_FT::Cancel then begin
            _Line.SetFilter(_Line.RegTaxNumId, Format(Rec.RegTaxNumId));
            if _Line.FindSet then begin
                repeat begin
                    //Message('jml line ' + Format(_Line.Count) + ' ' + RegTaxNumId);
                    _Line.Delete();
                end until _Line.Next = 0;
            end;
        end
        else
        begin
            Error('Not permitted to delete with ' + Format(Rec.Status) + ' status');
        end;
    end;
}
