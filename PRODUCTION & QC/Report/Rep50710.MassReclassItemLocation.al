report 50710 "Gen Reclass to Temp"
{
    UsageCategory = Tasks;
    ApplicationArea = All;
    Caption = 'Generate Reclass to Temp Location';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnPostDataItem()
            var
                myInt: Integer;
            begin

            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Parameters)
                {
                    field(TargetLocationF; TargetLocation)
                    {
                        ApplicationArea = All;
                        Caption = 'Temp Location (Tujuan)';
                        Lookup = true;
                        TableRelation = Location.Code;
                    }
                    field(OrigLocation; OrigLocation)
                    {
                        ApplicationArea = All;
                        Caption = 'Source Location';
                    }
                    field(PostingDateF; PostingDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Posting Date';
                    }
                    field(DocNoF; DocNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Document No.';
                        ToolTip = 'Nomor dokumen untuk jurnal reclass.';
                    }
                    field(ReasonCodeF; ReasonCodeParam)
                    {
                        ApplicationArea = All;
                        Caption = 'Reason Code (Opsional)';
                        TableRelation = "Reason Code".Code;
                    }
                    field(ItemNo; ItemNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Item No.';
                        // TableRelation = Item."No.";
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            if PostingDate = 0D then
                PostingDate := WorkDate();
            if DocNo = '' then
                DocNo := StrSubstNo('TEMP-%1', Format(WorkDate(), 0, '<Year4><Month,2><Day,2>'));
        end;
    }

    var
        // Context dari PageExtension
        TemplateName: Code[10];
        BatchName: Code[10];

        // Parameters (Request Page)
        TargetLocation: Code[10];
        OrigLocation: Code[10];
        PostingDate: Date;
        DocNo: Code[20];
        ReasonCodeParam: Code[10];
        ItemNo: Code[20];

        // Records
        Loc: Record Location;
        ILE: Record "Item Ledger Entry";
        Item: Record Item;
        JnlBatch: Record "Item Journal Batch";

        LinesCreated: Integer;

    procedure SetBatch(TemplateNameP: Code[10]; BatchNameP: Code[10])
    begin
        TemplateName := TemplateNameP;
        BatchName := BatchNameP;
    end;

    var
        CurrData: Text;
        TempData: Text;

    trigger OnPreReport()
    var
        ILESum: Record "Item Ledger Entry";
    begin
        ValidateParameters();

        // Loop ILE open dengan Remaining Qty > 0, exclude lokasi tujuan
        ILE.Reset();
        ILE.SetCurrentKey("Item No.", "Variant Code", "Location Code", "Lot No.", "Serial No.");
        ILE.SetFilter("Remaining Quantity", '>0'); // FlowField
        ILE.SetFilter("Location Code", '<>%1', TargetLocation);
        ILE.SetRange(Open, true);
        if ItemNo <> '' then
            ILE.SetFilter("Item No.", ItemNo);
        if OrigLocation <> '' then
            ILE.SetFilter("Location Code", OrigLocation);

        Clear(TempData);
        Clear(CurrData);

        if ILE.FindSet() then
            repeat
                CurrData := ILE."Item No." + '#' + ILE."Location Code" + '#' + ILE."Lot No.";
                if CurrData <> TempData then begin
                    Clear(ILESum);
                    ILESum.Reset();
                    ILESum.SetRange("Item No.", ILE."Item No.");
                    ILESum.SetRange("Location Code", ILE."Location Code");
                    ILESum.SetRange("Lot No.", ILE."Lot No.");
                    if ILESum.FindSet() then begin
                        ILESum.CalcSums("Remaining Quantity");
                        if not ignoreIntransitLocation(ILESum."Location Code") then
                            CreateReclassLine_ByShortcutTracking(ILESum);
                        LinesCreated += 1;
                    end;
                end;
                TempData := CurrData;
            until ILE.Next() = 0;

        if LinesCreated = 0 then
            Error('Tidak ada baris dibuat. Pastikan stok open (Remaining Qty > 0) tersedia di lokasi selain %1.', TargetLocation);

        Message('Selesai. %1 baris dibuat pada batch %2/%3 (tujuan: %4).',
          LinesCreated, TemplateName, BatchName, TargetLocation);
    end;

    local procedure ignoreIntransitLocation(iCode: Code[20]): Boolean
    var
        location: Record Location;
    begin
        location.Reset();
        if location.Get(iCode) then
            if location."Use As In-Transit" Or location."Bin Mandatory" then
                exit(true);
    end;

    local procedure ValidateParameters()
    begin
        if TemplateName = '' then
            Error('Konteks batch tidak ada. Action harus dipanggil dari halaman Item Reclass. Journal.');
        if BatchName = '' then
            Error('Konteks batch tidak ada. Action harus dipanggil dari halaman Item Reclass. Journal.');

        if TargetLocation = '' then
            Error('Lokasi tujuan (Temp) wajib diisi.');
        if PostingDate = 0D then
            Error('Posting Date wajib diisi.');
        if DocNo = '' then
            Error('Document No. wajib diisi.');

        if not Loc.Get(TargetLocation) then
            Error('Lokasi tujuan %1 tidak ditemukan.', TargetLocation);

        // Defensive untuk WMS/Bin
        if Loc."Bin Mandatory" or Loc."Directed Put-away and Pick" then
            Error('Lokasi tujuan menggunakan Bin/WMS. Gunakan Warehouse Transfer bila WMS aktif.');

        if not JnlBatch.Get(TemplateName, BatchName) then
            Error('Batch jurnal %1/%2 tidak ditemukan.', TemplateName, BatchName);
    end;

    local procedure CreateReclassLine_ByShortcutTracking(ILEP: Record "Item Ledger Entry")
    var
        Line: Record "Item Journal Line";
        ItemRec: Record Item;
        NextLineNo: Integer;
        QtyBase: Decimal;
    begin
        QtyBase := ILEP."Remaining Quantity";
        ItemRec.Get(ILEP."Item No.");

        Line.Init();
        Line.Validate("Journal Template Name", TemplateName);
        Line.Validate("Journal Batch Name", BatchName);

        NextLineNo := GetNextLineNo(TemplateName, BatchName);
        Line."Line No." := NextLineNo;

        Line.Validate("Posting Date", PostingDate);
        Line.Validate("Document No.", DocNo);
        Line.Validate("Entry Type", Line."Entry Type"::Transfer);
        Line.Validate("Gen. Bus. Posting Group", 'TRANSFER');

        // Item & Variant
        Line.Validate("Item No.", ILEP."Item No.");
        if ILEP."Variant Code" <> '' then
            Line.Validate("Variant Code", ILEP."Variant Code");

        // Lokasi asal = ILE, tujuan = parameter (Temp)
        Line.Validate("Location Code", ILEP."Location Code");
        Line.Validate("New Location Code", TargetLocation);

        // UOM & Qty (base)
        Line.Validate("Unit of Measure Code", ItemRec."Base Unit of Measure");
        Line.Validate(Quantity, QtyBase);
        Line."Lot No. (Gen.)" := ILEP."Lot No.";

        // Reason Code (opsional)
        if ReasonCodeParam <> '' then
            Line.Validate("Reason Code", ReasonCodeParam);

        // === Tracking otomatis via shortcut fields ===
        if ILEP."Lot No." <> '' then
            // Line.Validate("Lot No.", ILEP."Lot No.");
            Line."Lot No." := ILEP."Lot No.";
        if ILEP."Serial No." <> '' then
            Line.Validate("Serial No.", ILEP."Serial No.");

        // Line."New Lot No." := ILEP."Lot No.";

        Line.Insert(true);
        //reserve 
        ItemTrackingWithReservation(Line, QtyBase, ILEP."Lot No.", ILEP."Serial No.");
    end;


    procedure ItemTrackingWithReservation(var JLine: Record "Item Journal Line"; QtyBase: Decimal; iLotNo: Code[50]; iSerialNo: Code[50])
    var
        ReservEntry: Record "Reservation Entry";
        IsSerial: Boolean;
        IsLot: Boolean;
    begin
        // --- 0) Validasi dasar ---
        JLine.TestField("Journal Template Name");
        JLine.TestField("Journal Batch Name");
        JLine.TestField("Line No.");
        JLine.TestField("Item No.");
        JLine.TestField("Location Code");
        if QtyBase <= 0 then
            Error('Quantity (Base) summary untuk line %1 harus > 0.', JLine."Line No.");

        // Deteksi tipe tracking dari shortcut di line (kamu sudah isi dari ILE summary)
        JLine."Lot No." := iLotNo;
        JLine."Serial No." := iSerialNo;
        //
        IsSerial := JLine."Serial No." <> '';
        IsLot := JLine."Lot No." <> '';

        // --- 1) Hapus reservation yang terikat ke line (hindari duplikat/orphan) ---
        ReservEntry.Reset();
        ReservEntry.SetRange("Source Type", DATABASE::"Item Journal Line");
        ReservEntry.SetRange("Source Subtype", JLine."Entry Type".AsInteger());
        ReservEntry.SetRange("Source ID", JLine."Journal Template Name");
        ReservEntry.SetRange("Source Batch Name", JLine."Journal Batch Name");
        ReservEntry.SetRange("Source Ref. No.", JLine."Line No.");
        if ReservEntry.FindSet() then
            ReservEntry.DeleteAll(true);

        // --- 2) Sisipkan reservation entry baru (Prospect) untuk tracking line ---
        ReservEntry.Init();

        // Pointer ke baris sumber (WAJIB benar)
        ReservEntry."Source Type" := DATABASE::"Item Journal Line";
        ReservEntry."Source Subtype" := JLine."Entry Type".AsInteger();  // Reclass, dsb.
        ReservEntry."Source ID" := JLine."Journal Template Name";
        ReservEntry."Source Batch Name" := JLine."Journal Batch Name";
        ReservEntry."Source Ref. No." := JLine."Line No.";

        // Identitas item + konteks
        ReservEntry.Validate("Item No.", JLine."Item No.");
        ReservEntry.Validate("Variant Code", JLine."Variant Code");
        ReservEntry.Validate("Location Code", JLine."Location Code");

        // Tracking detail
        if IsSerial then
            ReservEntry.Validate("Serial No.", JLine."Serial No.");
        if IsLot then
            ReservEntry.Validate("Lot No.", JLine."Lot No.");

        ReservEntry."New Lot No." := JLine."Lot No.";

        // Quantity (Base) hasil summary CalcSums
        QtyBase := -1 * QtyBase;
        ReservEntry.Validate("Quantity (Base)", QtyBase);

        // Status & jenis (untuk jurnal: gunakan Prospect agar engine posting yang memproses)
        ReservEntry."Reservation Status" := ReservEntry."Reservation Status"::Prospect;
        ReservEntry.Positive := true; // untuk jurnal reclass, satu line membawa tracking prospektif
        ReservEntry."Binding" := ReservEntry."Binding"::" "; // non-hard
        // ReservEntry."Expected Quantity" := 0; // opsional; bisa diabaikan bila bukan scenario planning

        // Catatan tambahan (opsional): expiry warranty bila perlu
        // ReservEntry."Expiration Date" := JLine."New Expiration Date"; // jika kamu set pada reclass

        ReservEntry.Insert(true);
    end;


    local procedure GetNextLineNo(TemplateNameP: Code[10]; BatchNameP: Code[10]): Integer
    var
        L: Record "Item Journal Line";
    begin
        L.SetRange("Journal Template Name", TemplateNameP);
        L.SetRange("Journal Batch Name", BatchNameP);
        if L.FindLast() then
            exit(L."Line No." + 10000)
        else
            exit(10000);
    end;


}
