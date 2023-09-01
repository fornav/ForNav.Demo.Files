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
                    FileMgt: Codeunit "ForNAV File Mgt.";
                begin
                    FileMgt.ScanDir('DEMOFILES:', '*.*', true, TempFileDirectory);
                    if TempFileDirectory.FindFirst() then;
                    Message(Format(TempFileDirectory.Count));
                    TempFileDirectory.SetFilter(ShareDirectory, TempFileDirectory.LinkDirectory);
                    page.RunModal(Page::"ForNAV File Directory", TempFileDirectory);
                end;
            }
            action(Exists)
            {
                ApplicationArea = All;
                Caption = 'Exists';
                ToolTip = 'Check if test.txt exists';
                Image = NewItem;

                trigger OnAction()
                var
                    myFile: Codeunit "ForNAV File Mgt.";
                begin
                    message(format(myFile.FileExist('DEMOFILES:\test.txt')));
                end;
            }
            action(TestFiles)
            {
                ApplicationArea = All;
                Image = TestFile;
                ToolTip = 'Test local file operations';

                trigger OnAction()
                var
                    TempFileDirectory: Record "ForNAV File Directory" temporary;
                    FileMgt: Codeunit "ForNAV File Mgt.";
                    TypeHelper: Codeunit "Type Helper";
                    tmpBlob: Codeunit "Temp Blob";
                    writeBytesBigText: BigText;
                    readBytesBigText: BigText;
                    starttime: DateTime;
                    testTime: DateTime;
                    asyncTime: Duration;
                    syncTime: Duration;
                    linesToWrite: List of [Text];
                    linesToRead: List of [Text];
                    fileOutStream: OutStream;
                    fileInStream: InStream;
                    testPath: Text;
                    fn8: Text;
                    fn16: Text;
                    fn16_2: Text;
                    fn16_copy: Text;
                    i: Integer;
                    b: Boolean;
                    txt: Text;
                    txt2: Text;
                    taskUTF8, taskUTF16, taskReadBytes : Integer;
                    taskDirExistsTrue, taskDirExistsFalse : Integer;
                    taskFileExistsTrue, taskFileExistsFalse : Integer;
                    taskScanDir: Integer;
                    taskReadLines: Integer;
                begin
                    FileMgt.SetTimeOut(20000);
                    testTime := CurrentDateTime();
                    tmpBlob.CreateOutStream(fileOutStream);
                    starttime := CurrentDateTime();
                    testPath := 'DEMOFILES:\filetest-async';

                    // Clean up
                    FileMgt.SetErrorAction("ForNAV File Error Action"::Ignore);
                    FileMgt.DeleteDirectoryTask(testPath + '\filetest', true);

                    // Prepare
                    FileMgt.SetErrorAction("ForNAV File Error Action"::Error);
                    taskDirExistsFalse := FileMgt.DirectoryExistTask(testPath + '\filetest');
                    FileMgt.CreateDirectoryTask(testPath + '\filetest');
                    taskDirExistsTrue := FileMgt.DirectoryExistTask(testPath + '\filetest');

                    // Write bytes
                    taskFileExistsFalse := FileMgt.FileExistTask(testPath + '\filetest\test-write-bytes.txt');
                    writeBytesBigText.AddText('This is a sample output file ' + Format(testTime));
                    Clear(tmpBlob);
                    tmpBlob.CreateOutStream(fileOutStream);
                    writeBytesBigText.Write(fileOutStream);
                    tmpBlob.CreateInStream(fileInStream);
                    FileMgt.WriteFromStreamTask(testPath + '\filetest\test-write-bytes.txt', fileInStream);
                    taskFileExistsTrue := FileMgt.FileExistTask(testPath + '\filetest\test-write-bytes.txt');

                    // Read bytes
                    FileMgt.SetErrorAction("ForNAV File Error Action"::Error);
                    tmpBlob.CreateOutStream(fileOutStream);
                    taskReadBytes := FileMgt.ReadFromStreamTask(testPath + '\filetest\test-write-bytes.txt');

                    // Write lines
                    Clear(linesToWrite);
                    for i := 1 to 1000 do
                        linesToWrite.Add('Line ' + Format(i));
                    FileMgt.WriteLinesTask(testPath + '\filetest\test-write-lines.txt', linesToWrite, "ForNAV Code Page"::"utf-8", true);

                    // Read lines
                    taskReadLines := FileMgt.ReadLinesTask(testPath + '\filetest\test-write-lines.txt', "ForNAV Code Page"::"utf-8");

                    txt := 'My sample text æøå 你好世界';
                    for i := 1 to 15 do
                        txt := txt + TypeHelper.CRLFSeparator() + txt;

                    // UTF8
                    fn8 := testPath + '\filetest\textfile-utf8 æøå 你好世界.txt';
                    FileMgt.WriteTextTask(fn8, txt, "ForNAV Code Page"::"utf-8", true);

                    // UTF16
                    fn16 := testPath + '\filetest\textfile-utf16 æøå 你好世界.txt';
                    fn16_2 := testPath + '\filetest\textfile-utf16 æøå 你好世界 - 2.txt';
                    fn16_copy := 'subdir\textfile-utf16 æøå 你好世界 - copy %1.txt';
                    FileMgt.WriteTextTask(fn16, txt, "ForNAV Code Page"::"utf-16BE", true);

                    // Rename the UTF16 file
                    FileMgt.MoveTask(fn16, fn16_2);

                    FileMgt.SetCurrentDir(testPath + '\filetest');
                    FileMgt.CreateDirectoryTask('subdir');
                    // Copy the new file
                    for i := 1 to 10 do begin
                        FileMgt.CopyTask(fn16_2, StrSubstNo(fn16_copy, i));
                    end;

                    taskUTF8 := FileMgt.ReadTextTask(fn8, "ForNAV Code Page"::"utf-8");
                    taskUTF16 := FileMgt.ReadTextTask(StrSubstNo(fn16_copy, 1), "ForNAV Code Page"::"utf-16BE");

                    FileMgt.CopyTask('subdir', 'subdir 2');

                    FileMgt.SetCurrentDir(testPath + '\filetest');
                    taskScanDir := FileMgt.ScanDirTask('.', '*.*', true);

                    FileMgt.RunTasks();

                    // Validate binary write and read
                    Clear(tmpBlob);
                    tmpBlob.CreateOutStream(fileOutStream);
                    if not FileMgt.GetReadFromStreamTaskResult(taskReadBytes, fileOutStream) then error('Error reading bytes.');
                    tmpBlob.CreateInStream(fileInStream);
                    readBytesBigText.Read(fileInStream);
                    if Format(readBytesBigText) <> Format(writeBytesBigText) then Error('Test failed: Write and read bytes.');

                    // Validate read lines
                    if not FileMgt.GetReadLinesTaskResult(taskReadLines, linesToRead) then error('Unable to read lines.');
                    if linesToRead.Get(3) <> 'Line 3' then Error('Test failed: Reading line does not match.');

                    // Validate UTF-8 read and write
                    if not FileMgt.GetReadTextTaskResult(taskUTF8, txt2) then error('Unable to read UTF8 file.');
                    if txt <> txt2 then Error('Test failed: UTF8 text does not match.');

                    // Validate UTF-16BE read and write
                    if not FileMgt.GetReadTextTaskResult(taskUTF16, txt2) then error('Unable to read UTF16 file.');
                    if txt <> txt2 then Error('Test failed: UTF16 text does not match.');

                    // Validate directory exists
                    if not FileMgt.GetBooleanTaskResult(taskDirExistsFalse, b) then error('Unable to check for non existing directory.');
                    if b then Error('Test failed: The directory should not exist.');
                    if not FileMgt.GetBooleanTaskResult(taskDirExistsTrue, b) then error('Unable to check for existing directory.');
                    if not b then Error('Test failed: The directory should exist.');

                    // Validate file exists
                    if not FileMgt.GetBooleanTaskResult(taskFileExistsFalse, b) then error('Unable to check for non existing file.');
                    if b then Error('Test failed: The file should not exist.');
                    if not FileMgt.GetBooleanTaskResult(taskFileExistsTrue, b) then error('Unable to check for existing file.');
                    if not b then Error('Test failed: The file should exist.');

                    // Validate directory scanning
                    if not FileMgt.GetScanDirTaskResult(taskScanDir, TempFileDirectory) then error('Unable to get directory scanning result.');
                    TempFileDirectory.SetRange(IsDirectory, true);
                    TempFileDirectory.SetRange(Name, 'subdir');
                    if TempFileDirectory.Count <> 1 then Error('Test failed: Cannot find subdir in scandir.');
                    TempFileDirectory.SetRange(IsDirectory, false);
                    TempFileDirectory.SetRange(Name, 'test-write-bytes.txt');
                    if TempFileDirectory.IsEmpty() then Error('Test failed: Cannot find file in scandir.');
                    // if not (TempFileDirectory.FullName = testPath + '\filetest\test-write-bytes.txt') then Error('Test failed: Cannot match full name in scandir.');

                    asyncTime := CurrentDateTime() - starttime;
                    // Message('Async test\Time: %1', endtime - starttime);

                    starttime := CurrentDateTime();

                    //
                    // SYNC TEST
                    //

                    testPath := 'DEMOFILES:\filetest-sync';

                    // Clean up
                    FileMgt.SetErrorAction("ForNAV File Error Action"::Ignore);
                    FileMgt.DeleteDirectory(testPath + '\filetest', true);

                    // Prepare
                    FileMgt.SetErrorAction("ForNAV File Error Action"::Error);
                    if FileMgt.DirectoryExist(testPath + '\filetest') then Error('Folder should not exist.');
                    FileMgt.CreateDirectory(testPath + '\filetest');
                    if not FileMgt.DirectoryExist(testPath + '\filetest') then Error('Folder should exist');

                    // Write bytes
                    Clear(tmpBlob);
                    Clear(writeBytesBigText);
                    if FileMgt.FileExist(testPath + '\filetest\test-write-bytes.txt') then Error('File should not exist');
                    writeBytesBigText.AddText('This is a sample output file ' + Format(testTime));
                    tmpBlob.CreateOutStream(fileOutStream);
                    writeBytesBigText.Write(fileOutStream);
                    tmpBlob.CreateInStream(fileInStream);
                    FileMgt.WriteFromStream(testPath + '\filetest\test-write-bytes.txt', fileInStream);
                    if not FileMgt.FileExist(testPath + '\filetest\test-write-bytes.txt') then Error('File should exist.');

                    // Read bytes
                    Clear(tmpBlob);
                    FileMgt.SetErrorAction("ForNAV File Error Action"::Error);
                    tmpBlob.CreateOutStream(fileOutStream);
                    FileMgt.ReadFromStream(testPath + '\filetest\test-write-bytes.txt', fileOutStream);
                    tmpBlob.CreateInStream(fileInStream);
                    readBytesBigText.Read(fileInStream);
                    if Format(readBytesBigText) <> Format(writeBytesBigText) then Error('Test failed: Write and read bytes.');

                    // Write lines
                    Clear(linesToWrite);
                    for i := 1 to 1000 do
                        linesToWrite.Add('Line ' + Format(i));
                    FileMgt.WriteLines(testPath + '\filetest\test-write-lines.txt', linesToWrite, "ForNAV Code Page"::"utf-8", true);

                    // Validate read lines
                    linesToRead := FileMgt.ReadLines(testPath + '\filetest\test-write-lines.txt', "ForNAV Code Page"::"utf-8");
                    if linesToRead.Get(3) <> 'Line 3' then Error('Test failed: Reading line does not match.');
                    if FileMgt.GetText(linesToRead) <> FileMgt.GetText(linesToWrite) then Error('Test failed: Reading line does not match text of written lines.');

                    // UTF8
                    fn8 := testPath + '\filetest\textfile-utf8 æøå 你好世界.txt';
                    FileMgt.WriteText(fn8, txt, "ForNAV Code Page"::"utf-8", true);

                    // UTF16
                    fn16 := testPath + '\filetest\textfile-utf16 æøå 你好世界.txt';
                    fn16_2 := testPath + '\filetest\textfile-utf16 æøå 你好世界 - 2.txt';
                    fn16_copy := 'subdir\textfile-utf16 æøå 你好世界 - copy %1.txt';
                    FileMgt.WriteText(fn16, txt, "ForNAV Code Page"::"utf-16BE", true);

                    // Rename the UTF16 file
                    FileMgt.Move(fn16, fn16_2);

                    FileMgt.SetCurrentDir(testPath + '\filetest');
                    FileMgt.CreateDirectory('subdir');

                    // Copy the new file
                    FileMgt.Copy(fn16_2, StrSubstNo(fn16_copy, 1));
                    // for i := 1 to 10 do
                    //     myFile.Copy(fn16_2, StrSubstNo(fn16_copy, i));

                    // UTF-8 read and write
                    txt2 := FileMgt.ReadText(fn8, "ForNAV Code Page"::"utf-8");
                    if txt <> txt2 then Error('Test failed: UTF8 text does not match.');
                    txt2 := FileMgt.ReadText(StrSubstNo(fn16_copy, 1), "ForNAV Code Page"::"utf-16BE");
                    if txt <> txt2 then Error('Test failed: UTF16 text does not match.');

                    FileMgt.Copy('subdir', 'subdir 2');

                    // Validate directory scanning
                    Clear(TempFileDirectory);
                    TempFileDirectory.DeleteAll();
                    TempFileDirectory.Reset();
                    FileMgt.SetCurrentDir(testPath + '\filetest');
                    FileMgt.ScanDir('.', '*.*', true, TempFileDirectory);
                    TempFileDirectory.SetRange(IsDirectory, true);
                    TempFileDirectory.SetRange(Name, 'subdir');
                    if not TempFileDirectory.IsEmpty then begin
                        // if Confirm(Format(FileDirectory.Count)) then;
                        // page.RunModal(Page::"ForNAV File Directory", FileDirectory);
                        if TempFileDirectory.Count <> 1 then Error('Test failed: Cannot find subdir in scandir.');
                        TempFileDirectory.SetRange(IsDirectory, false);
                        TempFileDirectory.SetRange(Name, 'test-write-bytes.txt');
                        if TempFileDirectory.IsEmpty() then Error('Test failed: Cannot find file in scandir.');
                        // if not (TempFileDirectory.FullName = testPath + '\filetest\test-write-bytes.txt') then Error('Test failed: Cannot match full name in scandir.');
                    end else
                        Error('Test failed: Scandir did not return any subdir.');

                    syncTime := CurrentDateTime() - starttime;
                    Message('Async test time: %1\Sync test time: %2', asyncTime, syncTime);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
    //  CreateReminders: Report "ForNAV Create Reminders";
    begin
        //   CreateReminders.RunModal;
    end;

}