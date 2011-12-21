#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

if $CmdLine[0] = 0 Then
	MsgBox(0,"Error","kein Pfad angegeben")
	Exit
EndIf
MsgBox(0,"",$CmdLine[1])
#Region ### START Koda GUI section ### Form=C:\Dokumente und Einstellungen\Artboy\Desktop\sportwahl\GUI\addGUI.kxf
$addGUI = GUICreate("Datensatz einfügen", 401, 178, 278, 402, -1, BitOR($WS_EX_TOOLWINDOW,$WS_EX_WINDOWEDGE))
$Label1 = GUICtrlCreateLabel("Name:", 8, 8, 35, 17)
$inName = GUICtrlCreateInput("", 8, 32, 121, 21)
$Label2 = GUICtrlCreateLabel("Schwerpunkt:", 8, 64, 70, 17)
$inTWD = GUICtrlCreateRadio("Datenverarbeitung", 8, 88, 113, 17)
$inTWM = GUICtrlCreateRadio("Maschinenbau", 8, 104, 113, 17)
$inTWE = GUICtrlCreateRadio("Elektrotechnik", 8, 120, 113, 17)
$Label3 = GUICtrlCreateLabel("1.Wahl Q1", 144, 8, 55, 17)
$in1q1 = GUICtrlCreateInput("", 144, 32, 121, 21)
$Label4 = GUICtrlCreateLabel("2.Wahl Q1", 272, 8, 55, 17)
$in2q1 = GUICtrlCreateInput("", 272, 32, 121, 21)
$Label5 = GUICtrlCreateLabel("1.Wahl Q2", 144, 64, 55, 17)
$in1q2 = GUICtrlCreateInput("", 144, 88, 121, 21)
$Label6 = GUICtrlCreateLabel("2.Wahl Q2", 272, 64, 55, 17)
$in2q2 = GUICtrlCreateInput("", 272, 88, 121, 21)
$inSki = GUICtrlCreateCheckbox("möchte am Skikurs teilnehmen?", 144, 120, 177, 17)
$inDone = GUICtrlCreateButton("Speichern", 104, 144, 75, 25)
$inStop = GUICtrlCreateButton("Abbruch", 184, 144, 75, 25)
#EndRegion ### END Koda GUI section ###
GUISetState()

While 1
    $msg = GUIGetMsg()
    Switch $msg
	Case $inDone
		_save(GUICtrlRead($inName),_getSP(),GUICtrlRead($in1q1),GUICtrlRead($in1q2),GUICtrlRead($in2q1),GUICtrlRead($in2q2),GUICtrlRead($inSki))
		Exit
	Case $inStop
		Exit
	EndSwitch
    Sleep(10)
WEnd

Func _save($Name,$SP,$1q1,$2q1,$1q2,$2q2,$ski)
	if $ski = $GUI_CHECKED Then
		$tSki = "Skikurs"
	else
		$tSki = "ich möchte keinen Ski-oder Snowboardkurs belegen"
	EndIf
	FileWriteLine($CmdLine[1],",none,"&$Name&","&$SP&","&$1q1&","&$2q1&","&$1q2&","&$2q2&","&$tSki&",57,SW Q1 Q2")
EndFunc

Func _getSP()
	if GUICtrlRead($inTWD) = $GUI_CHECKED Then
		return "Datenverarbeitung"
	ElseIf GUICtrlRead($inTWM) = $GUI_CHECKED Then
		return "Maschinenbau"
	ElseIf GUICtrlRead($inTWE) = $GUI_CHECKED Then
		return "Elektrotechnik"
	Else
		return -1
	EndIf
EndFunc