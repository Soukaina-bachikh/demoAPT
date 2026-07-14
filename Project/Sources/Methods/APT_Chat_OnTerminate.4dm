// Called by AIKit once the stream completes. Dispatches tool calls if the model requested
// any, otherwise finalizes the reply in the browser and persists the conversation.

#DECLARE($result : cs.AIKit.OpenAIChatCompletionsResult)

var $jsResult : Variant

If (Not($result.success))
	WA EXECUTE JAVASCRIPT FUNCTION(*; "webArea"; "streamError"; $jsResult; "Stream terminated with an error.")
	return
End if

var $choice : cs.AIKit.OpenAIChoice
$choice:=$result.choice

If ($choice.finish_reason="tool_calls")
	Form.chatMessages.push({role: "assistant"; tool_calls: $choice.message.tool_calls})

	var $toolCall : Object
	For each ($toolCall; $choice.message.tool_calls)
		var $fnArgs : Object
		$fnArgs:=JSON Parse($toolCall.function.arguments)

		var $toolResult : Object
		$toolResult:=APT_Tool_Dispatch($toolCall.function.name; $fnArgs)

		Form.chatMessages.push({\
			role: "tool";\
			tool_call_id: $toolCall.id;\
			content: JSON Stringify($toolResult)\
		})
	End for each

	WA EXECUTE JAVASCRIPT FUNCTION(*; "webArea"; "streamStart"; $jsResult)
	APT_Chat_ResetChunk
	APT_Chat_ContinueStream

Else
	var $fullReply : Text
	$fullReply:=APT_Chat_GetAccumulatedChunk

	Form.chatMessages.push({role: "assistant"; content: $fullReply})

	WA EXECUTE JAVASCRIPT FUNCTION(*; "webArea"; "streamEnd"; $jsResult; $fullReply)

	var $conv : cs.ConversationEntity
	$conv:=ds.Conversation.query("conversationID = :1"; Form.conversationID).first()
	If ($conv#Null)
		$conv.messages:=JSON Stringify(Form.chatMessages)
		$conv.save()
	End if
End if
