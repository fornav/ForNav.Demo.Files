page 50100 "ForNAV Files Demo"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Name; 'Welcome to ForNAV files demo')
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                    ToolTip = 'ForNAV files demo page';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ScanDir)
            {
                ApplicationArea = All;
                Image = Filed;
                ToolTip = 'Scan directory';

                trigger OnAction()
                var
                    TempFileDirectory: Record "ForNAV File Directory" temporary;
                    FileService: Codeunit "ForNAV File Service";
                begin
                    FileService.ScanDir('DEMOFILES:\', '*.*', true, TempFileDirectory);
                    if TempFileDirectory.FindFirst() then;
                    TempFileDirectory.SetFilter(ShareDirectory, TempFileDirectory.LinkDirectory);
                    page.RunModal(Page::"ForNAV File Directory", TempFileDirectory);
                end;
            }
            action(WriteText)
            {
                ApplicationArea = All;
                Caption = 'Write Text File';
                ToolTip = 'Write the test text file.';
                Image = Export;

                trigger OnAction()
                var
                    FileService: Codeunit "ForNAV File Service";
                begin
                    FileService.WriteText('DEMOFILES:\test.txt', 'Hello world!', "ForNAV Encoding"::"utf-8", true);
                end;
            }
            action(WriteTextTwoDevices)
            {
                ApplicationArea = All;
                Caption = 'Write Text File to two devices';
                ToolTip = 'Write the test text file to two devices.';
                Image = Export;

                trigger OnAction()
                var
                    FileService: Codeunit "ForNAV File Service";
                begin
                    FileService.SetDevice('DEVICE1');
                    FileService.WriteText('DEMOFILES:\device1.txt', 'Hello device 1!', "ForNAV Encoding"::"utf-8", true);
                    FileService.SetDevice('DEVICE2');
                    FileService.WriteText('DEMOFILES:\device2.txt', 'Hello device 2!', "ForNAV Encoding"::"utf-8", true);
                end;
            }
            action(ReadText)
            {
                ApplicationArea = All;
                Caption = 'Read Text File';
                ToolTip = 'Read the test text file.';
                Image = Import;

                trigger OnAction()
                var
                    FileService: Codeunit "ForNAV File Service";
                    t: Text;
                begin
                    FileService.SetErrorAction("ForNAV File Error Action"::Ignore);
                    t := FileService.ReadText('DEMOFILES:\test.txt', "ForNAV Encoding"::"utf-8");
                    if FileService.LastError() <> '' then
                        Message('Read Error:\\' + FileService.LastError())
                    else
                        Message('File Content:\\' + t);
                end;
            }
            action(Exists)
            {
                ApplicationArea = All;
                Caption = 'Exists';
                ToolTip = 'Check if test file exists';
                Image = Questionaire;

                trigger OnAction()
                var
                    FileService: Codeunit "ForNAV File Service";
                begin
                    message(format(FileService.FileExist('DEMOFILES:\test.txt')));
                end;
            }
            action(DeleteFile)
            {
                ApplicationArea = All;
                Caption = 'Delete File';
                ToolTip = 'Delete the test file';
                Image = "Invoicing-MDL-Delete";

                trigger OnAction()
                var
                    FileService: Codeunit "ForNAV File Service";
                begin
                    FileService.DeleteFile('DEMOFILES:\test.txt');
                end;
            }
            action(ExportInvoices)
            {
                // This action will demonstrate how to loop through invoices and save them.
                ApplicationArea = All;
                Caption = 'Export Invoices';
                ToolTip = 'Export invoices to files';
                Image = ExportFile;

                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                    SalesInvHeader2: Record "Sales Invoice Header";
                    FileService: Codeunit "ForNAV File Service";
                    TempBlob: Codeunit "Temp Blob";
                    TypeHelper: Codeunit "Type Helper";
                    RecRef: RecordRef;
                    InStr: InStream;
                    OutStr: OutStream;
                    FileNameLbl: Label '%1_%2.pdf', Comment = '%1 = Number; %2 = Name';
                    FileName: Text;
                    Count: Integer;
                begin
                    RecRef.Open(Database::"Sales Invoice Header");
                    if SalesInvHeader.FindSet() then
                        repeat
                            Count += 1;
                            Clear(TempBlob);
                            OutStr := TempBlob.CreateOutStream();
                            SalesInvHeader2.Setrange("No.", SalesInvHeader."No.");
                            RecRef.Copy(SalesInvHeader2);
                            Report.SaveAs(Report::"Standard Sales - Invoice", '', ReportFormat::Pdf, OutStr, RecRef);
                            InStr := TempBlob.CreateInStream();
                            FileName := StrSubstNo(FileNameLbl, SalesInvHeader."No.", SalesInvHeader."Sell-to Customer Name");
                            FileName := TypeHelper.UrlEncode(FileName);
                            FileService.WriteFromStream('DEMOFILES:\' + FileName, InStr);
                        until (SalesInvHeader.Next() = 0) or (Count = 10);
                end;
            }
        }
    }
}