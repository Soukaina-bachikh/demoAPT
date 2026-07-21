// Sends the user's message to OpenAI with streaming enabled and tool-calling active

#DECLARE($userMessage : Text)

// Refresh the system message every turn rather than trusting whatever was baked in when
// the conversation started, so prompt edits and "today's date" (a long-running window
// left open overnight) both stay current - see APT_WebChat_Handle for the same fix.
If (Form.chatMessages.length>0) && (Form.chatMessages[0].role="system")
	Form.chatMessages[0].content:=APT_SystemPrompt
Else
	Form.chatMessages.unshift({role: "system"; content: APT_SystemPrompt})
End if

Form.chatMessages.push({role: "user"; content: $userMessage})

var $openAI : cs.AIKit.OpenAI
$openAI:=cs.AIKit.OpenAI.new(APT_GetOpenAIKey)

$openAI.chat.completions.create(Form.chatMessages; {\
	model: "gpt-4o";\
	tools: APT_GetToolDefinitions;\
	stream: True;\
	max_tokens: 500;\
	onData: Formula(APT_Chat_OnData($1));\
	onTerminate: Formula(APT_Chat_OnTerminate($1))\
})
