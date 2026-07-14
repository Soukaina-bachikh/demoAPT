// Initializes (or resets) the current form's conversation state and creates a Conversation record

#DECLARE()

Form.chatMessages:=[{role: "system"; content: APT_SystemPrompt}]
Form.streamBuffer:=""

var $conv : cs.ConversationEntity
$conv:=ds.Conversation.new()
$conv.messages:="[]"
$conv.startedAt:=String(Current date; "yyyy-MM-dd")+"T"+String(Current time; "HH:mm:ss")
$conv.save()
Form.conversationID:=$conv.conversationID
