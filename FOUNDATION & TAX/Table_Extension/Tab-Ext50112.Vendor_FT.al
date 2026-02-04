tableextension 50112 Vendor_FT extends Vendor
{
    fields
    {
        field(50100; "NPWP No_FT"; Code[20])
        {
            Caption = 'NPWP';
        }
        field(50101; "NPWP Nama_FT"; Code[50])
        {
            Caption = 'Nama NPWP';
        }
        field(50102; "NPWP Alamat_FT"; Text[250])
        {
            Caption = 'Alamat NPWP';
        }
        field(50111; "WHT Business Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'WHT Business Posting Group';
            TableRelation = WHTBusinessPostinGroup_FT."Code";
        }

        field(50112;"Category Asset";Text[100])
        {
            
        }

        field(50113;"Industrial Classification";Text[250])
        {

        }


    }
}