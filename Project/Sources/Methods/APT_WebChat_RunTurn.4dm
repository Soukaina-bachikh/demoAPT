// Synchronous (non-streaming) counterpart to APT_Chat_Send/OnData/OnTerminate, used by the
// public web chat endpoint. HTTP request/response has no persistent connection to stream
// chunks over, so this blocks until the model's final (non-tool-call) reply is ready,
// running the same tool-dispatch loop the native chat uses.

#DECLARE($messages : Collection) : Object

var $result : Object:={success: False}
var $openAI : cs.AIKit.OpenAI
$openAI:=cs.AIKit.OpenAI.new(APT_GetOpenAIKey)

var $linkedClientID : Text:=""
var $linkedAppointmentID : Text:=""
var $rounds : Integer:=0
var $done : Boolean:=False

While (Not($done)) && ($rounds<6)
	$rounds:=$rounds+1

	var $completion : cs.AIKit.OpenAIChatCompletionsResult
	$completion:=$openAI.chat.completions.create($messages; {\
		model: "gpt-4o";\
		tools: APT_GetToolDefinitions;\
		stream: False;\
		max_tokens: 500\
	})

	If (Not($completion.success))
		$result.error:="The AI request failed."
		return $result
	End if

	var $choice : cs.AIKit.OpenAIChoice
	$choice:=$completion.choice

	If ($choice.finish_reason="tool_calls")
		$messages.push({role: "assistant"; tool_calls: $choice.message.tool_calls})

		var $toolCall : Object
		For each ($toolCall; $choice.message.tool_calls)
			var $fnArgs : Object
			$fnArgs:=JSON Parse($toolCall.function.arguments)

			var $toolResult : Object
			$toolResult:=APT_Tool_Dispatch($toolCall.function.name; $fnArgs)

			If ($toolResult.client#Null)
				$linkedClientID:=$toolResult.client.clientID
			End if
			If ($toolCall.function.name="createAppointment") && ($toolResult.success)
				$linkedAppointmentID:=$toolResult.appointmentID
			End if

			$messages.push({\
				role: "tool";\
				tool_call_id: $toolCall.id;\
				content: JSON Stringify($toolResult)\
			})
		End for each

	Else
		$result.reply:=APT_TextOrEmpty($choice.message.content)
		$messages.push({role: "assistant"; content: $result.reply})
		$done:=True
	End if
End while

If (Not($done))
	$result.error:="The assistant took too many steps to answer - please try rephrasing."
	return $result
End if

$result.success:=True
$result.messages:=$messages
$result.clientID:=$linkedClientID
$result.appointmentID:=$linkedAppointmentID
return $result
