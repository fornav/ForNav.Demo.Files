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
            action(ScanDirSingle)
            {
                ApplicationArea = All;
                Image = Filed;
                Caption = 'Scan demo files';
                ToolTip = 'Scan single directory';

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
            action(ScanDirAll)
            {
                ApplicationArea = All;
                Image = Filed;
                Caption = 'Scan all';
                ToolTip = 'Scan all aliases';

                trigger OnAction()
                var
                    TempFileDirectory: Record "ForNAV File Directory" temporary;
                    FileService: Codeunit "ForNAV File Service";
                begin
                    FileService.ScanDir('', '*.*', true, TempFileDirectory);
                    if TempFileDirectory.FindFirst() then;
                    TempFileDirectory.SetFilter(ShareDirectory, '%1', '');
                    page.RunModal(Page::"ForNAV File Directory", TempFileDirectory);
                end;
            }
            action(ScanDirAllPdf)
            {
                ApplicationArea = All;
                Image = Filed;
                Caption = 'Scan all PDFs';
                ToolTip = 'Find all PDF files';

                trigger OnAction()
                var
                    TempFileDirectory: Record "ForNAV File Directory" temporary;
                    FileService: Codeunit "ForNAV File Service";
                begin
                    FileService.ScanDir('', '*.*|*.pdf', true, TempFileDirectory);
                    if TempFileDirectory.FindFirst() then;
                    TempFileDirectory.SetFilter(ShareDirectory, '%1', '');
                    page.RunModal(Page::"ForNAV File Directory", TempFileDirectory);
                end;
            }
            action(ScanDirFlat)
            {
                ApplicationArea = All;
                Image = Filed;
                Caption = 'Scan all EUR PDFs';
                ToolTip = 'Find all EUR PDF files';

                trigger OnAction()
                var
                    TempFileDirectory: Record "ForNAV File Directory" temporary;
                    FileService: Codeunit "ForNAV File Service";
                begin
                    FileService.ScanDir('', '*eur*.pdf', true, TempFileDirectory);
                    // if TempFileDirectory.FindFirst() then;
                    // TempFileDirectory.SetFilter(ShareDirectory, '%1', '');
                    TempFileDirectory.SetRange(IsDirectory, false);
                    page.RunModal(Page::"ForNAV File Directory", TempFileDirectory);
                end;
            }
            action(ScanDirImages)
            {
                ApplicationArea = All;
                Image = Filed;
                Caption = 'Scan all images';
                ToolTip = 'Find all image files';

                trigger OnAction()
                var
                    TempFileDirectory: Record "ForNAV File Directory" temporary;
                    FileService: Codeunit "ForNAV File Service";
                begin
                    FileService.ScanDir('', 't*.*;s*.?|*.gif;*.png;*.jpg;*.jpeg;*.bmp', true, TempFileDirectory);
                    if TempFileDirectory.FindFirst() then;
                    TempFileDirectory.SetFilter(ShareDirectory, '%1', '');
                    page.RunModal(Page::"ForNAV File Directory", TempFileDirectory);
                end;
            }
            action(ScanDirRegex)
            {
                ApplicationArea = All;
                Image = Filed;
                Caption = 'Scan with Regex';
                ToolTip = 'Find with regular expression';

                trigger OnAction()
                var
                    TempFileDirectory: Record "ForNAV File Directory" temporary;
                    FileService: Codeunit "ForNAV File Service";
                begin
                    FileService.ScanDir('', '@(?i-:)(\w{5,}$)|(\\$)|\\a[^\\]*$', true, TempFileDirectory);
                    if TempFileDirectory.FindFirst() then;
                    TempFileDirectory.SetFilter(ShareDirectory, '%1', '');
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
            action(WriteTextBatch)
            {
                ApplicationArea = All;
                Caption = 'Write Text Files in Batch';
                ToolTip = 'Write the test text files as a batch.';
                Image = Export;

                trigger OnAction()
                var
                    FileService: Codeunit "ForNAV File Service";
                    id1, id2 : Integer;
                    text1, text2 : Text;
                begin
                    FileService.WriteTextTask('DEMOFILES:\test1.txt', 'Hello world!');
                    FileService.WriteTextTask('DEMOFILES:\test2.txt', 'Hello again!');
                    FileService.RunTasks();

                    id1 := FileService.ReadTextTask('DEMOFILES:\test1.txt');
                    id2 := FileService.ReadTextTask('DEMOFILES:\test1.txt');
                    FileService.RunTasks();
                    FileService.GetReadTextTaskResult(id1, text1);
                    FileService.GetReadTextTaskResult(id2, text2);
                    Message('File 1:\%1\\File 2:\%2', text1, text2);

                    FileService.SetErrorAction("ForNAV File Error Action"::Ignore);
                    id1 := FileService.ReadTextTask('DEMOFILES:\test1.txt');
                    id2 := FileService.ReadTextTask('DEMOFILES:\test1.txt');
                    FileService.RunTasks();
                    if not FileService.GetReadTextTaskResult(id1, text1) then
                        Message(FileService.GetTaskError(id1));
                    if not FileService.GetReadTextTaskResult(id2, text2) then
                        Message(FileService.GetTaskError(id2));
                    if FileService.LastError() = '' then
                        Message('File 1:\%1\\File 2:\%2', text1, text2);

                    FileService.GetTaskError(id1);
                    FileService.LastError()

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
                            TempBlob.CreateOutStream(OutStr);
                            SalesInvHeader2.Setrange("No.", SalesInvHeader."No.");
                            RecRef.Copy(SalesInvHeader2);
                            Report.SaveAs(Report::"Standard Sales - Invoice", '', ReportFormat::Pdf, OutStr, RecRef);
                            TempBlob.CreateInStream(InStr);
                            FileName := StrSubstNo(FileNameLbl, SalesInvHeader."No.", SalesInvHeader."Sell-to Customer Name");
                            FileName := TypeHelper.UrlEncode(FileName);
                            FileService.WriteFromStream('DEMOFILES:\' + FileName, InStr);
                        until (SalesInvHeader.Next() = 0) or (Count = 10);
                end;
            }
        }
    }
}