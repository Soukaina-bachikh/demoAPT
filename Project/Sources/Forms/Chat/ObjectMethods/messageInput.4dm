If (Form event code=On After Keystroke)
	If (Character code(Keystroke)=Carriage return)
		FILTER KEYSTROKE("")
		APT_Chat_SubmitInput
	End if
End if
