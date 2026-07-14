// Second streaming pass, run after tool results have been appended to the message history

#DECLARE()

var $openAI : cs.AIKit.OpenAI
$openAI:=cs.AIKit.OpenAI.new(GetOption("OPENAI_API_KEY"))

$openAI.chat.completions.create(Form.chatMessages; {\
	model: "gpt-4o";\
	tools: APT_GetToolDefinitions;\
	stream: True;\
	onData: Formula(APT_Chat_OnData($1));\
	onTerminate: Formula(APT_Chat_OnTerminate($1))\
})