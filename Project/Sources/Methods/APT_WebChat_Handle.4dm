// Entry point for the public web chat, called from the exposed "chat" REST class function
// (Project/Sources/Classes/DataStore.4dm) - i.e. POST /rest/$catalog/chat.
// Stateless per-request: the browser holds the conversationID (localStorage) and passes it
// back each turn; the full message history lives in Conversation.messages, same as the
// native Chat form, so both surfaces use the exact same tables/tools/system prompt.

#DECLARE($body : Object) : Object

var $result : Object:={success: False}

Try
	var $userMessage : Text
	$userMessage:=APT_TextOrEmpty($body.message)

	If ($userMessage="")
		$result.error:="Message is required."
		return $result
	End if

	var $conversationID : Text
	$conversationID:=APT_TextOrEmpty($body.conversationID)

	var $conv : cs.ConversationEntity
	$conv:=Null
	If ($conversationID#"")
		$conv:=ds.Conversation.query("conversationID = :1"; $conversationID).first()
	End if

	var $messages : Collection
	If ($conv=Null)
		$conv:=ds.Conversation.new()
		$conv.messages:="[]"
		$conv.startedAt:=String(Current date; "yyyy-MM-dd")+"T"+String(Current time; "HH:mm:ss")
		$conv.save()
		$messages:=[{role: "system"; content: APT_SystemPrompt}]
	Else
		$messages:=JSON Parse($conv.messages)
		// Refresh the system message every turn rather than trusting the stored one -
		// otherwise a resumed conversation keeps whatever rules/date were baked in when it
		// started, silently ignoring later APT_SystemPrompt edits and going stale on "today".
		If ($messages.length>0) && ($messages[0].role="system")
			$messages[0].content:=APT_SystemPrompt
		Else
			$messages.unshift({role: "system"; content: APT_SystemPrompt})
		End if
	End if

	$messages.push({role: "user"; content: $userMessage})

	var $turn : Object
	$turn:=APT_WebChat_RunTurn($messages)

	If (Not($turn.success))
		$result.error:=$turn.error
		return $result
	End if

	$conv.messages:=JSON Stringify($turn.messages)
	If ($turn.clientID#"")
		$conv.clientID:=$turn.clientID
	End if
	If ($turn.appointmentID#"")
		$conv.appointmentID:=$turn.appointmentID
	End if
	$conv.save()

	$result.success:=True
	$result.conversationID:=$conv.conversationID
	$result.reply:=$turn.reply

Catch
	$result.error:=Last errors.first().message
End try

return $result
