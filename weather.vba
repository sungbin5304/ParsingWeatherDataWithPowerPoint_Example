Function GetHTML(URL As String) As String
    Dim Html As String
    With CreateObject("MSXML2.XMLHTTP")
        .Open "GET", URL, False
        .Send
        GetHTML = .ResponseText
    End With
End Function
Function ReplaceRegex(Text As String, Regex As String, NewText As String) As String
    Dim RegexObject As Object
    Set RegexObject = CreateObject("vbscript.regexp")

    With RegexObject
        .Pattern = Regex
        .Global = True
        .IgnoreCase = True
        .MultiLine = True
    End With

    ReplaceRegex = RegexObject.Replace(Text, NewText)
End Function
Function SplitText(Text As String, Regex As String, Index As Integer) As String
    Dim Data() As String
    Data = Split(Text, Regex)
    SplitText = Data(Index)
End Function
Function JoinEnter(Text As String) As String
    Text = Replace(Text, "백령", "[백령]")
    Dim AreaList As Variant
    AreaList = Array("서울", "춘천", "강릉", "대전", "청주", "전주", "대구", "광주", "부산", "제주", "울릉/독도", "안동", "목포", "여수", "울산", "수원")
    For i = 0 To 15
        Dim Area As String
        Area = AreaList(i)
        Text = Replace(Text, Area, "[" + Area + "]")
        Text = Replace(Text, "[" + Area + "]", vbCrLf + "[" + Area + "]")
    Next i
    JoinEnter = Text
End Function
Private Sub LoadWeatherView_Click()
    WeatherView.Caption = "전국날씨 불러오는중..."
    Dim Value As String
    Value = GetHTML("https://m.search.naver.com/search.naver?query=전국날씨")
    Value = SplitText(Value, "전국날씨</strong>", 1)
    Value = SplitText(Value, "<div class=""t_notice"">", 0)
    Value = ReplaceRegex(Value, "<!*[^<>]*>", "")
    Value = Trim(Value)
    Value = JoinEnter(Value)
    Value = Replace(Value, "  ", "")
    Value = Replace(Value, "도씨", "℃")
    Value = SplitText(Value, "관련날씨뉴스", 0)
    Value = Replace(Value, "단위 ℃특보", "")
    Value = Replace(Value, "(", vbCrLf + "기상특보 (")
    Value = Replace(Value, ") ", ")" + vbCrLf)
    Value = Replace(Value, "기상특보", vbCrLf + "기상특보", 1, 1)
    Value = Replace(Value, "기준기상청", "기상청 발표 기준}")
    Dim NowDate As String
    NowData = Format(Date, "mm.dd")
    Value = Replace(Value, NowData, vbCrLf + vbCrLf + "{" + NowData)
    WeatherView.Caption = Value
End Sub
