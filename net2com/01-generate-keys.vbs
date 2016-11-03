
'generate a strong name key pair, its base name matching
'the base name of the file passed in on the command line

'drag the .cs file onto this script

With New KeyPairGenerator
    .Main
End With

Class KeyPairGenerator

    Private fso, sa
    Private batFile, msg

    Sub Class_Initialize
        batFile = "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\Tools\VsDevCmd.bat"
        Set fso = CreateObject("Scripting.FileSystemObject")
        Set sa = CreateObject("Shell.Application")
    End Sub

    Sub Main

        'validate command-line argument, batch file

        If 0 = WScript.Arguments.Count Then Err.Raise 1, WScript.ScriptName, "A command line argument is required:" & vbLf & vbTab & "the basename desired for the .snk key file or a filespec with the desired base name."
        If Not fso.FileExists(batFile) Then Err.Raise 1, WScript.ScriptName, "Couldn't find the batch file """ & batFile & """. You could try changing the batFile value hardcoded in """ & WScript.ScriptName & """ to match your system. If you don't have Visual Studio, but you have some version of the .NET framework in C:\Windows\Microsoft.NET\Framework, then you can still compile and register without a strong name: Remove or comment out the line in the .cs file with AssemblyKeyFileAttribute. You will receive a warning message when registering the .dll."
        filespec = WScript.Arguments(0)

        'build the arguments

        args = "/c cd """ & fso.GetParentFolderName(WScript.ScriptFullName) & """"
        args = args & " & """ & batFile & """"
        args = args & " & sn -k " & fso.GetBaseName(filespec) & ".snk"
        args = args & " & echo. & pause"

        'give an opt out

        If Len(cmd) > 254 Then
            'command length exceeds InputBox limit, so use MsgBox
            msg = "Verify arguments"
            If vbCancel = MsgBox(args, vbOKCancel, msg & " - " & WScript.ScriptName) Then Exit Sub
        Else
            msg = "Verify/modify arguments"
            If "" = InputBox(msg, WScript.ScriptName, args) Then Exit Sub
        End If

        'generate the strong name key pair

        sa.ShellExecute "cmd", args',, "runas"

    End Sub

    Sub Class_Terminate
        Set fso = Nothing
        Set sa = Nothing
    End Sub
End Class
