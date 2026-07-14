// Chat form method

var $event : Object
$event:=FORM Event

Case of

	: ($event.code=On Load)
		Form.messageText:=""
		APT_Chat_StartConversation

		WA SET PREFERENCE(*; "webArea"; WA enable contextual menu; True)
		WA SET PREFERENCE(*; "webArea"; WA enable Web inspector; True)

		var $htmlPath : Text
		$htmlPath:=Get 4D folder(Current resources folder)+"chat.html"
		WA OPEN URL(*; "webArea"; $htmlPath)

End case
