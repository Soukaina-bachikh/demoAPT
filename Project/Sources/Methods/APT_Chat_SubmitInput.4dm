// Sends the current text in the native message input, if non-empty, and clears it

#DECLARE()

var $text : Text
$text:=Trim(Form.messageText)

If ($text#"")
	Form.messageText:=""
	APT_Chat_Receive($text)
End if
