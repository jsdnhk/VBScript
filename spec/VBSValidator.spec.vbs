
With CreateObject("includer")
    Execute(.read("VBSValidator"))
    Execute(.read("TestingFramework"))
End With

Dim val : Set val = New VBSValidator 'Class Under Test

With New TestingFramework

    .describe "VBSValidator class"

    .it "should return True when IsBoolean is given a True"

        .AssertEqual val.IsBoolean(True), True

    .it "should return True when IsBoolean is given a False"

        .AssertEqual val.IsBoolean(False), True

    .it "should return False when IsBoolean is given a 0"

        .AssertEqual val.IsBoolean(0), False

    .it "should return False when IsBoolean is given a 1"

        .AssertEqual val.IsBoolean(1), False

    .it "should return False when IsBoolean is given a string"

        .AssertEqual val.IsBoolean("sdfjke"), False

    .it "should raise an error when EnsureBoolean is given a string"

        Dim nonBool : nonBool = "a string"

        On Error Resume Next

            val.EnsureBoolean(nonBool)

            .AssertErrorRaised

            Dim errDescr : errDescr = Err.Description 'capture the error information
            Dim errSrc : errSrc = Err.Source

        On Error Goto 0

    .it "should give the expected, descriptive, Err.Description"

        .AssertEqual errDescr, WScript.ScriptName & ": " & CStr(nonBool) & val.ErrDescrBool

    .it "should give the expected Err.Source"

        .AssertEqual errSrc, val.GetClassName
        
End With