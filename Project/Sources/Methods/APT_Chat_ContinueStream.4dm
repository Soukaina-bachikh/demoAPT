// Second streaming pass, run after tool results have been appended to the message history

#DECLARE()

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