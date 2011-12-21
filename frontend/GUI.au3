#Include "_CSV2Array.au3"
#include "TabControler.au3"
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Include <GuiListView.au3>

Global $path = ""
Local $hGui = GUICreate("Sportwahl", 750, 600)
GUISetBkColor(0xbbbbbb)

Local $aTabText[4] = ["Schritt 1", "Schritt 2", "Schritt 3", "Einstellungen"]
Local $aTabIcons[4][2] = [["shell32.dll", 131],["shell32.dll", 109],["shell32.dll", 109],["shell32.dll", 21]]
Global $aCtrlTab = _OwnTab_Create($hGui, $aTabText, 10, 10, 730, 550, 30, 0xD5D5D5, 0xCFE0E7, 0xCFE0E7, $aTabIcons)

Local $aTabTip[4] = ["Eingabe", "Verarbeitung", "Ausgabe", "Einstellungen"]
_OwnTab_SetTip($aCtrlTab, $aTabTip)

#Region Tab1
_OwnTab_Add($aCtrlTab)
Global $inputLV = GUICtrlCreateListView("  Name  |  Schwerpunkt  |  1.Wahl Q1  |  2.Wahl Q1  |  1.Wahl Q2  |  2.Wahl Q2  |  Skikurs", 15, 48, 718, 500)
Global $loadCSVButton = GUICtrlCreateButton("CSV Moodle-Export Laden", 15, 550, 200, 20)
Global $inputButton = GUICtrlCreateButton("Datensatz hinzufügen", 215, 550, 200, 20)
#EndRegion Tab1

#Region Tab2
_OwnTab_Add($aCtrlTab)
#EndRegion Tab2

#Region Tab3
_OwnTab_Add($aCtrlTab)
#EndRegion Tab3

#Region Tab4
_OwnTab_Add($aCtrlTab)
#EndRegion Tab4

#Region Tab5 and "Tab in Tab"
_OwnTab_Add($aCtrlTab)
#EndRegion Tab5

_OwnTab_End($aCtrlTab)
_OwnTab_Disable($aCtrlTab, 2)
_OwnTab_Disable($aCtrlTab, 3)
_OwnTab_SetFontCol($aCtrlTab, 0xFF)

GUISetState()
GUISetState(@SW_SHOW,$hGui)
_OwnTab_AlarmInit()

Local $msg
While 1
    $msg = GUIGetMsg()
    For $a = 1 To UBound($aCtrlTab, 1) - 1
        If $msg = $aCtrlTab[$a][0] Then
            _OwnTab_Switch($aCtrlTab, $a)
            If $a = 5 Then
                _OwnTab_Switch($aCtrlTab2, $aCtrlTab2[0][0], 1)
                _OwnTab_Switch($aCtrlTab3, $aCtrlTab3[0][0], 1)
            EndIf
        EndIf
    Next
	
    Switch $msg
	Case $loadCSVButton
		$path = FileOpenDialog("CSV-Datei auswählen",@scriptdir,"Moodle-Export(*.csv)",1)
		ReadSVC()
	Case $inputButton
		_addStudent()
	Case -3
           Exit
    EndSwitch
    Sleep(10)
WEnd

Func _addStudent()
	if $path <> "" Then
		RunWait(@ScriptDir&'\add.exe '&""""&$path&"""")
	Else
		MsgBox(0,"Achtung","keine Datei geladen")
		Return
	EndIf
	ReadSVC();refresh
EndFunc

Func ReadSVC()
	_GUICtrlListView_DeleteAllItems($inputLV)
	$oExcel = FileOpen($path, 0)
	If @error = 1 Then
		MsgBox(0, "Error!", "Die Datei("&$path&") ist schlecht formatiert.")
		return
	ElseIf @error = 2 Then
		MsgBox(0, "Error!", "Die Datei("&$path&") Existiert nicht.")
		return
	EndIf
	
	$data = _CSV2Array($oExcel, ",", True, 1)
	$i = 1 ; weil die erste reihe mist ist
	;_ArrayDisplay($data); DEBUG
	While $i < UBound($data)
		if $data[$i][8] = "Skikurs" Then
			$ski = "ja"
		Else
			$ski = "nein"
		EndIf
		GUICtrlCreateListViewItem($data[$i][2]&"|"&$data[$i][3]&"|"&$data[$i][4]&"|"&$data[$i][5]&"|"&$data[$i][6]&"|"&$data[$i][7]&"|"&$ski,$inputLV)
		$i += 1
	WEnd
EndFunc
