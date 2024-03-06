report 52000 PostnetExampleINT
{
    ApplicationArea = All;
    Caption = 'Postnet Example';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = '.\CustomerPostnetBarcode.rdlc';
    Permissions = tabledata Customer = R;
    dataset
    {
        dataitem(Integer; Integer)
        {
            MaxIteration = 1;
            column(Post_Code; intPostCode)
            {
            }
            column(PostnetFontFamily; txtPostnetFontFamily)
            {
            }
            column(Barcode_Postnet; GetBarcode_Postnet())
            {
            }
            column(Code39FontFamily; txtCode39FontFamily)
            {
            }
            column(GetBarcode_Code39; GetBarcode_Code39())
            {
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                field("Post Code"; intPostCode)
                {
                    Caption = 'Post Code';
                    ApplicationArea = All;
                    ToolTip = 'Used to test Barcode rendering.';
                }
                field("Postnet Font Family"; txtPostnetFontFamily)
                {
                    Caption = 'Postnet Font Family';
                    ApplicationArea = All;
                    ToolTip = 'Sets the font used for Postnet barcode rendering.';
                }
                field("Code39 Font Family"; txtCode39FontFamily)
                {
                    Caption = 'Code 39 Font Family';
                    ApplicationArea = All;
                    ToolTip = 'Sets the font used for Code39 barcode rendering.';
                }
            }
        }
    }
    trigger OnInitReport()
    begin
        intPostCode := 80204;
        txtPostnetFontFamily := 'IDAutomationUSPS';
        txtCode39FontFamily := 'IDAutomationHC39M';
    end;

    var
        intPostCode: Integer;
        txtPostnetFontFamily: Text;
        txtCode39FontFamily: Text;

    local procedure GetBarcode_Code39() EncodedText: Text;
    var
        BarcodeSymbology: Enum "Barcode Symbology";
    begin
        BarcodeSymbology := BarcodeSymbology::Code39;
        EncodedText := GetBarcode(BarcodeSymbology);
    end;

    local procedure GetBarcode_Postnet() EncodedText: Text;
    var
        BarcodeSymbology: Enum "Barcode Symbology";
    begin
        BarcodeSymbology := BarcodeSymbology::Postnet;
        EncodedText := GetBarcode(BarcodeSymbology);
    end;

    local procedure GetBarcode(var BarcodeSymbology: Enum "Barcode Symbology") EncodedText: Text;
    var
        txtBarcodeString: Text;
        BarcodeFontProvider: Interface "Barcode Font Provider";
    begin
        if intPostCode = 0 then exit;
        // Declare the barcode provider using the barcode provider interface and enum
        BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;

        // Set data string source
        txtBarcodeString := Format(intPostCode);
        // Validate the input. This method is not available for 2D provider
        BarcodeFontProvider.ValidateInput(txtBarcodeString, BarcodeSymbology);

        // Encode the data string to the barcode font
        EncodedText := BarcodeFontProvider.EncodeFont(txtBarcodeString, BarcodeSymbology);
    end;
}