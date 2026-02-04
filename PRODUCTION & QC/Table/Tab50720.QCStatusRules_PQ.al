table 50720 QCStatusRules_PQ
{
    // version QC71.1

    Caption = 'Quality Control Status Rules';

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Description"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(10; "Non-Mgr Default"; Option)
        {
            OptionMembers = ,Yes,No,Confirm;
            DataClassification = CustomerContent;
        }
        field(11; "Mgr Default"; Option)
        {
            OptionMembers = ,Yes,No,Confirm;
            DataClassification = CustomerContent;
        }
        field(12; "Non-Mgr New"; Option)
        {
            OptionMembers = Default,Yes,No,Confirm;
            DataClassification = CustomerContent;
        }
        field(13; "Mgr New"; Option)
        {
            OptionMembers = Default,Yes,No,Confirm;
            DataClassification = CustomerContent;
        }
        field(14; "Non-Mgr Ready For Testing"; Option)
        {
            OptionMembers = Default,Yes,No,Confirm;
            DataClassification = CustomerContent;
        }
        field(15; "Mgr Ready For Testing"; Option)
        {
            OptionMembers = Default,Yes,No,Confirm;
            DataClassification = CustomerContent;
        }
        field(16; "Non-Mgr In Process"; Option)
        {
            OptionMembers = Default,Yes,No,Confirm;
            DataClassification = CustomerContent;
        }
        field(17; "Mgr In Process"; Option)
        {
            OptionMembers = Default,Yes,No,Confirm;
            DataClassification = CustomerContent;
        }
        field(18; "Non-Mgr Ready for Review"; Option)
        {
            OptionMembers = Default,Yes,No,Confirm;
            DataClassification = CustomerContent;
        }
        field(19; "Mgr Ready for Review"; Option)
        {
            OptionMembers = Default,Yes,No,Confirm;
            DataClassification = CustomerContent;
        }
        field(20; "Non-Mgr Certified"; Option)
        {
            OptionMembers = Default,Yes,No,Confirm;
            DataClassification = CustomerContent;
        }
        field(21; "Mgr Certified"; Option)
        {
            OptionMembers = Default,Yes,No,Confirm;
            DataClassification = CustomerContent;
        }
        field(22; "Non-Mgr Certified With Waiver"; Option)
        {
            OptionMembers = Default,Yes,No,Confirm;
            DataClassification = CustomerContent;
        }
        field(23; "Mgr Certified With Waiver"; Option)
        {
            OptionMembers = Default,Yes,No,Confirm;
            DataClassification = CustomerContent;
        }
        field(24; "Non-Mgr Certified Final"; Option)
        {
            OptionMembers = Default,Yes,No,Confirm;
            DataClassification = CustomerContent;
        }
        field(25; "Mgr Certified Final"; Option)
        {
            OptionMembers = Default,Yes,No,Confirm;
            DataClassification = CustomerContent;
        }
        field(100; "Non-Mgr Rejected"; Option)
        {
            OptionMembers = Default,Yes,No,Confirm;
            DataClassification = CustomerContent;
        }
        field(101; "Mgr Rejected"; Option)
        {
            OptionMembers = Default,Yes,No,Confirm;
            DataClassification = CustomerContent;
        }
        field(102; "Non-Mgr Closed"; Option)
        {
            OptionMembers = Default,Yes,No,Confirm;
            DataClassification = CustomerContent;
        }
        field(103; "Mgr Closed"; Option)
        {
            OptionMembers = Default,Yes,No,Confirm;
            DataClassification = CustomerContent;
        }
        field(200; "Must Complete"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(201; "Mgr Can Waive"; Text[250])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        QCFuncs: Codeunit QCFunctionLibrary_PQ;
        IsQCMgr: Boolean;
        ThisDefault: Option Yes,No,Confirm;
        ThisStatusOption: Option Default,Yes,No,Confirm;
        QCStatusRules: Record QCStatusRules_PQ;

    procedure InitStatusRules();
    begin

        INIT;

        Code := 'PRINTCOA';
        Description := 'Allow Printing of a Certificate of Authority';
        "Non-Mgr Default" := "Non-Mgr Default"::No;
        "Mgr Default" := "Mgr Default"::No;
        "Mgr Certified" := "Mgr Certified"::Confirm;
        "Mgr Certified With Waiver" := "Mgr Certified With Waiver"::Confirm;
        "Non-Mgr Certified Final" := "Non-Mgr Certified Final"::Yes;
        "Mgr Certified Final" := "Mgr Certified Final"::Yes;

        INSERT;
    end;

    procedure CheckCoAAvail(QCTestHeader: Record QualityTestHeader_PQ) CoAAvailable: Text;
    begin
        //New,Ready for Testing,In-Process,Ready for Review,Certified,Certified with Waiver,Certified Final,,,,,,,Rejected,Closed

        //Default,Yes,No,Confirm

        CoAAvailable := 'No';

        QCStatusRules.SETRANGE(Code, 'PRINTCOA');
        if QCStatusRules.FINDFIRST then begin
            IsQCMgr := QCFuncs.TestQCMgr;
            if IsQCMgr then
                ThisDefault := QCStatusRules."Mgr Default"
            else
                ThisDefault := QCStatusRules."Non-Mgr Default";

            case QCTestHeader."Test Status" of

                QCTestHeader."Test Status"::"In-Process":
                    begin
                        if IsQCMgr then
                            ThisStatusOption := QCStatusRules."Mgr In Process"
                        else
                            ThisStatusOption := QCStatusRules."Non-Mgr In Process";
                    end; //END "In-Process" CASE

                QCTestHeader."Test Status"::"Ready for Review":
                    begin
                        if IsQCMgr then
                            ThisStatusOption := QCStatusRules."Mgr Ready for Review"
                        else
                            ThisStatusOption := QCStatusRules."Non-Mgr Ready for Review";
                    end; //END "Ready for Review" CASE

                QCTestHeader."Test Status"::Certified:
                    begin
                        if IsQCMgr then
                            ThisStatusOption := QCStatusRules."Mgr Certified"
                        else
                            ThisStatusOption := QCStatusRules."Non-Mgr Certified";
                    end; //END "Certified" CASE

            /*QCTestHeader."Test Status"::"Certified Final":
                begin
                    if IsQCMgr then
                        ThisStatusOption := QCStatusRules."Mgr Certified Final"
                    else
                        ThisStatusOption := QCStatusRules."Non-Mgr Certified Final";
                end; //END "Certified Final" CASE
            */

            end; //End CASEs

            case ThisStatusOption of

                ThisStatusOption::Default:
                    begin
                        if ThisDefault = ThisDefault::Yes then
                            CoAAvailable := 'Yes';
                        if ThisDefault = ThisDefault::No then
                            CoAAvailable := 'No';
                        if ThisDefault = ThisDefault::Confirm then
                            CoAAvailable := 'Confirm'
                    end; //END Default CASE

                ThisStatusOption::Yes:
                    CoAAvailable := 'Yes';

                ThisStatusOption::No:
                    CoAAvailable := 'No';

                ThisStatusOption::Confirm:
                    CoAAvailable := 'Confirm';

                else
                    CoAAvailable := FORMAT(ThisStatusOption);

            end; //End CASEs

        end;
    end;
}

