page 50758 ItemProdDesignFactbox_PQ
{
    // version MP13.0.00

    // MP11 - New Fact Box

    Caption = 'Item Prod. Design';
    Editable = true;
    PageType = CardPart;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            field("Routing No."; Rec."Routing No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of the routing.';

                trigger OnDrillDown()
                var
                    RoutingHeader: Record "Routing Header";
                    MfgSetupT: Record "Manufacturing Setup";
                    ProdVer: Record "Routing Version";
                begin
                    if not RoutingHeader.Get(Rec."Routing No.") then begin
                        if Confirm(MPRText000 +
                                   MPText001, false, Rec."Routing No.")
                        then begin
                            RoutingHeader.Init;
                            RoutingHeader."No." := Rec."No.";
                            RoutingHeader.Description := Rec.Description;
                            RoutingHeader."Search Description" := Rec."No.";
                            RoutingHeader.Status := RoutingHeader.Status::"Under Development";
                            //RoutingHeader."Version Nos." := MfgSetupT."Routing Version No. Series";
                            Rec."Routing No." := Rec."No.";  // on Item
                            RoutingHeader.Insert(true);

                            MfgSetupT.Get;
                            if MfgSetupT."Always Create Router Versions" then begin
                                RoutingHeader.Validate(Status, RoutingHeader.Status::Certified);
                                RoutingHeader.Modify;

                                ProdVer.Init;
                                ProdVer."Routing No." := Rec."No.";
                                ProdVer."Version Code" := '1';
                                ProdVer.Description := Rec.Description;
                                ProdVer."Starting Date" := WorkDate;
                                ProdVer.Status := ProdVer.Status::"Under Development";
                                ProdVer.Insert(true);
                                ProdVer.SetRange("Routing No.", Rec."No.");
                                PAGE.Run(PAGE::"Routing Version", ProdVer);
                                Rec."Routing Curr Version" := ProdVer."Version Code";

                            end else begin
                                RoutingHeader.Validate(Status, RoutingHeader.Status::"Under Development");
                                RoutingHeader.Modify;

                                PAGE.Run(PAGE::Routing, RoutingHeader);
                            end;
                            Rec.Modify;
                        end;
                    end else
                        if Rec.FieldActive(Rec."Routing No.") then begin
                            if RoutingHeader.Get(Rec."Routing No.") then
                                PAGE.Run(PAGE::Routing, RoutingHeader);
                        end;
                end;

                trigger OnLookup(var Text: Text): Boolean
                var
                    RoutingHeader: Record "Routing Header";
                    MfgSetupT: Record "Manufacturing Setup";
                    ProdVer: Record "Routing Version";
                begin
                    if not RoutingHeader.Get(Rec."Routing No.") then begin
                        if Confirm(MPRText000 +
                          MPText001, false, Rec."Routing No.")
                        then begin
                            RoutingHeader.Init;
                            RoutingHeader."No." := Rec."No.";
                            RoutingHeader.Description := Rec.Description;
                            RoutingHeader."Search Description" := Rec."No.";
                            RoutingHeader.Status := RoutingHeader.Status::"Under Development";
                            //RoutingHeader."Version Nos." := MfgSetupT."Routing Version No. Series";
                            Rec."Routing No." := Rec."No.";  // on Item
                            RoutingHeader.Insert(true);

                            MfgSetupT.Get;
                            if MfgSetupT."Always Create Router Versions" then begin
                                RoutingHeader.Validate(Status, RoutingHeader.Status::Certified);
                                RoutingHeader.Modify;

                                ProdVer.Init;
                                ProdVer."Routing No." := Rec."No.";
                                ProdVer."Version Code" := '1';
                                ProdVer.Description := Rec.Description;
                                ProdVer."Starting Date" := WorkDate;
                                ProdVer.Status := ProdVer.Status::"Under Development";
                                ProdVer.Insert(true);
                                ProdVer.SetRange("Routing No.", Rec."No.");
                                PAGE.Run(PAGE::"Routing Version", ProdVer);
                                Rec."Routing Curr Version" := ProdVer."Version Code";

                            end else begin
                                RoutingHeader.Validate(Status, RoutingHeader.Status::"Under Development");
                                RoutingHeader.Modify;

                                PAGE.Run(PAGE::Routing, RoutingHeader);
                            end;
                            Rec.Modify;
                        end;
                    end else
                        if Rec.FieldActive(Rec."Routing No.") then begin
                            if RoutingHeader.Get(Rec."Routing No.") then
                                PAGE.Run(PAGE::Routing, RoutingHeader);
                        end;
                end;
            }
            field("Routing Curr Version"; Rec."Routing Curr Version")
            {
                ApplicationArea = All;

                trigger OnDrillDown()
                var
                    ProdRoutingVer: Record "Routing Version";
                    ProdVer: Record "Routing Version";
                    ProdRouting: Record "Routing Header";
                    VersionMgt: Codeunit VersionManagement;
                    ActiveVersionCode: Code[20];
                    MfgSetupT: Record "Manufacturing Setup";
                begin
                    //MP11 begin
                    //See local variables
                    //See global textconstants MPText000 to MPText003
                    if Rec.FieldActive(Rec."Routing Curr Version") then begin
                        MfgSetupT.Get;
                        ActiveVersionCode := '';
                        if Rec."Routing No." <> '' then begin
                            ActiveVersionCode := VersionMgt.GetRtngVersion(Rec."Routing No.", WorkDate, true);  // TRUE = (only certified)

                            if ProdRoutingVer.Get(Rec."Routing No.", ActiveVersionCode) then begin
                                ProdRoutingVer.SetFilter("Routing No.", Rec."Routing No.");
                                PAGE.Run(PAGE::"Routing Version", ProdRoutingVer);
                            end else begin
                                //no routing versions so get Prod. BOM Header
                                ProdRouting.SetRange("No.", Rec."Routing No.");
                                if ProdRouting.FindFirst then begin
                                    PAGE.Run(PAGE::Routing, ProdRouting);
                                    Rec."Routing No." := ProdRouting."No.";   // on Item
                                end;
                            end;
                        end else begin
                            // "Routing No." is ''
                            if not ProdRouting.Get(Rec."No.") then begin
                                if Confirm(MPRText000 +
                                            MPText001, false, Rec."No.") then begin
                                    ProdRouting.Init;
                                    ProdRouting."No." := Rec."No.";
                                    ProdRouting.Description := Rec.Description;
                                    ProdRouting."Search Description" := Rec."No.";
                                    ProdRouting.Status := ProdRouting.Status::"Under Development";
                                    //ProdRouting."Version Nos." := MfgSetupT."Routing Version No. Series";
                                    Rec."Routing No." := Rec."No.";  // on Item
                                    ProdRouting.Insert(true);

                                    MfgSetupT.Get;
                                    if MfgSetupT."Always Create Router Versions" then begin
                                        ProdRouting.Validate(Status, ProdRouting.Status::Certified);
                                        ProdRouting.Modify;

                                        ProdVer.Init;
                                        ProdVer."Routing No." := Rec."No.";
                                        ProdVer."Version Code" := '1';
                                        ProdVer.Description := Rec.Description;
                                        ProdVer."Starting Date" := WorkDate;
                                        ProdVer.Status := ProdVer.Status::"Under Development";
                                        ProdVer.Insert(true);
                                        ProdVer.SetRange("Routing No.", Rec."No.");
                                        PAGE.Run(PAGE::"Routing Version", ProdVer);
                                        Rec."Routing Curr Version" := ProdVer."Version Code";

                                    end else begin
                                        ProdRouting.Validate(Status, ProdRouting.Status::"Under Development");
                                        ProdRouting.Modify;

                                        PAGE.Run(PAGE::Routing, ProdRouting);
                                    end;
                                    Rec.Modify;
                                end;
                            end else begin
                                // Routing No. is blank and Routing with Item No. is found
                                ProdRouting.SetRange("No.", Rec."No.");
                                if ProdRouting.FindFirst then begin
                                    PAGE.Run(PAGE::Routing, ProdRouting);
                                    Rec."Routing No." := ProdRouting."No.";   // on
                                end;
                            end;
                        end;
                    end;
                end;

                trigger OnLookup(var Text: Text): Boolean
                var
                    ProdRoutingVer: Record "Routing Version";
                    ProdVer: Record "Routing Version";
                    ProdRouting: Record "Routing Header";
                    VersionMgt: Codeunit VersionManagement;
                    ActiveVersionCode: Code[20];
                    MfgSetupT: Record "Manufacturing Setup";
                begin
                    //MP11 begin
                    //See local variables
                    //See global textconstants MPText000 to MPText003
                    if Rec.FieldActive(Rec."Routing Curr Version") then begin
                        MfgSetupT.Get;
                        ActiveVersionCode := '';
                        if Rec."Routing No." <> '' then begin
                            ActiveVersionCode := VersionMgt.GetRtngVersion(Rec."Routing No.", WorkDate, true);  // TRUE = (only certified)

                            if ProdRoutingVer.Get(Rec."Routing No.", ActiveVersionCode) then begin
                                ProdRoutingVer.SetFilter("Routing No.", Rec."Routing No.");
                                PAGE.Run(PAGE::"Routing Version", ProdRoutingVer);
                            end else begin
                                //no routing versions so get Prod. BOM Header
                                ProdRouting.SetRange("No.", Rec."Routing No.");
                                if ProdRouting.FindFirst then begin
                                    PAGE.Run(PAGE::Routing, ProdRouting);
                                    Rec."Routing No." := ProdRouting."No.";   // on Item
                                end;
                            end;
                        end else begin
                            // "Routing No." is ''
                            if not ProdRouting.Get(Rec."No.") then begin
                                if Confirm(MPRText000 +
                                            MPText001, false, Rec."No.") then begin
                                    ProdRouting.Init;
                                    ProdRouting."No." := Rec."No.";
                                    ProdRouting.Description := Rec.Description;
                                    ProdRouting."Search Description" := Rec."No.";
                                    ProdRouting.Status := ProdRouting.Status::"Under Development";
                                    //ProdRouting."Version Nos." := MfgSetupT."Routing Version No. Series";
                                    Rec."Routing No." := Rec."No.";  // on Item
                                    ProdRouting.Insert(true);

                                    MfgSetupT.Get;
                                    if MfgSetupT."Always Create Router Versions" then begin
                                        ProdRouting.Validate(Status, ProdRouting.Status::Certified);
                                        ProdRouting.Modify;

                                        ProdVer.Init;
                                        ProdVer."Routing No." := Rec."No.";
                                        ProdVer."Version Code" := '1';
                                        ProdVer.Description := Rec.Description;
                                        ProdVer."Starting Date" := WorkDate;
                                        ProdVer.Status := ProdVer.Status::"Under Development";
                                        ProdVer.Insert(true);
                                        ProdVer.SetRange("Routing No.", Rec."No.");
                                        PAGE.Run(PAGE::"Routing Version", ProdVer);
                                        Rec."Routing Curr Version" := ProdVer."Version Code";

                                    end else begin
                                        ProdRouting.Validate(Status, ProdRouting.Status::"Under Development");
                                        ProdRouting.Modify;

                                        PAGE.Run(PAGE::Routing, ProdRouting);
                                    end;
                                    Rec.Modify;
                                end;
                            end else begin
                                // Routing No. is blank and Routing with Item No. is found
                                ProdRouting.SetRange("No.", Rec."No.");
                                if ProdRouting.FindFirst then begin
                                    PAGE.Run(PAGE::Routing, ProdRouting);
                                    Rec."Routing No." := ProdRouting."No.";   // on
                                end;
                            end;
                        end;
                    end;
                end;
            }
            field("Production BOM No."; Rec."Production BOM No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of the Production BOM.';

                trigger OnDrillDown()
                var
                    ProdBOMHeader: Record "Production BOM Header";
                    ProdBOMVer: Record "Production BOM Version";
                    ProdVer: Record "Production BOM Version";
                    ProdBOM: Record "Production BOM Header";
                    VersionMgt: Codeunit VersionManagement;
                    ActiveVersionCode: Code[20];
                    MfgSetupT: Record "Manufacturing Setup";
                begin
                    if Rec."Production BOM No." = '' then begin
                        if not ProdBOM.Get(Rec."No.") then begin
                            if Confirm(MPText000 +
                                        MPText001, false, Rec."No.") then begin
                                ProdBOM.Init;
                                ProdBOM."No." := Rec."No.";
                                ProdBOM.Description := Rec.Description;
                                ProdBOM."Search Name" := Rec."No.";
                                ProdBOM."Unit of Measure Code" := Rec."Base Unit of Measure";
                                ProdBOM.Status := ProdBOM.Status::"Under Development";
                                //ProdBOM."Version Nos." := MfgSetupT."Prod. BOM Version No. Series";
                                Rec."Production BOM No." := Rec."No.";   // on Item
                                ProdBOM.Insert(true);
                                //MODIFY;

                                MfgSetupT.Get;
                                if MfgSetupT."Always Create BOM Versions" then begin
                                    ProdBOM.Validate(Status, ProdBOM.Status::Certified);
                                    ProdBOM.Modify;

                                    ProdVer.Init;
                                    ProdVer."Production BOM No." := Rec."No.";
                                    ProdVer."Version Code" := '1';
                                    ProdVer."Starting Date" := WorkDate;
                                    ProdVer.Description := Rec.Description;
                                    ProdVer."Unit of Measure Code" := Rec."Base Unit of Measure";
                                    ProdVer.Status := ProdVer.Status::"Under Development";
                                    ProdVer.Insert(true);
                                    ProdVer.SetRange("Production BOM No.", Rec."No.");
                                    PAGE.Run(PAGE::"Production BOM Version", ProdVer);
                                    Rec."Prod BOM Curr Version" := ProdVer."Version Code";

                                end else begin
                                    ProdBOM.Validate(Status, ProdBOM.Status::"Under Development");
                                    ProdBOM.Modify;

                                    PAGE.Run(PAGE::"Production BOM", ProdBOM);
                                end;
                            end;

                        end else begin
                            ActiveVersionCode := VersionMgt.GetBOMVersion(Rec."No.", WorkDate, false);  //FALSE = Not Certified
                            if ProdBOMVer.Get(Rec."No.", ActiveVersionCode) then begin
                                ProdBOMVer.SetFilter("Production BOM No.", Rec."No.");
                                PAGE.Run(PAGE::"Production BOM Version", ProdBOMVer);
                                Rec."Production BOM No." := Rec."No.";   // on Item
                            end else begin
                                //no BOM versions so get Prod. BOM Header
                                ProdBOM.SetRange("No.", Rec."No.");
                                if ProdBOM.FindFirst then begin
                                    PAGE.Run(PAGE::"Production BOM", ProdBOM);
                                    Rec."Production BOM No." := Rec."No.";  // on Item
                                end;
                            end;
                        end;
                    end else
                        if Rec.FieldActive(Rec."Production BOM No.") then begin
                            if ProdBOMHeader.Get(Rec."Production BOM No.") then
                                PAGE.Run(PAGE::"Production BOM", ProdBOMHeader);
                        end;
                end;

                trigger OnLookup(var Text: Text): Boolean
                var
                    ProdBOMHeader: Record "Production BOM Header";
                    ProdBOMVer: Record "Production BOM Version";
                    ProdVer: Record "Production BOM Version";
                    ProdBOM: Record "Production BOM Header";
                    VersionMgt: Codeunit VersionManagement;
                    ActiveVersionCode: Code[20];
                    MfgSetupT: Record "Manufacturing Setup";
                begin
                    if Rec."Production BOM No." = '' then begin
                        if not ProdBOM.Get(Rec."No.") then begin
                            if Confirm(MPText000 +
                                        MPText001, false, Rec."No.") then begin
                                ProdBOM.Init;
                                ProdBOM."No." := Rec."No.";
                                ProdBOM.Description := Rec.Description;
                                ProdBOM."Search Name" := Rec."No.";
                                ProdBOM."Unit of Measure Code" := Rec."Base Unit of Measure";
                                ProdBOM.Status := ProdBOM.Status::"Under Development";
                                //ProdBOM."Version Nos." := MfgSetupT."Prod. BOM Version No. Series";
                                Rec."Production BOM No." := Rec."No.";   // on Item
                                ProdBOM.Insert(true);
                                //MODIFY;

                                MfgSetupT.Get;
                                if MfgSetupT."Always Create BOM Versions" then begin
                                    ProdBOM.Validate(Status, ProdBOM.Status::Certified);
                                    ProdBOM.Modify;

                                    ProdVer.Init;
                                    ProdVer."Production BOM No." := Rec."No.";
                                    ProdVer."Version Code" := '1';
                                    ProdVer."Starting Date" := WorkDate;
                                    ProdVer.Description := Rec.Description;
                                    ProdVer."Unit of Measure Code" := Rec."Base Unit of Measure";
                                    ProdVer.Status := ProdVer.Status::"Under Development";
                                    ProdVer.Insert(true);
                                    ProdVer.SetRange("Production BOM No.", Rec."No.");
                                    PAGE.Run(PAGE::"Production BOM Version", ProdVer);
                                    Rec."Prod BOM Curr Version" := ProdVer."Version Code";

                                end else begin
                                    ProdBOM.Validate(Status, ProdBOM.Status::"Under Development");
                                    ProdBOM.Modify;

                                    PAGE.Run(PAGE::"Production BOM", ProdBOM);
                                end;
                            end;

                        end else begin
                            ActiveVersionCode := VersionMgt.GetBOMVersion(Rec."No.", WorkDate, false);  //FALSE = Not Certified
                            if ProdBOMVer.Get(Rec."No.", ActiveVersionCode) then begin
                                ProdBOMVer.SetFilter("Production BOM No.", Rec."No.");
                                PAGE.Run(PAGE::"Production BOM Version", ProdBOMVer);
                                Rec."Production BOM No." := Rec."No.";   // on Item
                            end else begin
                                //no BOM versions so get Prod. BOM Header
                                ProdBOM.SetRange("No.", Rec."No.");
                                if ProdBOM.FindFirst then begin
                                    PAGE.Run(PAGE::"Production BOM", ProdBOM);
                                    Rec."Production BOM No." := Rec."No.";  // on Item
                                end;
                            end;
                        end;
                    end else
                        if Rec.FieldActive(Rec."Production BOM No.") then begin
                            if ProdBOMHeader.Get(Rec."Production BOM No.") then
                                PAGE.Run(PAGE::"Production BOM", ProdBOMHeader);
                        end;
                end;
            }
            field("Prod BOM Curr Version"; Rec."Prod BOM Curr Version")
            {
                ApplicationArea = All;

                trigger OnDrillDown()
                var
                    ProdBOMVer: Record "Production BOM Version";
                    ProdVer: Record "Production BOM Version";
                    ProdBOM: Record "Production BOM Header";
                    VersionMgt: Codeunit VersionManagement;
                    ActiveVersionCode: Code[20];
                    MfgSetupT: Record "Manufacturing Setup";
                begin
                    //MP11 start
                    //See local variables
                    //See global textconstants MPText000 to MPText003
                    if Rec.FieldActive(Rec."Prod BOM Curr Version") then begin
                        MfgSetupT.Get;
                        ActiveVersionCode := '';
                        if Rec."Production BOM No." <> '' then
                            ActiveVersionCode := VersionMgt.GetBOMVersion(Rec."Production BOM No.", WorkDate, true);  //TRUE = Get Certified

                        if ProdBOMVer.Get(Rec."Production BOM No.", ActiveVersionCode) then begin
                            ProdBOMVer.SetFilter("Production BOM No.", Rec."Production BOM No.");
                            PAGE.Run(PAGE::"Production BOM Version", ProdBOMVer);
                        end else begin
                            if Rec."Production BOM No." = '' then begin
                                if not ProdBOM.Get(Rec."No.") then begin
                                    if Confirm(MPText000 +
                                                MPText001, false, Rec."No.") then begin
                                        ProdBOM.Init;
                                        ProdBOM."No." := Rec."No.";
                                        ProdBOM.Description := Rec.Description;
                                        ProdBOM."Search Name" := Rec."No.";
                                        ProdBOM."Unit of Measure Code" := Rec."Base Unit of Measure";
                                        ProdBOM.Status := ProdBOM.Status::"Under Development";
                                        //ProdBOM."Version Nos." := MfgSetupT."Prod. BOM Version No. Series";
                                        Rec."Production BOM No." := Rec."No.";   // on Item
                                        ProdBOM.Insert(true);
                                        //MODIFY;

                                        MfgSetupT.Get;
                                        if MfgSetupT."Always Create BOM Versions" then begin
                                            ProdBOM.Validate(Status, ProdBOM.Status::Certified);
                                            ProdBOM.Modify;

                                            ProdVer.Init;
                                            ProdVer."Production BOM No." := Rec."No.";
                                            ProdVer."Version Code" := '1';
                                            ProdVer."Starting Date" := WorkDate;
                                            ProdVer.Description := Rec.Description;
                                            ProdVer."Unit of Measure Code" := Rec."Base Unit of Measure";
                                            ProdVer.Status := ProdVer.Status::"Under Development";
                                            ProdVer.Insert(true);
                                            ProdVer.SetRange("Production BOM No.", Rec."No.");
                                            PAGE.Run(PAGE::"Production BOM Version", ProdVer);
                                            Rec."Prod BOM Curr Version" := ProdVer."Version Code";

                                        end else begin
                                            ProdBOM.Validate(Status, ProdBOM.Status::"Under Development");
                                            ProdBOM.Modify;

                                            PAGE.Run(PAGE::"Production BOM", ProdBOM);
                                        end;
                                    end;

                                end else begin
                                    ActiveVersionCode := VersionMgt.GetBOMVersion(Rec."No.", WorkDate, false);  //FALSE = Not Certified
                                    if ProdBOMVer.Get(Rec."No.", ActiveVersionCode) then begin
                                        ProdBOMVer.SetFilter("Production BOM No.", Rec."No.");
                                        PAGE.Run(PAGE::"Production BOM Version", ProdBOMVer);
                                        Rec."Production BOM No." := Rec."No.";   // on Item
                                    end else begin
                                        //no BOM versions so get Prod. BOM Header
                                        ProdBOM.SetRange("No.", Rec."No.");
                                        if ProdBOM.FindFirst then begin
                                            PAGE.Run(PAGE::"Production BOM", ProdBOM);
                                            Rec."Production BOM No." := Rec."No.";  // on Item
                                        end;
                                    end;
                                end;

                            end else begin
                                // Prod. BOM No. is not blank
                                if not ProdBOM.Get(Rec."Production BOM No.") then begin
                                    if Confirm(MPText000 +
                                                MPText001, false, Rec."Production BOM No.") then begin
                                        ProdBOM.Init;
                                        ProdBOM."No." := Rec."Production BOM No.";
                                        ProdBOM.Description := Rec.Description;
                                        ProdBOM."Search Name" := Rec."Production BOM No.";
                                        ProdBOM."Unit of Measure Code" := Rec."Base Unit of Measure";
                                        ProdBOM.Status := ProdBOM.Status::"Under Development";
                                        //ProdBOM."Version Nos." := MfgSetupT."Prod. BOM Version No. Series";
                                        Rec."Production BOM No." := Rec."Production BOM No.";   // on Item
                                        ProdBOM.Insert(true);
                                        //MODIFY;

                                        if Rec."Production BOM No." <> '' then
                                            ActiveVersionCode := VersionMgt.GetBOMVersion(Rec."Production BOM No.", WorkDate, false);  //FALSE = Not Certified

                                        if ProdBOMVer.Get(Rec."Production BOM No.", ActiveVersionCode) then begin
                                            ProdBOMVer.SetFilter("Production BOM No.", Rec."Production BOM No.");
                                            PAGE.Run(PAGE::"Production BOM Version", ProdBOMVer)
                                        end else begin
                                            MfgSetupT.Get;
                                            if MfgSetupT."Always Create BOM Versions" then begin
                                                ProdBOM.Validate(Status, ProdBOM.Status::Certified);
                                                ProdBOM.Modify;

                                                ProdVer.Init;
                                                ProdVer."Production BOM No." := Rec."Production BOM No.";
                                                ProdVer."Version Code" := '1';
                                                ProdVer."Starting Date" := WorkDate;
                                                ProdVer.Description := Rec.Description;
                                                ProdVer."Unit of Measure Code" := Rec."Base Unit of Measure";
                                                ProdVer.Status := ProdVer.Status::"Under Development";
                                                ProdVer.Insert(true);
                                                ProdVer.SetRange("Production BOM No.", Rec."Production BOM No.");
                                                PAGE.Run(PAGE::"Production BOM Version", ProdVer);
                                                Rec."Prod BOM Curr Version" := ProdVer."Version Code";
                                            end else begin
                                                ProdBOM.Validate(Status, ProdBOM.Status::"Under Development");
                                                ProdBOM.Modify;

                                                PAGE.Run(PAGE::"Production BOM", ProdBOM);
                                            end;
                                        end;
                                    end;

                                end else begin
                                    //no BOM versions so get Prod. BOM Header
                                    if Rec."Production BOM No." <> '' then
                                        ActiveVersionCode := VersionMgt.GetBOMVersion(Rec."Production BOM No.", WorkDate, false);  //FALSE = Not Certified

                                    if ProdBOMVer.Get(Rec."Production BOM No.", ActiveVersionCode) then begin
                                        ProdBOMVer.SetFilter("Production BOM No.", Rec."Production BOM No.");
                                        PAGE.Run(PAGE::"Production BOM Version", ProdBOMVer)
                                    end else begin
                                        MfgSetupT.Get;
                                        if MfgSetupT."Always Create BOM Versions" then begin
                                            ProdVer.Init;
                                            ProdVer."Production BOM No." := Rec."Production BOM No.";
                                            ProdVer."Version Code" := '1';
                                            ProdVer."Starting Date" := WorkDate;
                                            ProdVer.Description := Rec.Description;
                                            ProdVer."Unit of Measure Code" := Rec."Base Unit of Measure";
                                            ProdVer.Status := ProdVer.Status::"Under Development";
                                            ProdVer.Insert(true);
                                            ProdVer.SetRange("Production BOM No.", Rec."Production BOM No.");
                                            PAGE.Run(PAGE::"Production BOM Version", ProdVer);

                                            Rec."Prod BOM Curr Version" := ProdVer."Version Code";
                                        end else begin
                                            ProdBOM.SetRange("No.", Rec."Production BOM No.");
                                            if ProdBOM.FindFirst then begin
                                                PAGE.Run(PAGE::"Production BOM", ProdBOM);
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                    Rec.Modify;
                    //MP11 end
                end;

                trigger OnLookup(var Text: Text): Boolean
                var
                    ProdBOMVer: Record "Production BOM Version";
                    ProdVer: Record "Production BOM Version";
                    ProdBOM: Record "Production BOM Header";
                    VersionMgt: Codeunit VersionManagement;
                    ActiveVersionCode: Code[20];
                    MfgSetupT: Record "Manufacturing Setup";
                begin
                    //MP11 start
                    //See local variables
                    //See global textconstants MPText000 to MPText003
                    if Rec.FieldActive(Rec."Prod BOM Curr Version") then begin
                        MfgSetupT.Get;
                        ActiveVersionCode := '';
                        if Rec."Production BOM No." <> '' then
                            ActiveVersionCode := VersionMgt.GetBOMVersion(Rec."Production BOM No.", WorkDate, true);  //TRUE = Get Certified

                        if ProdBOMVer.Get(Rec."Production BOM No.", ActiveVersionCode) then begin
                            ProdBOMVer.SetFilter("Production BOM No.", Rec."Production BOM No.");
                            PAGE.Run(PAGE::"Production BOM Version", ProdBOMVer);
                        end else begin
                            if Rec."Production BOM No." = '' then begin
                                if not ProdBOM.Get(Rec."No.") then begin
                                    if Confirm(MPText000 +
                                                MPText001, false, Rec."No.") then begin
                                        ProdBOM.Init;
                                        ProdBOM."No." := Rec."No.";
                                        ProdBOM.Description := Rec.Description;
                                        ProdBOM."Search Name" := Rec."No.";
                                        ProdBOM."Unit of Measure Code" := Rec."Base Unit of Measure";
                                        ProdBOM.Status := ProdBOM.Status::"Under Development";
                                        //ProdBOM."Version Nos." := MfgSetupT."Prod. BOM Version No. Series";
                                        Rec."Production BOM No." := Rec."No.";   // on Item
                                        ProdBOM.Insert(true);
                                        //MODIFY;

                                        MfgSetupT.Get;
                                        if MfgSetupT."Always Create BOM Versions" then begin
                                            ProdBOM.Validate(Status, ProdBOM.Status::Certified);
                                            ProdBOM.Modify;

                                            ProdVer.Init;
                                            ProdVer."Production BOM No." := Rec."No.";
                                            ProdVer."Version Code" := '1';
                                            ProdVer."Starting Date" := WorkDate;
                                            ProdVer.Description := Rec.Description;
                                            ProdVer."Unit of Measure Code" := Rec."Base Unit of Measure";
                                            ProdVer.Status := ProdVer.Status::"Under Development";
                                            ProdVer.Insert(true);
                                            ProdVer.SetRange("Production BOM No.", Rec."No.");
                                            PAGE.Run(PAGE::"Production BOM Version", ProdVer);
                                            Rec."Prod BOM Curr Version" := ProdVer."Version Code";

                                        end else begin
                                            ProdBOM.Validate(Status, ProdBOM.Status::"Under Development");
                                            ProdBOM.Modify;

                                            PAGE.Run(PAGE::"Production BOM", ProdBOM);
                                        end;
                                    end;

                                end else begin
                                    ActiveVersionCode := VersionMgt.GetBOMVersion(Rec."No.", WorkDate, false);  //FALSE = Not Certified
                                    if ProdBOMVer.Get(Rec."No.", ActiveVersionCode) then begin
                                        ProdBOMVer.SetFilter("Production BOM No.", Rec."No.");
                                        PAGE.Run(PAGE::"Production BOM Version", ProdBOMVer);
                                        Rec."Production BOM No." := Rec."No.";   // on Item
                                    end else begin
                                        //no BOM versions so get Prod. BOM Header
                                        ProdBOM.SetRange("No.", Rec."No.");
                                        if ProdBOM.FindFirst then begin
                                            PAGE.Run(PAGE::"Production BOM", ProdBOM);
                                            Rec."Production BOM No." := Rec."No.";  // on Item
                                        end;
                                    end;
                                end;

                            end else begin
                                // Prod. BOM No. is not blank
                                if not ProdBOM.Get(Rec."Production BOM No.") then begin
                                    if Confirm(MPText000 +
                                                MPText001, false, Rec."Production BOM No.") then begin
                                        ProdBOM.Init;
                                        ProdBOM."No." := Rec."Production BOM No.";
                                        ProdBOM.Description := Rec.Description;
                                        ProdBOM."Search Name" := Rec."Production BOM No.";
                                        ProdBOM."Unit of Measure Code" := Rec."Base Unit of Measure";
                                        ProdBOM.Status := ProdBOM.Status::"Under Development";
                                        //ProdBOM."Version Nos." := MfgSetupT."Prod. BOM Version No. Series";
                                        Rec."Production BOM No." := Rec."Production BOM No.";   // on Item
                                        ProdBOM.Insert(true);
                                        //MODIFY;

                                        if Rec."Production BOM No." <> '' then
                                            ActiveVersionCode := VersionMgt.GetBOMVersion(Rec."Production BOM No.", WorkDate, false);  //FALSE = Not Certified

                                        if ProdBOMVer.Get(Rec."Production BOM No.", ActiveVersionCode) then begin
                                            ProdBOMVer.SetFilter("Production BOM No.", Rec."Production BOM No.");
                                            PAGE.Run(PAGE::"Production BOM Version", ProdBOMVer)
                                        end else begin
                                            MfgSetupT.Get;
                                            if MfgSetupT."Always Create BOM Versions" then begin
                                                ProdBOM.Validate(Status, ProdBOM.Status::Certified);
                                                ProdBOM.Modify;

                                                ProdVer.Init;
                                                ProdVer."Production BOM No." := Rec."Production BOM No.";
                                                ProdVer."Version Code" := '1';
                                                ProdVer."Starting Date" := WorkDate;
                                                ProdVer.Description := Rec.Description;
                                                ProdVer."Unit of Measure Code" := Rec."Base Unit of Measure";
                                                ProdVer.Status := ProdVer.Status::"Under Development";
                                                ProdVer.Insert(true);
                                                ProdVer.SetRange("Production BOM No.", Rec."Production BOM No.");
                                                PAGE.Run(PAGE::"Production BOM Version", ProdVer);
                                                Rec."Prod BOM Curr Version" := ProdVer."Version Code";
                                            end else begin
                                                ProdBOM.Validate(Status, ProdBOM.Status::"Under Development");
                                                ProdBOM.Modify;

                                                PAGE.Run(PAGE::"Production BOM", ProdBOM);
                                            end;
                                        end;
                                    end;

                                end else begin
                                    //no BOM versions so get Prod. BOM Header
                                    if Rec."Production BOM No." <> '' then
                                        ActiveVersionCode := VersionMgt.GetBOMVersion(Rec."Production BOM No.", WorkDate, false);  //FALSE = Not Certified

                                    if ProdBOMVer.Get(Rec."Production BOM No.", ActiveVersionCode) then begin
                                        ProdBOMVer.SetFilter("Production BOM No.", Rec."Production BOM No.");
                                        PAGE.Run(PAGE::"Production BOM Version", ProdBOMVer)
                                    end else begin
                                        MfgSetupT.Get;
                                        if MfgSetupT."Always Create BOM Versions" then begin
                                            ProdVer.Init;
                                            ProdVer."Production BOM No." := Rec."Production BOM No.";
                                            ProdVer."Version Code" := '1';
                                            ProdVer."Starting Date" := WorkDate;
                                            ProdVer.Description := Rec.Description;
                                            ProdVer."Unit of Measure Code" := Rec."Base Unit of Measure";
                                            ProdVer.Status := ProdVer.Status::"Under Development";
                                            ProdVer.Insert(true);
                                            ProdVer.SetRange("Production BOM No.", Rec."Production BOM No.");
                                            PAGE.Run(PAGE::"Production BOM Version", ProdVer);

                                            Rec."Prod BOM Curr Version" := ProdVer."Version Code";
                                        end else begin
                                            ProdBOM.SetRange("No.", Rec."Production BOM No.");
                                            if ProdBOM.FindFirst then begin
                                                PAGE.Run(PAGE::"Production BOM", ProdBOM);
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                    Rec.Modify;
                    //MP11 end
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        UpdateFactBox;
    end;

    var
        NetSupply: Decimal;
        MPText000: Label 'A Production BOM Header does not exist for Item %1 \';
        MPText001: Label 'Would you like to create one now?';
        MPRText000: Label 'A Routing Header does not exist for Item %1 \';

    procedure UpdateFactBox()
    var
        VersionMgt: Codeunit VersionManagement;
    begin
        //Get Active Versions
        if Rec."Routing No." <> '' then
            Rec."Routing Curr Version" := VersionMgt.GetRtngVersion(Rec."Routing No.", WorkDate, true);  // TRUE = (only certified)

        if Rec."Production BOM No." <> '' then
            Rec."Prod BOM Curr Version" := VersionMgt.GetBOMVersion(Rec."Production BOM No.", WorkDate, true);  //TRUE = Get Certified

        CurrPage.Update(false); //Called from Page in which this FB is Embedded
    end;
}

