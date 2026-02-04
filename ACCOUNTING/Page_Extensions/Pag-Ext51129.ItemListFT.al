pageextension 51129 "Item List_FT" extends "Item List"
{
    // layout
    // {
    //     addafter(Description)
    //     {
    //         field("Suffix Number"; getSuffixNumber())
    //         {
    //             ApplicationArea = All;
    //         }
    //     }
    // }

    // local procedure getSuffixNumber(): Decimal
    // var
    //     myInt: Integer;
    //     ItemText: Text;
    //     Const: Integer;
    // begin
    //     Const := 2;
    //     Clear(myInt);
    //     ItemText := CopyStr(Rec."No.", 4);
    //     Evaluate(myInt, ItemText);
    //     myInt := (myInt Mod Const) + 1;
    //     exit(myInt);
    // end;

    // trigger OnAfterGetRecord()
    // var
    //     myInt: Integer;
    // begin
    //     getSuffixNumber();
    // end;
}
