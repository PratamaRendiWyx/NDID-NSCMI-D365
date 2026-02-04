page 50119 TaxSyncronizePage_FT
{
    PageType = Card;
    actions
    {
        area(Processing)
        {
            action("Tax Syncronize")
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()var Question: Text;
                Answer: Boolean;
                sukses: Text;
                suksesSalesInvoiceBC: Text;
                suksesCrMemotoPenampung: Text;
                suksesPurchInvtoPenampung: Text;
                suksesPurchCrMemotoPenampung: Text;
                //CustomerNo: Integer;
                Text000: TextConst ENU='Are you sure to syncronize ?';
                Text001: TextConst ENU='You selected %1.';
                tesDPP: Decimal;
                _Sales: Record "Sales Invoice Header";_TaxSetup: Record TaxIndoParameter_FT;
                _CUSync: Codeunit Syncronize_FT;
                //CUnit: Codeunit CodeUnitPPN;
                begin
                    Question:=Text000;
                    Answer:=Dialog.CONFIRM(Question, false);
                    //MESSAGE(Text001, Answer);
                    if Answer then begin
                        //status awal di true semua karena supaya yang tidak di jalankan fungsinya dianggap benar
                        suksesPurchInvtoPenampung:='true';
                        suksesPurchCrMemotoPenampung:='true';
                        suksesSalesInvoiceBC:='true';
                        suksesCrMemotoPenampung:='true';
                        _TaxSetup.Find('-');
                        if _TaxSetup.TaxIN = true then begin
                            //purchase
                            suksesPurchInvtoPenampung:=_CUSync.SyncPurcInvtoPenampung();
                            suksesPurchCrMemotoPenampung:=_CUSync.SyncPurcCrMemotoPenampung();
                        end;
                        if _TaxSetup.TaxOut = true then begin
                            // sales2an
                            suksesSalesInvoiceBC:=_CUSync.SyncSalesInvcHdrtoPenampung();
                            suksesCrMemotoPenampung:=_CUSync.SyncSalesCrMemoHdrtoPenampung();
                        end;
                        sukses:=_CUSync.SynDataPenampungToPPN();

                        if(sukses = 'true') and (suksesSalesInvoiceBC = 'true') and (suksesCrMemotoPenampung = 'true') and (suksesPurchInvtoPenampung = 'true') and (suksesPurchCrMemotoPenampung = 'true')then begin
                            Message('Syncronize Success');
                        end
                        else
                        begin
                            if(sukses = 'false') or (suksesSalesInvoiceBC = 'false') or (suksesCrMemotoPenampung = 'false') or (suksesPurchInvtoPenampung = 'false') or (suksesPurchCrMemotoPenampung = 'false')then begin
                                Message('Syncronize Failed');
                            end
                            else
                            begin
                                if(sukses = 'NoData') and (suksesSalesInvoiceBC = 'NoData') and (suksesCrMemotoPenampung = 'NoData') and (suksesPurchInvtoPenampung = 'NoData') and (suksesPurchCrMemotoPenampung = 'NoData')then begin
                                    Message('no data needs to be synchronized');
                                end
                                else
                                begin
                                    // kalo sebagian ada yang nodata dan sebagian ada yang true saat sync
                                    // Nodata artinya tidak ada data untuk di syncronize
                                    Message('Syncronize Success');
                                end;
                            end;
                        end;
                    //Message('test true');
                    end
                    else
                    begin
                        MESSAGE('Syncronize Cancel');
                    end;
                end;
            }
        }
    }

}