// Chat form method

var $event : Object
$event:=FORM Event

Case of

	: ($event.code=On Load)
		Form.messageText:=""
		APT_Chat_StartConversation

		var $htmlPath : Text
		$htmlPath:=Get 4D folder(Current resources folder)+"chat.html"
		WA OPEN URL(*; "webArea"; $htmlPath)

End case
