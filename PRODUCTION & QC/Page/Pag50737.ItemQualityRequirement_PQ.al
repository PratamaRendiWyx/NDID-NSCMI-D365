page 50737 ItemQualityRequirement_PQ
{
    Caption = 'Item Quality Requirement';
    DataCaptionExpression = SetCaption;
    DelayedInsert = true;
    PageType = List;
    SaveValues = true;
    SourceTable = ItemQualityRequirement_PQ;
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';


                field(ItemNoFilterCtrl; ItemNoFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Item No. Filter';
                    ToolTip = 'Specifies a filter for which sales prices to display.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemList: Page "Item List";
                    begin
                        ItemList.LookupMode := true;
                        if ItemList.RunModal = ACTION::LookupOK then
                            Text := ItemList.GetSelectionFilter
                        else
                            exit(false);

                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        ItemNoFilterOnAfterValidate;
                    end;
                }
                field(StartingDateFilter; StartingDateFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Starting Date Filter';
                    ToolTip = 'Specifies a filter for which sales prices to display.';

                    trigger OnValidate()
                    var
                        FilterTokens: Codeunit "Filter Tokens";
                    begin
                        FilterTokens.MakeDateFilter(StartingDateFilter);
                        StartingDateFilterOnAfterValid;
                    end;
                }
            }

            repeater(Control1)
            {
                ShowCaption = false;
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of the item quality requirement.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item no of the item quality requirement.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the variant code of the item quality requirement';
                }
                field("Specification No."; Rec."Specification No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the specification no of the item quality requirement.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location code of the item quality requirement';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the starting date of the item quality requirement.';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ending date of the item quality requirement.';
                }

            }
        }

    }

    trigger OnInit()
    begin
        SalesCodeFilterCtrlEnable := true;
        SalesCodeControlEditable := true;
        IsLookupMode := CurrPage.LookupMode;
    end;

    trigger OnOpenPage()
    begin
        GetRecFilters;
        SetRecFilters;
        SetCaptions();
    end;

    var
        ClientTypeManagement: Codeunit "Client Type Management";
        ItemNoFilter: Text;
        StartingDateFilter: Text[30];
        SetCaption: Text;
        Text000: Label 'All Customers';
        Text001: Label 'No %1 within the filter %2.';
        [InDataSet]
        SalesCodeFilterCtrlEnable: Boolean;
        IsLookupMode: Boolean;
        SalesCodeControlEditable: Boolean;

    local procedure GetRecFilters()
    begin
        if Rec.GetFilters <> '' then
            UpdateBasicRecFilters;

        Evaluate(StartingDateFilter, Rec.GetFilter(Rec."Starting Date"));
    end;

    local procedure UpdateBasicRecFilters()
    begin
        ItemNoFilter := Rec.GetFilter(Rec."Item No.");
    end;

    procedure SetRecFilters()
    begin
        SalesCodeFilterCtrlEnable := true;

        if StartingDateFilter <> '' then
            Rec.SetFilter(Rec."Starting Date", StartingDateFilter)
        else
            Rec.SetRange(Rec."Starting Date");

        if ItemNoFilter <> '' then begin
            Rec.SetFilter(Rec."Item No.", ItemNoFilter);
        end else
            Rec.SetRange(Rec."Item No.");


        CheckFilters(DATABASE::Item, ItemNoFilter);

        CurrPage.Update(false);
    end;

    local procedure SetCaptions()
    begin
        SetCaption := GetFilterDescription();
    end;

    local procedure GetFilterDescription(): Text
    var
        ObjTranslation: Record "Object Translation";
        SourceTableName: Text;
        SalesSrcTableName: Text;
        Description: Text;
    begin
        GetRecFilters;

        SourceTableName := '';
        if ItemNoFilter <> '' then
            SourceTableName := ObjTranslation.TranslateObject(ObjTranslation."Object Type"::Table, 27);

        SalesSrcTableName := '';
        Description := '';


        if SalesSrcTableName = Text000 then
            exit(StrSubstNo('%1 %2 %3', SalesSrcTableName, SourceTableName, ItemNoFilter));
        exit(StrSubstNo('%1 %2 %3 %4', SalesSrcTableName, Description, SourceTableName, ItemNoFilter));
    end;

    local procedure CheckFilters(TableNo: Integer; FilterTxt: Text)
    var
        FilterRecordRef: RecordRef;
        FilterFieldRef: FieldRef;
    begin
        if FilterTxt = '' then
            exit;
        Clear(FilterRecordRef);
        Clear(FilterFieldRef);
        FilterRecordRef.Open(TableNo);
        FilterFieldRef := FilterRecordRef.Field(1);
        FilterFieldRef.SetFilter(FilterTxt);
        if FilterRecordRef.IsEmpty() then
            Error(Text001, FilterRecordRef.Caption, FilterTxt);
    end;

    local procedure StartingDateFilterOnAfterValid()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure ItemNoFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
        SetCaptions();
    end;
}
