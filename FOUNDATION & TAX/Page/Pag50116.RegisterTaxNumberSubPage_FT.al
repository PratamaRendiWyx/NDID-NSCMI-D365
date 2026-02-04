page 50116 RegisterTaxNumberSubPage_FT
{
    PageType = ListPart;
    Caption = 'Register Tax Number Line';
    SourceTable = RegTaxNumLine_FT;
    ModifyAllowed = true;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(TaxNum;Rec.TaxNum)
                {
                    ApplicationArea = All;
                    Enabled = false;
                    Caption = 'Tax Number';
                }
                field(Reff;Rec.Reff)
                {
                    ApplicationArea = All;
                    //Enabled = false;
                    Caption = 'Refference';
                }
                field(Status;Rec.Status)
                {
                    ApplicationArea = All;
                    Enabled = false;
                    Caption = 'Status';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(Manage)
            {
                Visible = _visibleBTN;

                action(Cancel)
                {
                    ApplicationArea = All;

                    trigger OnAction()var // _RegtaxNumHead: Record RegTaxNumHeader_FT;
                    begin
                        //_RegtaxNumHead.Get(RegTaxNumId);
                        // if _RegtaxNumHead.Status <> TaxStatus_FT::Generate then begin
                        //     //_visibleBTN := false;
                        //     Error('Can not change status line when statud header : %1', _RegtaxNumHead.Status);
                        // end;
                        if Rec.Status <> TaxLineStatus_FT::Used then begin
                           Rec.Status:= TaxLineStatus_FT::Cancel;
                           Rec.Modify();
                        end;
                        if Rec.Status = TaxLineStatus_FT::Used then begin
                            if cekrelatetaxnumonPPN(Rec.TaxNum)then begin
                                // berarti dipake
                                Error('Can not change status line');
                            end
                            else
                            begin
                                //berarti ga dipake
                                Rec.Status:=TaxLineStatus_FT::Cancel;
                                Rec.Reff:='';
                                Rec.Modify();
                            end;
                        end;
                    end;
                }
                action("Set Free")
                {
                    ApplicationArea = All;

                    trigger OnAction()
                    var 
                    //_RegtaxNumHead: Record RegTaxNumHeader_FT;
                    begin
                        //_RegtaxNumHead.Get(RegTaxNumId);
                        // Message('%1', _RegtaxNumHead.Status);
                        // if _RegtaxNumHead.Status <> TaxStatusEnum_FT::Generate then begin
                        //     //_visibleBTN := false;
                        //     Error('Can not change status line when statud header : %1', _RegtaxNumHead.Status);
                        // end;
                        if Rec.Status <> TaxLineStatus_FT::Used then begin
                            Rec.Status:= TaxLineStatus_FT::Free;
                            Rec.Reff:='';
                            Rec.Modify();
                        end;
                        if Rec.Status = TaxLineStatus_FT::Used then begin
                            if cekrelatetaxnumonPPN(Rec.TaxNum)then begin
                                // berarti dipake
                                Error('Can not change status line');
                            end
                            else
                            begin
                                //berarti ga dipake
                                Rec.Status:=TaxLineStatus_FT::Free;
                                Rec.Reff:='';
                                Rec.Modify();
                            end;
                        end;
                    end;
                }
                action("Set Used")
                {
                    ApplicationArea = All;

                    trigger OnAction()
                    var 
                    //_RegtaxNumHead: Record RegTaxNumHeader_FT;
                    begin
                        if Rec.Status <> TaxLineStatus_FT::Used then begin
                            Rec.Status:= TaxLineStatus_FT::Used;
                            Rec.Modify();
                        end;
                    end;
                }

            }
        }
    }
    var 
    _visibleBTN: Boolean;

    procedure visibleBTN(boolbtn: Boolean)
    begin
        //Message('kiriman dari header %1', boolbtn);
        _visibleBTN:=boolbtn;
    end;
    procedure cekrelatetaxnumonPPN(_taxnum: Text): Boolean 
    var 
    _PPN: Record PPN_FT;
    position: Integer;
    lenght: Integer;
    begin
        position:=1;
        lenght:=3;
        _taxnum:=DelStr(_taxnum, 1, 3);
        _taxnum:='*' + _taxnum + '*';
        //_PPN.SetFilter(TaxNumber, '%1', '*23-0.1.00000127*');
        _PPN.SetFilter(TaxNumber, '%1', _taxnum);
        //Message('test line regis tax no');
        if _PPN.FindSet then begin
            //Error('');
            //kalo ada berarti balikan true
            exit(true);
        end
        else
        begin
            exit(false);
        end;
        ;
    end;
}
