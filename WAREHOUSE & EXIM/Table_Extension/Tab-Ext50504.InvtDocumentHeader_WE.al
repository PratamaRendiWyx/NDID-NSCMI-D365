tableextension 50504 InvtDocumentHeader_WE extends "Invt. Document Header"
{
    fields
    {
        // Add changes to table fields here

        field(50500; Remarks; Text[250])
        {
        }

        field(50501; IsSubcon; Boolean)
        {
            trigger OnValidate()
            begin
                if IsSubcon then begin
                    "Vendor No." := '';
                    "Vendor Name" := '';
                end;
            end;
        }

        field(50509; "Vendor No."; Code[20])
        {
            TableRelation = Vendor."No.";
            trigger OnValidate()
            var
                myInt: Integer;
                vendor: Record Vendor;
            begin
                Clear(vendor);
                vendor.Reset();
                vendor.SetRange("No.", "Vendor No.");
                if vendor.Find('-') then begin
                    "Vendor Name" := vendor.Name;
                end;
            end;
        }
        field(50510; "Vendor Name"; Text[100])
        {
        }

    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }


}