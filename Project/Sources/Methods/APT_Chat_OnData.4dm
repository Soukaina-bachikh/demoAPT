// Called by AIKit for each streamed chunk while the assistant is replying.
// Accumulates both the plain-text content and any tool_calls, since OpenAI
// streams tool_calls fragmented by index just like content is streamed by token.

#DECLARE($chunk : cs.AIKit.OpenAIChatCompletionsStreamResult)

If ($chunk.success)
	var $delta : Object
	$delta:=$chunk.choice.delta

	var $content : Text
	$content:=""
	If ($delta.content#Null)
		$content:=String($delta.content)
	End if

	If ($content#"")
		APT_Chat_AppendChunk($content)

		var $jsResult : Variant
		WA EXECUTE JAVASCRIPT FUNCTION(*; "webArea"; "streamChunk"; $jsResult; $content)
	End if

	If ($delta.tool_calls#Null)
		var $deltaCall : Object
		For each ($deltaCall; $delta.tool_calls)
			var $idx : Integer
			$idx:=$deltaCall.index

			While (Form.toolCallsBuffer.length<=$idx)
				Form.toolCallsBuffer.push({id: ""; type: "function"; function: {name: ""; arguments: ""}})
			End while

			If ($deltaCall.id#Null)
				Form.toolCallsBuffer[$idx].id:=$deltaCall.id
			End if

			If ($deltaCall.function#Null)
				If ($deltaCall.function.name#Null)
					Form.toolCallsBuffer[$idx].function.name:=$deltaCall.function.name
				End if
				If ($deltaCall.function.arguments#Null)
					Form.toolCallsBuffer[$idx].function.arguments:=Form.toolCallsBuffer[$idx].function.arguments+$deltaCall.function.arguments
				End if
			End if
		End for each
	End if
End if
