report 50309 "Sales Budget Entry"
{
    Caption = 'Sales Budget Entry';
    DefaultLayout = RDLC;
    RDLCLayout = './ReportDesign/Sales Budget Entry.rdlc';
    ApplicationArea = Basic, Suite;
    dataset
    {
        dataitem("Item Budget Entry"; "Item Budget Entry")
        {
            DataItemTableView = sorting("Analysis Area", "Budget Name", "Item No.", Date) where("Analysis Area" = const(Sales));
            column(Analysis_Area; "Analysis Area") { }
            column(Budget_Name; "Budget Name") { }
            column(BudgeDesription; getBudgetDesription(BudgeName)) { }
            column(Date; Format(Date, 0, '<Year4>-<Month,2>-<Day,2>')) { }
            column(Item_No_; "Item No.") { }
            column(Desc__Item; "Desc. Item") { }
            column(Variant_Name; '') { }
            column(Source_Type; "Source Type") { }
            column(Source_No_; "Source No.") { }
            column(Description; Description) { }
            column(Quantity; Quantity) { }
            column(Cost_Amount; "Cost Amount") { }
            column(Sales_Amount; "Sales Amount") { }
            column(Location_Code; "Location Code") { }
            column(Site_Code; "Global Dimension 1 Code") { }
            column(Product_Type_Code; "Global Dimension 2 Code") { }
            column(Agency_Code; "Budget Dimension 1 Code") { }
            column(Budget_Type_Code; "Budget Dimension 2 Code") { }
            column(Sales_Person_Code; "Budget Dimension 3 Code") { }
            column(Variant_Code; '') { }
            column(DateFilter; DateFilter) { }
            column(CustomerFilter; CustomerFilter) { }
            column(ItemFilter; ItemFilter) { }
            column(AgencyFilter; AgencyFilter) { }
            column(SiteFilter; SiteFilter) { }
            column(ProductTypeFilter; ProductTypeFilter) { }
            column(BudgetTypeFilter; BudgetTypeFilter) { }
            column(SalesPersonFilter; SalesPersonFilter) { }

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                //get range sales
                SetRange("Analysis Area", "Item Budget Entry"."Analysis Area"::Sales);
                if DateFilter <> '' then
                    SetFilter(Date, DateFilter);
                if CustomerFilter <> '' then
                    SetRange("Source No.", CustomerFilter);
                if ItemFilter <> '' then
                    SetRange("Item No.", ItemFilter);
                if AgencyFilter <> '' then
                    SetRange("Budget Dimension 1 Code", AgencyFilter);
                if SiteFilter <> '' then
                    SetRange("Global Dimension 1 Code", SiteFilter);
                if ProductTypeFilter <> '' then
                    SetRange("Global Dimension 2 Code", ProductTypeFilter);
                if BudgetTypeFilter <> '' then
                    SetRange("Budget Dimension 2 Code", BudgetTypeFilter);
                if SalesPersonFilter <> '' then
                    SetRange("Budget Dimension 3 Code", SalesPersonFilter);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    field(BudgeName; BudgeName)
                    {
                        Caption = 'Budget Name';
                        ApplicationArea = All;
                        Enabled = false;
                        Editable = false;
                    }
                    field(DateFilter; DateFilter)
                    {
                        Caption = 'Date Filter';
                        ApplicationArea = All;
                    }
                    field(CustomerFilter; CustomerFilter)
                    {
                        Caption = 'Customer Filter';
                        ApplicationArea = All;
                        TableRelation = Customer."No.";
                    }
                    field(ItemFilter; ItemFilter)
                    {
                        Caption = 'Item Filter';
                        ApplicationArea = All;
                        TableRelation = Item."No.";
                    }
                    field(AgencyFilter; AgencyFilter)
                    {
                        Caption = 'Agency Filter';
                        ApplicationArea = All;
                        TableRelation = "Dimension Value".Code where("Dimension Code" = const('AGENCY'));
                    }
                    field(BudgetTypeFilter; BudgetTypeFilter)
                    {
                        Caption = 'Budget Type Filter';
                        ApplicationArea = All;
                        TableRelation = "Dimension Value".Code where("Dimension Code" = const('BUDGET TYPE'));
                    }
                    field(SalesPersonFilter; SalesPersonFilter)
                    {
                        Caption = 'Sales Person Filter';
                        ApplicationArea = All;
                        TableRelation = "Dimension Value".Code where("Dimension Code" = const('SALESPERSON'));
                    }
                    field(SiteFilter; SiteFilter)
                    {
                        Caption = 'Site Filter';
                        ApplicationArea = All;
                        TableRelation = "Dimension Value".Code where("Dimension Code" = const('SITE'));
                    }
                    field(ProductTypeFilter; ProductTypeFilter)
                    {
                        Caption = 'Product Type Filter';
                        ApplicationArea = All;
                        TableRelation = "Dimension Value".Code where("Dimension Code" = const('PRODUCT TYPE'));
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    procedure SetParameters(var iBudgetName: Code[10])
    begin
        BudgeName := iBudgetName;
    end;

    local procedure getBudgetDesription(iBudgetName: Text): Text
    var
        itembudgetNames: Record "Item Budget Name";
    begin
        Clear(itembudgetNames);
        itembudgetNames.SetRange(Name, iBudgetName);
        if itembudgetNames.Find('-') then
            exit(itembudgetNames.Description);
        exit('');
    end;

    var

        BudgeName: Text;
        DateFilter: Text;
        CustomerFilter: Text;
        ItemFilter: Text;
        AgencyFilter: Text;
        BudgetTypeFilter: Text;
        SalesPersonFilter: Text;
        SiteFilter: Text;
        ProductTypeFilter: Text;

}
