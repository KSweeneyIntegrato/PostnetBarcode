report 52000 PostnetExampleINT
{
    ApplicationArea = All;
    Caption = 'Postnet Example';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = '.\CustomerPostnetBarcode.rdlc';
    Permissions = tabledata Customer = R;
    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", Name, "Post Code";
            column(No; "No.")
            {
            }
            column(Name; Name)
            {
            }
            column(Address; Address)
            {
            }
            column(City; City)
            {
            }
            column(County; County)
            {
            }
            column(PostCode; "Post Code")
            {
            }
            column(Country_Region_Code; "Country/Region Code")
            {
            }
            column(Barcode_GlobalVar; gtxtBarcode)
            {
            }
            column(Barcode_Procedure; GetPostnetBarcode())
            {
            }
            trigger OnAfterGetRecord()
            begin
                gtxtBarcode := GetPostnetBarcode();
            end;
        }
    }
    var
        gtxtBarcode: Text;

    local procedure GetPostnetBarcode() EncodedText: Text;
    var
        txtBarcodeString: Text;
        BarcodeSymbology: Enum "Barcode Symbology";
        BarcodeFontProvider: Interface "Barcode Font Provider";

    begin
        if Customer."Post Code" = '' then exit;
        // Declare the barcode provider using the barcode provider interface and enum
        BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;

        // Declare the font using the barcode symbology enum
        BarcodeSymbology := Enum::"Barcode Symbology"::Postnet;

        // Set data string source
        txtBarcodeString := Customer."Post Code";

        // Validate the input. This method is not available for 2D provider
        BarcodeFontProvider.ValidateInput(txtBarcodeString, BarcodeSymbology);

        // Encode the data string to the barcode font
        EncodedText := BarcodeFontProvider.EncodeFont(txtBarcodeString, BarcodeSymbology);
    end;
}