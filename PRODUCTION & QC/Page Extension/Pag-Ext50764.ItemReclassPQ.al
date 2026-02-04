pageextension 50764 "Item Reclass_PQ" extends "Item Reclass. Journal"
{
    layout
    {
        addbefore("Applies-to Entry")
        {
            field("Lot No. (Gen.)"; Rec."Lot No. (Gen.)")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action(GenMoveToTemp)
            {
                ApplicationArea = All;
                Caption = 'Generate → Move to Temp Location';
                Image = New;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Rep: Report "Gen Reclass to Temp";
                    TemplateName: Code[10];
                    BatchName: Code[10];
                begin
                    // Pastikan user sudah memilih batch pada Page 393
                    if Rec."Journal Template Name" = '' then
                        Error('Pilih Journal Template pada halaman terlebih dulu.');
                    if Rec."Journal Batch Name" = '' then
                        Error('Pilih Journal Batch pada halaman terlebih dulu.');

                    TemplateName := Rec."Journal Template Name";
                    BatchName := Rec."Journal Batch Name";

                    // Kirim konteks batch ke report, lalu jalankan dengan Request Page
                    Rep.SetBatch(TemplateName, BatchName);
                    Rep.RunModal();
                end;
            }

            action(CleanseBatch)
            {
                ApplicationArea = All;
                Caption = 'Cleanse Batch';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    JnlLine: Record "Item Journal Line";
                    Cnt: Integer;
                begin
                    if Rec."Journal Template Name" = '' then
                        Error('Pilih Journal Template pada halaman terlebih dulu.');
                    if Rec."Journal Batch Name" = '' then
                        Error('Pilih Journal Batch pada halaman terlebih dulu.');

                    if not Confirm(
                        'Hapus SEMUA baris pada batch %1/%2 ?',
                        false, Rec."Journal Template Name", Rec."Journal Batch Name")
                    then
                        exit;

                    JnlLine.Reset();
                    JnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    JnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    if JnlLine.FindSet() then
                        repeat
                            // Hapus Reservation Entry (item tracking) yang mengacu ke baris jurnal ini
                            DeleteItemTrackingForLine(JnlLine);
                            // Hapus baris jurnalnya
                            JnlLine.Delete(true);
                            Cnt += 1;
                        until JnlLine.Next() = 0;

                    Message('Batch %1/%2 telah dibersihkan.',
                      Rec."Journal Template Name", Rec."Journal Batch Name");
                end;
            }


            action(CreateReservationForLines)
            {
                ApplicationArea = All;
                Caption = 'Gen. Item Tracking';
                Image = ItemTracking;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Sel: Record "Item Journal Line";
                    Lines: Record "Item Journal Line";
                    Cnt: Integer;
                    MassGen: Report "Gen Reclass to Temp";
                begin
                    // Ambil selection pada grid. Kalau ada → proses selection, kalau tidak → proses seluruh batch aktif.
                    CurrPage.SetSelectionFilter(Sel);

                    if Sel.FindFirst() then begin
                        // Proses baris-baris yang terseleksi
                        repeat
                            Clear(MassGen);
                            MassGen.ItemTrackingWithReservation(Sel, Sel.Quantity, Sel."Lot No. (Gen.)", Sel."Serial No.");
                            Cnt += 1;
                        until Sel.Next() = 0;
                    end else begin
                        // Proses seluruh baris dalam batch aktif
                        if Rec."Journal Template Name" = '' then
                            Error('Pilih Journal Template dulu.');
                        if Rec."Journal Batch Name" = '' then
                            Error('Pilih Journal Batch dulu.');

                        Lines.Reset();
                        Lines.SetRange("Journal Template Name", Rec."Journal Template Name");
                        Lines.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                        if Lines.FindSet() then
                            repeat
                                Clear(MassGen);
                                MassGen.ItemTrackingWithReservation(Sel, Sel.Quantity, Sel."Lot No. (Gen.)", Sel."Serial No.");
                                Cnt += 1;
                            until Lines.Next() = 0;
                    end;

                    Message('%1 reservation entry dibuat/di-replace.', Cnt);
                end;
            }
        }
    }

    local procedure DeleteItemTrackingForLine(var JLine: Record "Item Journal Line")
    var
        ReservEntry: Record "Reservation Entry";
    begin
        // Reservation Entry (T337) menyimpan detail Item Tracking Lines untuk baris sumber
        // Filter sesuai Source Type = Item Journal Line dan pointer ke baris
        ReservEntry.Reset();
        ReservEntry.SetRange("Source Type", DATABASE::"Item Journal Line");
        ReservEntry.SetRange("Source Subtype", JLine."Entry Type".AsInteger()); // Reclass, dll.
        ReservEntry.SetRange("Source ID", JLine."Journal Template Name");
        ReservEntry.SetRange("Source Batch Name", JLine."Journal Batch Name");
        ReservEntry.SetRange("Source Ref. No.", JLine."Line No.");

        if ReservEntry.FindSet() then
            ReservEntry.DeleteAll(true);
        // Catatan:
        // - Tracking Specification (T336) adalah buffer sementara; yang persisten adalah Reservation Entry (T337).
        // - Jika suatu saat menggunakan WMS (bins), ada tabel Whse. Item Tracking Line (internal),
        //   tetapi untuk konfigurasi tanpa WMS seperti kamu, cukup hapus Reservation Entry saja. 
        //   Engine posting akan membentuk ulang entri tracking sesuai kebutuhan. 
        //   Lihat desain & struktur tracking: Microsoft Learn (T336/T337, posting structure).
    end;

}


