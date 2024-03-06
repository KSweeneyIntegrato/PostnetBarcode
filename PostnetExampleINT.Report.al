report 52000 PostnetExampleINT
{
    ApplicationArea = All;
    Caption = 'Postnet Example';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = '.\PostnetBarcode.rdlc';
    dataset
    {
        dataitem(Integer; Integer)
        {
            MaxIteration = 1;
            column(Post_Code; gcdPostCode)
            {
            }
            column(Barcode_Postnet; GetBarcode_Postnet())
            {
            }
            column(Barcode_Postnet_Description; GetDescription(true))
            {
            }
            column(Barcode_Postnet_FontFamily; gtxtPostnetFontFamily)
            {
            }
            column(Barcode_Code39; GetBarcode_Code39())
            {
            }
            column(Barcode_Code39_Description; GetDescription(false))
            {
            }
            column(Barcode_Code39_FontFamily; gtxtCode39FontFamily)
            {
            }
        }
    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                field(PostCode; gcdPostCode)
                {
                    Caption = 'Post Code';
                    ApplicationArea = All;
                    ToolTip = 'Used to test Barcode rendering.';
                    trigger OnValidate()
                    begin
                        SetPostCodeNumeric();
                    end;
                }
                group(Postnet)
                {
                    field(PostnetFontFamily; gtxtPostnetFontFamily)
                    {
                        Caption = 'Font Family';
                        ApplicationArea = All;
                        ToolTip = 'Sets the font used for Postnet barcode rendering.';
                    }
                    field(genPostnetBarcodeSymbology; genPostnetBarcodeSymbology)
                    {
                        Caption = 'Symbology';
                        ApplicationArea = All;
                        ToolTip = 'Picks the symbology used to create encoded text for the Postnet Barcode.';
                    }
                }
                group(Code39)
                {
                    field(Code39FontFamily; gtxtCode39FontFamily)
                    {
                        Caption = 'Font Family';
                        ApplicationArea = All;
                        ToolTip = 'Sets the font used for Code39 barcode rendering.';
                        Editable = false;
                    }
                    field(genCode39BarcodeSymbology; genCode39BarcodeSymbology)
                    {
                        Caption = 'Symbology';
                        ApplicationArea = All;
                        ToolTip = 'Picks the symbology used to create encoded text for the Code39 Barcode.';
                        Editable = false;
                    }
                }
            }
        }
    }
    trigger OnInitReport()
    begin
        genCode39BarcodeSymbology := genCode39BarcodeSymbology::Code39;
        gtxtCode39FontFamily := 'IDAutomationHC39M';
    end;

    var
        genPostnetBarcodeSymbology: Enum "Barcode Symbology";
        genCode39BarcodeSymbology: Enum "Barcode Symbology";
        gcdPostCode: Code[50];
        gtxtPostnetFontFamily: Text;
        gtxtCode39FontFamily: Text;

    local procedure GetBarcode_Code39() EncodedText: Text;
    begin
        EncodedText := GetBarcode(genCode39BarcodeSymbology);
    end;

    local procedure GetBarcode_Postnet() EncodedText: Text;
    begin
        EncodedText := GetBarcode(genPostnetBarcodeSymbology);
    end;

    local procedure GetBarcode(var BarcodeSymbology: Enum "Barcode Symbology") EncodedText: Text;
    var
        txtBarcodeString: Text;
        BarcodeFontProvider: Interface "Barcode Font Provider";
    begin
        if gcdPostCode = '' then exit;
        // Declare the barcode provider using the barcode provider interface and enum
        BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;

        // Set data string source
        txtBarcodeString := Format(gcdPostCode);
        // Validate the input. This method is not available for 2D provider
        BarcodeFontProvider.ValidateInput(txtBarcodeString, BarcodeSymbology);

        // Encode the data string to the barcode font
        EncodedText := BarcodeFontProvider.EncodeFont(txtBarcodeString, BarcodeSymbology);
    end;

    local procedure GetDescription(bIsPostnet: Boolean) txtDescription: Text
    var
        llblDescription: Label 'Font Family: %1, Symbology: %2';
    begin
        if bIsPostnet then
            txtDescription := StrSubstNo(llblDescription, gtxtPostnetFontFamily, genPostnetBarcodeSymbology)
        else
            txtDescription := StrSubstNo(llblDescription, gtxtCode39FontFamily, genCode39BarcodeSymbology);
    end;

    local procedure SetPostCodeNumeric()
    var
        lcuRegex: Codeunit Regex;
    begin
        //gcdPostCode := CopyStr(lcuRegex.Replace(gcdPostCode, '^[0-9]*$'), 1, MaxStrLen(gcdPostCode));
    end;
}