// Sends the user's message to OpenAI with streaming enabled and tool-calling active

#DECLARE($userMessage : Text)

Form.chatMessages.push({role: "user"; content: $userMessage})

var $openAI : cs.AIKit.OpenAI
$openAI:=cs.AIKit.OpenAI.new(APT_GetOpenAIKey)

$openAI.chat.completions.create(Form.chatMessages; {\
	model: "gpt-4o";\
	tools: APT_GetToolDefinitions;\
	stream: True;\
	onData: Formula(APT_Chat_OnData($1));\
	onTerminate: Formula(APT_Chat_OnTerminate($1))\
})
