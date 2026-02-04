page 50738 SpecificationCategories_PQ
{
    Caption = 'Categories';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = SpecificationCategory_PQ;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}