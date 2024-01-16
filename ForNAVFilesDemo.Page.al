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
                    FileService.ScanDir('', '*.*', true, TempFileDirectory);
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
        }
    }
}