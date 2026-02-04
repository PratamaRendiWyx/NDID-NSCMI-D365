tableextension 51100 BankAccount_AF extends "Bank Account"
{
    fields
    {
        field(51100; "Branch"; Text[250])
        {
            Caption = 'Branch';
            DataClassification = ToBeClassified;
        }
        // Primary Contact Nos
        field(51101; "Primary Contact No."; Code[20])
        {
            Caption = 'Primary Contact No.';
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record Contact;
                ContBusRel: Record "Contact Business Relation";
                TempBankAccount: Record "Bank Account" temporary;
            begin
                Cont.FilterGroup(2);
                ContBusRel.SetCurrentKey("Link to Table", "No.");
                ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::"Bank Account");
                ContBusRel.SetRange("No.", "No.");
                if ContBusRel.FindFirst() then
                    Cont.SetRange("Company No.", ContBusRel."Contact No.")
                else
                    Cont.SetRange("No.", '');

                if "Primary Contact No." <> '' then
                    if Cont.Get("Primary Contact No.") then;
                if PAGE.RunModal(0, Cont) = ACTION::LookupOK then begin
                    TempBankAccount.Copy(Rec);
                    Find();
                    TransferFields(TempBankAccount, false);
                    Validate("Primary Contact No.", Cont."No.");
                end;
            end;

            trigger OnValidate()
            var
                Cont: Record Contact;
                ContBusRel: Record "Contact Business Relation";
            begin
                Contact := '';
                if "Primary Contact No." <> '' then begin
                    Cont.Get("Primary Contact No.");

                    ContBusRel.FindOrRestoreContactBusinessRelation(Cont, Rec, ContBusRel."Link to Table"::"Bank Account");

                    if Cont."Company No." <> ContBusRel."Contact No." then
                        Error(Text004, Cont."No.", Cont.Name, "No.", Name);

                    if Cont.Type = Cont.Type::Person then begin
                        Contact := Cont.Name;
                        Contact2 := Cont.Name;
                        exit;
                    end;

                    if Cont."Phone No." <> '' then
                        "Phone No." := Cont."Phone No.";
                    if Cont."E-Mail" <> '' then
                        "E-Mail" := Cont."E-Mail";
                end;
            end;
        }
        field(51102; Contact2; Text[100])
        {
            Caption = 'Contact';
            DataClassification = EndUserIdentifiableInformation;

            trigger OnLookup()
            var
                ContactBusinessRelation: Record "Contact Business Relation";
                Cont: Record Contact;
                TempBankAccount: Record "Bank Account" temporary;
            begin
                if ContactBusinessRelation.FindByRelation(ContactBusinessRelation."Link to Table"::"Bank Account", "No.") then
                    Cont.SetRange("Company No.", ContactBusinessRelation."Contact No.")
                else
                    Cont.SetRange("Company No.", '');

                if "Primary Contact No." <> '' then
                    if Cont.Get("Primary Contact No.") then;
                if PAGE.RunModal(0, Cont) = ACTION::LookupOK then begin
                    TempBankAccount.Copy(Rec);
                    Find();
                    TransferFields(TempBankAccount, false);
                    Validate("Primary Contact No.", Cont."No.");
                end;
            end;

            trigger OnValidate()
            begin
                if MarketingSetup.Get() then
                    if MarketingSetup."Bus. Rel. Code for Bank Accs." <> '' then begin
                        if (xRec.Contact2 = '') and (xRec."Primary Contact No." = '') and (Contact2 <> '') then begin
                            Modify();
                            UpdateContFromBank.OnModify(Rec);
                            UpdateContFromBank.InsertNewContactPerson(Rec, false);
                            Modify(true);
                        end;
                        exit;
                    end;
            end;
        }
    }

    var
        Text004: Label 'Contact %1 %2 is not related to Bank Account %3 %4.';
        MarketingSetup: Record "Marketing Setup";
        UpdateContFromBank: Codeunit BankContUpdate_AF;
}
