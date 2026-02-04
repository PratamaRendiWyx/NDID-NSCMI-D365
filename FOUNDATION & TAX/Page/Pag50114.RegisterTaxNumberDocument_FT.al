page 50114 RegisterTaxNumberDocument_FT
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = RegTaxNumHeader_FT;
    Caption = 'Register Tax Number Document';
    InsertAllowed = true;
    DeleteAllowed = true;
    ModifyAllowed = true;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                Editable = boolgroupname;

                field(RegTaxNumId;Rec.RegTaxNumId)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(FromDate;Rec.FromDate)
                {
                    ApplicationArea = All;
                // trigger OnValidate()
                // begin
                //     if (Rec.FromDate > Rec.ToDate) then begin
                //         Error('from date value must be smaller than to date');
                //     end;
                // end;
                }
                field(ToDate;Rec.ToDate)
                {
                    ApplicationArea = All;

                    trigger OnValidate()begin
                        if(Rec.FromDate > Rec.ToDate)then begin
                            Error('from date value must be greater than to date');
                        end;
                    end;
                }
                field(Prefix;Rec.Prefix)
                {
                    ApplicationArea = All;

                    trigger OnValidate()var myInt: Integer;
                    begin
                        if StrLen(Rec.Prefix) > 8 then begin
                            Error('Prefix not allowed more than 8 chars');
                        end;
                    end;
                }
                field(NoFrom;Rec.NoFrom)
                {
                    ApplicationArea = All;
                // trigger OnValidate()
                // begin
                //     if (Rec.NoFrom >= Rec.NoTo) then begin //and (Rec.NoTo <> 0)
                //         Error('tax no from value must be smaller than tax no to');
                //     end;
                // end;
                }
                field(NoTo;Rec.NoTo)
                {
                    ApplicationArea = All;

                    trigger OnValidate()begin
                        if Rec.NoFrom >= Rec.NoTo then begin
                            //Rec.Modify(false);
                            Error('tax no to value must be greater than tax no from');
                        //Message();
                        end;
                    end;
                }
                field(StatusHeader;Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            part(XXX;RegisterTaxNumberSubPage_FT)
            {
                ApplicationArea = All;
                SubPageLink = RegTaxNumId=Field(RegTaxNumId);
                SubPageView = sorting(TaxNum);
                Enabled = boolsubpage;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Generate")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Visible = btnGenerate;

                trigger OnAction()var _Yes: Boolean;
                _Success: Boolean;
                _Text01: TextConst ENU='Are you sure want to generate it?';
                _RTNH: Record RegTaxNumHeader_FT;
                _RTNL: Record RegTaxNumLine_FT;
                _CekRTNL: Record RegTaxNumLine_FT;
                _ZeroString: Text[20];
                _TaxNumCounter: Integer;
                _TaxNumString: Text[20];
                _NoFrom: Integer;
                _NoTo: Integer;
                begin
                    _RTNH.get(Rec.RegTaxNumId);
                    if Rec.NoFrom >= Rec.NoTo then begin
                        Error('tax no to value must be greater than tax no from');
                    end;
                    if(Rec.FromDate > Rec.ToDate)then begin
                        Error('from date value must be greater than to date');
                    end;
                    if _RTNH.Status = Rec.Status::Generate then begin
                        Dialog.Error('Cancelled, Status is already "Generate"');
                    end
                    else
                    begin
                        _Yes:=Dialog.CONFIRM(_Text01, false);
                        If(_Yes)then begin
                            _ZeroString:='00000000000000000000';
                            _Success:=true;
                            for _TaxNumCounter:=Rec.NoFrom to Rec.NoTo do begin
                                //_RTNL.Reset();
                                Clear(_RTNL);
                                _RTNL.RegTaxNumId:=Rec.RegTaxNumId;
                                _TaxNumString:=FORMAT(_TaxNumCounter, 10, 0);
                                _RTNL.TaxNum:=_ZeroString.Substring(1, 8 - StrLen(_TaxNumString.trim())) + _TaxNumString.Trim();
                                _RTNL.TaxNum:=Rec.Prefix + _RTNL.TaxNum;
                                _RTNL.Reff:='';
                                _RTNL.Status:=TaxLineStatus_FT::Free;
                                Clear(_CekRTNL);
                                _CekRTNL.SetFilter(TaxNum, '=%1', _RTNL.TaxNum);
                                _CekRTNL.SetFilter(Status, '%1|%2', TaxLineStatus_FT::Free, TaxLineStatus_FT::Used);
                                if _CekRTNL.FindSet then begin
                                //Message('cekrtnl true');
                                // taxnum ga boleh ke create
                                end
                                else
                                begin
                                    //Message('cekrtnl false');
                                    // ini taxnum tidak ada atau yang statusnya cancel
                                    if Not _RTNL.Insert()then _Success:=false;
                                end;
                            //Message('jumlah cek rtnl %1', _CekRTNL.Count);
                            end;
                            If _Success then begin
                                _RTNH.Get(Rec.RegTaxNumId);
                                if _RTNH.RegTaxNumId = Rec.RegTaxNumId then begin
                                    _RTNH.Status:=TaxStatus_FT::Generate;
                                    if _RTNH.Modify()then begin
                                        message('Success Generate');
                                        CurrPage.Close();
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            }
            action(Cancel)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Visible = btnCancel;

                trigger OnAction()var _line: Record RegTaxNumLine_FT;
                begin
                    Rec.Status:=TaxStatus_FT::Cancel;
                    if Rec.Modify()then begin
                        _line.SetFilter(RegTaxNumId, Format(rec.RegTaxNumId));
                        if _line.FindSet()then begin
                            repeat begin
                                if _line.Status = TaxLineStatus_FT::Free then begin
                                    _line.Status:=TaxLineStatus_FT::Cancel;
                                    _line.Modify();
                                end;
                            end until _line.Next = 0;
                        end;
                        Message('Success');
                        CurrPage.Close();
                    end;
                end;
            }
        }
    }
    var _GlobalParm: Record RegTaxNumHeader_FT;
    btnGenerate: Boolean;
    btnCancel: Boolean;
    mindate: Date;
    boolinsert: Boolean;
    boolmodify: Boolean;
    booldelete: Boolean;
    boolgroupname: Boolean;
    boolsubpage: Boolean;

    trigger OnOpenPage()
    var myInt: Integer;
    begin
        boolgroupname:=true;
        boolsubpage:=false;
        if Rec.Status = TaxStatus_FT::ReadyToUse then begin
            btnGenerate:=true;
            btnCancel:=false;
            booldelete:=false;
            CurrPage.XXX.Page.visibleBTN(false);
        end;
        if Rec.Status = TaxStatus_FT::Generate then begin
            btnGenerate:=false;
            btnCancel:=true;
            boolgroupname:=false;
            boolsubpage:=true;
            CurrPage.XXX.Page.visibleBTN(true);
        end;
        if Rec.Status = TaxStatus_FT::Cancel then begin
            btnGenerate:=false;
            btnCancel:=false;
            boolgroupname:=false;
            CurrPage.XXX.Page.visibleBTN(false);
        end;
    end;
    trigger OnModifyRecord(): Boolean begin
        mindate:=DMY2Date(01, 01, 1753);
        if(Rec.NoTo > 1) and (rec.Prefix <> '') and (Rec.FromDate > mindate) and (Rec.ToDate > mindate)then begin
            Rec.Status:=TaxStatus_FT::ReadyToUse;
        //Rec.Modify();
        //Message('masuk kondisi date');
        end;
    end;
    trigger OnDeleteRecord(): Boolean var _Line: Record RegTaxNumLine_FT;
    begin
        if Rec.Status = TaxStatus_FT::ReadyToUse then begin
            _Line.SetFilter(_Line.RegTaxNumId, Format(Rec.RegTaxNumId));
            if _Line.FindSet then begin
                repeat begin
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
