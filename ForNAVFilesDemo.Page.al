page 50100 "ForNAV Files Demo"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Name; 'Welcome to ForNAV files demo')
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                    ToolTip = 'ForNAV files demo page';
                }
            }
            group(Help)
            {
                field(ScanDirDoc; ScanDirHelpUrlLbl)
                {
                    ApplicationArea = All;
                    Caption = 'ScanDir';
                    ToolTip = 'Documentation for ScanDir';

                    // AutoFormatType = Text;
                    ExtendedDatatype = URL;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ScanDirAliases)
            {
                ApplicationArea = All;
                Image = Filed;
                Caption = 'Scan aliases';
                ToolTip = 'Scan get a list of all aliases without files';

                trigger OnAction()
                var
                    TempFileDirectory: Record "ForNAV File Directory" temporary;
                    FileService: Codeunit "ForNAV File Service";
                begin
                    // Get a list of aliases but without any files in the result.
                    FileService.ScanDir('', '', false, TempFileDirectory);
                    TempFileDirectory.SetRange(ShareDirectory, '');
                    if TempFileDirectory.FindFirst() then;
                    page.RunModal(Page::"ForNAV File Directory", TempFileDirectory);
                end;
            }
            action(ScanDirSingle)
            {
                ApplicationArea = All;
                Image = Filed;
                Caption = 'Scan demo files';
                ToolTip = 'Scan single directory with subdirectories';

                trigger OnAction()
                var
                    TempFileDirectory: Record "ForNAV File Directory" temporary;
                    FileService: Codeunit "ForNAV File Service";
                begin
                    // Get all the files in the DEMOFILES directory. All subdirectories are included.
                    FileService.ScanDir('DEMOFILES:\', '*.*', true, TempFileDirectory);
                    if TempFileDirectory.FindFirst() then;
                    TempFileDirectory.SetFilter(ShareDirectory, TempFileDirectory.LinkDirectory);
                    page.RunModal(Page::"ForNAV File Directory", TempFileDirectory);
                end;
            }
            action(ScanDirSingleNonRecursive)
            {
                ApplicationArea = All;
                Image = Filed;
                Caption = 'Scan demo files - not recursive';
                ToolTip = 'Scan single directory without subdirectories';

                trigger OnAction()
                var
                    TempFileDirectory: Record "ForNAV File Directory" temporary;
                    FileService: Codeunit "ForNAV File Service";
                begin
                    // Get all the files in the DEMOFILES directory. All subdirectories are included.
                    FileService.ScanDir('DEMOFILES:\', '*.*', false, TempFileDirectory);
                    if TempFileDirectory.FindFirst() then;
                    TempFileDirectory.SetFilter(ShareDirectory, TempFileDirectory.LinkDirectory);
                    page.RunModal(Page::"ForNAV File Directory", TempFileDirectory);
                end;
            }
            action(ScanDirPdfNonRecursive)
            {
                ApplicationArea = All;
                Image = Filed;
                Caption = 'Scan demo PDF files - not recursive';
                ToolTip = 'Scan single directory for PDF files without subdirectories';

                trigger OnAction()
                var
                    TempFileDirectory: Record "ForNAV File Directory" temporary;
                    FileService: Codeunit "ForNAV File Service";
                begin
                    // Get all the files in the DEMOFILES directory. All subdirectories are included.
                    FileService.ScanDir('DEMOFILES:\', '*.pdf', false, TempFileDirectory);
                    if TempFileDirectory.FindFirst() then;
                    TempFileDirectory.SetFilter(ShareDirectory, TempFileDirectory.LinkDirectory);
                    page.RunModal(Page::"ForNAV File Directory", TempFileDirectory);
                end;
            }
            action(ScanDirPdfAndDirsNonRecursive)
            {
                ApplicationArea = All;
                Image = Filed;
                Caption = 'Scan demo PDF files and directories - not recursive';
                ToolTip = 'Scan single directory for PDF files and all directories';

                trigger OnAction()
                var
                    TempFileDirectory: Record "ForNAV File Directory" temporary;
                    FileService: Codeunit "ForNAV File Service";
                begin
                    // Get all the files in the DEMOFILES directory. All subdirectories are included.
                    FileService.ScanDir('DEMOFILES:\', '*.*|*.pdf', false, TempFileDirectory);
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
                ToolTip = 'Scan all aliases and directories';

                trigger OnAction()
                var
                    TempFileDirectory: Record "ForNAV File Directory" temporary;
                    FileService: Codeunit "ForNAV File Service";
                begin
                    // Get all the files in all aliases. All subdirectories are included.
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
                    // Get all the PDF files in all aliases. All subdirectories are included.
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
                    // Get all the PDF files with 'eur' in then name in all aliases. All subdirectories are included.
                    FileService.ScanDir('', '*eur*.pdf', true, TempFileDirectory);
                    // TempFileDirectory.SetFilter(ShareDirectory, '%1', '');
                    // if TempFileDirectory.FindFirst() then;
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
                    // Get all the image files in all aliases. All subdirectories are included.
                    FileService.ScanDir('', '*.gif;*.png;*.jpg;*.jpeg;*.bmp', true, TempFileDirectory);
                    TempFileDirectory.SetFilter(ShareDirectory, '%1', '');
                    if TempFileDirectory.FindFirst() then;
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
                    // Get all the files with a name that starts with an 'a' or has a file extension of at least 5 characters.
                    // (?i-:) is a case insensitive flag.
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
                    // Write the text file to the DEMOFILES directory.
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
                    // Write the text files to the DEMOFILES directory.
                    FileService.WriteTextTask('DEMOFILES:\test1.txt', 'Hello world!');
                    FileService.WriteTextTask('DEMOFILES:\test2.txt', 'Hello again!');
                    FileService.RunTasks();

                    // Read the text files from the DEMOFILES directory.
                    id1 := FileService.ReadTextTask('DEMOFILES:\test1.txt');
                    id2 := FileService.ReadTextTask('DEMOFILES:\test1.txt');
                    FileService.RunTasks();
                    FileService.GetReadTextTaskResult(id1, text1);
                    FileService.GetReadTextTaskResult(id2, text2);
                    Message('File 1:\%1\\File 2:\%2', text1, text2);

                    // Get the error message from the task.
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
                    // Write the text files to different devices.
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
                    // Read the text file from the DEMOFILES directory.
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
                    // Check if the test file exists in the DEMOFILES directory.
                    Message(Format(FileService.FileExist('DEMOFILES:\test.txt')));
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
                    // Delete the test file from the DEMOFILES directory.
                    FileService.DeleteFile('DEMOFILES:\test.txt');
                end;
            }
            action(CopyFiles)
            {
                ApplicationArea = All;
                Caption = 'Copy files';
                ToolTip = 'Creates error in copy operation';
                Image = Delete;

                trigger OnAction()
                var
                    FileService: Codeunit "ForNAV File Service";
                begin
                    // Set error action to ignore errors.
                    FileService.SetErrorAction("ForNAV File Error Action"::Ignore);

                    // Remove files from previous runs.
                    FileService.DeleteFile('DEMOFILES:\original.txt');
                    FileService.DeleteFile('DEMOFILES:\copy.txt');

                    // Set action to raise errors.
                    FileService.SetErrorAction("ForNAV File Error Action"::Error);

                    // Create original file.
                    FileService.WriteText('DEMOFILES:\original.txt', 'Hello world!');

                    // Copy the file.
                    FileService.Copy('DEMOFILES:\original.txt', 'DEMOFILES:\copy.txt');

                    // Check if the copy operation was successful.
                    if not FileService.FileExist('DEMOFILES:\copy.txt') then
                        Error('Copy operation failed.');

                    // Copy the file again to cause an error becaue the file already exists.
                    FileService.SetErrorAction("ForNAV File Error Action"::Ignore);
                    FileService.Copy('DEMOFILES:\original.txt', 'DEMOFILES:\copy.txt');
                    if FileService.LastError() = '' then
                        Error('Copy operation should have failed because the file already exists.');

                    // Copy the file again without an error because we choose to overwrite the file.
                    FileService.SetErrorAction("ForNAV File Error Action"::Error);
                    FileService.Copy('DEMOFILES:\original.txt', 'DEMOFILES:\copy.txt', true);

                    // Check if the copy operation was successful.
                    if FileService.ReadText('DEMOFILES:\copy.txt', "ForNAV Encoding"::"utf-8") <> 'Hello world!' then
                        Error('Copy operation failed. Content of file is not correct.');

                    Message('Copy operation successful.');
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

    var
        ScanDirHelpUrlLbl: Label 'https://docs.fornav.com/file-service/scan.html';
}